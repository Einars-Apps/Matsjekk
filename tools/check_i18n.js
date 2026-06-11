// Dev guard: verifies every data-translate / data-translate-html key used in
// the HTML pages exists in the English fallback dictionary. If a key is missing
// from English, that language would fall back to Norwegian and the page would
// show a "language mix". Run with: node tools/check_i18n.js
const fs = require('fs');
const path = require('path');

const ROOT = path.dirname(__dirname);
const LANG_FILE = path.join(ROOT, 'docs', 'lang.local.js');
const PAGES = ['index.html', 'news.html', 'gardsbutikker.html'];

// Load the translations object from lang.local.js in a minimal browser-less stub.
const stub = {
  window: { location: { search: '' }, addEventListener() {} },
  navigator: { language: 'en', languages: ['en'] },
  document: {
    documentElement: {}, body: {},
    querySelectorAll: () => [], getElementById: () => null, addEventListener() {},
  },
};
const sandbox = Object.assign({ console, module: {}, require }, stub);
const vm = require('vm');
vm.createContext(sandbox);
// `const translations` is block-scoped, so expose it explicitly for inspection.
vm.runInContext(fs.readFileSync(LANG_FILE, 'utf8') + '\nthis.__translations = translations;', sandbox);
const translations = sandbox.__translations;
const en = translations.en || {};

let totalMissing = 0;
for (const page of PAGES) {
  const file = path.join(ROOT, 'docs', page);
  if (!fs.existsSync(file)) continue;
  const html = fs.readFileSync(file, 'utf8');
  const keys = [...html.matchAll(/data-translate(?:-html)?="([^"]+)"/g)].map((m) => m[1]);
  const unique = [...new Set(keys)];
  const missing = unique.filter((k) => en[k] == null);
  console.log(`${page}: ${unique.length} unique keys, ${missing.length} missing in EN`);
  if (missing.length) {
    console.log('  MISSING:', missing.join(', '));
    totalMissing += missing.length;
  }
}

if (totalMissing > 0) {
  console.error(`\nFAIL: ${totalMissing} key(s) missing from the English fallback.`);
  process.exit(1);
}
console.log('\nOK: every translate key has an English fallback (no language mix possible).');
