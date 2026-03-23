const supportedLanguages = [
  { code: 'nb', label: 'Norsk' },
  { code: 'en', label: 'English' },
  { code: 'sv', label: 'Svenska' },
  { code: 'da', label: 'Dansk' },
  { code: 'fi', label: 'Suomi' },
  { code: 'de', label: 'Deutsch' },
  { code: 'nl', label: 'Nederlands' },
  { code: 'fr', label: 'Francais' },
  { code: 'it', label: 'Italiano' },
  { code: 'pt', label: 'Portugues' },
  { code: 'es', label: 'Espanol' },
];

const AUTO_LANGUAGE_CODE = 'auto';
const LOCAL_UI_LANGUAGES = ['nb', 'en', 'sv', 'da', 'fi', 'de', 'nl', 'fr', 'it', 'pt', 'es'];

const translations = {
  nb: {
    title: '🛒 Mat Sjekk',
    tagline: 'Skann mat, velg bevisst',
    privacy: 'Personvern',
    terms: 'Vilkår',
    analytics: 'Analytics',
    navHome: 'Hjem',
    navFarmshops: 'Gardsbutikker',
    navOrganicFarmshops: 'Okologiske gardsbutikker',
    navImmigrantShops: 'Innvandrerbutikker',
    navNews: 'Nyheter',
    navContact: 'Kontakt oss',
    heroHeading: 'Din personlige matvareguide',
    heroIntro: 'Skann strekkoder og fa umiddelbar informasjon om Bovaer, GMO-fiskefor og insektmel i matvarene dine.',
    ctaAppStore: '📱 Last ned pa App Store',
    ctaGooglePlay: '🤖 Last ned pa Google Play',
    ctaFindFarmshops: '🏬 Finn Gardsbutikker',
    ctaFindOrganicFarmshops: '🌿 Finn Okologiske Gardsbutikker',
    ctaFindImmigrantShops: '🛒 Finn Innvandrerbutikker',
    featuresHeading: 'Funksjoner',
    featureScanTitle: 'Strekkodeskanning',
    featureScanText: 'Skann produkter direkte i butikken med mobilkameraet ditt',
    featureBovaerTitle: 'Bovaer-varsler',
    featureBovaerText: 'Umiddelbar informasjon om produkter fra produsenter som bruker Bovaer',
    featureGmoTitle: 'GMO-fiskefor',
    featureGmoText: 'Sjekk om oppdrettslaks inneholder GMO-fiskefor',
    featureInsectTitle: 'Insektmel',
    featureInsectText: 'Varsler om produkter med insektinnhold',
    featureListTitle: 'Handlelister',
    featureListText: 'Lag og administrer flere handlelister samtidig',
    featureLangTitle: '11 sprak',
    featureLangText: 'Stotte for norsk, engelsk, svensk, dansk, finsk, tysk, nederlandsk, fransk, italiensk, portugisisk og spansk',
    adPlaceholder: 'Reklameplass (vises etter at du godtar informasjonskapsler)',
    howHeading: 'Slik fungerer det',
    howStep1Title: 'Last ned appen',
    howStep1Text: '- Gratis pa App Store og Google Play',
    howStep2Title: 'Skann strekkoden',
    howStep2Text: '- Rett pa produktet i butikken',
    howStep3Title: 'Se resultatet',
    howStep3Text: '- Fa umiddelbar informasjon om risikoniva',
    howStep4Title: 'Velg bevisst',
    howStep4Text: '- Bestem selv hva du vil kjope',
    aboutHeading: 'Om Mat Sjekk',
    aboutText1: 'Mat Sjekk er utviklet for bevisste forbrukere som onsker full kontroll over hva de kjoper. Appen bruker data fra OpenFoodFacts og andre apne kilder for a gi deg aerlig informasjon om matvarene dine.',
    aboutText2: 'Vi tar ikke stilling til om Bovaer, GMO eller insektmel er bra eller darlig - vi gir deg bare informasjonen du trenger for a ta dine egne valg.',
    faqHeading: 'Vanlige sporsmal',
    faq1Q: 'Er appen helt gratis?',
    faq1A: 'Ja, Mat Sjekk er helt gratis a laste ned og bruke. Vi finansieres gjennom annonser.',
    faq2Q: 'Hvor kommer dataene fra?',
    faq2A: 'Vi bruker primaert OpenFoodFacts, en apen database med produktinformasjon. For enkelte land bruker vi ogsa nasjonale matvarebaser som Matvaretabellen (Norge) og Fineli (Finland).',
    faq3Q: 'Hvordan vet jeg om informasjonen er korrekt?',
    faq3A: 'Vi baserer oss pa offentlig tilgjengelig informasjon om hvilke produsenter som bruker Bovaer, GMO-fiskefor eller insektmel. Produktdatabasen oppdateres kontinuerlig.',
    faq4Q: 'Hvilke land stottes?',
    faq4A: 'Appen fungerer i hele verden, men vi har spesialdata for Norge, Sverige, Danmark, Finland, Tyskland, Nederland, Frankrike, Italia, Portugal, Spania og Storbritannia.',
    faq5Q: 'Lagrer dere personlig informasjon?',
    faq5A: 'Nei. Alt lagres lokalt pa din telefon. Vi samler ikke inn eller deler persondata.',
    contactHeading: 'Kontakt',
    contactIntro: 'Har du sporsmal, tilbakemeldinger eller forslag?',
    newsHeading: 'Nyheter',
    newsIntro: 'Hold deg oppdatert - legg til relevante artikler om Bovaer, GMO, insektmel og baerekraft.',
    newsModerationNote: 'Innsendte artikler publiseres ikke direkte. De gar til moderering forst.',
    newsLanguageLabel: 'Lesesprak / oversett til:',
    newsRegionLabel: 'Region:',
    newsAddArticleBtn: 'Legg til artikkel',
    newsFormHeading: 'Legg til artikkel',
    newsFormTitleLabel: 'Tittel',
    newsFormSourceLabel: 'Kilde',
    newsFormUrlLabel: 'URL',
    newsFormLanguageLabel: 'Sprak',
    newsSubmitForModerationBtn: 'Send til moderering',
    cancel: 'Avbryt',
    footerCopyright: '© 2026 Mat Sjekk / Einar\'s Apps. Alle rettigheter reservert.',
  },
  en: {
    title: '🛒 Food Control',
    tagline: 'Scan food, choose consciously',
    privacy: 'Privacy',
    terms: 'Terms',
    analytics: 'Analytics',
    navHome: 'Home',
    navFarmshops: 'Farm Shops',
    navOrganicFarmshops: 'Organic Farm Shops',
    navImmigrantShops: 'Immigrant Shops',
    navNews: 'News',
    navContact: 'Contact us',
    heroHeading: 'Your personal food guide',
    heroIntro: 'Scan barcodes and get instant information about Bovaer, GMO fish feed, and insect meal in your groceries.',
    ctaAppStore: '📱 Download on the App Store',
    ctaGooglePlay: '🤖 Download on Google Play',
    ctaFindFarmshops: '🏬 Find Farm Shops',
    ctaFindOrganicFarmshops: '🌿 Find Organic Farm Shops',
    ctaFindImmigrantShops: '🛒 Find Immigrant Shops',
    featuresHeading: 'Features',
    featureScanTitle: 'Barcode scanning',
    featureScanText: 'Scan products directly in stores with your camera',
    featureBovaerTitle: 'Bovaer alerts',
    featureBovaerText: 'Instant information about producers using Bovaer',
    featureGmoTitle: 'GMO fish feed',
    featureGmoText: 'Check whether farmed fish includes GMO fish feed',
    featureInsectTitle: 'Insect meal',
    featureInsectText: 'Warnings for products containing insect ingredients',
    featureListTitle: 'Shopping lists',
    featureListText: 'Create and manage multiple shopping lists',
    featureLangTitle: '11 languages',
    featureLangText: 'Supports Norwegian, English, Swedish, Danish, Finnish, German, Dutch, French, Italian, Portuguese, and Spanish',
    adPlaceholder: 'Ad space (shown after cookie consent)',
    howHeading: 'How it works',
    howStep1Title: 'Download the app',
    howStep1Text: '- Free on the App Store and Google Play',
    howStep2Title: 'Scan the barcode',
    howStep2Text: '- Point your phone at a product in store',
    howStep3Title: 'See the result',
    howStep3Text: '- Get instant risk-level information',
    howStep4Title: 'Choose consciously',
    howStep4Text: '- Decide what you want to buy',
    aboutHeading: 'About Food Control',
    aboutText1: 'Mat Check is made for conscious consumers who want full control over what they buy. The app uses OpenFoodFacts and other open sources to provide transparent information.',
    aboutText2: 'We do not tell you whether Bovaer, GMO, or insect meal is good or bad. We provide information so you can make your own choices.',
    faqHeading: 'FAQ',
    faq1Q: 'Is the app completely free?',
    faq1A: 'Yes. Food Control is free to download and use. We are funded by ads.',
    faq2Q: 'Where does the data come from?',
    faq2A: 'We primarily use OpenFoodFacts and, for some countries, national food databases.',
    faq3Q: 'How do I know the information is correct?',
    faq3A: 'We use publicly available information and continuously update the product database.',
    faq4Q: 'Which countries are supported?',
    faq4A: 'The app works worldwide, with dedicated datasets for several European countries and the UK.',
    faq5Q: 'Do you store personal information?',
    faq5A: 'No. Data is stored locally on your phone. We do not collect or share personal data.',
    contactHeading: 'Contact',
    contactIntro: 'Questions, feedback, or suggestions?',
    newsHeading: 'News',
    newsIntro: 'Stay updated - add relevant articles about Bovaer, GMO, insect meal, and sustainability.',
    newsModerationNote: 'Submitted articles are not published directly. They go to moderation first.',
    newsLanguageLabel: 'Reading language / translate to:',
    newsRegionLabel: 'Region:',
    newsAddArticleBtn: 'Add article',
    newsFormHeading: 'Add article',
    newsFormTitleLabel: 'Title',
    newsFormSourceLabel: 'Source',
    newsFormUrlLabel: 'URL',
    newsFormLanguageLabel: 'Language',
    newsSubmitForModerationBtn: 'Send for moderation',
    cancel: 'Cancel',
    footerCopyright: '© 2026 Mat Sjekk / Einar\'s Apps. All rights reserved.',
  },
  sv: {
    title: '🛒 Mat Sjekk',
    tagline: 'Skanna mat, välj medvetet',
    privacy: 'Integritet',
    terms: 'Villkor',
    analytics: 'Analytics',
    navHome: 'Hem',
    navFarmshops: 'Gårdsbutiker',
    navOrganicFarmshops: 'Ekologiska gårdsbutiker',
    navImmigrantShops: 'Invandrarbutiker',
    navNews: 'Nyheter',
    navContact: 'Kontakta oss',
    heroHeading: 'Din personliga matguide',
    heroIntro: 'Skanna streckkoder och få omedelbar information om Bovaer, GMO-fiskfoder och insektsmjöl i dina matvaror.',
    ctaAppStore: '📱 Ladda ner på App Store',
    ctaGooglePlay: '🤖 Ladda ner på Google Play',
    ctaFindFarmshops: '🏬 Hitta gårdsbutiker',
    ctaFindOrganicFarmshops: '🌿 Hitta ekologiska gårdsbutiker',
    ctaFindImmigrantShops: '🛒 Hitta invandrarbutiker',
    featuresHeading: 'Funktioner',
    featureScanTitle: 'Streckkodsskanning',
    featureScanText: 'Skanna produkter direkt i butiken med din kamera',
    featureBovaerTitle: 'Bovaer-varningar',
    featureBovaerText: 'Omedelbar information om producenter som använder Bovaer',
    featureGmoTitle: 'GMO-fiskfoder',
    featureGmoText: 'Kontrollera om odlad fisk innehåller GMO-fiskfoder',
    featureInsectTitle: 'Insektsmjöl',
    featureInsectText: 'Varningar för produkter med insektsinnehåll',
    featureListTitle: 'Inköpslistor',
    featureListText: 'Skapa och hantera flera inköpslistor samtidigt',
    featureLangTitle: '11 språk',
    featureLangText: 'Stöd för norska, engelska, svenska, danska, finska, tyska, nederländska, franska, italienska, portugisiska och spanska',
    adPlaceholder: 'Annonsplats (visas efter cookie-godkännande)',
    howHeading: 'Så fungerar det',
    howStep1Title: 'Ladda ner appen',
    howStep1Text: '- Gratis på App Store och Google Play',
    howStep2Title: 'Skanna streckkoden',
    howStep2Text: '- Peka på produkten i butiken',
    howStep3Title: 'Se resultatet',
    howStep3Text: '- Få omedelbar information om risknivå',
    howStep4Title: 'Välj medvetet',
    howStep4Text: '- Bestäm själv vad du vill köpa',
    aboutHeading: 'Om Mat Sjekk',
    aboutText1: 'Mat Sjekk är utvecklad för medvetna konsumenter som vill ha full kontroll över vad de köper. Appen använder data från OpenFoodFacts och andra öppna källor.',
    aboutText2: 'Vi tar inte ställning till om Bovaer, GMO eller insektsmjöl är bra eller dåligt – vi ger dig informationen du behöver för att göra egna val.',
    faqHeading: 'Vanliga frågor',
    faq1Q: 'Är appen helt gratis?',
    faq1A: 'Ja. Mat Sjekk är gratis att ladda ner och använda. Vi finansieras genom annonser.',
    faq2Q: 'Varifrån kommer uppgifterna?',
    faq2A: 'Vi använder primärt OpenFoodFacts och nationella livsmedelsdatabaser för vissa länder.',
    faq3Q: 'Hur vet jag att informationen stämmer?',
    faq3A: 'Vi baserar oss på offentligt tillgänglig information och uppdaterar produktdatabasen kontinuerligt.',
    faq4Q: 'Vilka länder stöds?',
    faq4A: 'Appen fungerar globalt, med specialdata för flera europeiska länder och Storbritannien.',
    faq5Q: 'Sparar ni personlig information?',
    faq5A: 'Nej. All data lagras lokalt på din telefon. Vi samlar inte in eller delar personliga uppgifter.',
    contactHeading: 'Kontakt',
    contactIntro: 'Frågor, feedback eller förslag?',
    newsHeading: 'Nyheter',
    newsIntro: 'Håll dig uppdaterad – lägg till relevanta artiklar om Bovaer, GMO, insektsmjöl och hållbarhet.',
    newsModerationNote: 'Inskickade artiklar publiceras inte direkt. De granskas av redaktionen.',
    newsLanguageLabel: 'Läsespråk / översätt till:',
    newsRegionLabel: 'Region:',
    newsAddArticleBtn: 'Lägg till artikel',
    newsFormHeading: 'Lägg till artikel',
    newsFormTitleLabel: 'Titel',
    newsFormSourceLabel: 'Källa',
    newsFormUrlLabel: 'URL',
    newsFormLanguageLabel: 'Språk',
    newsSubmitForModerationBtn: 'Skicka för granskning',
    cancel: 'Avbryt',
    footerCopyright: '© 2026 Mat Sjekk / Einar\'s Apps. Alla rättigheter förbehållna.',
  },
  da: {
    title: '🛒 Mat Sjekk',
    tagline: 'Scan mad, vælg bevidst',
    privacy: 'Privatliv',
    terms: 'Vilkår',
    analytics: 'Analytics',
    navHome: 'Hjem',
    navFarmshops: 'Gårdsbutikker',
    navOrganicFarmshops: 'Økologiske gårdsbutikker',
    navImmigrantShops: 'Indvandrerbutikker',
    navNews: 'Nyheder',
    navContact: 'Kontakt os',
    heroHeading: 'Din personlige fødevareguide',
    heroIntro: 'Scan stregkoder og få øjeblikkelig information om Bovaer, GMO-fiskefoder og insektmel i dine fødevarer.',
    ctaAppStore: '📱 Download på App Store',
    ctaGooglePlay: '🤖 Download på Google Play',
    ctaFindFarmshops: '🏬 Find gårdsbutikker',
    ctaFindOrganicFarmshops: '🌿 Find økologiske gårdsbutikker',
    ctaFindImmigrantShops: '🛒 Find indvandrerbutikker',
    featuresHeading: 'Funktioner',
    featureScanTitle: 'Stregkodescanning',
    featureScanText: 'Scan produkter direkte i butikken med dit kamera',
    featureBovaerTitle: 'Bovaer-advarsler',
    featureBovaerText: 'Øjeblikkelig information om producenter der bruger Bovaer',
    featureGmoTitle: 'GMO-fiskefoder',
    featureGmoText: 'Kontrollér om opdrætsfisk indeholder GMO-fiskefoder',
    featureInsectTitle: 'Insektmel',
    featureInsectText: 'Advarsler om produkter med insektindhold',
    featureListTitle: 'Indkøbslister',
    featureListText: 'Opret og administrer flere indkøbslister samtidigt',
    featureLangTitle: '11 sprog',
    featureLangText: 'Understøttelse af norsk, engelsk, svensk, dansk, finsk, tysk, nederlandsk, fransk, italiensk, portugisisk og spansk',
    adPlaceholder: 'Reklameplads (vises efter cookie-samtykke)',
    howHeading: 'Sådan fungerer det',
    howStep1Title: 'Download appen',
    howStep1Text: '- Gratis på App Store og Google Play',
    howStep2Title: 'Scan stregkoden',
    howStep2Text: '- Peg på produktet i butikken',
    howStep3Title: 'Se resultatet',
    howStep3Text: '- Få øjeblikkelig information om risikoniveau',
    howStep4Title: 'Vælg bevidst',
    howStep4Text: '- Bestem selv hvad du vil købe',
    aboutHeading: 'Om Mat Sjekk',
    aboutText1: 'Mat Sjekk er udviklet til bevidste forbrugere, der ønsker fuld kontrol over hvad de køber. Appen bruger data fra OpenFoodFacts og andre åbne kilder.',
    aboutText2: 'Vi tager ikke stilling til, om Bovaer, GMO eller insektmel er godt eller skidt – vi giver dig informationen, så du kan tage dine egne valg.',
    faqHeading: 'Ofte stillede spørgsmål',
    faq1Q: 'Er appen helt gratis?',
    faq1A: 'Ja. Mat Sjekk er gratis at downloade og bruge. Vi finansieres af annoncer.',
    faq2Q: 'Hvor kommer dataene fra?',
    faq2A: 'Vi bruger primært OpenFoodFacts og nationale fødevaredatabaser for visse lande.',
    faq3Q: 'Hvordan ved jeg, om informationen er korrekt?',
    faq3A: 'Vi bruger offentligt tilgængelig information og opdaterer produktdatabasen løbende.',
    faq4Q: 'Hvilke lande understøttes?',
    faq4A: 'Appen fungerer globalt, med specialdata for flere europæiske lande og Storbritannien.',
    faq5Q: 'Gemmer I personlige oplysninger?',
    faq5A: 'Nej. Alle data gemmes lokalt på din telefon. Vi indsamler eller deler ikke persondata.',
    contactHeading: 'Kontakt',
    contactIntro: 'Spørgsmål, feedback eller forslag?',
    newsHeading: 'Nyheder',
    newsIntro: 'Hold dig opdateret – tilføj relevante artikler om Bovaer, GMO, insektmel og bæredygtighed.',
    newsModerationNote: 'Indsendte artikler offentliggøres ikke direkte. De gennemgås af redaktionen.',
    newsLanguageLabel: 'Læsesprog / oversæt til:',
    newsRegionLabel: 'Region:',
    newsAddArticleBtn: 'Tilføj artikel',
    newsFormHeading: 'Tilføj artikel',
    newsFormTitleLabel: 'Titel',
    newsFormSourceLabel: 'Kilde',
    newsFormUrlLabel: 'URL',
    newsFormLanguageLabel: 'Sprog',
    newsSubmitForModerationBtn: 'Send til moderering',
    cancel: 'Annuller',
    footerCopyright: '© 2026 Mat Sjekk / Einar\'s Apps. Alle rettigheder forbeholdes.',
  },
  fi: {
    title: '🛒 Mat Sjekk',
    tagline: 'Skannaa ruoka, valitse tietoisesti',
    privacy: 'Tietosuoja',
    terms: 'Ehdot',
    analytics: 'Analytiikka',
    navHome: 'Koti',
    navFarmshops: 'Tilakaupat',
    navOrganicFarmshops: 'Luomun tilakaupat',
    navImmigrantShops: 'Maahanmuuttajakaupat',
    navNews: 'Uutiset',
    navContact: 'Ota yhteyttä',
    heroHeading: 'Henkilökohtainen ruokaoppaasi',
    heroIntro: 'Skannaa viivakoodeja ja saa välitöntä tietoa Bovaerista, GMO-kalarehusta ja hyönteisjauhosta elintarvikkeissasi.',
    ctaAppStore: '📱 Lataa App Storesta',
    ctaGooglePlay: '🤖 Lataa Google Playsta',
    ctaFindFarmshops: '🏬 Etsi tilakauppoja',
    ctaFindOrganicFarmshops: '🌿 Etsi luomun tilakauppoja',
    ctaFindImmigrantShops: '🛒 Etsi maahanmuuttajakauppoja',
    featuresHeading: 'Ominaisuudet',
    featureScanTitle: 'Viivakoodiskannaus',
    featureScanText: 'Skannaa tuotteita suoraan kaupassa kamerallasi',
    featureBovaerTitle: 'Bovaer-varoitukset',
    featureBovaerText: 'Välitöntä tietoa Bovaeria käyttävistä tuottajista',
    featureGmoTitle: 'GMO-kalarehu',
    featureGmoText: 'Tarkista sisältääkö kasvatettu kala GMO-kalarehua',
    featureInsectTitle: 'Hyönteisjauho',
    featureInsectText: 'Varoitukset hyönteisiä sisältävistä tuotteista',
    featureListTitle: 'Ostoslistat',
    featureListText: 'Luo ja hallinnoi useita ostoslistoja samanaikaisesti',
    featureLangTitle: '11 kieltä',
    featureLangText: 'Tuki norjaksi, englanniksi, ruotsiksi, tanskaksi, suomeksi, saksaksi, hollanniksi, ranskaksi, italiaksi, portugaliksi ja espanjaksi',
    adPlaceholder: 'Mainostila (näytetään evästeiden hyväksynnän jälkeen)',
    howHeading: 'Näin se toimii',
    howStep1Title: 'Lataa sovellus',
    howStep1Text: '- Ilmainen App Storesta ja Google Playsta',
    howStep2Title: 'Skannaa viivakoodi',
    howStep2Text: '- Osoita tuotetta kaupassa',
    howStep3Title: 'Katso tulos',
    howStep3Text: '- Saa välitöntä riskitason tietoa',
    howStep4Title: 'Valitse tietoisesti',
    howStep4Text: '- Päätä itse mitä haluat ostaa',
    aboutHeading: 'Tietoa Mat Sjekkistä',
    aboutText1: 'Mat Sjekk on kehitetty tietoisille kuluttajille, jotka haluavat täyden hallinnan ostoksiinsa. Sovellus käyttää dataa OpenFoodFactsista ja muista avoimista lähteistä.',
    aboutText2: 'Emme ota kantaa siihen, onko Bovaer, GMO tai hyönteisjauho hyvää vai huonoa – annamme sinulle tiedon, jotta voit tehdä omat valintasi.',
    faqHeading: 'Usein kysytyt kysymykset',
    faq1Q: 'Onko sovellus täysin ilmainen?',
    faq1A: 'Kyllä. Mat Sjekk on ilmainen ladata ja käyttää. Rahoitamme toimintamme mainoksilla.',
    faq2Q: 'Mistä data tulee?',
    faq2A: 'Käytämme pääasiassa OpenFoodFactsia ja joidenkin maiden kansallisia elintarviketietokantoja.',
    faq3Q: 'Miten tiedän, että tieto on oikeaa?',
    faq3A: 'Käytämme julkisesti saatavilla olevaa tietoa ja päivitämme tuotetietokantaa jatkuvasti.',
    faq4Q: 'Mitä maita tuetaan?',
    faq4A: 'Sovellus toimii maailmanlaajuisesti, ja erityisdataa on useille Euroopan maille ja Britannialle.',
    faq5Q: 'Tallennatteko henkilötietoja?',
    faq5A: 'Ei. Kaikki data tallennetaan paikallisesti puhelimeesi. Emme kerää tai jaa henkilötietoja.',
    contactHeading: 'Yhteystiedot',
    contactIntro: 'Kysymyksiä, palautetta tai ehdotuksia?',
    newsHeading: 'Uutiset',
    newsIntro: 'Pysy ajan tasalla – lisää artikkeleita Bovaerista, GMO:sta, hyönteisjauhosta ja kestävyydestä.',
    newsModerationNote: 'Lähetettyjä artikkeleita ei julkaista suoraan. Ne käyvät läpi moderoinnin.',
    newsLanguageLabel: 'Lukukieli / käännös:',
    newsRegionLabel: 'Alue:',
    newsAddArticleBtn: 'Lisää artikkeli',
    newsFormHeading: 'Lisää artikkeli',
    newsFormTitleLabel: 'Otsikko',
    newsFormSourceLabel: 'Lähde',
    newsFormUrlLabel: 'URL',
    newsFormLanguageLabel: 'Kieli',
    newsSubmitForModerationBtn: 'Lähetä moderointiin',
    cancel: 'Peruuta',
    footerCopyright: '© 2026 Mat Sjekk / Einar\'s Apps. Kaikki oikeudet pidätetään.',
  },
  de: {
    title: '🛒 LebensmittelCheck',
    tagline: 'Lebensmittel scannen, bewusst wählen',
    privacy: 'Datenschutz',
    terms: 'AGB',
    analytics: 'Analysen',
    navHome: 'Startseite',
    navFarmshops: 'Hofläden',
    navOrganicFarmshops: 'Bio-Hofläden',
    navImmigrantShops: 'Internationale Läden',
    navNews: 'Nachrichten',
    navContact: 'Kontakt',
    heroHeading: 'Dein persönlicher Lebensmittelführer',
    heroIntro: 'Scanne Barcodes und erhalte sofort Informationen über Bovaer, GMO-Fischfutter und Insektenmehl in deinen Lebensmitteln.',
    ctaAppStore: '📱 Im App Store laden',
    ctaGooglePlay: '🤖 Bei Google Play laden',
    ctaFindFarmshops: '🏬 Hofläden finden',
    ctaFindOrganicFarmshops: '🌿 Bio-Hofläden finden',
    ctaFindImmigrantShops: '🛒 Internationale Läden finden',
    featuresHeading: 'Funktionen',
    featureScanTitle: 'Barcode-Scan',
    featureScanText: 'Scanne Produkte direkt im Laden mit deiner Kamera',
    featureBovaerTitle: 'Bovaer-Warnungen',
    featureBovaerText: 'Sofortige Informationen über Hersteller, die Bovaer verwenden',
    featureGmoTitle: 'GMO-Fischfutter',
    featureGmoText: 'Prüfe, ob Zuchtfisch GMO-Fischfutter enthält',
    featureInsectTitle: 'Insektenmehl',
    featureInsectText: 'Warnungen bei Produkten mit Insektenbestandteilen',
    featureListTitle: 'Einkaufslisten',
    featureListText: 'Erstelle und verwalte mehrere Einkaufslisten gleichzeitig',
    featureLangTitle: '11 Sprachen',
    featureLangText: 'Unterstützung für Norwegisch, Englisch, Schwedisch, Dänisch, Finnisch, Deutsch, Niederländisch, Französisch, Italienisch, Portugiesisch und Spanisch',
    adPlaceholder: 'Werbefläche (wird nach Cookie-Zustimmung angezeigt)',
    howHeading: 'So funktioniert es',
    howStep1Title: 'App herunterladen',
    howStep1Text: '- Kostenlos im App Store und bei Google Play',
    howStep2Title: 'Barcode scannen',
    howStep2Text: '- Richte dein Handy auf ein Produkt im Laden',
    howStep3Title: 'Ergebnis ansehen',
    howStep3Text: '- Erhalte sofort eine Risikobewertung',
    howStep4Title: 'Bewusst wählen',
    howStep4Text: '- Entscheide selbst, was du kaufst',
    aboutHeading: 'Über LebensmittelCheck',
    aboutText1: 'Mat Sjekk wurde für bewusste Verbraucher entwickelt, die volle Kontrolle über ihre Einkäufe haben möchten. Die App nutzt Daten von OpenFoodFacts und anderen offenen Quellen.',
    aboutText2: 'Wir nehmen keine Stellung dazu, ob Bovaer, GMO oder Insektenmehl gut oder schlecht ist – wir liefern die Informationen, damit du eigene Entscheidungen treffen kannst.',
    faqHeading: 'Häufige Fragen',
    faq1Q: 'Ist die App völlig kostenlos?',
    faq1A: 'Ja. Mat Sjekk ist kostenlos. Wir finanzieren uns über Werbung.',
    faq2Q: 'Woher stammen die Daten?',
    faq2A: 'Wir nutzen hauptsächlich OpenFoodFacts und für einige Länder nationale Lebensmitteldatenbanken.',
    faq3Q: 'Wie weiß ich, ob die Informationen korrekt sind?',
    faq3A: 'Wir verwenden öffentlich verfügbare Informationen und aktualisieren die Produktdatenbank laufend.',
    faq4Q: 'Welche Länder werden unterstützt?',
    faq4A: 'Die App funktioniert weltweit, mit Spezialdaten für mehrere europäische Länder und Großbritannien.',
    faq5Q: 'Speichert ihr persönliche Daten?',
    faq5A: 'Nein. Alle Daten werden lokal auf deinem Telefon gespeichert. Wir erheben oder teilen keine persönlichen Daten.',
    contactHeading: 'Kontakt',
    contactIntro: 'Fragen, Feedback oder Vorschläge?',
    newsHeading: 'Nachrichten',
    newsIntro: 'Bleibe informiert – füge relevante Artikel über Bovaer, GMO, Insektenmehl und Nachhaltigkeit hinzu.',
    newsModerationNote: 'Eingereichte Artikel werden nicht direkt veröffentlicht. Sie durchlaufen zuerst eine Moderation.',
    newsLanguageLabel: 'Lesesprache / übersetzen nach:',
    newsRegionLabel: 'Region:',
    newsAddArticleBtn: 'Artikel hinzufügen',
    newsFormHeading: 'Artikel hinzufügen',
    newsFormTitleLabel: 'Titel',
    newsFormSourceLabel: 'Quelle',
    newsFormUrlLabel: 'URL',
    newsFormLanguageLabel: 'Sprache',
    newsSubmitForModerationBtn: 'Zur Moderation senden',
    cancel: 'Abbrechen',
    footerCopyright: '© 2026 Mat Sjekk / Einar\'s Apps. Alle Rechte vorbehalten.',
  },
  nl: {
    title: '🛒 VoedselCheck',
    tagline: 'Scan voedsel, kies bewust',
    privacy: 'Privacy',
    terms: 'Voorwaarden',
    analytics: 'Statistieken',
    navHome: 'Startpagina',
    navFarmshops: 'Boerenmarkten',
    navOrganicFarmshops: 'Biologische boerenmarkten',
    navImmigrantShops: 'Internationale winkels',
    navNews: 'Nieuws',
    navContact: 'Contact',
    heroHeading: 'Jouw persoonlijke voedselgids',
    heroIntro: 'Scan barcodes en ontvang direct informatie over Bovaer, GMO-visvoer en insectenmeel in je boodschappen.',
    ctaAppStore: '📱 Download in de App Store',
    ctaGooglePlay: '🤖 Download in Google Play',
    ctaFindFarmshops: '🏬 Vind boerenmarkten',
    ctaFindOrganicFarmshops: '🌿 Vind biologische boerenmarkten',
    ctaFindImmigrantShops: '🛒 Vind internationale winkels',
    featuresHeading: 'Functies',
    featureScanTitle: 'Barcodescanner',
    featureScanText: 'Scan producten direct in de winkel met je camera',
    featureBovaerTitle: 'Bovaer-waarschuwingen',
    featureBovaerText: 'Directe informatie over producenten die Bovaer gebruiken',
    featureGmoTitle: 'GMO-visvoer',
    featureGmoText: 'Controleer of kweekvis GMO-visvoer bevat',
    featureInsectTitle: 'Insectenmeel',
    featureInsectText: 'Waarschuwingen bij producten met insectenbestanddelen',
    featureListTitle: 'Boodschappenlijsten',
    featureListText: 'Maak en beheer meerdere boodschappenlijsten tegelijk',
    featureLangTitle: '11 talen',
    featureLangText: 'Ondersteuning voor Noors, Engels, Zweeds, Deens, Fins, Duits, Nederlands, Frans, Italiaans, Portugees en Spaans',
    adPlaceholder: 'Advertentieruimte (wordt getoond na cookie-toestemming)',
    howHeading: 'Zo werkt het',
    howStep1Title: 'Download de app',
    howStep1Text: '- Gratis in de App Store en Google Play',
    howStep2Title: 'Scan de barcode',
    howStep2Text: '- Richt je telefoon op een product in de winkel',
    howStep3Title: 'Bekijk het resultaat',
    howStep3Text: '- Ontvang direct informatie over het risiconiveau',
    howStep4Title: 'Kies bewust',
    howStep4Text: '- Bepaal zelf wat je wilt kopen',
    aboutHeading: 'Over VoedselCheck',
    aboutText1: 'Mat Sjekk is gemaakt voor bewuste consumenten die volledige controle willen over hun aankopen. De app gebruikt data van OpenFoodFacts en andere open bronnen.',
    aboutText2: 'We nemen geen standpunt in over of Bovaer, GMO of insectenmeel goed of slecht is – we geven je de informatie zodat je eigen keuzes kunt maken.',
    faqHeading: 'Veelgestelde vragen',
    faq1Q: 'Is de app helemaal gratis?',
    faq1A: 'Ja. Mat Sjekk is gratis te downloaden en te gebruiken. We worden gefinancierd door advertenties.',
    faq2Q: 'Waar komen de gegevens vandaan?',
    faq2A: 'We gebruiken voornamelijk OpenFoodFacts en nationale voedingsdatabases voor sommige landen.',
    faq3Q: 'Hoe weet ik of de informatie klopt?',
    faq3A: 'We gebruiken openbaar beschikbare informatie en werken de productdatabase voortdurend bij.',
    faq4Q: 'Welke landen worden ondersteund?',
    faq4A: 'De app werkt wereldwijd, met speciale data voor meerdere Europese landen en het VK.',
    faq5Q: 'Slaan jullie persoonlijke gegevens op?',
    faq5A: 'Nee. Alle data wordt lokaal op je telefoon opgeslagen. We verzamelen of delen geen persoonlijke gegevens.',
    contactHeading: 'Contact',
    contactIntro: 'Vragen, feedback of suggesties?',
    newsHeading: 'Nieuws',
    newsIntro: 'Blijf op de hoogte – voeg relevante artikelen toe over Bovaer, GMO, insectenmeel en duurzaamheid.',
    newsModerationNote: 'Ingediende artikelen worden niet direct gepubliceerd. Ze worden eerst gemodereerd.',
    newsLanguageLabel: 'Leestaal / vertaal naar:',
    newsRegionLabel: 'Regio:',
    newsAddArticleBtn: 'Artikel toevoegen',
    newsFormHeading: 'Artikel toevoegen',
    newsFormTitleLabel: 'Titel',
    newsFormSourceLabel: 'Bron',
    newsFormUrlLabel: 'URL',
    newsFormLanguageLabel: 'Taal',
    newsSubmitForModerationBtn: 'Verzenden voor moderatie',
    cancel: 'Annuleren',
    footerCopyright: '© 2026 Mat Sjekk / Einar\'s Apps. Alle rechten voorbehouden.',
  },
  fr: {
    title: '🛒 ContrôleAliment',
    tagline: 'Scannez vos aliments, choisissez librement',
    privacy: 'Confidentialité',
    terms: 'CGU',
    analytics: 'Statistiques',
    navHome: 'Accueil',
    navFarmshops: 'Magasins de ferme',
    navOrganicFarmshops: 'Magasins bio de ferme',
    navImmigrantShops: 'Épiceries internationales',
    navNews: 'Actualités',
    navContact: 'Contact',
    heroHeading: 'Votre guide alimentaire personnel',
    heroIntro: 'Scannez les codes-barres et obtenez des informations instantanées sur le Bovaer, les aliments OGM pour poissons et la farine d\'insectes dans vos courses.',
    ctaAppStore: '📱 Télécharger sur l\'App Store',
    ctaGooglePlay: '🤖 Télécharger sur Google Play',
    ctaFindFarmshops: '🏬 Trouver des magasins de ferme',
    ctaFindOrganicFarmshops: '🌿 Trouver des magasins bio',
    ctaFindImmigrantShops: '🛒 Trouver des épiceries internationales',
    featuresHeading: 'Fonctionnalités',
    featureScanTitle: 'Scan de codes-barres',
    featureScanText: 'Scannez les produits directement en magasin avec votre caméra',
    featureBovaerTitle: 'Alertes Bovaer',
    featureBovaerText: 'Informations instantanées sur les producteurs utilisant le Bovaer',
    featureGmoTitle: 'Aliments OGM pour poissons',
    featureGmoText: 'Vérifiez si le poisson d\'élevage contient des OGM',
    featureInsectTitle: 'Farine d\'insectes',
    featureInsectText: 'Alertes sur les produits contenant des insectes',
    featureListTitle: 'Listes de courses',
    featureListText: 'Créez et gérez plusieurs listes de courses simultanément',
    featureLangTitle: '11 langues',
    featureLangText: 'Prise en charge du norvégien, anglais, suédois, danois, finnois, allemand, néerlandais, français, italien, portugais et espagnol',
    adPlaceholder: 'Espace publicitaire (affiché après consentement aux cookies)',
    howHeading: 'Comment ça marche',
    howStep1Title: 'Téléchargez l\'application',
    howStep1Text: '- Gratuite sur l\'App Store et Google Play',
    howStep2Title: 'Scannez le code-barres',
    howStep2Text: '- Pointez votre téléphone sur un produit en magasin',
    howStep3Title: 'Consultez le résultat',
    howStep3Text: '- Obtenez instantanément le niveau de risque',
    howStep4Title: 'Choisissez librement',
    howStep4Text: '- Décidez vous-même ce que vous voulez acheter',
    aboutHeading: 'À propos de ContrôleAliment',
    aboutText1: 'Mat Sjekk est conçu pour les consommateurs avertis qui veulent un contrôle total sur leurs achats. L\'application utilise les données d\'OpenFoodFacts et d\'autres sources ouvertes.',
    aboutText2: 'Nous ne prenons pas position sur le Bovaer, les OGM ou la farine d\'insectes. Nous fournissons l\'information pour que vous puissiez faire vos propres choix.',
    faqHeading: 'Questions fréquentes',
    faq1Q: 'L\'application est-elle entièrement gratuite ?',
    faq1A: 'Oui. Mat Sjekk est gratuit. Nous sommes financés par la publicité.',
    faq2Q: 'D\'où proviennent les données ?',
    faq2A: 'Nous utilisons principalement OpenFoodFacts et des bases de données alimentaires nationales pour certains pays.',
    faq3Q: 'Comment savoir si les informations sont correctes ?',
    faq3A: 'Nous utilisons des informations publiques et mettons continuellement à jour la base de données produits.',
    faq4Q: 'Quels pays sont pris en charge ?',
    faq4A: 'L\'application fonctionne dans le monde entier, avec des données spécifiques pour plusieurs pays européens et le Royaume-Uni.',
    faq5Q: 'Stockez-vous des informations personnelles ?',
    faq5A: 'Non. Toutes les données sont stockées localement sur votre téléphone. Nous ne collectons ni ne partageons de données personnelles.',
    contactHeading: 'Contact',
    contactIntro: 'Questions, retours ou suggestions ?',
    newsHeading: 'Actualités',
    newsIntro: 'Restez informé(e) – ajoutez des articles pertinents sur Bovaer, OGM, farine d\'insectes et durabilité.',
    newsModerationNote: 'Les articles soumis ne sont pas publiés directement. Ils passent d\'abord par une modération.',
    newsLanguageLabel: 'Langue de lecture / traduire en\u00a0:',
    newsRegionLabel: 'Région\u00a0:',
    newsAddArticleBtn: 'Ajouter un article',
    newsFormHeading: 'Ajouter un article',
    newsFormTitleLabel: 'Titre',
    newsFormSourceLabel: 'Source',
    newsFormUrlLabel: 'URL',
    newsFormLanguageLabel: 'Langue',
    newsSubmitForModerationBtn: 'Envoyer pour modération',
    cancel: 'Annuler',
    footerCopyright: '© 2026 Mat Sjekk / Einar\'s Apps. Tous droits réservés.',
  },
  it: {
    title: '🛒 ControlloAlimenti',
    tagline: 'Scansiona il cibo, scegli consapevolmente',
    privacy: 'Privacy',
    terms: 'Termini',
    analytics: 'Statistiche',
    navHome: 'Home',
    navFarmshops: 'Negozi aziendali',
    navOrganicFarmshops: 'Negozi bio aziendali',
    navImmigrantShops: 'Negozi internazionali',
    navNews: 'Notizie',
    navContact: 'Contattaci',
    heroHeading: 'La tua guida alimentare personale',
    heroIntro: 'Scansiona i codici a barre e ottieni informazioni istantanee su Bovaer, mangimi OGM per pesci e farina di insetti nei tuoi acquisti.',
    ctaAppStore: '📱 Scarica dall\'App Store',
    ctaGooglePlay: '🤖 Scarica da Google Play',
    ctaFindFarmshops: '🏬 Trova negozi aziendali',
    ctaFindOrganicFarmshops: '🌿 Trova negozi bio',
    ctaFindImmigrantShops: '🛒 Trova negozi internazionali',
    featuresHeading: 'Funzionalità',
    featureScanTitle: 'Scansione codici a barre',
    featureScanText: 'Scansiona i prodotti direttamente in negozio con la fotocamera',
    featureBovaerTitle: 'Avvisi Bovaer',
    featureBovaerText: 'Informazioni istantanee sui produttori che usano Bovaer',
    featureGmoTitle: 'Mangimi OGM per pesci',
    featureGmoText: 'Verifica se il pesce d\'allevamento contiene mangimi OGM',
    featureInsectTitle: 'Farina di insetti',
    featureInsectText: 'Avvisi per prodotti con contenuto di insetti',
    featureListTitle: 'Liste della spesa',
    featureListText: 'Crea e gestisci più liste della spesa contemporaneamente',
    featureLangTitle: '11 lingue',
    featureLangText: 'Supporto per norvegese, inglese, svedese, danese, finlandese, tedesco, olandese, francese, italiano, portoghese e spagnolo',
    adPlaceholder: 'Spazio pubblicitario (mostrato dopo il consenso ai cookie)',
    howHeading: 'Come funziona',
    howStep1Title: 'Scarica l\'app',
    howStep1Text: '- Gratuita su App Store e Google Play',
    howStep2Title: 'Scansiona il codice a barre',
    howStep2Text: '- Punta il telefono su un prodotto in negozio',
    howStep3Title: 'Guarda il risultato',
    howStep3Text: '- Ottieni subito il livello di rischio',
    howStep4Title: 'Scegli consapevolmente',
    howStep4Text: '- Decidi tu cosa comprare',
    aboutHeading: 'Informazioni su ControlloAlimenti',
    aboutText1: 'Mat Sjekk è creato per consumatori consapevoli che vogliono il pieno controllo sui propri acquisti. L\'app utilizza dati da OpenFoodFacts e altre fonti aperte.',
    aboutText2: 'Non esprimiamo giudizi su Bovaer, OGM o farina di insetti. Forniamo le informazioni affinché tu possa fare le tue scelte.',
    faqHeading: 'Domande frequenti',
    faq1Q: 'L\'app è completamente gratuita?',
    faq1A: 'Sì. Mat Sjekk è gratuita. Ci finanziamo con la pubblicità.',
    faq2Q: 'Da dove vengono i dati?',
    faq2A: 'Utilizziamo principalmente OpenFoodFacts e database alimentari nazionali per alcuni paesi.',
    faq3Q: 'Come faccio a sapere se le informazioni sono corrette?',
    faq3A: 'Utilizziamo informazioni pubbliche e aggiorniamo continuamente il database prodotti.',
    faq4Q: 'Quali paesi sono supportati?',
    faq4A: 'L\'app funziona a livello globale, con dati specifici per diversi paesi europei e il Regno Unito.',
    faq5Q: 'Memorizzate informazioni personali?',
    faq5A: 'No. Tutti i dati sono memorizzati localmente sul tuo telefono. Non raccogliamo né condividiamo dati personali.',
    contactHeading: 'Contattaci',
    contactIntro: 'Domande, feedback o suggerimenti?',
    newsHeading: 'Notizie',
    newsIntro: 'Rimani aggiornato – aggiungi articoli rilevanti su Bovaer, OGM, farina di insetti e sostenibilità.',
    newsModerationNote: 'Gli articoli inviati non vengono pubblicati direttamente. Vengono prima moderati.',
    newsLanguageLabel: 'Lingua di lettura / traduci in:',
    newsRegionLabel: 'Regione:',
    newsAddArticleBtn: 'Aggiungi articolo',
    newsFormHeading: 'Aggiungi articolo',
    newsFormTitleLabel: 'Titolo',
    newsFormSourceLabel: 'Fonte',
    newsFormUrlLabel: 'URL',
    newsFormLanguageLabel: 'Lingua',
    newsSubmitForModerationBtn: 'Invia per moderazione',
    cancel: 'Annulla',
    footerCopyright: '© 2026 Mat Sjekk / Einar\'s Apps. Tutti i diritti riservati.',
  },
  pt: {
    title: '🛒 ControloAlimentos',
    tagline: 'Digitalize alimentos, escolha conscientemente',
    privacy: 'Privacidade',
    terms: 'Termos',
    analytics: 'Análises',
    navHome: 'Início',
    navFarmshops: 'Lojas de fazenda',
    navOrganicFarmshops: 'Lojas bio de fazenda',
    navImmigrantShops: 'Lojas internacionais',
    navNews: 'Notícias',
    navContact: 'Contacto',
    heroHeading: 'O seu guia alimentar pessoal',
    heroIntro: 'Digitalize códigos de barras e obtenha informações instantâneas sobre Bovaer, rações OGM para peixes e farinha de insetos nas suas compras.',
    ctaAppStore: '📱 Descarregar na App Store',
    ctaGooglePlay: '🤖 Descarregar no Google Play',
    ctaFindFarmshops: '🏬 Encontrar lojas de fazenda',
    ctaFindOrganicFarmshops: '🌿 Encontrar lojas bio',
    ctaFindImmigrantShops: '🛒 Encontrar lojas internacionais',
    featuresHeading: 'Funcionalidades',
    featureScanTitle: 'Leitura de códigos de barras',
    featureScanText: 'Digitalize produtos diretamente na loja com a sua câmara',
    featureBovaerTitle: 'Alertas Bovaer',
    featureBovaerText: 'Informações instantâneas sobre produtores que utilizam Bovaer',
    featureGmoTitle: 'Rações OGM para peixes',
    featureGmoText: 'Verifique se o peixe de aquicultura contém rações OGM',
    featureInsectTitle: 'Farinha de insetos',
    featureInsectText: 'Alertas para produtos com conteúdo de insetos',
    featureListTitle: 'Listas de compras',
    featureListText: 'Crie e gira várias listas de compras em simultâneo',
    featureLangTitle: '11 idiomas',
    featureLangText: 'Suporte para norueguês, inglês, sueco, dinamarquês, finlandês, alemão, neerlandês, francês, italiano, português e espanhol',
    adPlaceholder: 'Espaço publicitário (exibido após consentimento de cookies)',
    howHeading: 'Como funciona',
    howStep1Title: 'Descarregue a aplicação',
    howStep1Text: '- Gratuita na App Store e no Google Play',
    howStep2Title: 'Digitalize o código de barras',
    howStep2Text: '- Aponte o telemóvel para um produto na loja',
    howStep3Title: 'Veja o resultado',
    howStep3Text: '- Obtenha instantaneamente o nível de risco',
    howStep4Title: 'Escolha conscientemente',
    howStep4Text: '- Decida o que comprar',
    aboutHeading: 'Sobre ControloAlimentos',
    aboutText1: 'O Mat Sjekk foi criado para consumidores conscientes que querem total controlo sobre as suas compras. A aplicação utiliza dados do OpenFoodFacts e outras fontes abertas.',
    aboutText2: 'Não tomamos partido sobre se Bovaer, OGM ou farinha de insetos é bom ou mau. Fornecemos a informação para que possa fazer as suas próprias escolhas.',
    faqHeading: 'Perguntas frequentes',
    faq1Q: 'A aplicação é totalmente gratuita?',
    faq1A: 'Sim. O Mat Sjekk é gratuito. Financiamo-nos através de publicidade.',
    faq2Q: 'De onde vêm os dados?',
    faq2A: 'Utilizamos principalmente o OpenFoodFacts e bases de dados alimentares nacionais para alguns países.',
    faq3Q: 'Como sei que as informações estão corretas?',
    faq3A: 'Utilizamos informações públicas e atualizamos continuamente a base de dados de produtos.',
    faq4Q: 'Que países são suportados?',
    faq4A: 'A aplicação funciona globalmente, com dados específicos para vários países europeus e o Reino Unido.',
    faq5Q: 'Armazenam informações pessoais?',
    faq5A: 'Não. Todos os dados são armazenados localmente no seu telemóvel. Não recolhemos nem partilhamos dados pessoais.',
    contactHeading: 'Contacto',
    contactIntro: 'Perguntas, feedback ou sugestões?',
    newsHeading: 'Notícias',
    newsIntro: 'Mantenha-se atualizado(a) – adicione artigos relevantes sobre Bovaer, OGM, farinha de insetos e sustentabilidade.',
    newsModerationNote: 'Os artigos enviados não são publicados diretamente. Passam primeiro por moderação.',
    newsLanguageLabel: 'Língua de leitura / traduzir para:',
    newsRegionLabel: 'Região:',
    newsAddArticleBtn: 'Adicionar artigo',
    newsFormHeading: 'Adicionar artigo',
    newsFormTitleLabel: 'Título',
    newsFormSourceLabel: 'Fonte',
    newsFormUrlLabel: 'URL',
    newsFormLanguageLabel: 'Língua',
    newsSubmitForModerationBtn: 'Enviar para moderação',
    cancel: 'Cancelar',
    footerCopyright: '© 2026 Mat Sjekk / Einar\'s Apps. Todos os direitos reservados.',
  },
  es: {
    title: '🛒 ControlAlimentos',
    tagline: 'Escanea alimentos, elige conscientemente',
    privacy: 'Privacidad',
    terms: 'Términos',
    analytics: 'Estadísticas',
    navHome: 'Inicio',
    navFarmshops: 'Tiendas de granja',
    navOrganicFarmshops: 'Tiendas bio de granja',
    navImmigrantShops: 'Tiendas internacionales',
    navNews: 'Noticias',
    navContact: 'Contacto',
    heroHeading: 'Tu guía alimentaria personal',
    heroIntro: 'Escanea códigos de barras y obtén información instantánea sobre Bovaer, pienso OGM para peces y harina de insectos en tus compras.',
    ctaAppStore: '📱 Descargar en App Store',
    ctaGooglePlay: '🤖 Descargar en Google Play',
    ctaFindFarmshops: '🏬 Encontrar tiendas de granja',
    ctaFindOrganicFarmshops: '🌿 Encontrar tiendas bio',
    ctaFindImmigrantShops: '🛒 Encontrar tiendas internacionales',
    featuresHeading: 'Funciones',
    featureScanTitle: 'Escáner de códigos de barras',
    featureScanText: 'Escanea productos directamente en la tienda con tu cámara',
    featureBovaerTitle: 'Alertas Bovaer',
    featureBovaerText: 'Información instantánea sobre productores que usan Bovaer',
    featureGmoTitle: 'Pienso OGM para peces',
    featureGmoText: 'Comprueba si el pescado de acuicultura contiene pienso OGM',
    featureInsectTitle: 'Harina de insectos',
    featureInsectText: 'Alertas sobre productos con contenido de insectos',
    featureListTitle: 'Listas de compras',
    featureListText: 'Crea y administra varias listas de compras simultáneamente',
    featureLangTitle: '11 idiomas',
    featureLangText: 'Compatible con noruego, inglés, sueco, danés, finlandés, alemán, neerlandés, francés, italiano, portugués y español',
    adPlaceholder: 'Espacio publicitario (se muestra tras el consentimiento de cookies)',
    howHeading: 'Cómo funciona',
    howStep1Title: 'Descarga la aplicación',
    howStep1Text: '- Gratis en App Store y Google Play',
    howStep2Title: 'Escanea el código de barras',
    howStep2Text: '- Apunta tu teléfono a un producto en la tienda',
    howStep3Title: 'Consulta el resultado',
    howStep3Text: '- Obtén al instante el nivel de riesgo',
    howStep4Title: 'Elige conscientemente',
    howStep4Text: '- Decide tú mismo qué comprar',
    aboutHeading: 'Sobre ControlAlimentos',
    aboutText1: 'Mat Sjekk está creado para consumidores conscientes que quieren control total sobre sus compras. La app usa datos de OpenFoodFacts y otras fuentes abiertas.',
    aboutText2: 'No tomamos posición sobre si Bovaer, OGM o harina de insectos es bueno o malo. Proporcionamos la información para que puedas tomar tus propias decisiones.',
    faqHeading: 'Preguntas frecuentes',
    faq1Q: '¿La aplicación es totalmente gratuita?',
    faq1A: 'Sí. Mat Sjekk es gratuita. Nos financiamos con publicidad.',
    faq2Q: '¿De dónde provienen los datos?',
    faq2A: 'Usamos principalmente OpenFoodFacts y bases de datos alimentarias nacionales para algunos países.',
    faq3Q: '¿Cómo sé que la información es correcta?',
    faq3A: 'Usamos información pública y actualizamos la base de datos de productos continuamente.',
    faq4Q: '¿Qué países se admiten?',
    faq4A: 'La aplicación funciona a nivel mundial, con datos específicos para varios países europeos y el Reino Unido.',
    faq5Q: '¿Almacenan información personal?',
    faq5A: 'No. Todos los datos se almacenan localmente en tu teléfono. No recopilamos ni compartimos datos personales.',
    contactHeading: 'Contacto',
    contactIntro: '¿Preguntas, comentarios o sugerencias?',
    newsHeading: 'Noticias',
    newsIntro: 'Mantente informado/a – añade artículos relevantes sobre Bovaer, OGM, harina de insectos y sostenibilidad.',
    newsModerationNote: 'Los artículos enviados no se publican directamente. Pasan primero por moderación.',
    newsLanguageLabel: 'Idioma de lectura / traducir a:',
    newsRegionLabel: 'Región:',
    newsAddArticleBtn: 'Añadir artículo',
    newsFormHeading: 'Añadir artículo',
    newsFormTitleLabel: 'Título',
    newsFormSourceLabel: 'Fuente',
    newsFormUrlLabel: 'URL',
    newsFormLanguageLabel: 'Idioma',
    newsSubmitForModerationBtn: 'Enviar para moderación',
    cancel: 'Cancelar',
    footerCopyright: '© 2026 Mat Sjekk / Einar\'s Apps. Todos los derechos reservados.',
  },
};

const LANG_STORAGE_KEY = 'matsjekk_lang';
const GEO_CACHE_KEY = 'matsjekk_geo_country';
const GEO_CACHE_MAX_AGE_MS = 24 * 60 * 60 * 1000;

function safeStorageGet(key) {
  try {
    return localStorage.getItem(key);
  } catch (_) {
    return '';
  }
}

function safeStorageSet(key, value) {
  try {
    localStorage.setItem(key, value);
    return true;
  } catch (_) {
    return false;
  }
}

function safeStorageRemove(key) {
  try {
    localStorage.removeItem(key);
    return true;
  } catch (_) {
    return false;
  }
}

const countryToLanguage = {
  NO: 'nb',
  SE: 'sv',
  DK: 'da',
  FI: 'fi',
  DE: 'de',
  AT: 'de',
  NL: 'nl',
  BE: 'nl',
  FR: 'fr',
  IT: 'it',
  PT: 'pt',
  ES: 'es',
  GB: 'en',
  IE: 'en',
};

function isGoogleTranslatedHost() {
  const host = String(window.location.hostname || '').toLowerCase();
  return host.includes('translate.goog') || host.includes('translate.googleusercontent.com');
}

function buildOriginalUrlFromTranslateProxy() {
  const host = String(window.location.hostname || '').toLowerCase();
  if (!isGoogleTranslatedHost()) return '';

  let originHost = '';
  if (host.endsWith('.translate.goog')) {
    originHost = host.slice(0, -'.translate.goog'.length);
  }
  if (!originHost) return '';

  const params = new URLSearchParams(window.location.search || '');
  const translatedTo = normalizeLanguageCode(params.get('_x_tr_tl'));

  const keys = Array.from(params.keys());
  keys.forEach((key) => {
    if (key.startsWith('_x_tr_')) params.delete(key);
  });

  if (translatedTo && isSupportedLanguage(translatedTo)) {
    params.set('lang', translatedTo);
  }

  const query = params.toString();
  return `${window.location.protocol}//${originHost}${window.location.pathname}${query ? `?${query}` : ''}${window.location.hash || ''}`;
}

function normalizeLanguageCode(value) {
  const raw = String(value || '').trim().toLowerCase();
  if (!raw) return '';
  return raw.split('-')[0];
}

function isSupportedLanguage(code) {
  return supportedLanguages.some((entry) => entry.code === code);
}

function isLocalUiLanguage(code) {
  return LOCAL_UI_LANGUAGES.includes(normalizeLanguageCode(code));
}

function detectBrowserLanguage() {
  const candidates = [
    ...(Array.isArray(navigator.languages) ? navigator.languages : []),
    navigator.language,
    navigator.userLanguage,
  ].filter(Boolean);

  for (const candidate of candidates) {
    const normalized = normalizeLanguageCode(candidate);
    if (isSupportedLanguage(normalized)) return normalized;
  }
  return 'nb';
}

function readGeoCacheCountry() {
  try {
    const raw = safeStorageGet(GEO_CACHE_KEY);
    if (!raw) return '';
    const parsed = JSON.parse(raw);
    if (!parsed || !parsed.country || !parsed.ts) return '';
    if (Date.now() - Number(parsed.ts) > GEO_CACHE_MAX_AGE_MS) return '';
    return String(parsed.country).toUpperCase();
  } catch (_) {
    return '';
  }
}

function writeGeoCacheCountry(countryCode) {
  if (!countryCode) return;
  try {
    safeStorageSet(
      GEO_CACHE_KEY,
      JSON.stringify({ country: String(countryCode).toUpperCase(), ts: Date.now() })
    );
  } catch (_) {
    // Ignore storage failures.
  }
}

function reverseCountryCode(lat, lon) {
  const url = `https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=${encodeURIComponent(lat)}&lon=${encodeURIComponent(lon)}&zoom=3`;
  return fetch(url, {
    headers: {
      Accept: 'application/json',
    },
  })
    .then((response) => {
      if (!response.ok) throw new Error(`HTTP ${response.status}`);
      return response.json();
    })
    .then((payload) => String(payload?.address?.country_code || '').toUpperCase())
    .catch(() => '');
}

function detectCountryCodeFromGeo() {
  const cached = readGeoCacheCountry();
  if (cached) return Promise.resolve(cached);

  if (!navigator.geolocation) return Promise.resolve('');

  return new Promise((resolve) => {
    navigator.geolocation.getCurrentPosition(
      async (position) => {
        const countryCode = await reverseCountryCode(position.coords.latitude, position.coords.longitude);
        if (countryCode) writeGeoCacheCountry(countryCode);
        resolve(countryCode);
      },
      () => resolve(''),
      { enableHighAccuracy: false, timeout: 3500, maximumAge: 10 * 60 * 1000 }
    );
  });
}

function dictForLanguage(lang) {
  const normalized = normalizeLanguageCode(lang);
  if (translations[normalized]) return translations[normalized];
  if (normalized !== 'nb' && isSupportedLanguage(normalized)) return translations.en;
  return translations.nb;
}

function applyTranslations(lang) {
  const normalized = normalizeLanguageCode(lang);
  const dictLang = translations[normalized] ? normalized : (normalized !== 'nb' && isSupportedLanguage(normalized) ? 'en' : 'nb');
  const dict = dictForLanguage(dictLang);
  document.querySelectorAll('[data-translate]').forEach((el) => {
    const key = el.getAttribute('data-translate');
    if (key && dict[key]) {
      el.textContent = dict[key];
    }
  });
  document.documentElement.lang = dictLang || 'nb';
}

function populateSelect(selectElement) {
  if (!selectElement) return;
  selectElement.innerHTML = '';

  const autoOption = document.createElement('option');
  autoOption.value = AUTO_LANGUAGE_CODE;
  autoOption.textContent = 'Auto';
  selectElement.appendChild(autoOption);

  supportedLanguages.forEach((entry) => {
    const option = document.createElement('option');
    option.value = entry.code;
    option.textContent = entry.label;
    selectElement.appendChild(option);
  });
}

function populateSelectWithOptions(selectElement, options) {
  if (!selectElement) return;
  selectElement.innerHTML = '';
  options.forEach((entry) => {
    const option = document.createElement('option');
    option.value = entry.code;
    option.textContent = entry.label;
    selectElement.appendChild(option);
  });
}

function populateLangSelects() {
  populateSelect(document.getElementById('lang-select'));
  populateSelectWithOptions(document.getElementById('news-lang'), supportedLanguages);
  populateSelectWithOptions(document.getElementById('article-lang'), supportedLanguages);
}

async function resolveAutoLanguage() {
  const browserLang = detectBrowserLanguage();
  if (browserLang && isSupportedLanguage(browserLang)) return browserLang;

  const country = await detectCountryCodeFromGeo();
  const geoLang = countryToLanguage[country] || '';
  if (geoLang && isSupportedLanguage(geoLang)) return geoLang;

  return 'nb';
}

async function loadLanguage() {
  const params = new URLSearchParams(window.location.search || '');
  const queryLang = normalizeLanguageCode(params.get('lang'));
  const saved = normalizeLanguageCode(safeStorageGet(LANG_STORAGE_KEY));
  const picked = queryLang || saved || AUTO_LANGUAGE_CODE;
  const useAuto = picked === AUTO_LANGUAGE_CODE || !isSupportedLanguage(picked);
  const resolvedLang = useAuto ? await resolveAutoLanguage() : picked;
  const effectiveLang = isSupportedLanguage(resolvedLang) ? resolvedLang : 'nb';

  // Keep selected language stable and avoid locking users into translated proxy URLs.
  safeStorageSet(LANG_STORAGE_KEY, useAuto ? AUTO_LANGUAGE_CODE : resolvedLang);

  if (queryLang) {
    params.delete('lang');
    const query = params.toString();
    const cleanUrl = `${window.location.pathname}${query ? `?${query}` : ''}${window.location.hash || ''}`;
    window.history.replaceState({}, document.title, cleanUrl);
  }

  const langSelect = document.getElementById('lang-select');
  const newsSelect = document.getElementById('news-lang');
  const articleSelect = document.getElementById('article-lang');

  if (langSelect) {
    langSelect.value = useAuto ? AUTO_LANGUAGE_CODE : resolvedLang;
    if (!langSelect.value) langSelect.value = AUTO_LANGUAGE_CODE;
  }
  if (newsSelect) newsSelect.value = isSupportedLanguage(resolvedLang) ? resolvedLang : effectiveLang;
  if (articleSelect) articleSelect.value = isSupportedLanguage(resolvedLang) ? resolvedLang : effectiveLang;

  applyTranslations(effectiveLang);
  return resolvedLang;
}

function initLanguage() {
  // Extra defense against browser-wide auto-translate overlays.
  if (document.documentElement) {
    document.documentElement.setAttribute('translate', 'no');
    document.documentElement.classList.add('notranslate');
  }
  if (document.body) {
    document.body.setAttribute('translate', 'no');
    document.body.classList.add('notranslate');
  }

  if (isGoogleTranslatedHost()) {
    const originUrl = buildOriginalUrlFromTranslateProxy();
    if (originUrl) {
      window.location.replace(originUrl);
      return;
    }
  }

  populateLangSelects();
  loadLanguage().then((lang) => {
    if (typeof window.renderNews === 'function') {
      window.renderNews(lang);
    }
  });

  const langSelect = document.getElementById('lang-select');
  if (!langSelect) return;

  langSelect.addEventListener('change', async (event) => {
    const selected = normalizeLanguageCode(event.target.value);
    if (selected === AUTO_LANGUAGE_CODE) {
      safeStorageSet(LANG_STORAGE_KEY, AUTO_LANGUAGE_CODE);
      const autoLang = await resolveAutoLanguage();
      const effectiveLang = isSupportedLanguage(autoLang) ? autoLang : 'nb';

      const newsSelect = document.getElementById('news-lang');
      const articleSelect = document.getElementById('article-lang');
      if (newsSelect) newsSelect.value = isSupportedLanguage(autoLang) ? autoLang : effectiveLang;
      if (articleSelect) articleSelect.value = isSupportedLanguage(autoLang) ? autoLang : effectiveLang;

      applyTranslations(effectiveLang);
      if (typeof window.renderNews === 'function') {
        window.renderNews(autoLang);
      }
      return;
    }

    const nextLang = isSupportedLanguage(selected) ? selected : 'nb';
    safeStorageSet(LANG_STORAGE_KEY, nextLang);

    const newsSelect = document.getElementById('news-lang');
    const articleSelect = document.getElementById('article-lang');
    if (newsSelect) newsSelect.value = nextLang;
    if (articleSelect) articleSelect.value = nextLang;

    applyTranslations(nextLang);
    if (typeof window.renderNews === 'function') {
      window.renderNews(nextLang);
    }
  });
}

function resetLanguagePreference() {
  safeStorageRemove(LANG_STORAGE_KEY);
  window.location.href = window.location.pathname + window.location.search + window.location.hash;
}

window.resetLanguagePreference = resetLanguagePreference;

window.addEventListener('DOMContentLoaded', initLanguage);
