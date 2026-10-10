const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');
const { test } = require('node:test');

const script = fs.readFileSync(path.join(__dirname, '..', '..', 'docs', 'js', 'eu-decisions.js'), 'utf8');
const now = Date.parse('2026-10-10T12:00:00Z');
const day = 24 * 60 * 60 * 1000;
const item = {
  date: '2026-10-01', title: 'Test decision', topic: 'GMO/NGT',
  summary: '', url: 'https://example.com', source: 'European Parliament'
};

async function render(feed, { failure = false, lang = 'en' } = {}) {
  const elements = {
    'eu-decisions-list': {},
    'eu-decisions-status': {},
    'lang-select': { addEventListener: (_, callback) => { elements.languageChanged = callback; } }
  };
  const document = {
    documentElement: { lang },
    getElementById: (id) => elements[id] || null
  };
  const errors = [];
  let onLoad;
  const context = vm.createContext({
    document, URL, URLSearchParams,
    Date: class extends Date { static now() { return now; } },
    console: { error: (...args) => errors.push(args) },
    window: {
      location: { search: '', pathname: '/news.html', hash: '' },
      history: { replaceState() {} },
      setTimeout: (callback) => callback(),
      addEventListener: (_, callback) => { onLoad = callback; }
    },
    fetch: async (url) => {
      if (url.includes('translate')) throw new Error('Translation unavailable in test');
      const automatic = url.includes('eu_decisions_auto');
      return {
        ok: !automatic || !failure,
        status: automatic && failure ? 503 : 200,
        json: async () => automatic ? feed : { items: [item] }
      };
    }
  });
  vm.runInContext(script, context);
  onLoad();
  await new Promise((resolve) => setImmediate(resolve));
  return { elements, errors, document };
}

test('recent check is active, including exactly the three-day threshold', async () => {
  for (const age of [0, 3 * day]) {
    const { elements } = await render({ updated_at: new Date(now - age).toISOString(), items: [item] });
    assert.match(elements['eu-decisions-status'].textContent, /Automatic updates are active/);
    assert.match(elements['eu-decisions-list'].innerHTML, /Test decision/);
  }
});

test('old check is delayed, even if the feed is empty', async () => {
  for (const items of [[item], []]) {
    const { elements } = await render({ updated_at: new Date(now - 3 * day - 1).toISOString(), items });
    assert.match(elements['eu-decisions-status'].textContent, /Automatic updates are delayed/);
  }
});

test('missing, invalid and future timestamps cannot report active updates', async () => {
  for (const updated_at of [null, '', 'invalid', new Date(now + day).toISOString()]) {
    const { elements } = await render({ updated_at, items: [item] });
    assert.match(elements['eu-decisions-status'].textContent, /status is unavailable/);
  }
});

test('empty recent feed reports no automatic results', async () => {
  const { elements } = await render({ updated_at: new Date(now).toISOString(), items: [] });
  assert.match(elements['eu-decisions-status'].textContent, /No automatic results/);
  assert.match(elements['eu-decisions-list'].innerHTML, /Test decision/);
});

test('failed or malformed automatic feed retains manual decisions and logs the error', async () => {
  for (const options of [{ failure: true }, {}]) {
    const { elements, errors } = await render({ items: {} }, options);
    assert.match(elements['eu-decisions-status'].textContent, /status is unavailable/);
    assert.match(elements['eu-decisions-list'].innerHTML, /Test decision/);
    assert.equal(errors.length, 1);
  }
});

test('status follows a language change', async () => {
  const { elements, document } = await render({ updated_at: new Date(now - 4 * day).toISOString(), items: [item] });
  document.documentElement.lang = 'nb';
  elements.languageChanged();
  assert.match(elements['eu-decisions-status'].textContent, /Automatisk oppdatering er forsinket/);
});

test('translation links target the publisher in the selected language', async () => {
  const url = 'https://food.ec.europa.eu/example?first=1&second=2';
  for (const [lang, target] of [['nb', 'no'], ['de', 'de'], ['zh', 'zh-CN']]) {
    const { elements } = await render({ items: [{ ...item, url }] }, { lang });
    const html = elements['eu-decisions-list'].innerHTML;
    assert.ok(html.includes(`tl=${target}&amp;u=${encodeURIComponent(url)}`));
    assert.ok(html.includes('href="https://food.ec.europa.eu/example?first=1&amp;second=2"'));
  }
});

test('unresolved Google News links are not sent through Google Translate', async () => {
  const url = 'https://news.google.com/rss/articles/opaque-id?oc=5';
  const { elements } = await render({ items: [{ ...item, url }] }, { lang: 'nb' });
  const html = elements['eu-decisions-list'].innerHTML;
  assert.ok(!html.includes(encodeURIComponent(url)));
  assert.ok(html.includes(`href="${url}"`));
  assert.match(html, /Direkte kildelenke mangler/);
});
