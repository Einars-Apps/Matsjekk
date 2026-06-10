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
  },};

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
  ko: '17 languages',
  pl: '17 languages',
  ru: '17 languages',
  zh: '17 languages',
  ar: '17 languages',
  th: '17 languages',
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
  ko: 'Supports Norwegian, English, Swedish, Danish, Finnish, German, Dutch, French, Italian, Portuguese, Spanish, Korean, Polish, Russian, Chinese, Arabic, and Thai',
  pl: 'Supports Norwegian, English, Swedish, Danish, Finnish, German, Dutch, French, Italian, Portuguese, Spanish, Korean, Polish, Russian, Chinese, Arabic, and Thai',
  ru: 'Supports Norwegian, English, Swedish, Danish, Finnish, German, Dutch, French, Italian, Portuguese, Spanish, Korean, Polish, Russian, Chinese, Arabic, and Thai',
  zh: 'Supports Norwegian, English, Swedish, Danish, Finnish, German, Dutch, French, Italian, Portuguese, Spanish, Korean, Polish, Russian, Chinese, Arabic, and Thai',
  ar: 'Supports Norwegian, English, Swedish, Danish, Finnish, German, Dutch, French, Italian, Portuguese, Spanish, Korean, Polish, Russian, Chinese, Arabic, and Thai',
  th: 'Supports Norwegian, English, Swedish, Danish, Finnish, German, Dutch, French, Italian, Portuguese, Spanish, Korean, Polish, Russian, Chinese, Arabic, and Thai',
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
  ko: '🟨 Download for HarmonyOS',
  pl: '🟨 Download for HarmonyOS',
  ru: '🟨 Download for HarmonyOS',
  zh: '🟨 Download for HarmonyOS',
  ar: '🟨 Download for HarmonyOS',
  th: '🟨 Download for HarmonyOS',
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
