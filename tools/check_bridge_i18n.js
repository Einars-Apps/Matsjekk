#!/usr/bin/env node
'use strict';

// Validates that every data-translate / data-translate-html key used on the
// "page-language-bridge" content pages exists in the inline
// window.PAGE_BRIDGE_TRANSLATIONS dictionary (nb + en required, de reported).
const fs = require('fs');
const path = require('path');

const DOCS = path.join(__dirname, '..', 'docs');
const PAGES = ['editorial-method.html', 'source-criteria.html'];

let failures = 0;

for (const page of PAGES) {
  const file = path.join(DOCS, page);
  const html = fs.readFileSync(file, 'utf8');

  const keys = new Set();
  const attrRe = /data-translate(?:-html)?="([^"]+)"/g;
  let m;
  while ((m = attrRe.exec(html)) !== null) keys.add(m[1]);

  const dictMatch = html.match(/window\.PAGE_BRIDGE_TRANSLATIONS\s*=\s*(\{[\s\S]*?\});/);
  if (!dictMatch) {
    console.error(`${page}: could not find window.PAGE_BRIDGE_TRANSLATIONS`);
    failures += 1;
    continue;
  }

  let dict;
  try {
    // eslint-disable-next-line no-new-func
    dict = new Function(`return (${dictMatch[1]});`)();
  } catch (err) {
    console.error(`${page}: dictionary is not valid JS: ${err.message}`);
    failures += 1;
    continue;
  }

  const nb = dict.nb || {};
  const en = dict.en || {};
  const de = dict.de || {};

  const missingNb = [...keys].filter((k) => !(k in nb));
  const missingEn = [...keys].filter((k) => !(k in en));
  const missingDe = [...keys].filter((k) => !(k in de));

  if (missingNb.length) {
    console.error(`${page}: missing in nb: ${missingNb.join(', ')}`);
    failures += 1;
  }
  if (missingEn.length) {
    console.error(`${page}: missing in en: ${missingEn.join(', ')}`);
    failures += 1;
  }

  console.log(
    `${page}: ${keys.size} keys; nb missing ${missingNb.length}, en missing ${missingEn.length}, de missing ${missingDe.length}`
  );
}

if (failures) {
  console.error('FAIL: some bridge pages have missing nb/en translation keys.');
  process.exit(1);
}
console.log('OK: every bridge translate key has nb + en fallback.');
