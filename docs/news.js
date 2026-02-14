// Client-side news feed stored in localStorage
const NEWS_KEY = 'matsjekk_news_v1';
const NEWS_REMOTE_URL = 'data/news.latest.json';

function getNews() {
  try {
    const raw = localStorage.getItem(NEWS_KEY);
    return raw ? JSON.parse(raw) : [];
  } catch (e) {
    console.error('Failed to parse news', e);
    return [];
  }
}

function saveNews(list) {
  localStorage.setItem(NEWS_KEY, JSON.stringify(list));
}

async function fetchRemoteNews() {
  try {
    const response = await fetch(NEWS_REMOTE_URL, { cache: 'no-cache' });
    if (!response.ok) return [];
    const payload = await response.json();
    if (payload && Array.isArray(payload.items)) return payload.items;
    return [];
  } catch (_) {
    return [];
  }
}

function mergeUniqueByUrl(primary, secondary) {
  const seen = new Set();
  const out = [];
  [...primary, ...secondary].forEach((item) => {
    const key = (item?.url || '').toLowerCase().trim();
    if (!key || seen.has(key)) return;
    seen.add(key);
    out.push(item);
  });
  return out;
}

async function renderNews(preferredLang) {
  const localNews = getNews();
  const remoteNews = await fetchRemoteNews();
  const list = mergeUniqueByUrl(remoteNews, localNews);
  const container = document.getElementById('news-list');
  container.innerHTML = '';
  if (!list || list.length === 0) {
    container.innerHTML = '<p class="muted">Ingen artikler ennå. Nye artikler lastes inn automatisk når kilder er tilgjengelige.</p>';
    return;
  }
  // Show all articles, newest first
  list.sort((a,b) => new Date(b.pubDate || b.date) - new Date(a.pubDate || a.date));
  const targetLang = preferredLang || navigator.language?.substr(0,2) || 'nb';
  list.forEach(a => {
    const card = document.createElement('article');
    card.className = 'news-card';
    const title = escapeHtml(a.title);
    const source = escapeHtml(a.source || a.sourceName || 'Ukjent kilde');
    const dateStr = new Date(a.pubDate || a.date).toLocaleDateString();
    const summary = a.shortSummary || a.summary || '';
    const eng = a.englishSummary ? `<p class="eng-summary">${escapeHtml(a.englishSummary)}</p>` : '';
    const translateUrl = `https://translate.google.com/translate?sl=auto&tl=${encodeURIComponent(targetLang)}&u=${encodeURIComponent(a.url)}`;
    card.innerHTML = `
      <h4><a href="${a.url}" target="_blank" rel="noopener">${title}</a></h4>
      <p class="meta">${source} • ${dateStr} • ${a.language || 'nb'}</p>
      ${summary ? `<p class="summary">${escapeHtml(summary)}</p>` : ''}
      ${eng}
      <p class="links"><a href="${a.url}" target="_blank" rel="noopener">Åpne original</a> • <a href="${translateUrl}" target="_blank" rel="noopener">Oversett</a></p>
    `;
    container.appendChild(card);
  });
}

function escapeHtml(s){
  if(!s) return '';
  return s.replaceAll('&','&amp;').replaceAll('<','&lt;').replaceAll('>','&gt;');
}

function initNews() {
  const addBtn = document.getElementById('add-article-btn');
  const form = document.getElementById('news-form');
  const saveBtn = document.getElementById('save-article');
  const cancelBtn = document.getElementById('cancel-article');
  const langSelect = document.getElementById('news-lang');

  if (addBtn) addBtn.addEventListener('click', () => form.classList.toggle('hidden'));
  if (cancelBtn) cancelBtn.addEventListener('click', (e) => { e.preventDefault(); form.classList.add('hidden'); });

  if (saveBtn) saveBtn.addEventListener('click', (e) => {
    e.preventDefault();
    const title = document.getElementById('article-title').value.trim();
    const source = document.getElementById('article-source').value.trim() || 'Ukjent kilde';
    const url = document.getElementById('article-url').value.trim();
    const lang = document.getElementById('article-lang').value || 'nb';
    if (!title || !url) { alert('Tittel og URL må fylles ut'); return; }
    const list = getNews();
    list.push({ title, source, url, language: lang, pubDate: new Date().toISOString() });
    saveNews(list);
    form.classList.add('hidden');
    document.getElementById('article-title').value = '';
    document.getElementById('article-source').value = '';
    document.getElementById('article-url').value = '';
    renderNews(langSelect.value || lang);
  });

  if (langSelect) langSelect.addEventListener('change', (e)=> renderNews(e.target.value));

  // seed curated articles if empty
  if (getNews().length === 0) {
    const curated = [
      {
        "title":"Skulda for å putte gift i dyra – Tine pausar klima­vennleg fôr",
        "url":"https://www.nrk.no/vestland/skulda-for-a-putte-gift-i-dyra-_-tine-stoppar-med-metanhemmaren-bovaer-1.17648112",
        "pubDate":"2026-01-16",
        "source":"nrk.no",
        "language":"nb",
        "shortSummary":"NRK beskriver reaksjonar mot Tine etter innføring av metanhemmaren Bovaer; selskapet pausar bruken av stoffet medan saker om sjuke dyr i Danmark og protestar diskuteres.",
        "englishSummary":"NRK reports on protests and concerns after Tine paused use of the methane inhibitor Bovaer amid reports of sick cows and public backlash."
      },
      {
        "title":"Tine meieriers skumle ultimatum om Bovaer",
        "url":"https://www.document.no/2026/01/15/tine-meieriers-skumle-ultimatum-om-bovaer/",
        "pubDate":"2026-01-15T04:01:00Z",
        "source":"document.no",
        "language":"nb",
        "shortSummary":"Artikkelen hevder at Tine krever bruk av Bovaer for å utløse tilskudd og setter norske melkebønder i et umulig valg, med sterke kritiske røster fra bønder.",
        "englishSummary":"Document.no claims Tine is pressuring farmers to use Bovaer to secure subsidies, presenting farmers with an impossible choice."
      },
      {
        "title":"Ny sjokkstudie om metanhemmere: – Kan danne giftig gass",
        "url":"https://www.document.no/2026/01/14/ny-sjokkstudie-om-metanhemmere-kan-danne-giftig-gass/",
        "pubDate":"2026-01-14T08:01:00Z",
        "source":"document.no",
        "language":"nb",
        "shortSummary":"Document.no refererer til en dansk studie som påstår at kombinasjon av raps og Bovaer i fôr kan gi opphav til giftige gasser, og advarer mot ukjente helseeffekter.",
        "englishSummary":"Document.no reports on a Danish study claiming that combining rapeseed and Bovaer could produce toxic gases, raising safety concerns."
      },
      {
        "title":"Tor (56) vil sette rekord i motstand mot Bovaer: – Nå er din mulighet til å stoppe det",
        "url":"https://www.document.no/2026/01/06/tor-56-vil-sette-rekord-i-motstand-mot-bovaer-na-er-din-mulighet-til-a-stoppe-det/",
        "pubDate":"2026-01-06T08:01:00Z",
        "source":"document.no",
        "language":"nb",
        "shortSummary":"Personlig portrett og mobilisering: en bonde oppfordrer folk til å sende høringssvar og demonstrerer lokal motstand mot tvungen bruk av Bovaer.",
        "englishSummary":"A Document.no piece profiles a farmer organizing opposition and urging people to submit consultation responses against mandatory Bovaer use."
      },
      {
        "title":"Mattilsynet innrømmer: Bovaer-rester i melken",
        "url":"https://www.document.no/2025/12/22/mattilsynet-innrommer-bovaer-rester-i-melken/",
        "pubDate":"2025-12-22T08:12:00Z",
        "source":"document.no",
        "language":"nb",
        "shortSummary":"Document.no melder at Mattilsynet har funnet spor av Bovaer i melkprøver, og diskuterer konsekvenser for forbrukertillit og industripraksis.",
        "englishSummary":"Document.no reports that the Norwegian Food Safety Authority found traces of Bovaer in milk samples, raising consumer trust issues."
      },
      {
        "title":"Eksplosiv økning i salg av melk hos Rørosmeieriet – rømmer kundene fra «Bovaer-melken»?",
        "url":"https://www.document.no/2025/12/21/eksplosiv-okning-i-salg-av-melk-hos-rorosmeieriet-rommer-kundene-fra-bovaer-melken/",
        "pubDate":"2025-12-21T05:12:00Z",
        "source":"document.no",
        "language":"nb",
        "shortSummary":"Artikkelen hevder at kunder flykter fra store leverandører som bruker Bovaer, og søker sikrere alternativer hos små meierier som Rørosmeieriet.",
        "englishSummary":"Document.no claims consumers are switching from major suppliers using Bovaer to smaller dairies like Rørosmeieriet."
      },
      {
        "title":"TINE nektet for at Bovaer-melk går på tanken – nå kommer sannheten frem: – Fører kundene bak lyset",
        "url":"https://www.document.no/2025/12/20/tine-nektet-for-at-bovaer-melk-gar-pa-tanken-na-kommer-sannheten-frem-forer-kundene-bak-lyset/",
        "pubDate":"2025-12-20T12:12:00Z",
        "source":"document.no",
        "language":"nb",
        "shortSummary":"Document.no anklager TINE for å villede kunder om blanding av melk fra gårder der Bovaer er brukt, og etterlyser full åpenhet om innholdet i melet.",
        "englishSummary":"Document.no accuses TINE of misleading customers about mixing milk from farms using Bovaer and calls for transparency."
      },
      {
        "title":"Bovaer tvangsinnført: 70 prosent av bønder melder om syke kyr og mindre melk",
        "url":"https://www.document.no/2025/12/18/bovaer-tvangsinnfort-70-prosent-av-bonder-melder-om-syke-kyr-og-mindre-melk/",
        "pubDate":"2025-12-18T08:12:00Z",
        "source":"document.no",
        "language":"nb",
        "shortSummary":"Document.no viser til en undersøkelse der et flertall danske bønder rapporterer helseproblemer og redusert melkeproduksjon etter bruk av Bovaer.",
        "englishSummary":"Document.no cites a survey where a majority of Danish farmers report sick cows and lower milk yields after using Bovaer."
      },
      {
        "title":"«Kutt korken, ikke kua» – Melkebønder peker på enkel løsning, TINE ignorerer",
        "url":"https://www.document.no/2025/12/06/kutt-korken-ikke-kua-melkebonder-peker-pa-enkel-losning-tine-ignorerer/",
        "pubDate":"2025-12-06T11:12:00Z",
        "source":"document.no",
        "language":"nb",
        "shortSummary":"Bøndene foreslår alternative, enkle tiltak for å håndtere klimakrav uten Bovaer; Document.no kritiserer TINEs respons som utilstrekkelig.",
        "englishSummary":"Document.no reports farmers proposing simple alternatives to meet climate goals without Bovaer, criticizing TINE's inadequate response."
      },
      {
        "title":"Forskere skal undersøge effekter af Bovaer i 70 kvægbesætninger",
        "url":"https://politiken.dk/search/art10670891/Forskere-skal-unders%C3%B8ge-effekter-af-Bovaer-i-70-kv%C3%A6gbes%C3%A6tninger",
        "pubDate":"2025-12-17T17:56:00+01:00",
        "source":"politiken.dk",
        "language":"da",
        "shortSummary":"Politiken skriver at et forskningsprosjekt skal følge 70 danske kvægbesætninger for å kartlegge effekter av Bovaer på produksjon og dyrehelse.",
        "englishSummary":"Politiken reports a study to monitor 70 cattle herds to assess Bovaer's effects on production and animal health."
      },
      {
        "title":"Bruk av metanhemmende stoff i fôr til norske kuer stoppes",
        "url":"https://www.nrk.no/nyheter/bruk-av-metanhemmende-stoff-i-for-til-norske-kuer-stoppes-1.17649525",
        "pubDate":"2025-11-14",
        "source":"nrk.no",
        "language":"nb",
        "shortSummary":"NRK melder at norsk melkeindustri stopper bruk av metanhemmende tilskudd i påvente av mer kunnskap etter negative meldinger fra Danmark.",
        "englishSummary":"NRK reports Norway has halted use of methane-inhibiting feed additives pending more information after adverse reports from Denmark."
      },
      {
        "title":"Over 300 landmænd beretter om problemer med klimavenlige Bovaer",
        "url":"https://politiken.dk/search/art10631487/%C2%BBSkal-k%C3%B8er-blive-syge-for-at-slippe-for-Bovaer-Ville-det-ikke-v%C3%A6re-rimeligt-med-straksforbud%C2%AB",
        "pubDate":"2025-11-20T06:38:00+01:00",
        "source":"politiken.dk",
        "language":"da",
        "shortSummary":"Politiken refererer til et spørreskjema hvor over 300 danske bønder rapporterer om problemer med dyrehelse og melkeutbytte etter innføring av Bovaer.",
        "englishSummary":"Politiken cites a survey of over 300 Danish farmers reporting health and yield problems after adopting Bovaer."
      },
      {
        "title":"Nu er vestjysk mælkebonde blevet skeptisk over køernes »uskadelige« antibøvsemiddel",
        "url":"https://politiken.dk/search/art10622137/Nu-er-vestjysk-m%C3%A6lkebonde-blevet-skeptisk-over-k%C3%B8ernes-%C2%BBuskadelige%C2%AB-antib%C3%B8vsemiddel",
        "pubDate":"2025-11-12T11:04:00+01:00",
        "source":"politiken.dk",
        "language":"da",
        "shortSummary":"Politiken møter en enkel bonde som uttrykker skepsis etter at flere besetninger i Vestjylland har opplevd problemer etter Bovaer-innføring.",
        "englishSummary":"Politiken profiles a West Jutland farmer who has become skeptical after neighboring herds experienced problems following Bovaer use."
      },
      {
        "title":"Danske problemer får Norge til at sætte brug af Bovaer på pause",
        "url":"https://politiken.dk/search/art10620104/Danske-problemer-f%C3%A5r-Norge-til-at-s%C3%A6tte-brug-af-Bovaer-p%C3%A5-pause",
        "pubDate":"2025-11-04T10:03:00+01:00",
        "source":"politiken.dk",
        "language":"da",
        "shortSummary":"Politiken rapporterer at problemer i Danmark med Bovaer fører til at Norge pauser bruken inntil videre, og at myndigheter følger situasjonen tett.",
        "englishSummary":"Politiken reports Danish problems with Bovaer prompted Norway to pause its use while authorities monitor the situation."
      },
      {
        "title":"Fler danska mjölkbönder ser problem efter fodertillskott",
        "url":"https://www.dn.se/direkt/2025-12-02/fler-danska-mjolkbonder-ser-problem-efter-fodertillskott/",
        "pubDate":"2025-12-02",
        "source":"dn.se",
        "language":"sv",
        "shortSummary":"DN Direkt formidler TT/nyhetsmeldinger om at flere danska mjölkbönder rapporterar problem efter att ha använt ett metanreducerande fodertillskott.",
        "englishSummary":"DN Direkt relays news that multiple Danish dairy farmers report problems after using a methane-reducing feed supplement."
      }
    ];
    saveNews(curated);
  }

  const initialLang = document.getElementById('news-lang') ? document.getElementById('news-lang').value : (localStorage.getItem('matsjekk_lang') || 'nb');
  if (document.getElementById('news-lang')) document.getElementById('news-lang').value = initialLang;
  renderNews(initialLang);
}

window.addEventListener('DOMContentLoaded', () => {
  initNews();
});
