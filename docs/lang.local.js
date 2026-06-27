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
  { code: 'ko', label: '한국어' },
  { code: 'pl', label: 'Polski' },
  { code: 'ru', label: 'Русский' },
  { code: 'zh', label: '中文' },
  { code: 'ar', label: 'العربية' },
  { code: 'th', label: 'ภาษาไทย' },
];

const AUTO_LANGUAGE_CODE = 'auto';
const LOCAL_UI_LANGUAGES = ['nb', 'en', 'sv', 'da', 'fi', 'de', 'nl', 'fr', 'it', 'pt', 'es', 'ko', 'pl', 'ru', 'zh', 'ar', 'th'];

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
    navResearch: 'Forskning',
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
    featureLangTitle: '17 sprak',
    featureLangText: 'Stotte for norsk, engelsk, svensk, dansk, finsk, tysk, nederlandsk, fransk, italiensk, portugisisk, spansk, koreansk, polsk, russisk, kinesisk, arabisk og thai',
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
    navResearch: 'Research',
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
    featureLangTitle: '17 languages',
    featureLangText: 'Supports Norwegian, English, Swedish, Danish, Finnish, German, Dutch, French, Italian, Portuguese, Spanish, Korean, Polish, Russian, Chinese, Arabic, and Thai',
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
  },  sv: {
    title: '\ud83d\uded2 Mat Sjekk',
    tagline: 'Skanna mat, v\u00e4lj medvetet',
    privacy: 'Integritet',
    terms: 'Villkor',
    analytics: 'Analytics',
    navHome: 'Hem',
    navFarmshops: 'G\u00e5rdsbutiker',
    navOrganicFarmshops: 'Ekologiska g\u00e5rdsbutiker',
    navImmigrantShops: 'Invandrarbutiker',
    navNews: 'Nyheter',
    navContact: 'Kontakta oss',
    newsHeading: 'Nyheter',
    newsIntro: 'H\u00e5ll dig uppdaterad \u2013 l\u00e4gg till relevanta artiklar om Bovaer, GMO, insektsmj\u00f6l och h\u00e5llbarhet.',
    newsModerationNote: 'Inskickade artiklar publiceras inte direkt. De granskas av redaktionen.',
    newsLanguageLabel: 'L\u00e4sespråk / \u00f6vers\u00e4tt till:',
    newsRegionLabel: 'Region:',
    newsAddArticleBtn: 'L\u00e4gg till artikel',
    newsFormHeading: 'L\u00e4gg till artikel',
    newsFormTitleLabel: 'Titel',
    newsFormSourceLabel: 'K\u00e4lla',
    newsFormUrlLabel: 'URL',
    newsFormLanguageLabel: 'Spr\u00e5k',
    newsSubmitForModerationBtn: 'Skicka f\u00f6r granskning',
    cancel: 'Avbryt',
    footerCopyright: '\u00a9 2026 Mat Sjekk / Einar\'s Apps. Alla r\u00e4ttigheter f\u00f6rbeh\u00e5llna.',
  },
  da: {
    title: '\ud83d\uded2 Mat Sjekk',
    tagline: 'Scan mad, v\u00e6lg bevidst',
    privacy: 'Privatliv',
    terms: 'Vilk\u00e5r',
    analytics: 'Analytics',
    navHome: 'Hjem',
    navFarmshops: 'G\u00e5rdsbutikker',
    navOrganicFarmshops: '\u00d8kologiske g\u00e5rdsbutikker',
    navImmigrantShops: 'Indvandrerbutikker',
    navNews: 'Nyheder',
    navContact: 'Kontakt os',
    newsHeading: 'Nyheder',
    newsIntro: 'Hold dig opdateret \u2013 tilf\u00f8j relevante artikler om Bovaer, GMO, insektmel og b\u00e6redygtighed.',
    newsModerationNote: 'Indsendte artikler offentligg\u00f8res ikke direkte. De gennemg\u00e5s af redaktionen.',
    newsLanguageLabel: 'L\u00e6sesprog / overs\u00e6t til:',
    newsRegionLabel: 'Region:',
    newsAddArticleBtn: 'Tilf\u00f8j artikel',
    newsFormHeading: 'Tilf\u00f8j artikel',
    newsFormTitleLabel: 'Titel',
    newsFormSourceLabel: 'Kilde',
    newsFormUrlLabel: 'URL',
    newsFormLanguageLabel: 'Sprog',
    newsSubmitForModerationBtn: 'Send til moderering',
    cancel: 'Annuller',
    footerCopyright: '\u00a9 2026 Mat Sjekk / Einar\'s Apps. Alle rettigheder forbeholdes.',
  },
  fi: {
    title: '\ud83d\uded2 Mat Sjekk',
    tagline: 'Skannaa ruoka, valitse tietoisesti',
    privacy: 'Tietosuoja',
    terms: 'Ehdot',
    analytics: 'Analytiikka',
    navHome: 'Koti',
    navFarmshops: 'Tilakaupat',
    navOrganicFarmshops: 'Luomun tilakaupat',
    navImmigrantShops: 'Maahanmuuttajakaupat',
    navNews: 'Uutiset',
    navContact: 'Ota yhteytt\u00e4',
    newsHeading: 'Uutiset',
    newsIntro: 'Pysy ajan tasalla \u2013 lis\u00e4\u00e4 artikkeleita Bovaerista, GMO:sta, hy\u00f6nteisjauhosta ja kest\u00e4vyydest\u00e4.',
    newsModerationNote: 'L\u00e4hetettyj\u00e4 artikkeleita ei julkaista suoraan. Ne k\u00e4yv\u00e4t l\u00e4pi moderoinnin.',
    newsLanguageLabel: 'Lukukieli / k\u00e4\u00e4nn\u00f6s:',
    newsRegionLabel: 'Alue:',
    newsAddArticleBtn: 'Lis\u00e4\u00e4 artikkeli',
    newsFormHeading: 'Lis\u00e4\u00e4 artikkeli',
    newsFormTitleLabel: 'Otsikko',
    newsFormSourceLabel: 'L\u00e4hde',
    newsFormUrlLabel: 'URL',
    newsFormLanguageLabel: 'Kieli',
    newsSubmitForModerationBtn: 'L\u00e4het\u00e4 moderointiin',
    cancel: 'Peruuta',
    footerCopyright: '\u00a9 2026 Mat Sjekk / Einar\'s Apps. Kaikki oikeudet pidätetään.',
  },
  de: {
    title: '\ud83d\uded2 LebensmittelCheck',
    tagline: 'Lebensmittel scannen, bewusst w\u00e4hlen',
    privacy: 'Datenschutz',
    terms: 'AGB',
    analytics: 'Analysen',
    navHome: 'Startseite',
    navFarmshops: 'Hofläden',
    navOrganicFarmshops: 'Bio-Hofläden',
    navImmigrantShops: 'Internationale Läden',
    navResearch: 'Forschung',
    navNews: 'Nachrichten',
    navContact: 'Kontakt',
    heroHeading: 'Ihr persönlicher Lebensmittel-Guide',
    heroIntro: 'Scannen Sie Barcodes und erhalten Sie sofort Informationen über Bovaer, GVO-Fischfutter und Insektenmehl in Ihren Lebensmitteln.',
    ctaAppStore: '📱 Im App Store laden',
    ctaGooglePlay: '🤖 Bei Google Play laden',
    ctaFindFarmshops: '🏬 Hofläden finden',
    ctaFindOrganicFarmshops: '🌿 Bio-Hofläden finden',
    ctaFindImmigrantShops: '🛒 Internationale Läden finden',
    featuresHeading: 'Funktionen',
    featureScanTitle: 'Barcode-Scan',
    featureScanText: 'Scannen Sie Produkte direkt im Geschäft mit Ihrer Kamera',
    featureBovaerTitle: 'Bovaer-Hinweise',
    featureBovaerText: 'Sofortige Informationen zu Herstellern, die Bovaer verwenden',
    featureGmoTitle: 'GVO-Fischfutter',
    featureGmoText: 'Prüfen Sie, ob Zuchtfisch GVO-Fischfutter enthält',
    featureInsectTitle: 'Insektenmehl',
    featureInsectText: 'Hinweise zu Produkten mit Insektenbestandteilen',
    featureListTitle: 'Einkaufslisten',
    featureListText: 'Erstellen und verwalten Sie mehrere Einkaufslisten gleichzeitig',
    featureLangTitle: '17 Sprachen',
    featureLangText: 'Unterstützt Norwegisch, Englisch, Schwedisch, Dänisch, Finnisch, Deutsch, Niederländisch, Französisch, Italienisch, Portugiesisch, Spanisch, Koreanisch, Polnisch, Russisch, Chinesisch, Arabisch und Thai',
    adPlaceholder: 'Werbefläche (wird nach Cookie-Zustimmung angezeigt)',
    howHeading: 'So funktioniert es',
    howStep1Title: 'App herunterladen',
    howStep1Text: '- Kostenlos im App Store und bei Google Play',
    howStep2Title: 'Barcode scannen',
    howStep2Text: '- Richten Sie Ihr Handy im Geschäft auf ein Produkt',
    howStep3Title: 'Ergebnis ansehen',
    howStep3Text: '- Erhalten Sie sofort Informationen zur Risikostufe',
    howStep4Title: 'Bewusst wählen',
    howStep4Text: '- Entscheiden Sie selbst, was Sie kaufen möchten',
    aboutHeading: 'Über LebensmittelCheck',
    aboutText1: 'LebensmittelCheck ist für bewusste Verbraucher gemacht, die volle Kontrolle darüber möchten, was sie kaufen. Die App nutzt OpenFoodFacts und andere offene Quellen, um Ihnen transparente Informationen zu liefern.',
    aboutText2: 'Wir sagen Ihnen nicht, ob Bovaer, GVO oder Insektenmehl gut oder schlecht ist – wir liefern die Informationen, damit Sie Ihre eigene Wahl treffen können.',
    faqHeading: 'Häufige Fragen',
    faq1Q: 'Ist die App völlig kostenlos?',
    faq1A: 'Ja. LebensmittelCheck ist kostenlos zum Herunterladen und Verwenden. Wir finanzieren uns über Werbung.',
    faq2Q: 'Woher stammen die Daten?',
    faq2A: 'Wir nutzen hauptsächlich OpenFoodFacts und für einige Länder zusätzlich nationale Lebensmitteldatenbanken.',
    faq3Q: 'Woher weiß ich, dass die Informationen korrekt sind?',
    faq3A: 'Wir verwenden öffentlich verfügbare Informationen und aktualisieren die Produktdatenbank laufend.',
    faq4Q: 'Welche Länder werden unterstützt?',
    faq4A: 'Die App funktioniert weltweit, mit speziellen Datensätzen für mehrere europäische Länder und Großbritannien.',
    faq5Q: 'Speichern Sie persönliche Daten?',
    faq5A: 'Nein. Die Daten werden lokal auf Ihrem Telefon gespeichert. Wir sammeln oder teilen keine personenbezogenen Daten.',
    contactHeading: 'Kontakt',
    contactIntro: 'Fragen, Feedback oder Vorschläge?',
    newsHeading: 'Nachrichten',
    newsIntro: 'Bleiben Sie informiert \u2013 f\u00fcgen Sie relevante Artikel \u00fcber Bovaer, GMO, Insektenmehl und Nachhaltigkeit hinzu.',
    newsModerationNote: 'Eingereichte Artikel werden nicht direkt ver\u00f6ffentlicht. Sie durchlaufen zuerst eine Moderation.',
    newsLanguageLabel: 'Lesesprache / \u00fcbersetzen nach:',
    newsRegionLabel: 'Region:',
    newsAddArticleBtn: 'Artikel hinzuf\u00fcgen',
    newsFormHeading: 'Artikel hinzuf\u00fcgen',
    newsFormTitleLabel: 'Titel',
    newsFormSourceLabel: 'Quelle',
    newsFormUrlLabel: 'URL',
    newsFormLanguageLabel: 'Sprache',
    newsSubmitForModerationBtn: 'Zur Moderation senden',
    cancel: 'Abbrechen',
    footerCopyright: '\u00a9 2026 Mat Sjekk / Einar\'s Apps. Alle Rechte vorbehalten.',
  },
  nl: {
    title: '\ud83d\uded2 VoedselCheck',
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
    newsHeading: 'Nieuws',
    newsIntro: 'Blijf op de hoogte \u2013 voeg relevante artikelen toe over Bovaer, GMO, insectenmeel en duurzaamheid.',
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
    footerCopyright: '\u00a9 2026 Mat Sjekk / Einar\'s Apps. Alle rechten voorbehouden.',
  },
  fr: {
    title: '\ud83d\uded2 ContrôleAliment',
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
    newsHeading: 'Actualités',
    newsIntro: 'Restez informé(e) \u2013 ajoutez des articles pertinents sur Bovaer, OGM, farine d\'insectes et durabilité.',
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
    footerCopyright: '\u00a9 2026 Mat Sjekk / Einar\'s Apps. Tous droits réservés.',
  },
  it: {
    title: '\ud83d\uded2 ControlloAlimenti',
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
    newsHeading: 'Notizie',
    newsIntro: 'Rimani aggiornato \u2013 aggiungi articoli rilevanti su Bovaer, OGM, farina di insetti e sostenibilità.',
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
    footerCopyright: '\u00a9 2026 Mat Sjekk / Einar\'s Apps. Tutti i diritti riservati.',
  },
  pt: {
    title: '\ud83d\uded2 ControloAlimentos',
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
    newsHeading: 'Notícias',
    newsIntro: 'Mantenha-se atualizado(a) \u2013 adicione artigos relevantes sobre Bovaer, OGM, farinha de insetos e sustentabilidade.',
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
    footerCopyright: '\u00a9 2026 Mat Sjekk / Einar\'s Apps. Todos os direitos reservados.',
  },
  es: {
    title: '\ud83d\uded2 ControlAlimentos',
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
    newsHeading: 'Noticias',
    newsIntro: 'Mantente informado/a \u2013 añade artículos relevantes sobre Bovaer, OGM, harina de insectos y sostenibilidad.',
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
    footerCopyright: '\u00a9 2026 Mat Sjekk / Einar\'s Apps. Todos los derechos reservados.',
  },
  ko: {
    title: '🛒 Mat Sjekk',
    tagline: '식품을 스캔하고 의식적으로 선택하세요',
    privacy: '개인정보 보호',
    terms: '이용약관',
    analytics: '분석',
    navHome: '홈',
    navFarmshops: '농장 직판장',
    navOrganicFarmshops: '유기농 농장 직판장',
    navImmigrantShops: '이민자 상점',
    navNews: '뉴스',
    navContact: '문의하기',
    heroHeading: '나만의 식품 가이드',
    heroIntro: '바코드를 스캔하여 식료품에 포함된 Bovaer, GMO 어류 사료, 곤충 가루에 대한 정보를 즉시 확인하세요.',
    ctaAppStore: '📱 App Store에서 다운로드',
    ctaGooglePlay: '🤖 Google Play에서 다운로드',
    ctaFindFarmshops: '🏬 농장 직판장 찾기',
    ctaFindOrganicFarmshops: '🌿 유기농 농장 직판장 찾기',
    ctaFindImmigrantShops: '🛒 이민자 상점 찾기',
    featuresHeading: '주요 기능',
    featureScanTitle: '바코드 스캔',
    featureScanText: '카메라로 매장에서 바로 제품을 스캔하세요',
    featureBovaerTitle: 'Bovaer 알림',
    featureBovaerText: 'Bovaer를 사용하는 생산자에 대한 즉각적인 정보',
    featureGmoTitle: 'GMO 어류 사료',
    featureGmoText: '양식 어류에 GMO 어류 사료가 포함되었는지 확인하세요',
    featureInsectTitle: '곤충 가루',
    featureInsectText: '곤충 성분이 포함된 제품에 대한 경고',
    featureListTitle: '쇼핑 목록',
    featureListText: '여러 쇼핑 목록을 만들고 관리하세요',
    featureLangTitle: '17개 언어',
    featureLangText: '노르웨이어, 영어, 스웨덴어, 덴마크어, 핀란드어, 독일어, 네덜란드어, 프랑스어, 이탈리아어, 포르투갈어, 스페인어, 한국어, 폴란드어, 러시아어, 중국어, 아랍어, 태국어 지원',
    adPlaceholder: '광고 공간 (쿠키 동의 후 표시)',
    howHeading: '사용 방법',
    howStep1Title: '앱 다운로드',
    howStep1Text: '- App Store와 Google Play에서 무료',
    howStep2Title: '바코드 스캔',
    howStep2Text: '- 매장에서 제품에 휴대폰을 향하게 하세요',
    howStep3Title: '결과 확인',
    howStep3Text: '- 즉시 위험 수준 정보를 받으세요',
    howStep4Title: '의식적인 선택',
    howStep4Text: '- 무엇을 살지 스스로 결정하세요',
    aboutHeading: 'Mat Sjekk 소개',
    aboutText1: 'Mat Sjekk는 구매하는 제품을 완전히 파악하고 싶은 의식 있는 소비자를 위해 만들어졌습니다. 이 앱은 OpenFoodFacts 및 기타 공개 출처를 사용하여 투명한 정보를 제공합니다.',
    aboutText2: '우리는 Bovaer, GMO 또는 곤충 가루가 좋은지 나쁜지 알려주지 않습니다. 스스로 선택할 수 있도록 정보를 제공합니다.',
    faqHeading: '자주 묻는 질문',
    faq1Q: '앱은 완전히 무료인가요?',
    faq1A: '네. Mat Sjekk는 무료로 다운로드하고 사용할 수 있습니다. 광고로 운영됩니다.',
    faq2Q: '데이터는 어디에서 오나요?',
    faq2A: '주로 OpenFoodFacts를 사용하며, 일부 국가의 경우 국가 식품 데이터베이스를 사용합니다.',
    faq3Q: '정보가 정확한지 어떻게 알 수 있나요?',
    faq3A: '공개적으로 이용 가능한 정보를 사용하며 제품 데이터베이스를 지속적으로 업데이트합니다.',
    faq4Q: '어떤 국가가 지원되나요?',
    faq4A: '이 앱은 전 세계에서 작동하며 여러 유럽 국가와 영국을 위한 전용 데이터셋을 제공합니다.',
    faq5Q: '개인정보를 저장하나요?',
    faq5A: '아니요. 데이터는 휴대폰에 로컬로 저장됩니다. 개인 데이터를 수집하거나 공유하지 않습니다.',
    contactHeading: '문의',
    contactIntro: '질문, 피드백 또는 제안이 있으신가요?',
    newsHeading: '뉴스',
    newsIntro: '최신 정보를 받아보세요 - Bovaer, GMO, 곤충 가루 및 지속 가능성에 대한 관련 기사를 추가하세요.',
    newsModerationNote: '제출된 기사는 바로 게시되지 않습니다. 먼저 검토를 거칩니다.',
    newsLanguageLabel: '읽기 언어 / 번역 대상:',
    newsRegionLabel: '지역:',
    newsAddArticleBtn: '기사 추가',
    newsFormHeading: '기사 추가',
    newsFormTitleLabel: '제목',
    newsFormSourceLabel: '출처',
    newsFormUrlLabel: 'URL',
    newsFormLanguageLabel: '언어',
    newsSubmitForModerationBtn: '검토 요청 보내기',
    cancel: '취소',
    footerCopyright: '\u00a9 2026 Mat Sjekk / Einar\'s Apps. All rights reserved.',
  },
  pl: {
    title: '🛒 Mat Sjekk',
    tagline: 'Skanuj żywność, wybieraj świadomie',
    privacy: 'Prywatność',
    terms: 'Regulamin',
    analytics: 'Analityka',
    navHome: 'Strona główna',
    navFarmshops: 'Sklepy farmerskie',
    navOrganicFarmshops: 'Ekologiczne sklepy farmerskie',
    navImmigrantShops: 'Sklepy imigranckie',
    navNews: 'Aktualności',
    navContact: 'Kontakt',
    heroHeading: 'Twój osobisty przewodnik po żywności',
    heroIntro: 'Skanuj kody kreskowe i natychmiast otrzymuj informacje o Bovaer, paszy GMO dla ryb i mączce z owadów w Twoich zakupach.',
    ctaAppStore: '📱 Pobierz z App Store',
    ctaGooglePlay: '🤖 Pobierz z Google Play',
    ctaFindFarmshops: '🏬 Znajdź sklepy farmerskie',
    ctaFindOrganicFarmshops: '🌿 Znajdź ekologiczne sklepy farmerskie',
    ctaFindImmigrantShops: '🛒 Znajdź sklepy imigranckie',
    featuresHeading: 'Funkcje',
    featureScanTitle: 'Skanowanie kodów kreskowych',
    featureScanText: 'Skanuj produkty bezpośrednio w sklepach za pomocą aparatu',
    featureBovaerTitle: 'Alerty Bovaer',
    featureBovaerText: 'Natychmiastowe informacje o producentach stosujących Bovaer',
    featureGmoTitle: 'Pasza GMO dla ryb',
    featureGmoText: 'Sprawdź, czy ryby hodowlane były karmione paszą GMO',
    featureInsectTitle: 'Mączka z owadów',
    featureInsectText: 'Ostrzeżenia o produktach zawierających składniki owadzie',
    featureListTitle: 'Listy zakupów',
    featureListText: 'Twórz i zarządzaj wieloma listami zakupów',
    featureLangTitle: '17 języków',
    featureLangText: 'Obsługuje norweski, angielski, szwedzki, duński, fiński, niemiecki, niderlandzki, francuski, włoski, portugalski, hiszpański, koreański, polski, rosyjski, chiński, arabski i tajski',
    adPlaceholder: 'Miejsce na reklamę (wyświetlane po zgodzie na pliki cookie)',
    howHeading: 'Jak to działa',
    howStep1Title: 'Pobierz aplikację',
    howStep1Text: '- Bezpłatnie w App Store i Google Play',
    howStep2Title: 'Zeskanuj kod kreskowy',
    howStep2Text: '- Skieruj telefon na produkt w sklepie',
    howStep3Title: 'Zobacz wynik',
    howStep3Text: '- Otrzymaj natychmiastowe informacje o poziomie ryzyka',
    howStep4Title: 'Wybieraj świadomie',
    howStep4Text: '- Zdecyduj, co chcesz kupić',
    aboutHeading: 'O Mat Sjekk',
    aboutText1: 'Mat Sjekk został stworzony dla świadomych konsumentów, którzy chcą mieć pełną kontrolę nad tym, co kupują. Aplikacja korzysta z OpenFoodFacts i innych otwartych źródeł, aby zapewnić przejrzyste informacje.',
    aboutText2: 'Nie mówimy, czy Bovaer, GMO lub mączka z owadów są dobre czy złe. Dostarczamy informacji, abyś mógł podejmować własne decyzje.',
    faqHeading: 'Najczęstsze pytania',
    faq1Q: 'Czy aplikacja jest całkowicie bezpłatna?',
    faq1A: 'Tak. Mat Sjekk można pobrać i używać bezpłatnie. Utrzymujemy się z reklam.',
    faq2Q: 'Skąd pochodzą dane?',
    faq2A: 'Korzystamy głównie z OpenFoodFacts, a w niektórych krajach z krajowych baz danych o żywności.',
    faq3Q: 'Skąd mam wiedzieć, że informacje są poprawne?',
    faq3A: 'Korzystamy z publicznie dostępnych informacji i na bieżąco aktualizujemy bazę produktów.',
    faq4Q: 'Które kraje są obsługiwane?',
    faq4A: 'Aplikacja działa na całym świecie, z dedykowanymi zbiorami danych dla kilku krajów europejskich i Wielkiej Brytanii.',
    faq5Q: 'Czy przechowujecie dane osobowe?',
    faq5A: 'Nie. Dane są przechowywane lokalnie w telefonie. Nie zbieramy ani nie udostępniamy danych osobowych.',
    contactHeading: 'Kontakt',
    contactIntro: 'Pytania, opinie lub sugestie?',
    newsHeading: 'Aktualności',
    newsIntro: 'Bądź na bieżąco - dodawaj istotne artykuły o Bovaer, GMO, mączce z owadów i zrównoważonym rozwoju.',
    newsModerationNote: 'Przesłane artykuły nie są publikowane bezpośrednio. Najpierw przechodzą moderację.',
    newsLanguageLabel: 'Język czytania / przetłumacz na:',
    newsRegionLabel: 'Region:',
    newsAddArticleBtn: 'Dodaj artykuł',
    newsFormHeading: 'Dodaj artykuł',
    newsFormTitleLabel: 'Tytuł',
    newsFormSourceLabel: 'Źródło',
    newsFormUrlLabel: 'URL',
    newsFormLanguageLabel: 'Język',
    newsSubmitForModerationBtn: 'Wyślij do moderacji',
    cancel: 'Anuluj',
    footerCopyright: '\u00a9 2026 Mat Sjekk / Einar\'s Apps. All rights reserved.',
  },
  ru: {
    title: '🛒 Mat Sjekk',
    tagline: 'Сканируйте продукты, выбирайте осознанно',
    privacy: 'Конфиденциальность',
    terms: 'Условия',
    analytics: 'Аналитика',
    navHome: 'Главная',
    navFarmshops: 'Фермерские магазины',
    navOrganicFarmshops: 'Органические фермерские магазины',
    navImmigrantShops: 'Этнические магазины',
    navNews: 'Новости',
    navContact: 'Связаться с нами',
    heroHeading: 'Ваш личный путеводитель по продуктам',
    heroIntro: 'Сканируйте штрихкоды и мгновенно получайте информацию о Bovaer, ГМО-корме для рыбы и муке из насекомых в ваших продуктах.',
    ctaAppStore: '📱 Загрузить в App Store',
    ctaGooglePlay: '🤖 Загрузить в Google Play',
    ctaFindFarmshops: '🏬 Найти фермерские магазины',
    ctaFindOrganicFarmshops: '🌿 Найти органические фермерские магазины',
    ctaFindImmigrantShops: '🛒 Найти этнические магазины',
    featuresHeading: 'Возможности',
    featureScanTitle: 'Сканирование штрихкодов',
    featureScanText: 'Сканируйте продукты прямо в магазине с помощью камеры',
    featureBovaerTitle: 'Оповещения о Bovaer',
    featureBovaerText: 'Мгновенная информация о производителях, использующих Bovaer',
    featureGmoTitle: 'ГМО-корм для рыбы',
    featureGmoText: 'Проверьте, содержит ли выращенная рыба ГМО-корм',
    featureInsectTitle: 'Мука из насекомых',
    featureInsectText: 'Предупреждения о продуктах, содержащих ингредиенты из насекомых',
    featureListTitle: 'Списки покупок',
    featureListText: 'Создавайте несколько списков покупок и управляйте ими',
    featureLangTitle: '17 языков',
    featureLangText: 'Поддерживает норвежский, английский, шведский, датский, финский, немецкий, нидерландский, французский, итальянский, португальский, испанский, корейский, польский, русский, китайский, арабский и тайский',
    adPlaceholder: 'Место для рекламы (показывается после согласия на cookie)',
    howHeading: 'Как это работает',
    howStep1Title: 'Скачайте приложение',
    howStep1Text: '- Бесплатно в App Store и Google Play',
    howStep2Title: 'Отсканируйте штрихкод',
    howStep2Text: '- Наведите телефон на продукт в магазине',
    howStep3Title: 'Посмотрите результат',
    howStep3Text: '- Получите мгновенную информацию об уровне риска',
    howStep4Title: 'Выбирайте осознанно',
    howStep4Text: '- Решите, что вы хотите купить',
    aboutHeading: 'О Mat Sjekk',
    aboutText1: 'Mat Sjekk создан для осознанных потребителей, которые хотят полностью контролировать то, что покупают. Приложение использует OpenFoodFacts и другие открытые источники для предоставления прозрачной информации.',
    aboutText2: 'Мы не говорим, хороши или плохи Bovaer, ГМО или мука из насекомых. Мы предоставляем информацию, чтобы вы могли сделать собственный выбор.',
    faqHeading: 'Часто задаваемые вопросы',
    faq1Q: 'Приложение полностью бесплатное?',
    faq1A: 'Да. Mat Sjekk можно бесплатно скачать и использовать. Мы существуем за счёт рекламы.',
    faq2Q: 'Откуда берутся данные?',
    faq2A: 'В основном мы используем OpenFoodFacts, а для некоторых стран — национальные базы данных о продуктах.',
    faq3Q: 'Как узнать, что информация верна?',
    faq3A: 'Мы используем общедоступную информацию и постоянно обновляем базу продуктов.',
    faq4Q: 'Какие страны поддерживаются?',
    faq4A: 'Приложение работает по всему миру, с отдельными наборами данных для нескольких европейских стран и Великобритании.',
    faq5Q: 'Вы храните личную информацию?',
    faq5A: 'Нет. Данные хранятся локально на вашем телефоне. Мы не собираем и не передаём личные данные.',
    contactHeading: 'Контакты',
    contactIntro: 'Вопросы, отзывы или предложения?',
    newsHeading: 'Новости',
    newsIntro: 'Будьте в курсе - добавляйте актуальные статьи о Bovaer, ГМО, муке из насекомых и устойчивом развитии.',
    newsModerationNote: 'Отправленные статьи не публикуются сразу. Сначала они проходят модерацию.',
    newsLanguageLabel: 'Язык чтения / перевести на:',
    newsRegionLabel: 'Регион:',
    newsAddArticleBtn: 'Добавить статью',
    newsFormHeading: 'Добавить статью',
    newsFormTitleLabel: 'Заголовок',
    newsFormSourceLabel: 'Источник',
    newsFormUrlLabel: 'URL',
    newsFormLanguageLabel: 'Язык',
    newsSubmitForModerationBtn: 'Отправить на модерацию',
    cancel: 'Отмена',
    footerCopyright: '\u00a9 2026 Mat Sjekk / Einar\'s Apps. All rights reserved.',
  },
  zh: {
    title: '🛒 Mat Sjekk',
    tagline: '扫描食品，明智选择',
    privacy: '隐私',
    terms: '条款',
    analytics: '分析',
    navHome: '首页',
    navFarmshops: '农场商店',
    navOrganicFarmshops: '有机农场商店',
    navImmigrantShops: '移民商店',
    navNews: '新闻',
    navContact: '联系我们',
    heroHeading: '您的私人食品指南',
    heroIntro: '扫描条形码，即时获取食品中关于 Bovaer、转基因鱼饲料和昆虫粉的信息。',
    ctaAppStore: '📱 在 App Store 下载',
    ctaGooglePlay: '🤖 在 Google Play 下载',
    ctaFindFarmshops: '🏬 查找农场商店',
    ctaFindOrganicFarmshops: '🌿 查找有机农场商店',
    ctaFindImmigrantShops: '🛒 查找移民商店',
    featuresHeading: '功能',
    featureScanTitle: '条形码扫描',
    featureScanText: '用相机在商店中直接扫描产品',
    featureBovaerTitle: 'Bovaer 提醒',
    featureBovaerText: '即时获取使用 Bovaer 的生产商信息',
    featureGmoTitle: '转基因鱼饲料',
    featureGmoText: '检查养殖鱼是否使用转基因鱼饲料',
    featureInsectTitle: '昆虫粉',
    featureInsectText: '对含有昆虫成分的产品发出警告',
    featureListTitle: '购物清单',
    featureListText: '创建和管理多个购物清单',
    featureLangTitle: '17 种语言',
    featureLangText: '支持挪威语、英语、瑞典语、丹麦语、芬兰语、德语、荷兰语、法语、意大利语、葡萄牙语、西班牙语、韩语、波兰语、俄语、中文、阿拉伯语和泰语',
    adPlaceholder: '广告位（在同意 Cookie 后显示）',
    howHeading: '使用方法',
    howStep1Title: '下载应用',
    howStep1Text: '- 在 App Store 和 Google Play 上免费',
    howStep2Title: '扫描条形码',
    howStep2Text: '- 将手机对准商店里的产品',
    howStep3Title: '查看结果',
    howStep3Text: '- 即时获取风险等级信息',
    howStep4Title: '明智选择',
    howStep4Text: '- 决定您想购买什么',
    aboutHeading: '关于 Mat Sjekk',
    aboutText1: 'Mat Sjekk 专为希望完全掌控购买内容的有意识消费者打造。该应用使用 OpenFoodFacts 和其他开放来源，提供透明的信息。',
    aboutText2: '我们不会告诉您 Bovaer、转基因或昆虫粉是好是坏。我们提供信息，让您自己做出选择。',
    faqHeading: '常见问题',
    faq1Q: '应用完全免费吗？',
    faq1A: '是的。Mat Sjekk 可免费下载和使用。我们靠广告维持运营。',
    faq2Q: '数据来自哪里？',
    faq2A: '我们主要使用 OpenFoodFacts，部分国家则使用国家食品数据库。',
    faq3Q: '我怎么知道信息是正确的？',
    faq3A: '我们使用公开可用的信息，并持续更新产品数据库。',
    faq4Q: '支持哪些国家？',
    faq4A: '该应用在全球范围内可用，并为多个欧洲国家和英国提供专用数据集。',
    faq5Q: '你们会存储个人信息吗？',
    faq5A: '不会。数据存储在您的手机本地。我们不收集或共享个人数据。',
    contactHeading: '联系',
    contactIntro: '有问题、反馈或建议吗？',
    newsHeading: '新闻',
    newsIntro: '保持更新 - 添加关于 Bovaer、转基因、昆虫粉和可持续发展的相关文章。',
    newsModerationNote: '提交的文章不会直接发布，会先经过审核。',
    newsLanguageLabel: '阅读语言 / 翻译为：',
    newsRegionLabel: '地区：',
    newsAddArticleBtn: '添加文章',
    newsFormHeading: '添加文章',
    newsFormTitleLabel: '标题',
    newsFormSourceLabel: '来源',
    newsFormUrlLabel: '网址',
    newsFormLanguageLabel: '语言',
    newsSubmitForModerationBtn: '提交审核',
    cancel: '取消',
    footerCopyright: '\u00a9 2026 Mat Sjekk / Einar\'s Apps. All rights reserved.',
  },
  ar: {
    title: '🛒 Mat Sjekk',
    tagline: 'امسح الطعام، اختر بوعي',
    privacy: 'الخصوصية',
    terms: 'الشروط',
    analytics: 'التحليلات',
    navHome: 'الرئيسية',
    navFarmshops: 'متاجر المزارع',
    navOrganicFarmshops: 'متاجر المزارع العضوية',
    navImmigrantShops: 'متاجر المهاجرين',
    navNews: 'الأخبار',
    navContact: 'اتصل بنا',
    heroHeading: 'دليلك الشخصي للأغذية',
    heroIntro: 'امسح الباركود واحصل على معلومات فورية حول Bovaer وأعلاف الأسماك المعدّلة وراثيًا ومسحوق الحشرات في مشترياتك.',
    ctaAppStore: '📱 التنزيل من App Store',
    ctaGooglePlay: '🤖 التنزيل من Google Play',
    ctaFindFarmshops: '🏬 ابحث عن متاجر المزارع',
    ctaFindOrganicFarmshops: '🌿 ابحث عن متاجر المزارع العضوية',
    ctaFindImmigrantShops: '🛒 ابحث عن متاجر المهاجرين',
    featuresHeading: 'الميزات',
    featureScanTitle: 'مسح الباركود',
    featureScanText: 'امسح المنتجات مباشرة في المتاجر باستخدام الكاميرا',
    featureBovaerTitle: 'تنبيهات Bovaer',
    featureBovaerText: 'معلومات فورية عن المنتجين الذين يستخدمون Bovaer',
    featureGmoTitle: 'أعلاف الأسماك المعدّلة وراثيًا',
    featureGmoText: 'تحقق مما إذا كانت الأسماك المستزرعة تحتوي على أعلاف معدّلة وراثيًا',
    featureInsectTitle: 'مسحوق الحشرات',
    featureInsectText: 'تحذيرات بشأن المنتجات التي تحتوي على مكونات حشرية',
    featureListTitle: 'قوائم التسوق',
    featureListText: 'أنشئ وأدِر عدة قوائم تسوق',
    featureLangTitle: '17 لغة',
    featureLangText: 'يدعم النرويجية والإنجليزية والسويدية والدنماركية والفنلندية والألمانية والهولندية والفرنسية والإيطالية والبرتغالية والإسبانية والكورية والبولندية والروسية والصينية والعربية والتايلاندية',
    adPlaceholder: 'مساحة إعلانية (تظهر بعد الموافقة على ملفات تعريف الارتباط)',
    howHeading: 'كيف يعمل',
    howStep1Title: 'نزّل التطبيق',
    howStep1Text: '- مجانًا على App Store وGoogle Play',
    howStep2Title: 'امسح الباركود',
    howStep2Text: '- وجّه هاتفك نحو منتج في المتجر',
    howStep3Title: 'شاهد النتيجة',
    howStep3Text: '- احصل على معلومات فورية عن مستوى الخطورة',
    howStep4Title: 'اختر بوعي',
    howStep4Text: '- قرّر ما تريد شراءه',
    aboutHeading: 'حول Mat Sjekk',
    aboutText1: 'صُمم Mat Sjekk للمستهلكين الواعين الذين يريدون التحكم الكامل فيما يشترونه. يستخدم التطبيق OpenFoodFacts ومصادر مفتوحة أخرى لتقديم معلومات شفافة.',
    aboutText2: 'نحن لا نخبرك ما إذا كان Bovaer أو التعديل الوراثي أو مسحوق الحشرات جيدًا أم سيئًا. نحن نقدّم المعلومات لتتمكن من اتخاذ خياراتك الخاصة.',
    faqHeading: 'الأسئلة الشائعة',
    faq1Q: 'هل التطبيق مجاني تمامًا؟',
    faq1A: 'نعم. Mat Sjekk مجاني للتنزيل والاستخدام. نعتمد على الإعلانات.',
    faq2Q: 'من أين تأتي البيانات؟',
    faq2A: 'نستخدم بشكل أساسي OpenFoodFacts، وفي بعض البلدان قواعد بيانات الأغذية الوطنية.',
    faq3Q: 'كيف أعرف أن المعلومات صحيحة؟',
    faq3A: 'نستخدم معلومات متاحة للعموم ونحدّث قاعدة بيانات المنتجات باستمرار.',
    faq4Q: 'ما البلدان المدعومة؟',
    faq4A: 'يعمل التطبيق في جميع أنحاء العالم، مع مجموعات بيانات مخصصة لعدة دول أوروبية والمملكة المتحدة.',
    faq5Q: 'هل تخزّنون معلومات شخصية؟',
    faq5A: 'لا. تُخزَّن البيانات محليًا على هاتفك. نحن لا نجمع البيانات الشخصية أو نشاركها.',
    contactHeading: 'اتصل بنا',
    contactIntro: 'أسئلة أو ملاحظات أو اقتراحات؟',
    newsHeading: 'الأخبار',
    newsIntro: 'ابقَ على اطلاع - أضف مقالات ذات صلة حول Bovaer والتعديل الوراثي ومسحوق الحشرات والاستدامة.',
    newsModerationNote: 'لا تُنشر المقالات المرسلة مباشرة. تمر أولًا بعملية مراجعة.',
    newsLanguageLabel: 'لغة القراءة / الترجمة إلى:',
    newsRegionLabel: 'المنطقة:',
    newsAddArticleBtn: 'إضافة مقال',
    newsFormHeading: 'إضافة مقال',
    newsFormTitleLabel: 'العنوان',
    newsFormSourceLabel: 'المصدر',
    newsFormUrlLabel: 'الرابط',
    newsFormLanguageLabel: 'اللغة',
    newsSubmitForModerationBtn: 'إرسال للمراجعة',
    cancel: 'إلغاء',
    footerCopyright: '\u00a9 2026 Mat Sjekk / Einar\'s Apps. All rights reserved.',
  },
  th: {
    title: '🛒 Mat Sjekk',
    tagline: 'สแกนอาหาร เลือกอย่างมีสติ',
    privacy: 'ความเป็นส่วนตัว',
    terms: 'ข้อกำหนด',
    analytics: 'การวิเคราะห์',
    navHome: 'หน้าแรก',
    navFarmshops: 'ร้านฟาร์ม',
    navOrganicFarmshops: 'ร้านฟาร์มออร์แกนิก',
    navImmigrantShops: 'ร้านผู้อพยพ',
    navNews: 'ข่าวสาร',
    navContact: 'ติดต่อเรา',
    heroHeading: 'คู่มืออาหารส่วนตัวของคุณ',
    heroIntro: 'สแกนบาร์โค้ดและรับข้อมูลทันทีเกี่ยวกับ Bovaer อาหารปลา GMO และผงแมลงในของชำของคุณ',
    ctaAppStore: '📱 ดาวน์โหลดบน App Store',
    ctaGooglePlay: '🤖 ดาวน์โหลดบน Google Play',
    ctaFindFarmshops: '🏬 ค้นหาร้านฟาร์ม',
    ctaFindOrganicFarmshops: '🌿 ค้นหาร้านฟาร์มออร์แกนิก',
    ctaFindImmigrantShops: '🛒 ค้นหาร้านผู้อพยพ',
    featuresHeading: 'คุณสมบัติ',
    featureScanTitle: 'การสแกนบาร์โค้ด',
    featureScanText: 'สแกนผลิตภัณฑ์ได้โดยตรงในร้านด้วยกล้องของคุณ',
    featureBovaerTitle: 'การแจ้งเตือน Bovaer',
    featureBovaerText: 'ข้อมูลทันทีเกี่ยวกับผู้ผลิตที่ใช้ Bovaer',
    featureGmoTitle: 'อาหารปลา GMO',
    featureGmoText: 'ตรวจสอบว่าปลาเลี้ยงใช้อาหารปลา GMO หรือไม่',
    featureInsectTitle: 'ผงแมลง',
    featureInsectText: 'คำเตือนสำหรับผลิตภัณฑ์ที่มีส่วนผสมจากแมลง',
    featureListTitle: 'รายการช้อปปิ้ง',
    featureListText: 'สร้างและจัดการรายการช้อปปิ้งหลายรายการ',
    featureLangTitle: '17 ภาษา',
    featureLangText: 'รองรับภาษานอร์เวย์ อังกฤษ สวีเดน เดนมาร์ก ฟินแลนด์ เยอรมัน ดัตช์ ฝรั่งเศส อิตาลี โปรตุเกส สเปน เกาหลี โปแลนด์ รัสเซีย จีน อาหรับ และไทย',
    adPlaceholder: 'พื้นที่โฆษณา (แสดงหลังยินยอมคุกกี้)',
    howHeading: 'วิธีใช้งาน',
    howStep1Title: 'ดาวน์โหลดแอป',
    howStep1Text: '- ฟรีบน App Store และ Google Play',
    howStep2Title: 'สแกนบาร์โค้ด',
    howStep2Text: '- เล็งโทรศัพท์ไปที่ผลิตภัณฑ์ในร้าน',
    howStep3Title: 'ดูผลลัพธ์',
    howStep3Text: '- รับข้อมูลระดับความเสี่ยงทันที',
    howStep4Title: 'เลือกอย่างมีสติ',
    howStep4Text: '- ตัดสินใจว่าคุณต้องการซื้ออะไร',
    aboutHeading: 'เกี่ยวกับ Mat Sjekk',
    aboutText1: 'Mat Sjekk สร้างขึ้นสำหรับผู้บริโภคที่ใส่ใจซึ่งต้องการควบคุมสิ่งที่ซื้ออย่างเต็มที่ แอปใช้ OpenFoodFacts และแหล่งข้อมูลเปิดอื่น ๆ เพื่อให้ข้อมูลที่โปร่งใส',
    aboutText2: 'เราไม่ได้บอกว่า Bovaer, GMO หรือผงแมลงดีหรือไม่ดี เราให้ข้อมูลเพื่อให้คุณเลือกได้ด้วยตัวเอง',
    faqHeading: 'คำถามที่พบบ่อย',
    faq1Q: 'แอปฟรีทั้งหมดหรือไม่?',
    faq1A: 'ใช่ Mat Sjekk ดาวน์โหลดและใช้งานได้ฟรี เราได้รับการสนับสนุนจากโฆษณา',
    faq2Q: 'ข้อมูลมาจากไหน?',
    faq2A: 'เราใช้ OpenFoodFacts เป็นหลัก และสำหรับบางประเทศใช้ฐานข้อมูลอาหารแห่งชาติ',
    faq3Q: 'ฉันจะรู้ได้อย่างไรว่าข้อมูลถูกต้อง?',
    faq3A: 'เราใช้ข้อมูลที่เปิดเผยต่อสาธารณะและอัปเดตฐานข้อมูลผลิตภัณฑ์อย่างต่อเนื่อง',
    faq4Q: 'รองรับประเทศใดบ้าง?',
    faq4A: 'แอปใช้งานได้ทั่วโลก พร้อมชุดข้อมูลเฉพาะสำหรับหลายประเทศในยุโรปและสหราชอาณาจักร',
    faq5Q: 'คุณเก็บข้อมูลส่วนบุคคลหรือไม่?',
    faq5A: 'ไม่ ข้อมูลถูกจัดเก็บไว้ในโทรศัพท์ของคุณ เราไม่เก็บหรือแบ่งปันข้อมูลส่วนบุคคล',
    contactHeading: 'ติดต่อ',
    contactIntro: 'มีคำถาม ข้อเสนอแนะ หรือคำแนะนำหรือไม่?',
    newsHeading: 'ข่าวสาร',
    newsIntro: 'ติดตามข่าวสาร - เพิ่มบทความที่เกี่ยวข้องกับ Bovaer, GMO, ผงแมลง และความยั่งยืน',
    newsModerationNote: 'บทความที่ส่งมาจะไม่เผยแพร่ทันที โดยจะผ่านการตรวจสอบก่อน',
    newsLanguageLabel: 'ภาษาที่อ่าน / แปลเป็น:',
    newsRegionLabel: 'ภูมิภาค:',
    newsAddArticleBtn: 'เพิ่มบทความ',
    newsFormHeading: 'เพิ่มบทความ',
    newsFormTitleLabel: 'ชื่อเรื่อง',
    newsFormSourceLabel: 'แหล่งที่มา',
    newsFormUrlLabel: 'URL',
    newsFormLanguageLabel: 'ภาษา',
    newsSubmitForModerationBtn: 'ส่งเพื่อตรวจสอบ',
    cancel: 'ยกเลิก',
    footerCopyright: '\u00a9 2026 Mat Sjekk / Einar\'s Apps. All rights reserved.',
  },};

// --- Extended page content (hero, QR, EU sections, story cards, etc.) -------
// IMPORTANT: To avoid a half-translated "language mix", every visible string on
// index.html must have a key here. Add new keys to `nb` and `en` at minimum;
// English is the universal fallback for any language that lacks a key. Keys
// ending in *Html contain inline markup and are applied with data-translate-html.
const EXTRA_TRANSLATIONS = {
  nb: {
    heroMainTitle: 'Ren mat direkte fra bonden, med tydelige risikovarsler i butikk.',
    heroLead1: 'Mat Sjekk kombinerer to behov: finn bondens butikker for kortere matkjede, og skann produkter for trafikklys på Bovaer, GMO/NGT og insektsmel.',
    heroLead2: 'Målet er mer åpenhet om dyrevelferd, fôrvalg og leverandørkjeder, slik at du kan velge med bedre innsikt.',
    ctaHarmonyStore: '🟨 Last ned for HarmonyOS',
    heroFarmshopCountHtml: '🗺️ Over <strong>60 000</strong> gårdsbutikker, agriturismi og lokalmarkeder kartlagt i Europa — foreløpig register, oppdateres løpende.',
    heroEuBannerHtml: '<strong>Viktig EU-oppdatering:</strong> GMO/NGT-regler er i endring. Forbrukermerking kan bli mindre tydelig i enkelte løp, mens krav i frøkjeden fortsatt er sentrale. Mat Sjekk synliggjør dette som regelstatus + forbrukerrisiko. <a href="news.html?cb=20260606f">Les forklaringen</a>',
    qrHeading: 'Last ned appen raskt med QR',
    qrNote: 'Ja, QR er lurt på nettsiden: mobilbrukere kommer direkte til riktig butikkside uten ekstra klikk.',
    qrOpenAppStore: 'Åpne App Store',
    qrOpenGooglePlay: 'Åpne Google Play',
    qrOpenAppGallery: 'Åpne AppGallery',
    whyHeading: 'Hvorfor mange velger bondens butikk først',
    whyNote: 'Kortere verdikjede kan gi bedre innsyn i produksjon, dyrevelferd og råvarekvalitet.',
    whyCard1Title: 'Ren mat nær kilden',
    whyCard1Text: 'Direkte handel fra gård og lokale produsenter gjør det enklere å vite hvor maten kommer fra og hvordan den er produsert.',
    whyCard2Title: 'Dyrevelferd i fokus',
    whyCard2Text: 'Flere forbrukere ønsker aktive valg for bedre dyrevelferd. Derfor løfter vi fram gårds- og lokalbutikker som alternativ.',
    whyCard3Title: 'Bruk appen i tillegg',
    whyCard3Text: 'Når du handler i vanlig butikk, bruker du skanneren i appen for å se regelstatus, forbrukerrisiko og mulig kjederisiko.',
    platformHeading: 'Hvor brukes hva i Mat Sjekk?',
    platformNote: 'I appen skanner du varer i butikk og får trafikklys for risiko. Nettsiden er for å gå dypere: butikksøk, EU-bakgrunn, metode og åpne kilder.',
    platformChipWeb: 'Hjem: Nettside (best på PC)',
    platformChipApp: 'Butikkmodus: App (mobil først)',
    platformChipMix: 'EU-vedtak: Forklaring + bakgrunn',
    euMeansHeading: 'Hva EU-vedtaket betyr for deg i praksis',
    euMeansNote: 'Dette er grunnen til at appen viser både regelstatus og forbrukerrisiko, ikke bare ja/nei.',
    euMeansCard1Title: '1. Merking i forbrukerleddet kan bli svakere',
    euMeansCard1Text: 'I noen GMO/NGT-løp kan informasjonen være mindre synlig for forbruker enn tidligere. Derfor får du et eget trafikklys for regelstatus i appen.',
    euMeansCard2Title: '2. Frø og produksjonsledd har fortsatt krav',
    euMeansCard2Text: 'Det kan fortsatt finnes sporbarhets- og dokumentasjonskrav i upstream-ledd (for eksempel frøkjede/produksjon), selv om etiketten i butikk ikke alltid sier alt.',
    euMeansCard3Title: '3. Leverandørkjede-risiko blir viktigere',
    euMeansCard3Text: 'Importør, leverandør og produsentnettverk betyr mer når direkte produktmerking er svak. Mat Sjekk flagger dette som gul risiko der det er relevant.',
    euMeansCta: 'Se EU-vedtak-siden',
    updatesHeading: 'Siste oppdateringer (juni 2026)',
    updatesChip1: 'EU-fane: søk, filter og delbar lenke (q/topic)',
    updatesChip2: 'EU-fane: tema-seksjoner i fast rekkefølge (GMO, Bovaer, Insektsmel)',
    updatesChip3: 'EU-fane: lokal leselenke + originalkilde per vedtak',
    updatesChip4: 'App: tydeligere kildeknapper med originaltittel',
    updatesNoteHtml: 'Se detaljer under <a href="news.html?cb=20260606f">EU-vedtak</a>.',
    appWarnsHeadingHtml: 'Hva appen faktisk varsler om <span class="section-chip section-chip--web">Nettsideinnhold</span>',
    appWarnsIntro: 'Mat Sjekk varsler om risikosignaler knyttet til Bovaer, GMO i fôrkjeder og insektsmel. Under er temaene som vurderes i dagens app.',
    docLabel: 'Dokumentasjon',
    story1Title: 'Ku, melk og Bovaer',
    story1Text: 'Vi følger særlig saker om fôrtilsetninger i meierikjeden, merking og forbrukerinformasjon om melk og storfe.',
    story1Pill: 'Tema: Bovaer i meierikjeden',
    story1How: '<strong>Slik havner det i maten:</strong> Bovaer er et fôrtilsetningsstoff som gis til melkekyr for å redusere metanutslipp. Det kommer inn i kjeden via fôret → ku → melk og meieriprodukter.',
    story2Title: 'GMO på vei hit',
    story2Text: 'Vi vurderer GMO/NGT-signaler i import- og leverandørkjeder, slik at du ser mulig risiko før varen treffer hylla.',
    story2Pill: 'Tema: GMO/NGT + leverandørkjede',
    story2How: '<strong>Slik havner det i maten:</strong> GMO/NGT-vekster brukes ofte i dyrefôr og importerte råvarer. De kan nå tallerkenen indirekte via fôr → kjøtt/oppdrett, eller direkte som ingrediens i bearbeidede produkter.',
    story3Title: 'Fiskefôr i oppdrett',
    story3Text: 'Appen vurderer risiko i fiskefôrkjeder, inkludert GMO-signaler og mulig indirekte eksponering via leverandørledd.',
    story3Pill: 'Tema: GMO + insektsmel',
    story3How: '<strong>Slik havner det i maten:</strong> Oppdrettsfisk fôres med blandinger som kan inneholde GMO-råvarer. Eksponeringen skjer indirekte: fôr → fisk → fersk oppdrettslaks i butikken.',
    story4Title: 'Insektsmel i matkjeden',
    story4Text: 'Appen markerer produkter med mulig insekt-eksponering via ingrediens, merking eller leverandørkjede der informasjonen er usikker.',
    story4Pill: 'Tema: Insektsmel / novel food',
    story4How: '<strong>Slik havner det i maten:</strong> Insektsmel er godkjent som «novel food» og brukes i fôr og enkelte matvarer. Det kan nå maten via fôr → dyr, eller direkte som ingrediens i bearbeidede produkter.',
    aboutMethodLineHtml: 'Les mer om hvordan kvalitetskontroll gjøres i <a href="editorial-method.html">redaksjonell metode</a>. Vil du forstå forskningen bak temaene, se <a href="research.html">slik leser du forskning</a>.',
    editorial1Html: '<strong>Datakilder</strong><br>OpenFoodFacts, åpne offentlige kilder, og verifiserte nettaviser.',
    editorial2Html: '<strong>Redaksjonelt fokus</strong><br>Bovaer, insektsmel og GMO i fiskefôr, med europeisk dekning.',
    editorial3Html: '<strong>Transparens</strong><br>Risikosignaler i appen bygger på sporbare kilder og vises med forklarende tekst.',
    editorial4Html: '<strong>Oppdatering</strong><br>Risikoregler og butikklister oppdateres løpende for å holde innholdet relevant.',
  },
  en: {
    heroMainTitle: 'Clean food straight from the farm, with clear risk alerts in store.',
    heroLead1: 'Mat Sjekk combines two needs: find the farmer\u2019s shops for a shorter food chain, and scan products for a traffic-light reading of Bovaer, GMO/NGT and insect meal.',
    heroLead2: 'The goal is more transparency about animal welfare, feed choices and supply chains, so you can choose with better insight.',
    ctaHarmonyStore: '🟨 Download for HarmonyOS',
    heroFarmshopCountHtml: '🗺️ Over <strong>60,000</strong> farm shops, agriturismi and local markets mapped across Europe — a preliminary register, updated continuously.',
    heroEuBannerHtml: '<strong>Important EU update:</strong> GMO/NGT rules are changing. Consumer labelling may become less clear in some cases, while requirements in the seed chain remain central. Mat Sjekk makes this visible as rule status + consumer risk. <a href="news.html?cb=20260606f">Read the explanation</a>',
    qrHeading: 'Download the app quickly with QR',
    qrNote: 'Yes, QR is smart on the website: mobile users go straight to the right store page without extra clicks.',
    qrOpenAppStore: 'Open App Store',
    qrOpenGooglePlay: 'Open Google Play',
    qrOpenAppGallery: 'Open AppGallery',
    whyHeading: 'Why many choose the farm shop first',
    whyNote: 'A shorter value chain can give better insight into production, animal welfare and raw-material quality.',
    whyCard1Title: 'Clean food close to the source',
    whyCard1Text: 'Buying directly from farms and local producers makes it easier to know where the food comes from and how it was produced.',
    whyCard2Title: 'Animal welfare in focus',
    whyCard2Text: 'More consumers want active choices for better animal welfare. That is why we highlight farm and local shops as an alternative.',
    whyCard3Title: 'Use the app as well',
    whyCard3Text: 'When you shop in a regular store, use the scanner in the app to see rule status, consumer risk and possible chain risk.',
    platformHeading: 'Where is what used in Mat Sjekk?',
    platformNote: 'In the app you scan products in-store and get risk traffic-lights. The website is for going deeper: store search, EU background, methodology and open sources.',
    platformChipWeb: 'Home: Website (best on PC)',
    platformChipApp: 'Store mode: App (mobile first)',
    platformChipMix: 'EU decision: Explanation + background',
    euMeansHeading: 'What the EU decision means for you in practice',
    euMeansNote: 'This is why the app shows both rule status and consumer risk, not just yes/no.',
    euMeansCard1Title: '1. Labelling at the consumer stage may get weaker',
    euMeansCard1Text: 'In some GMO/NGT cases the information may be less visible to the consumer than before. That is why you get a dedicated traffic light for rule status in the app.',
    euMeansCard2Title: '2. Seed and production stages still have requirements',
    euMeansCard2Text: 'There may still be traceability and documentation requirements in upstream stages (for example the seed chain/production), even if the label in store does not always say everything.',
    euMeansCard3Title: '3. Supply-chain risk becomes more important',
    euMeansCard3Text: 'Importer, supplier and producer networks matter more when direct product labelling is weak. Mat Sjekk flags this as yellow risk where relevant.',
    euMeansCta: 'See the EU decision page',
    updatesHeading: 'Latest updates (June 2026)',
    updatesChip1: 'EU tab: search, filter and shareable link (q/topic)',
    updatesChip2: 'EU tab: topic sections in a fixed order (GMO, Bovaer, Insect meal)',
    updatesChip3: 'EU tab: local reading link + original source per decision',
    updatesChip4: 'App: clearer source buttons with the original title',
    updatesNoteHtml: 'See details under <a href="news.html?cb=20260606f">EU decision</a>.',
    appWarnsHeadingHtml: 'What the app actually alerts about <span class="section-chip section-chip--web">Website content</span>',
    appWarnsIntro: 'Mat Sjekk alerts about risk signals related to Bovaer, GMO in feed chains and insect meal. Below are the topics assessed in today\u2019s app.',
    docLabel: 'Documentation',
    story1Title: 'Cow, milk and Bovaer',
    story1Text: 'We follow in particular cases about feed additives in the dairy chain, labelling and consumer information about milk and cattle.',
    story1Pill: 'Topic: Bovaer in the dairy chain',
    story1How: '<strong>How it ends up in your food:</strong> Bovaer is a feed additive given to dairy cows to reduce methane emissions. It enters the chain via the feed → cow → milk and dairy products.',
    story2Title: 'GMO on its way here',
    story2Text: 'We assess GMO/NGT signals in import and supply chains, so you can see possible risk before the product reaches the shelf.',
    story2Pill: 'Topic: GMO/NGT + supply chain',
    story2How: '<strong>How it ends up in your food:</strong> GMO/NGT crops are often used in animal feed and imported ingredients. They can reach your plate indirectly via feed → meat/farmed fish, or directly as an ingredient in processed products.',
    story3Title: 'Feed in fish farming',
    story3Text: 'The app assesses risk in fish-feed chains, including GMO signals and possible indirect exposure via supplier stages.',
    story3Pill: 'Topic: GMO + insect meal',
    story3How: '<strong>How it ends up in your food:</strong> Farmed fish are fed mixes that may contain GMO ingredients. Exposure is indirect: feed → fish → fresh farmed salmon in the store.',
    story4Title: 'Insect meal in the food chain',
    story4Text: 'The app marks products with possible insect exposure via ingredient, labelling or supply chain where the information is uncertain.',
    story4Pill: 'Topic: Insect meal / novel food',
    story4How: '<strong>How it ends up in your food:</strong> Insect meal is approved as a "novel food" and used in feed and some foods. It can reach your food via feed → animals, or directly as an ingredient in processed products.',
    aboutMethodLineHtml: 'Read more about how quality control is done in <a href="editorial-method.html">editorial method</a>. To understand the research behind the topics, see <a href="research.html">how to read research</a>.',
    editorial1Html: '<strong>Data sources</strong><br>OpenFoodFacts, open public sources, and verified news outlets.',
    editorial2Html: '<strong>Editorial focus</strong><br>Bovaer, insect meal and GMO in fish feed, with European coverage.',
    editorial3Html: '<strong>Transparency</strong><br>Risk signals in the app are based on traceable sources and shown with explanatory text.',
    editorial4Html: '<strong>Updates</strong><br>Risk rules and store lists are updated continuously to keep the content relevant.',
  },
  de: {
    heroMainTitle: 'Saubere Lebensmittel direkt vom Hof, mit klaren Risikohinweisen im Geschäft.',
    heroLead1: 'Mat Sjekk verbindet zwei Bedürfnisse: Hofläden für eine kürzere Lebensmittelkette finden und Produkte per Ampel auf Bovaer, GMO/NGT und Insektenmehl prüfen.',
    heroLead2: 'Das Ziel ist mehr Transparenz über Tierwohl, Futterwahl und Lieferketten, damit Sie mit besserem Einblick wählen können.',
    ctaHarmonyStore: '🟨 Für HarmonyOS herunterladen',
    heroFarmshopCountHtml: '🗺️ Über <strong>60.000</strong> Hofläden, Agriturismi und lokale Märkte in ganz Europa erfasst — vorläufiges Verzeichnis, wird laufend aktualisiert.',
    heroEuBannerHtml: '<strong>Wichtiges EU-Update:</strong> Die GMO/NGT-Regeln ändern sich. Die Verbraucherkennzeichnung kann in einigen Fällen weniger eindeutig werden, während Anforderungen in der Saatgutkette weiterhin zentral sind. Mat Sjekk macht dies als Regelstatus + Verbraucherrisiko sichtbar. <a href="news.html?cb=20260606f">Erklärung lesen</a>',
    qrHeading: 'Die App schnell per QR herunterladen',
    qrNote: 'Ja, QR ist auf der Website sinnvoll: Mobilnutzer gelangen ohne Umwege direkt zur richtigen Store-Seite.',
    qrOpenAppStore: 'App Store öffnen',
    qrOpenGooglePlay: 'Google Play öffnen',
    qrOpenAppGallery: 'AppGallery öffnen',
    whyHeading: 'Warum viele zuerst den Hofladen wählen',
    whyNote: 'Eine kürzere Wertschöpfungskette kann besseren Einblick in Produktion, Tierwohl und Rohstoffqualität geben.',
    whyCard1Title: 'Saubere Lebensmittel nah an der Quelle',
    whyCard1Text: 'Der direkte Einkauf bei Höfen und lokalen Erzeugern macht es leichter zu wissen, woher die Lebensmittel kommen und wie sie produziert wurden.',
    whyCard2Title: 'Tierwohl im Fokus',
    whyCard2Text: 'Immer mehr Verbraucher möchten aktive Entscheidungen für besseres Tierwohl treffen. Deshalb heben wir Hof- und Lokalläden als Alternative hervor.',
    whyCard3Title: 'Nutzen Sie zusätzlich die App',
    whyCard3Text: 'Wenn Sie im normalen Geschäft einkaufen, nutzen Sie den Scanner in der App, um Regelstatus, Verbraucherrisiko und mögliches Kettenrisiko zu sehen.',
    platformHeading: 'Wo wird was in Mat Sjekk verwendet?',
    platformNote: 'In der App scannst du Produkte im Laden und erhältst Risiko-Ampeln. Die Website dient der Vertiefung: Ladensuche, EU-Hintergrund, Methodik und offene Quellen.',
    platformChipWeb: 'Start: Website (am besten am PC)',
    platformChipApp: 'Ladenmodus: App (mobil zuerst)',
    platformChipMix: 'EU-Entscheidung: Erklärung + Hintergrund',
    euMeansHeading: 'Was die EU-Entscheidung für Sie in der Praxis bedeutet',
    euMeansNote: 'Deshalb zeigt die App sowohl Regelstatus als auch Verbraucherrisiko, nicht nur ja/nein.',
    euMeansCard1Title: '1. Die Kennzeichnung beim Verbraucher kann schwächer werden',
    euMeansCard1Text: 'In einigen GMO/NGT-Fällen kann die Information für Verbraucher weniger sichtbar sein als früher. Deshalb erhalten Sie in der App eine eigene Ampel für den Regelstatus.',
    euMeansCard2Title: '2. Saatgut- und Produktionsstufen haben weiterhin Anforderungen',
    euMeansCard2Text: 'In vorgelagerten Stufen (zum Beispiel Saatgutkette/Produktion) kann es weiterhin Rückverfolgbarkeits- und Dokumentationspflichten geben, auch wenn das Etikett im Geschäft nicht immer alles sagt.',
    euMeansCard3Title: '3. Lieferkettenrisiko wird wichtiger',
    euMeansCard3Text: 'Importeur, Lieferant und Erzeugernetzwerke zählen mehr, wenn die direkte Produktkennzeichnung schwach ist. Mat Sjekk kennzeichnet dies als gelbes Risiko, wo es relevant ist.',
    euMeansCta: 'Zur EU-Entscheidungsseite',
    updatesHeading: 'Neueste Updates (Juni 2026)',
    updatesChip1: 'EU-Tab: Suche, Filter und teilbarer Link (q/topic)',
    updatesChip2: 'EU-Tab: Themenabschnitte in fester Reihenfolge (GMO, Bovaer, Insektenmehl)',
    updatesChip3: 'EU-Tab: lokaler Leselink + Originalquelle je Entscheidung',
    updatesChip4: 'App: deutlichere Quellen-Schaltflächen mit Originaltitel',
    updatesNoteHtml: 'Details siehe unter <a href="news.html?cb=20260606f">EU-Entscheidung</a>.',
    appWarnsHeadingHtml: 'Worüber die App tatsächlich informiert <span class="section-chip section-chip--web">Website-Inhalt</span>',
    appWarnsIntro: 'Mat Sjekk weist auf Risikosignale rund um Bovaer, GMO in Futterketten und Insektenmehl hin. Unten stehen die Themen, die in der heutigen App bewertet werden.',
    docLabel: 'Dokumentation',
    story1Title: 'Kuh, Milch und Bovaer',
    story1Text: 'Wir verfolgen besonders Fälle zu Futterzusätzen in der Milchkette, zur Kennzeichnung und zur Verbraucherinformation über Milch und Rinder.',
    story1Pill: 'Thema: Bovaer in der Milchkette',
    story1How: '<strong>So gelangt es in die Lebensmittel:</strong> Bovaer ist ein Futterzusatz, der Milchkühen gegeben wird, um Methanemissionen zu senken. Es gelangt über das Futter → Kuh → Milch und Milchprodukte in die Kette.',
    story2Title: 'GMO auf dem Weg hierher',
    story2Text: 'Wir bewerten GMO/NGT-Signale in Import- und Lieferketten, damit Sie mögliche Risiken sehen, bevor die Ware ins Regal kommt.',
    story2Pill: 'Thema: GMO/NGT + Lieferkette',
    story2How: '<strong>So gelangt es in die Lebensmittel:</strong> GMO/NGT-Pflanzen werden häufig in Tierfutter und importierten Rohstoffen verwendet. Sie können den Teller indirekt über Futter → Fleisch/Zucht erreichen oder direkt als Zutat in verarbeiteten Produkten.',
    story3Title: 'Futter in der Fischzucht',
    story3Text: 'Die App bewertet Risiken in Fischfutterketten, einschließlich GMO-Signalen und möglicher indirekter Exposition über Lieferstufen.',
    story3Pill: 'Thema: GMO + Insektenmehl',
    story3How: '<strong>So gelangt es in die Lebensmittel:</strong> Zuchtfische werden mit Mischungen gefüttert, die GMO-Rohstoffe enthalten können. Die Exposition erfolgt indirekt: Futter → Fisch → frischer Zuchtlachs im Geschäft.',
    story4Title: 'Insektenmehl in der Lebensmittelkette',
    story4Text: 'Die App kennzeichnet Produkte mit möglicher Insekten-Exposition über Zutat, Kennzeichnung oder Lieferkette, wenn die Information unsicher ist.',
    story4Pill: 'Thema: Insektenmehl / Novel Food',
    story4How: '<strong>So gelangt es in die Lebensmittel:</strong> Insektenmehl ist als „Novel Food“ zugelassen und wird in Futter und einigen Lebensmitteln verwendet. Es kann über Futter → Tiere oder direkt als Zutat in verarbeiteten Produkten in die Lebensmittel gelangen.',
    aboutMethodLineHtml: 'Lesen Sie mehr darüber, wie die Qualitätskontrolle erfolgt, in <a href="editorial-method.html">redaktionelle Methode</a>. Um die Forschung hinter den Themen zu verstehen, siehe <a href="research.html">Forschung lesen</a>.',
    editorial1Html: '<strong>Datenquellen</strong><br>OpenFoodFacts, offene öffentliche Quellen und verifizierte Nachrichtenmedien.',
    editorial2Html: '<strong>Redaktioneller Fokus</strong><br>Bovaer, Insektenmehl und GMO in Fischfutter, mit europäischer Abdeckung.',
    editorial3Html: '<strong>Transparenz</strong><br>Risikosignale in der App beruhen auf nachvollziehbaren Quellen und werden mit erläuterndem Text angezeigt.',
    editorial4Html: '<strong>Aktualisierung</strong><br>Risikoregeln und Ladenlisten werden laufend aktualisiert, um den Inhalt relevant zu halten.',
  },
};
Object.keys(EXTRA_TRANSLATIONS).forEach((lng) => {
  translations[lng] = Object.assign({}, translations[lng] || {}, EXTRA_TRANSLATIONS[lng]);
});

const APP_LANGUAGE_COUNT_LABELS = {
  nb: '17 sprak',
  en: '17 languages',
  sv: '17 sprak',
  da: '17 sprog',
  fi: '17 kieltä',
  de: '17 Sprachen',
  nl: '17 talen',
  fr: '17 langues',
  it: '17 lingue',
  pt: '17 idiomas',
  es: '17 idiomas',
  ko: '17개 언어',
  pl: '17 języków',
  ru: '17 языков',
  zh: '17 种语言',
  ar: '17 لغة',
  th: '17 ภาษา',
};

const APP_LANGUAGE_TEXT_LABELS = {
  nb: 'Stotte for norsk, engelsk, svensk, dansk, finsk, tysk, nederlandsk, fransk, italiensk, portugisisk, spansk, koreansk, polsk, russisk, kinesisk, arabisk og thai',
  en: 'Supports Norwegian, English, Swedish, Danish, Finnish, German, Dutch, French, Italian, Portuguese, Spanish, Korean, Polish, Russian, Chinese, Arabic, and Thai',
  sv: 'Stod for norska, engelska, svenska, danska, finska, tyska, nederlandska, franska, italienska, portugisiska, spanska, koreanska, polska, ryska, kinesiska, arabiska och thailandska',
  da: 'Understotter norsk, engelsk, svensk, dansk, finsk, tysk, nederlandsk, fransk, italiensk, portugisisk, spansk, koreansk, polsk, russisk, kinesisk, arabisk og thai',
  fi: 'Tukee norjaa, englantia, ruotsia, tanskaa, suomea, saksaa, hollantia, ranskaa, italiaa, portugalia, espanjaa, koreaa, puolaa, venajaa, kiinaa, arabiaa ja thaita',
  de: 'Unterstutzt Norwegisch, Englisch, Schwedisch, Danisch, Finnisch, Deutsch, Niederlandisch, Franzosisch, Italienisch, Portugiesisch, Spanisch, Koreanisch, Polnisch, Russisch, Chinesisch, Arabisch und Thai',
  nl: 'Ondersteunt Noors, Engels, Zweeds, Deens, Fins, Duits, Nederlands, Frans, Italiaans, Portugees, Spaans, Koreaans, Pools, Russisch, Chinees, Arabisch en Thai',
  fr: 'Prend en charge le norvegien, l anglais, le suedois, le danois, le finnois, l allemand, le neerlandais, le francais, l italien, le portugais, l espagnol, le coreen, le polonais, le russe, le chinois, l arabe et le thai',
  it: 'Supporta norvegese, inglese, svedese, danese, finlandese, tedesco, olandese, francese, italiano, portoghese, spagnolo, coreano, polacco, russo, cinese, arabo e tailandese',
  pt: 'Suporta noruegues, ingles, sueco, dinamarques, finlandes, alemao, neerlandes, frances, italiano, portugues, espanhol, coreano, polaco, russo, chines, arabe e tailandes',
  es: 'Admite noruego, ingles, sueco, danes, fines, aleman, neerlandes, frances, italiano, portugues, espanol, coreano, polaco, ruso, chino, arabe y tailandes',
  ko: '노르웨이어, 영어, 스웨덴어, 덴마크어, 핀란드어, 독일어, 네덜란드어, 프랑스어, 이탈리아어, 포르투갈어, 스페인어, 한국어, 폴란드어, 러시아어, 중국어, 아랍어, 태국어 지원',
  pl: 'Obsługuje norweski, angielski, szwedzki, duński, fiński, niemiecki, niderlandzki, francuski, włoski, portugalski, hiszpański, koreański, polski, rosyjski, chiński, arabski i tajski',
  ru: 'Поддерживает норвежский, английский, шведский, датский, финский, немецкий, нидерландский, французский, итальянский, португальский, испанский, корейский, польский, русский, китайский, арабский и тайский',
  zh: '支持挪威语、英语、瑞典语、丹麦语、芬兰语、德语、荷兰语、法语、意大利语、葡萄牙语、西班牙语、韩语、波兰语、俄语、中文、阿拉伯语和泰语',
  ar: 'يدعم النرويجية والإنجليزية والسويدية والدنماركية والفنلندية والألمانية والهولندية والفرنسية والإيطالية والبرتغالية والإسبانية والكورية والبولندية والروسية والصينية والعربية والتايلاندية',
  th: 'รองรับภาษานอร์เวย์ อังกฤษ สวีเดน เดนมาร์ก ฟินแลนด์ เยอรมัน ดัตช์ ฝรั่งเศส อิตาลี โปรตุเกส สเปน เกาหลี โปแลนด์ รัสเซีย จีน อาหรับ และไทย',
};

const HARMONY_BUTTON_LABELS = {
  nb: '🟨 Last ned for HarmonyOS',
  en: '🟨 Download for HarmonyOS',
  sv: '🟨 Ladda ner for HarmonyOS',
  da: '🟨 Download til HarmonyOS',
  fi: '🟨 Lataa HarmonyOS-versio',
  de: '🟨 Fur HarmonyOS herunterladen',
  nl: '🟨 Download voor HarmonyOS',
  fr: '🟨 Telecharger pour HarmonyOS',
  it: '🟨 Scarica per HarmonyOS',
  pt: '🟨 Transferir para HarmonyOS',
  es: '🟨 Descargar para HarmonyOS',
  ko: '🟨 HarmonyOS용 다운로드',
  pl: '🟨 Pobierz na HarmonyOS',
  ru: '🟨 Скачать для HarmonyOS',
  zh: '🟨 下载 HarmonyOS 版',
  ar: '🟨 التنزيل لنظام HarmonyOS',
  th: '🟨 ดาวน์โหลดสำหรับ HarmonyOS',
};

['ko', 'pl', 'ru', 'zh', 'ar', 'th'].forEach((code) => {
  if (!translations[code]) {
    translations[code] = { ...translations.en };
  }
});

Object.entries(translations).forEach(([code, dict]) => {
  dict.featureLangTitle = APP_LANGUAGE_COUNT_LABELS[code] || APP_LANGUAGE_COUNT_LABELS.en;
  dict.featureLangText = APP_LANGUAGE_TEXT_LABELS[code] || APP_LANGUAGE_TEXT_LABELS.en;
  dict.ctaHarmonyStore = HARMONY_BUTTON_LABELS[code] || HARMONY_BUTTON_LABELS.en;
});

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
  const dict = translations[dictLang] || translations.nb;
  const enDict = translations.en || {};
  const nbDict = translations.nb || {};
  // Per-key fallback: selected language -> English -> Norwegian. This keeps the
  // whole page in ONE language even when a translation key is missing, instead
  // of silently leaving the hardcoded Norwegian source (the old "mix" bug).
  const pick = (key) => {
    if (dict[key] != null) return dict[key];
    if (enDict[key] != null) return enDict[key];
    return nbDict[key];
  };
  document.querySelectorAll('[data-translate]').forEach((el) => {
    const key = el.getAttribute('data-translate');
    const value = pick(key);
    if (key && value != null) el.textContent = value;
  });
  // For text that contains inline markup (links, <strong>) we set innerHTML.
  document.querySelectorAll('[data-translate-html]').forEach((el) => {
    const key = el.getAttribute('data-translate-html');
    const value = pick(key);
    if (key && value != null) el.innerHTML = value;
  });
  document.documentElement.lang = dictLang || 'nb';
  // Right-to-left languages need the document direction flipped.
  const rtlLanguages = ['ar', 'he', 'fa', 'ur'];
  document.documentElement.dir = rtlLanguages.includes(dictLang) ? 'rtl' : 'ltr';
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
  populateSelect(document.getElementById('news-lang')); // Auto + all supported languages
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

function updateLangInUrl(lang) {
  const params = new URLSearchParams(window.location.search || '');
  if (!lang || lang === AUTO_LANGUAGE_CODE) {
    params.delete('lang');
  } else {
    params.set('lang', lang);
  }
  const query = params.toString();
  const newUrl = `${window.location.pathname}${query ? `?${query}` : ''}${window.location.hash || ''}`;
  window.history.replaceState({}, document.title, newUrl);
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

  // Reflect the active language in the URL (e.g. ?lang=de) so the link leads
  // directly to that language. In auto mode the param is removed.
  updateLangInUrl(useAuto ? AUTO_LANGUAGE_CODE : resolvedLang);

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

      updateLangInUrl(AUTO_LANGUAGE_CODE);
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

    updateLangInUrl(nextLang);
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
window.applyTranslations = applyTranslations;

window.addEventListener('DOMContentLoaded', initLanguage);
