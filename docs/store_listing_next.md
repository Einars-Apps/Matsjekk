# Matsjekk – store listing for next release (1.2.0, build 66)

Status: **draft, not published**. Copy into Google Play Console, App Store Connect and Huawei AppGallery Connect manually.

Character counts are Unicode characters (code points), as counted by Play Console / App Store Connect. Limits: Play title ≤30, short ≤80, full ≤4000; Apple name ≤30, subtitle ≤30, promotional text ≤170, keywords ≤100; Huawei intro ≤80; screenshot captions ≤40 (our own limit); what's new ≤500 (Play).

## Facts used (verified in code, branch `feature/in-app-farm-map`)

- Shopping list: multiple lists (Hive box `handlelister`), tick-off of items, per-list and global history, search, full-screen mode (`lib/main.dart`, `lib/widgets.dart`).
- Farm shops: native screen `lib/farm_shops/farm_shops_screen.dart` – OpenStreetMap map + list sorted by distance (geolocator), organic filter, address, products, directions, website, phone; cached on device + bundled Norway snapshot for offline use. Location is only used on the device and not stored.
- Farm shop count: same dataset as matsjekk.com/gardsbutikker.html (`docs/data/farmshops_by_country/*.json`) – **84,580 entries in 50 countries** on 2026-10-25 (Norway: 1,753 + 59 Debio organic entries). Copy says "over/more than 80,000 … in 50 countries" (and "over 1 700 i Norge" in nb) so it stays true when the weekly data job changes the numbers slightly.
- Scanner: barcode scan, product data from Open Food Facts (`world.openfoodfacts.org`), risk levels green/yellow/red (`RiskLevel`), alerts for Bovaer, GMO feed, insect ingredients and NGT, each switchable in settings (`varselBovaer`, `varselGmo`, `varselInsekt`, `varselNgt`). TINE/Bovaer remains YELLOW (unchanged).
- EU decisions: product view shows EU regulatory status with links to EU source documents; "News in your area" opens matsjekk.com news with the EU decisions feed (`docs/js/eu-decisions.js`).
- Monetisation: free with ads (AdMob). One-time purchase `matsjekk_remove_ads_lifetime` removes ads ("Engangskjøp. Ingen abonnement."); the app itself says "Fjern annonser for mer plass i handlelisten". No subscription.
- 11 languages: nb, en, sv, da, fi, de, nl, fr, it, pt, es.
- No health claims; the copy repeats the app's own advice to verify against the label.

## Screenshot order (all platforms)

1. Shopping list
2. Farm shop map (Gårdsbutikker screen with map + list)
3. Scanner result with traffic lights
4. EU decisions (EU regulatory status / news)

Captions per language are listed in each language section.

## Platform notes

- **Google Play**: new permissions ACCESS_COARSE_LOCATION / ACCESS_FINE_LOCATION (foreground only, used for distance sorting of farm shops). Update the Data safety form: the position is processed on the device only (distance sorting) and is not sent to Matsjekk or any server; the map only downloads OpenStreetMap tiles for the visible area. Review whether Play wants *Location → Approximate/Precise* declared before submitting. No background location. Map tiles are loaded from tile.openstreetmap.org.
- **Apple**: `NSLocationWhenInUseUsageDescription` added. App Privacy: location is not collected (used on-device only). Keywords are comma-separated without spaces after commas.
- **Huawei AppGallery**: use the Play title as app name, the short description as "Brief introduction" (≤80) and the full description as "Introduction".


---

## Norsk bokmål (nb-NO) – `nb`

### Google Play

**Title** (30/30)

```
Matsjekk – Gårdsbutikk & liste
```

**Short description** (78/80)

```
Handleliste for ekte mat. Finn gårdsbutikker og lokalmat nær deg. Skann varer.
```

**Full description** (1338/4000)

```
Matsjekk er handlelisten for deg som vil kjøpe ekte mat – og vite mer om det du kjøper.

🛒 HANDLELISTE
• Lag flere handlelister og kryss av varene mens du handler
• Historikk per liste, så du raskt finner igjen det du pleier å kjøpe
• Søk etter varer og bruk listen i fullskjerm i butikken

🚜 GÅRDSBUTIKKER OG LOKALMAT
• Kart og liste over gårdsbutikker og lokale matprodusenter nær deg
• Over 80 000 gårdsbutikker i 50 land – over 1 700 i Norge
• Sortert etter avstand fra deg, med filter for økologisk
• Se adresse og hva de selger, få veibeskrivelse, åpne nettsiden eller ring direkte
• Lagres på telefonen, så du kan bruke den uten nett. Posisjonen din lagres ikke.

📷 SKANNER MED TRAFIKKLYS
• Skann strekkoden og få grønt, gult eller rødt varsel
• Varsler om Bovaer (fôrtilsetning), GMO-fôr, insektingredienser og NGT (nye genteknikker)
• Du velger selv hvilke varsler du vil ha
• Produktdata fra Open Food Facts

⚖️ EU-VEDTAK
• Se EU-regelstatus for produktet, med lenker til kildedokumentene
• Følg nyheter og EU-vedtak om mat i ditt område

💚 GRATIS MED ANNONSER
Matsjekk er gratis med annonser. Vil du ha mer plass i handlelisten, kan du fjerne annonsene med et engangskjøp – ingen abonnement.

Tilgjengelig på 11 språk.

Varslene er informasjon basert på tilgjengelige data og erstatter ikke etiketten. Sjekk alltid emballasjen.
```

**What's new** (162/500)

```
Nytt i 1.2.0: Gårdsbutikker rett i appen! Kart og liste sortert etter avstand, filter for økologisk, veibeskrivelse, nettside og telefon. Fungerer også uten nett.
```

### Apple App Store

**Name** (30/30)

```
Matsjekk – Gårdsbutikk & liste
```

**Subtitle** (28/30)

```
Handleliste og gårdsbutikker
```

**Promotional text** (126/170)

```
Nytt: Gårdsbutikker rett i appen! Finn gårdsbutikker og lokalmat nær deg på kartet, filtrer på økologisk og få veibeskrivelse.
```

**Keywords** (91/100)

```
gårdsbutikk,lokalmat,handleliste,økologisk,strekkode,skanner,bovaer,gmo,insekter,ngt,eu,mat
```

**Description** (1338/4000): same as the Google Play full description above.

**What's new in this version**: same as the Google Play what's new above.

### Huawei AppGallery

**App name** (30): `Matsjekk – Gårdsbutikk & liste`

**Brief introduction** (78/80): `Handleliste for ekte mat. Finn gårdsbutikker og lokalmat nær deg. Skann varer.`

**Introduction**: same as the Google Play full description above (1338 characters).

**What's new**: same as above.

### Screenshot captions

1. Handlelisten for ekte mat (25/40)
2. Gårdsbutikker nær deg (21/40)
3. Skann og se trafikklys (22/40)
4. EU-vedtak om maten din (22/40)


---

## English (en-US / en-GB) – `en`

### Google Play

**Title** (28/30)

```
Matsjekk – Farm Shops & List
```

**Short description** (75/80)

```
Shopping list for real food. Find farm shops and local food near you. Scan.
```

**Full description** (1367/4000)

```
Matsjekk is the shopping list for people who want to buy real food – and know more about what they buy.

🛒 SHOPPING LIST
• Create several shopping lists and tick off items as you shop
• History per list, so you quickly find what you usually buy
• Search for products and use the list in full screen in the store

🚜 FARM SHOPS AND LOCAL FOOD
• Map and list of farm shops and local food producers near you
• More than 80,000 farm shops in 50 countries
• Sorted by distance from you, with an organic filter
• See the address and what they sell, get directions, open the website or call directly
• Stored on your phone so it works offline. Your location is not stored.

📷 SCANNER WITH TRAFFIC LIGHTS
• Scan the barcode and get a green, yellow or red alert
• Alerts for Bovaer (feed additive), GMO feed, insect ingredients and NGT (new genomic techniques)
• You choose which alerts you want
• Product data from Open Food Facts

⚖️ EU DECISIONS
• See the EU regulatory status for a product, with links to the source documents
• Follow news and EU decisions about food in your area

💚 FREE WITH ADS
Matsjekk is free with ads. If you want more room in the shopping list, you can remove the ads with a one-time purchase – no subscription.

Available in 11 languages.

The alerts are information based on available data and do not replace the label. Always check the packaging.
```

**What's new** (142/500)

```
New in 1.2.0: Farm shops right in the app! Map and list sorted by distance, organic filter, directions, website and phone. Also works offline.
```

### Apple App Store

**Name** (28/30)

```
Matsjekk – Farm Shops & List
```

**Subtitle** (26/30)

```
Shopping list & farm shops
```

**Promotional text** (124/170)

```
New: farm shops right in the app! Find farm shops and local food near you on the map, filter for organic and get directions.
```

**Keywords** (92/100)

```
farm shop,local food,shopping list,organic,barcode,scanner,bovaer,gmo,insects,ngt,eu,farmers
```

**Description** (1367/4000): same as the Google Play full description above.

**What's new in this version**: same as the Google Play what's new above.

### Huawei AppGallery

**App name** (28): `Matsjekk – Farm Shops & List`

**Brief introduction** (75/80): `Shopping list for real food. Find farm shops and local food near you. Scan.`

**Introduction**: same as the Google Play full description above (1367 characters).

**What's new**: same as above.

### Screenshot captions

1. The shopping list for real food (31/40)
2. Farm shops near you (19/40)
3. Scan and see the traffic light (30/40)
4. EU decisions about your food (28/40)


---

## Svenska (sv-SE) – `sv`

### Google Play

**Title** (29/30)

```
Matsjekk – Gårdsbutik & lista
```

**Short description** (78/80)

```
Inköpslista för riktig mat. Hitta gårdsbutiker och lokal mat nära dig. Skanna.
```

**Full description** (1348/4000)

```
Matsjekk är inköpslistan för dig som vill köpa riktig mat – och veta mer om det du köper.

🛒 INKÖPSLISTA
• Skapa flera inköpslistor och bocka av varorna medan du handlar
• Historik per lista, så att du snabbt hittar det du brukar köpa
• Sök efter varor och använd listan i helskärm i butiken

🚜 GÅRDSBUTIKER OCH LOKAL MAT
• Karta och lista över gårdsbutiker och lokala matproducenter nära dig
• Över 80 000 gårdsbutiker i 50 länder
• Sorterat efter avstånd från dig, med filter för ekologiskt
• Se adress och vad de säljer, få vägbeskrivning, öppna webbplatsen eller ring direkt
• Sparas i telefonen så att den fungerar offline. Din position sparas inte.

📷 SKANNER MED TRAFIKLJUS
• Skanna streckkoden och få grön, gul eller röd varning
• Varningar för Bovaer (fodertillsats), GMO-foder, insektsingredienser och NGT (nya genomiska tekniker)
• Du väljer själv vilka varningar du vill ha
• Produktdata från Open Food Facts

⚖️ EU-BESLUT
• Se produktens regelstatus i EU, med länkar till källdokumenten
• Följ nyheter och EU-beslut om mat i ditt område

💚 GRATIS MED ANNONSER
Matsjekk är gratis med annonser. Vill du ha mer plats i inköpslistan kan du ta bort annonserna med ett engångsköp – ingen prenumeration.

Finns på 11 språk.

Varningarna är information baserad på tillgänglig data och ersätter inte etiketten. Kontrollera alltid förpackningen.
```

**What's new** (167/500)

```
Nytt i 1.2.0: Gårdsbutiker direkt i appen! Karta och lista sorterad efter avstånd, filter för ekologiskt, vägbeskrivning, webbplats och telefon. Fungerar även offline.
```

### Apple App Store

**Name** (29/30)

```
Matsjekk – Gårdsbutik & lista
```

**Subtitle** (28/30)

```
Inköpslista och gårdsbutiker
```

**Promotional text** (134/170)

```
Nyhet: gårdsbutiker direkt i appen! Hitta gårdsbutiker och lokal mat nära dig på kartan, filtrera på ekologiskt och få vägbeskrivning.
```

**Keywords** (92/100)

```
gårdsbutik,lokal mat,inköpslista,ekologiskt,streckkod,skanner,bovaer,gmo,insekter,ngt,eu,mat
```

**Description** (1348/4000): same as the Google Play full description above.

**What's new in this version**: same as the Google Play what's new above.

### Huawei AppGallery

**App name** (29): `Matsjekk – Gårdsbutik & lista`

**Brief introduction** (78/80): `Inköpslista för riktig mat. Hitta gårdsbutiker och lokal mat nära dig. Skanna.`

**Introduction**: same as the Google Play full description above (1348 characters).

**What's new**: same as above.

### Screenshot captions

1. Inköpslistan för riktig mat (27/40)
2. Gårdsbutiker nära dig (21/40)
3. Skanna och se trafikljuset (26/40)
4. EU-beslut om din mat (20/40)


---

## Dansk (da-DK) – `da`

### Google Play

**Title** (28/30)

```
Matsjekk – Gårdbutik & liste
```

**Short description** (78/80)

```
Indkøbsliste til ægte mad. Find gårdbutikker og lokal mad nær dig. Scan varer.
```

**Full description** (1352/4000)

```
Matsjekk er indkøbslisten til dig, der vil købe ægte mad – og vide mere om det, du køber.

🛒 INDKØBSLISTE
• Lav flere indkøbslister, og sæt flueben ved varerne, mens du handler
• Historik for hver liste, så du hurtigt finder det, du plejer at købe
• Søg efter varer, og brug listen i fuld skærm i butikken

🚜 GÅRDBUTIKKER OG LOKAL MAD
• Kort og liste over gårdbutikker og lokale fødevareproducenter nær dig
• Over 80.000 gårdbutikker i 50 lande
• Sorteret efter afstand fra dig, med filter for økologisk
• Se adresse og hvad de sælger, få rutevejledning, åbn hjemmesiden eller ring direkte
• Gemmes på telefonen, så den virker uden net. Din position gemmes ikke.

📷 SCANNER MED TRAFIKLYS
• Scan stregkoden, og få grøn, gul eller rød advarsel
• Advarsler om Bovaer (fodertilsætning), GMO-foder, insektingredienser og NGT (nye genomiske teknikker)
• Du vælger selv, hvilke advarsler du vil have
• Produktdata fra Open Food Facts

⚖️ EU-BESLUTNINGER
• Se produktets regelstatus i EU, med links til kildedokumenterne
• Følg nyheder og EU-beslutninger om mad i dit område

💚 GRATIS MED REKLAMER
Matsjekk er gratis med reklamer. Vil du have mere plads i indkøbslisten, kan du fjerne reklamerne med et engangskøb – intet abonnement.

Fås på 11 sprog.

Advarslerne er information baseret på tilgængelige data og erstatter ikke etiketten. Tjek altid emballagen.
```

**What's new** (163/500)

```
Nyt i 1.2.0: Gårdbutikker direkte i appen! Kort og liste sorteret efter afstand, filter for økologisk, rutevejledning, hjemmeside og telefon. Virker også uden net.
```

### Apple App Store

**Name** (28/30)

```
Matsjekk – Gårdbutik & liste
```

**Subtitle** (28/30)

```
Indkøbsliste og gårdbutikker
```

**Promotional text** (129/170)

```
Nyhed: gårdbutikker direkte i appen! Find gårdbutikker og lokal mad nær dig på kortet, filtrér på økologisk og få rutevejledning.
```

**Keywords** (91/100)

```
gårdbutik,lokal mad,indkøbsliste,økologisk,stregkode,scanner,bovaer,gmo,insekter,ngt,eu,mad
```

**Description** (1352/4000): same as the Google Play full description above.

**What's new in this version**: same as the Google Play what's new above.

### Huawei AppGallery

**App name** (28): `Matsjekk – Gårdbutik & liste`

**Brief introduction** (78/80): `Indkøbsliste til ægte mad. Find gårdbutikker og lokal mad nær dig. Scan varer.`

**Introduction**: same as the Google Play full description above (1352 characters).

**What's new**: same as above.

### Screenshot captions

1. Indkøbslisten til ægte mad (26/40)
2. Gårdbutikker nær dig (20/40)
3. Scan og se trafiklyset (22/40)
4. EU-beslutninger om din mad (26/40)


---

## Suomi (fi-FI) – `fi`

### Google Play

**Title** (29/30)

```
Matsjekk – Tilapuodit & lista
```

**Short description** (77/80)

```
Ostoslista aidolle ruoalle. Löydä tilapuodit ja lähiruoka läheltäsi. Skannaa.
```

**Full description** (1392/4000)

```
Matsjekk on ostoslista sinulle, joka haluat ostaa aitoa ruokaa – ja tietää enemmän siitä, mitä ostat.

🛒 OSTOSLISTA
• Luo useita ostoslistoja ja rastita tuotteet kaupassa
• Listakohtainen historia, jotta löydät nopeasti tavalliset ostoksesi
• Hae tuotteita ja käytä listaa koko näytöllä kaupassa

🚜 TILAPUODIT JA LÄHIRUOKA
• Kartta ja lista tilapuodeista ja paikallisista ruoantuottajista lähelläsi
• Yli 80 000 tilapuotia 50 maassa
• Lajiteltu etäisyyden mukaan, suodatin luomulle
• Näe osoite ja myytävät tuotteet, hae reittiohjeet, avaa verkkosivu tai soita suoraan
• Tallennetaan puhelimeen, joten toimii myös ilman verkkoa. Sijaintiasi ei tallenneta.

📷 SKANNERI JA LIIKENNEVALOT
• Skannaa viivakoodi ja saat vihreän, keltaisen tai punaisen varoituksen
• Varoitukset Bovaerista (rehun lisäaine), GMO-rehusta, hyönteisainesosista ja NGT:stä (uudet genomitekniikat)
• Valitset itse, mitä varoituksia haluat
• Tuotetiedot Open Food Factsista

⚖️ EU-PÄÄTÖKSET
• Näe tuotteen EU-sääntelytilanne ja linkit lähdeasiakirjoihin
• Seuraa ruokaa koskevia uutisia ja EU-päätöksiä alueellasi

💚 ILMAINEN, SISÄLTÄÄ MAINOKSIA
Matsjekk on ilmainen ja sisältää mainoksia. Jos haluat ostoslistaan enemmän tilaa, voit poistaa mainokset kertaostolla – ei tilausta.

Saatavilla 11 kielellä.

Varoitukset ovat saatavilla olevaan tietoon perustuvaa tietoa eivätkä korvaa tuotemerkintöjä. Tarkista aina pakkaus.
```

**What's new** (180/500)

```
Uutta versiossa 1.2.0: Tilapuodit suoraan sovelluksessa! Kartta ja etäisyyden mukaan lajiteltu lista, luomusuodatin, reittiohjeet, verkkosivu ja puhelin. Toimii myös ilman verkkoa.
```

### Apple App Store

**Name** (29/30)

```
Matsjekk – Tilapuodit & lista
```

**Subtitle** (24/30)

```
Ostoslista ja tilapuodit
```

**Promotional text** (125/170)

```
Uutta: tilapuodit suoraan sovelluksessa! Löydä tilapuodit ja lähiruoka läheltäsi kartalta, suodata luomu ja hae reittiohjeet.
```

**Keywords** (91/100)

```
tilapuoti,lähiruoka,ostoslista,luomu,viivakoodi,skanneri,bovaer,gmo,hyönteiset,ngt,eu,ruoka
```

**Description** (1392/4000): same as the Google Play full description above.

**What's new in this version**: same as the Google Play what's new above.

### Huawei AppGallery

**App name** (29): `Matsjekk – Tilapuodit & lista`

**Brief introduction** (77/80): `Ostoslista aidolle ruoalle. Löydä tilapuodit ja lähiruoka läheltäsi. Skannaa.`

**Introduction**: same as the Google Play full description above (1392 characters).

**What's new**: same as above.

### Screenshot captions

1. Ostoslista aidolle ruoalle (26/40)
2. Tilapuodit lähelläsi (20/40)
3. Skannaa ja katso liikennevalo (29/40)
4. EU-päätökset ruoastasi (22/40)


---

## Deutsch (de-DE) – `de`

### Google Play

**Title** (27/30)

```
Matsjekk – Hofläden & Liste
```

**Short description** (77/80)

```
Einkaufsliste für echtes Essen. Hofläden und regionale Lebensmittel. Scannen.
```

**Full description** (1486/4000)

```
Matsjekk ist die Einkaufsliste für alle, die echte Lebensmittel kaufen – und mehr darüber wissen möchten, was sie kaufen.

🛒 EINKAUFSLISTE
• Mehrere Einkaufslisten anlegen und Artikel beim Einkaufen abhaken
• Verlauf pro Liste, damit du schnell findest, was du sonst kaufst
• Nach Produkten suchen und die Liste im Laden im Vollbild nutzen

🚜 HOFLÄDEN UND REGIONALE LEBENSMITTEL
• Karte und Liste mit Hofläden und regionalen Erzeugern in deiner Nähe
• Über 80.000 Hofläden in 50 Ländern
• Nach Entfernung sortiert, mit Bio-Filter
• Adresse und Angebot ansehen, Route planen, Website öffnen oder direkt anrufen
• Auf dem Handy gespeichert, funktioniert also auch offline. Dein Standort wird nicht gespeichert.

📷 SCANNER MIT AMPEL
• Barcode scannen und eine grüne, gelbe oder rote Warnung erhalten
• Warnungen zu Bovaer (Futterzusatz), GVO-Futter, Insektenzutaten und NGT (neue genomische Techniken)
• Du entscheidest selbst, welche Warnungen du möchtest
• Produktdaten von Open Food Facts

⚖️ EU-BESCHLÜSSE
• EU-Regelstatus eines Produkts ansehen, mit Links zu den Quelldokumenten
• Neuigkeiten und EU-Beschlüsse zu Lebensmitteln in deiner Region verfolgen

💚 KOSTENLOS MIT WERBUNG
Matsjekk ist kostenlos mit Werbung. Wenn du mehr Platz in der Einkaufsliste möchtest, kannst du die Werbung mit einem einmaligen Kauf entfernen – kein Abo.

Verfügbar in 11 Sprachen.

Die Warnungen sind Informationen auf Basis verfügbarer Daten und ersetzen nicht das Etikett. Prüfe immer die Verpackung.
```

**What's new** (150/500)

```
Neu in 1.2.0: Hofläden direkt in der App! Karte und Liste nach Entfernung sortiert, Bio-Filter, Route, Website und Telefon. Funktioniert auch offline.
```

### Apple App Store

**Name** (27/30)

```
Matsjekk – Hofläden & Liste
```

**Subtitle** (24/30)

```
Einkaufsliste & Hofläden
```

**Promotional text** (142/170)

```
Neu: Hofläden direkt in der App! Finde Hofläden und regionale Lebensmittel in deiner Nähe auf der Karte, filtere nach Bio und plane die Route.
```

**Keywords** (89/100)

```
hofladen,regional,einkaufsliste,bio,barcode,scanner,bovaer,gvo,gentechnik,insekten,ngt,eu
```

**Description** (1486/4000): same as the Google Play full description above.

**What's new in this version**: same as the Google Play what's new above.

### Huawei AppGallery

**App name** (27): `Matsjekk – Hofläden & Liste`

**Brief introduction** (77/80): `Einkaufsliste für echtes Essen. Hofläden und regionale Lebensmittel. Scannen.`

**Introduction**: same as the Google Play full description above (1486 characters).

**What's new**: same as above.

### Screenshot captions

1. Die Einkaufsliste für echtes Essen (34/40)
2. Hofläden in deiner Nähe (23/40)
3. Scannen und Ampel sehen (23/40)
4. EU-Beschlüsse zu deinem Essen (29/40)


---

## Nederlands (nl-NL) – `nl`

### Google Play

**Title** (28/30)

```
Matsjekk – Boerderij & lijst
```

**Short description** (77/80)

```
Boodschappenlijst voor echt eten. Vind boerderijwinkels en lokaal eten. Scan.
```

**Full description** (1542/4000)

```
Matsjekk is de boodschappenlijst voor wie echt eten wil kopen – en meer wil weten over wat je koopt.

🛒 BOODSCHAPPENLIJST
• Maak meerdere boodschappenlijsten en vink producten af tijdens het winkelen
• Geschiedenis per lijst, zodat je snel terugvindt wat je meestal koopt
• Zoek naar producten en gebruik de lijst schermvullend in de winkel

🚜 BOERDERIJWINKELS EN LOKAAL ETEN
• Kaart en lijst van boerderijwinkels en lokale voedselproducenten bij jou in de buurt
• Meer dan 80.000 boerderijwinkels in 50 landen
• Gesorteerd op afstand, met een filter voor biologisch
• Bekijk het adres en wat ze verkopen, krijg een routebeschrijving, open de website of bel direct
• Opgeslagen op je telefoon, dus werkt ook offline. Je locatie wordt niet opgeslagen.

📷 SCANNER MET STOPLICHT
• Scan de barcode en krijg een groene, gele of rode waarschuwing
• Waarschuwingen voor Bovaer (voedertoevoeging), ggo-voer, insectenbestanddelen en NGT (nieuwe genomische technieken)
• Je kiest zelf welke waarschuwingen je wilt
• Productgegevens van Open Food Facts

⚖️ EU-BESLUITEN
• Bekijk de EU-regelstatus van een product, met links naar de brondocumenten
• Volg nieuws en EU-besluiten over voedsel in jouw regio

💚 GRATIS MET ADVERTENTIES
Matsjekk is gratis met advertenties. Wil je meer ruimte in je boodschappenlijst, dan kun je de advertenties verwijderen met een eenmalige aankoop – geen abonnement.

Beschikbaar in 11 talen.

De waarschuwingen zijn informatie op basis van beschikbare gegevens en vervangen het etiket niet. Controleer altijd de verpakking.
```

**What's new** (159/500)

```
Nieuw in 1.2.0: Boerderijwinkels direct in de app! Kaart en lijst gesorteerd op afstand, filter voor biologisch, route, website en telefoon. Werkt ook offline.
```

### Apple App Store

**Name** (28/30)

```
Matsjekk – Boerderij & lijst
```

**Subtitle** (30/30)

```
Boodschappen & boerderijwinkel
```

**Promotional text** (150/170)

```
Nieuw: boerderijwinkels direct in de app! Vind boerderijwinkels en lokaal eten bij jou in de buurt op de kaart, filter op biologisch en plan je route.
```

**Keywords** (94/100)

```
boerderijwinkel,lokaal,boodschappenlijst,biologisch,barcode,scanner,bovaer,ggo,insecten,ngt,eu
```

**Description** (1542/4000): same as the Google Play full description above.

**What's new in this version**: same as the Google Play what's new above.

### Huawei AppGallery

**App name** (28): `Matsjekk – Boerderij & lijst`

**Brief introduction** (77/80): `Boodschappenlijst voor echt eten. Vind boerderijwinkels en lokaal eten. Scan.`

**Introduction**: same as the Google Play full description above (1542 characters).

**What's new**: same as above.

### Screenshot captions

1. De boodschappenlijst voor echt eten (35/40)
2. Boerderijwinkels bij jou in de buurt (36/40)
3. Scan en zie het stoplicht (25/40)
4. EU-besluiten over je eten (25/40)


---

## Français (fr-FR) – `fr`

### Google Play

**Title** (25/30)

```
Matsjekk – Fermes & liste
```

**Short description** (77/80)

```
Courses pour de vrais aliments. Fermes et produits locaux près de vous. Scan.
```

**Full description** (1704/4000)

```
Matsjekk est la liste de courses pour celles et ceux qui veulent acheter de vrais aliments – et en savoir plus sur ce qu’ils achètent.

🛒 LISTE DE COURSES
• Créez plusieurs listes de courses et cochez les articles pendant vos achats
• Historique par liste pour retrouver vite ce que vous achetez d’habitude
• Recherchez des produits et utilisez la liste en plein écran en magasin

🚜 VENTE À LA FERME ET PRODUITS LOCAUX
• Carte et liste des boutiques à la ferme et des producteurs locaux près de chez vous
• Plus de 80 000 boutiques à la ferme dans 50 pays
• Triées par distance, avec un filtre bio
• Consultez l’adresse et les produits, obtenez l’itinéraire, ouvrez le site web ou appelez directement
• Enregistré sur le téléphone, donc utilisable hors ligne. Votre position n’est pas enregistrée.

📷 SCANNER AVEC FEUX TRICOLORES
• Scannez le code-barres et obtenez une alerte verte, jaune ou rouge
• Alertes pour le Bovaer (additif alimentaire pour animaux), les aliments pour animaux OGM, les ingrédients à base d’insectes et les NGT (nouvelles techniques génomiques)
• Vous choisissez les alertes que vous voulez
• Données produits d’Open Food Facts

⚖️ DÉCISIONS DE L’UE
• Consultez le statut réglementaire européen d’un produit, avec des liens vers les documents sources
• Suivez l’actualité et les décisions de l’UE sur l’alimentation dans votre région

💚 GRATUIT AVEC PUBLICITÉ
Matsjekk est gratuit avec publicité. Pour plus de place dans la liste de courses, vous pouvez supprimer les publicités par un achat unique – sans abonnement.

Disponible en 11 langues.

Les alertes sont des informations basées sur les données disponibles et ne remplacent pas l’étiquette. Vérifiez toujours l’emballage.
```

**What's new** (168/500)

```
Nouveau dans la 1.2.0 : la vente à la ferme dans l’app ! Carte et liste triées par distance, filtre bio, itinéraire, site web et téléphone. Fonctionne aussi hors ligne.
```

### Apple App Store

**Name** (25/30)

```
Matsjekk – Fermes & liste
```

**Subtitle** (26/30)

```
Liste de courses et fermes
```

**Promotional text** (148/170)

```
Nouveau : la vente à la ferme dans l’app ! Trouvez fermes et produits locaux près de chez vous sur la carte, filtrez le bio et obtenez l’itinéraire.
```

**Keywords** (89/100)

```
ferme,produits locaux,liste de courses,bio,code-barres,scanner,bovaer,ogm,insectes,ngt,ue
```

**Description** (1704/4000): same as the Google Play full description above.

**What's new in this version**: same as the Google Play what's new above.

### Huawei AppGallery

**App name** (25): `Matsjekk – Fermes & liste`

**Brief introduction** (77/80): `Courses pour de vrais aliments. Fermes et produits locaux près de vous. Scan.`

**Introduction**: same as the Google Play full description above (1704 characters).

**What's new**: same as above.

### Screenshot captions

1. La liste de courses du vrai manger (34/40)
2. Fermes près de chez vous (24/40)
3. Scannez, voyez le feu tricolore (31/40)
4. Décisions de l’UE sur vos aliments (34/40)


---

## Italiano (it-IT) – `it`

### Google Play

**Title** (27/30)

```
Matsjekk – Fattorie & lista
```

**Short description** (80/80)

```
Lista della spesa per cibo vero. Trova fattorie e cibo locale vicino. Scansiona.
```

**Full description** (1482/4000)

```
Matsjekk è la lista della spesa per chi vuole comprare cibo vero – e sapere di più su ciò che compra.

🛒 LISTA DELLA SPESA
• Crea più liste della spesa e spunta gli articoli mentre fai la spesa
• Cronologia per ogni lista, per ritrovare subito ciò che compri di solito
• Cerca prodotti e usa la lista a schermo intero nel negozio

🚜 SPACCI AGRICOLI E CIBO LOCALE
• Mappa ed elenco di spacci agricoli e produttori locali vicino a te
• Oltre 80.000 spacci agricoli in 50 paesi
• Ordinati per distanza, con filtro per il biologico
• Vedi indirizzo e prodotti, ottieni indicazioni stradali, apri il sito web o chiama direttamente
• Salvato sul telefono, quindi funziona anche offline. La tua posizione non viene salvata.

📷 SCANNER CON SEMAFORO
• Scansiona il codice a barre e ricevi un avviso verde, giallo o rosso
• Avvisi per Bovaer (additivo per mangimi), mangimi OGM, ingredienti a base di insetti e NGT (nuove tecniche genomiche)
• Scegli tu quali avvisi ricevere
• Dati dei prodotti da Open Food Facts

⚖️ DECISIONI UE
• Vedi lo stato normativo UE di un prodotto, con link ai documenti di origine
• Segui notizie e decisioni UE sul cibo nella tua zona

💚 GRATIS CON PUBBLICITÀ
Matsjekk è gratuita con pubblicità. Se vuoi più spazio nella lista della spesa, puoi rimuovere la pubblicità con un acquisto unico – nessun abbonamento.

Disponibile in 11 lingue.

Gli avvisi sono informazioni basate sui dati disponibili e non sostituiscono l’etichetta. Controlla sempre la confezione.
```

**What's new** (167/500)

```
Novità nella 1.2.0: spacci agricoli direttamente nell’app! Mappa ed elenco ordinati per distanza, filtro bio, indicazioni, sito web e telefono. Funziona anche offline.
```

### Apple App Store

**Name** (27/30)

```
Matsjekk – Fattorie & lista
```

**Subtitle** (29/30)

```
Lista spesa e spacci agricoli
```

**Promotional text** (146/170)

```
Novità: spacci agricoli direttamente nell’app! Trova fattorie e cibo locale vicino a te sulla mappa, filtra il biologico e ottieni le indicazioni.
```

**Keywords** (95/100)

```
spaccio agricolo,km zero,lista spesa,biologico,codice a barre,scanner,bovaer,ogm,insetti,ngt,ue
```

**Description** (1482/4000): same as the Google Play full description above.

**What's new in this version**: same as the Google Play what's new above.

### Huawei AppGallery

**App name** (27): `Matsjekk – Fattorie & lista`

**Brief introduction** (80/80): `Lista della spesa per cibo vero. Trova fattorie e cibo locale vicino. Scansiona.`

**Introduction**: same as the Google Play full description above (1482 characters).

**What's new**: same as above.

### Screenshot captions

1. La lista della spesa per cibo vero (34/40)
2. Spacci agricoli vicino a te (27/40)
3. Scansiona e guarda il semaforo (30/40)
4. Decisioni UE sul tuo cibo (25/40)


---

## Português (pt-PT / pt-BR) – `pt`

### Google Play

**Title** (26/30)

```
Matsjekk – Quintas & lista
```

**Short description** (79/80)

```
Lista de compras para comida real. Encontre quintas e comida local. Digitalize.
```

**Full description** (1474/4000)

```
O Matsjekk é a lista de compras para quem quer comprar comida verdadeira – e saber mais sobre o que compra.

🛒 LISTA DE COMPRAS
• Crie várias listas de compras e marque os artigos enquanto faz compras
• Histórico por lista, para encontrar rapidamente o que costuma comprar
• Pesquise produtos e use a lista em ecrã inteiro na loja

🚜 LOJAS DE QUINTA E COMIDA LOCAL
• Mapa e lista de lojas de quinta e produtores locais perto de si
• Mais de 80 000 lojas de quinta em 50 países
• Ordenadas por distância, com filtro para biológico
• Veja a morada e o que vendem, obtenha direções, abra o site ou ligue diretamente
• Guardado no telemóvel, por isso funciona offline. A sua localização não é guardada.

📷 LEITOR COM SEMÁFORO
• Leia o código de barras e receba um alerta verde, amarelo ou vermelho
• Alertas para Bovaer (aditivo para rações), rações OGM, ingredientes de insetos e NGT (novas técnicas genómicas)
• Escolhe quais os alertas que pretende
• Dados de produtos da Open Food Facts

⚖️ DECISÕES DA UE
• Veja o estado regulamentar de um produto na UE, com ligações para os documentos de origem
• Acompanhe notícias e decisões da UE sobre alimentação na sua região

💚 GRÁTIS COM ANÚNCIOS
O Matsjekk é gratuito com anúncios. Se quiser mais espaço na lista de compras, pode remover os anúncios com uma compra única – sem subscrição.

Disponível em 11 idiomas.

Os alertas são informação baseada nos dados disponíveis e não substituem o rótulo. Verifique sempre a embalagem.
```

**What's new** (158/500)

```
Novo na 1.2.0: lojas de quinta diretamente na app! Mapa e lista ordenados por distância, filtro biológico, direções, site e telefone. Também funciona offline.
```

### Apple App Store

**Name** (26/30)

```
Matsjekk – Quintas & lista
```

**Subtitle** (26/30)

```
Lista de compras e quintas
```

**Promotional text** (139/170)

```
Novidade: lojas de quinta diretamente na app! Encontre quintas e comida local perto de si no mapa, filtre por biológico e obtenha direções.
```

**Keywords** (94/100)

```
quinta,comida local,lista de compras,biológico,código de barras,scanner,bovaer,ogm,insetos,ngt
```

**Description** (1474/4000): same as the Google Play full description above.

**What's new in this version**: same as the Google Play what's new above.

### Huawei AppGallery

**App name** (26): `Matsjekk – Quintas & lista`

**Brief introduction** (79/80): `Lista de compras para comida real. Encontre quintas e comida local. Digitalize.`

**Introduction**: same as the Google Play full description above (1474 characters).

**What's new**: same as above.

### Screenshot captions

1. A lista de compras para comida real (35/40)
2. Lojas de quinta perto de si (27/40)
3. Leia e veja o semáforo (22/40)
4. Decisões da UE sobre a sua comida (33/40)


---

## Español (es-ES / es-419) – `es`

### Google Play

**Title** (26/30)

```
Matsjekk – Granjas & lista
```

**Short description** (79/80)

```
Lista de la compra para comida real. Encuentra granjas y comida local. Escanea.
```

**Full description** (1522/4000)

```
Matsjekk es la lista de la compra para quien quiere comprar comida de verdad – y saber más sobre lo que compra.

🛒 LISTA DE LA COMPRA
• Crea varias listas de la compra y marca los productos mientras compras
• Historial por lista, para encontrar rápido lo que sueles comprar
• Busca productos y usa la lista a pantalla completa en la tienda

🚜 TIENDAS DE GRANJA Y COMIDA LOCAL
• Mapa y lista de tiendas de granja y productores locales cerca de ti
• Más de 80.000 tiendas de granja en 50 países
• Ordenadas por distancia, con filtro ecológico
• Consulta la dirección y lo que venden, obtén indicaciones, abre la web o llama directamente
• Se guarda en el teléfono, así que funciona sin conexión. Tu ubicación no se guarda.

📷 ESCÁNER CON SEMÁFORO
• Escanea el código de barras y recibe una alerta verde, amarilla o roja
• Alertas sobre Bovaer (aditivo para piensos), piensos con OMG, ingredientes de insectos y NGT (nuevas técnicas genómicas)
• Tú eliges qué alertas quieres
• Datos de productos de Open Food Facts

⚖️ DECISIONES DE LA UE
• Consulta el estado normativo de la UE de un producto, con enlaces a los documentos de origen
• Sigue las noticias y decisiones de la UE sobre alimentación en tu zona

💚 GRATIS CON ANUNCIOS
Matsjekk es gratis con anuncios. Si quieres más espacio en la lista de la compra, puedes quitar los anuncios con una compra única – sin suscripción.

Disponible en 11 idiomas.

Las alertas son información basada en los datos disponibles y no sustituyen la etiqueta. Comprueba siempre el envase.
```

**What's new** (166/500)

```
Novedades en 1.2.0: ¡tiendas de granja en la app! Mapa y lista ordenados por distancia, filtro ecológico, indicaciones, web y teléfono. También funciona sin conexión.
```

### Apple App Store

**Name** (26/30)

```
Matsjekk – Granjas & lista
```

**Subtitle** (25/30)

```
Lista de compra y granjas
```

**Promotional text** (138/170)

```
Novedad: ¡tiendas de granja en la app! Encuentra granjas y comida local cerca de ti en el mapa, filtra por ecológico y obtén indicaciones.
```

**Keywords** (97/100)

```
granja,comida local,lista de la compra,ecológico,código de barras,escáner,bovaer,omg,insectos,ngt
```

**Description** (1522/4000): same as the Google Play full description above.

**What's new in this version**: same as the Google Play what's new above.

### Huawei AppGallery

**App name** (26): `Matsjekk – Granjas & lista`

**Brief introduction** (79/80): `Lista de la compra para comida real. Encuentra granjas y comida local. Escanea.`

**Introduction**: same as the Google Play full description above (1522 characters).

**What's new**: same as above.

### Screenshot captions

1. La lista de la compra de verdad (31/40)
2. Tiendas de granja cerca de ti (29/40)
3. Escanea y mira el semáforo (26/40)
4. Decisiones de la UE sobre tu comida (35/40)

