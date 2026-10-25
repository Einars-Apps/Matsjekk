// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian Bokmål (`nb`).
class AppLocalizationsNb extends AppLocalizations {
  AppLocalizationsNb([String locale = 'nb']) : super(locale);

  @override
  String get appTitle => 'Matvare-sjekk';

  @override
  String get scanBarcode => 'Scan strekkode';

  @override
  String get productNotFound => 'Produktet ble ikke funnet i databasen.';

  @override
  String get addToList => 'Legg i handleliste';

  @override
  String get shoppingLists => 'Handlelister';

  @override
  String get history => 'Historikk';

  @override
  String get settings => 'Innstillinger';

  @override
  String get about => 'Om appen';

  @override
  String get howAppWorks => 'Hvordan appen henter info';

  @override
  String get appDescription => 'Appen bruker Open Food Facts og en intern liste for merkevare-koblinger til Bovaer, insektmel, GMO-fôr og andre kontroversielle ingredienser.';

  @override
  String get alerts => 'Velg varsler';

  @override
  String get bovaerAlert => 'Bovaer-varsel';

  @override
  String get insectMealAlert => 'Insektmel-varsel';

  @override
  String get ngtAlert => 'Skjult GMO (NGT)-varsel';

  @override
  String get gmoFishAlert => 'GMO-fôr (Fisk)';

  @override
  String get highRisk => 'HØY RISIKO';

  @override
  String get possibleRisk => 'MULIG RISIKO';

  @override
  String get safe => 'TRYGG';

  @override
  String get unknown => 'UKJENT';

  @override
  String get bovaerRiskDesc => 'Produsenten er direkte knyttet til Bovaer.';

  @override
  String get insectMealRiskDesc => 'Produktet kan inneholde insektmel.';

  @override
  String get gmoFishRiskDesc => 'Produsenten er knyttet til bruk av GMO-fôr.';

  @override
  String get safeDesc => 'Produktet er merket som økologisk.';

  @override
  String get nutriScore => 'Nutri-Score';

  @override
  String get traceability => 'Sporbarhet';

  @override
  String get beta => 'Beta';

  @override
  String get close => 'Lukk';

  @override
  String get create => 'Opprett';

  @override
  String get search => 'Søk';

  @override
  String get searchProducts => 'Søk etter produkt';

  @override
  String get noResults => 'Ingen resultater';

  @override
  String get newList => 'Ny liste';

  @override
  String get deleteList => 'Langtikk for å slette';

  @override
  String get language => 'Språk / Language';

  @override
  String get selectLanguage => 'Velg språk';

  @override
  String get norwegian => 'Norsk';

  @override
  String get swedish => 'Svenska';

  @override
  String get danish => 'Dansk';

  @override
  String get dutch => 'Nederlands';

  @override
  String get french => 'Français';

  @override
  String get english => 'English';

  @override
  String get german => 'Deutsch';

  @override
  String get italian => 'Italiano';

  @override
  String get spanish => 'Español';

  @override
  String get portuguese => 'Português';

  @override
  String get finnish => 'Finsk';

  @override
  String get changeListName => 'Endre listenavn';

  @override
  String get cancel => 'Avbryt';

  @override
  String get save => 'Lagre';

  @override
  String get manualAddItem => 'Legg til vare manuelt...';

  @override
  String get emptyList => 'Listen er tom';

  @override
  String get noHistory => 'Ingen historikk for denne listen';

  @override
  String get globalHistory => 'Global Historikk';

  @override
  String get newShoppingList => 'Ny handleliste';

  @override
  String get listName => 'Navn på liste';

  @override
  String get noHistoryFound => 'Ingen historikk funnet';

  @override
  String get addedItems => 'E-stoffer';

  @override
  String get identifiedAdditions => 'Identifiserte E-stoffer';

  @override
  String get noAdditionsFound => 'Ingen E-stoffer funnet i databasen.';

  @override
  String get disclaimer => 'Ansvarsfraskrivelse: Informasjonen er veiledende og basert på offentlig kjente data. For 100% nøyaktig informasjon, se produktets emballasje eller kontakt produsenten.';

  @override
  String get bovaerHighRisk => 'HØY RISIKO: Produsenten er direkte knyttet til Bovaer.';

  @override
  String get gmoHighRisk => 'HØY RISIKO: Produsenten er knyttet til bruk av GMO-fôr.';

  @override
  String get bovaerPossibleRisk => 'MULIG RISIKO: Produsenten er en samarbeidspartner med aktører som er knyttet til Bovaer.';

  @override
  String get safeProduct => 'TRYGG: Produktet er merket som økologisk.';

  @override
  String get searchHint => 'Søk... (f.eks. melk)';

  @override
  String get delete => 'Slett';

  @override
  String get deleteListConfirmTitle => 'Slette liste?';

  @override
  String get deleteListConfirmMessage => 'Er du sikker? Dette vil også slette historikken for listen.';

  @override
  String get unknownProduct => 'Ukjent produkt';

  @override
  String get removeAds => 'Fjern annonser';

  @override
  String get removeAdsInfo => 'Fjern annonser for mer plass i handlelisten';

  @override
  String get removeAdsMenuItem => 'Fjern annonser (kr 49,-) — støtter videre utvikling';

  @override
  String get gmoRegExplicit => 'EU-REGELSTATUS: Produktet ser ut til å være i GMO/NGT-regulert kategori.';

  @override
  String get gmoRegFeedChain => 'EU-REGELSTATUS: Kan omfattes av GMO/NGT-regelverk via fôrkjede.';

  @override
  String get gmoRegNgt => 'EU-REGELSTATUS: Produktet kan omfattes av nytt EU-vedtak for genredigering (NGT).';

  @override
  String get gmoRegSupplyChain => 'EU-REGELSTATUS: Mulig indirekte GMO/NGT-relevans via importør/leverandør/produsentkjede.';

  @override
  String get gmoRegCropOrigin => 'EU-REGELSTATUS: GMO-utsatt råvare med amerikansk/ikke-EU-opprinnelse – kan utløse EUs GMO-merkeplikt.';

  @override
  String get gmoRegCropUnknown => 'EU-REGELSTATUS: GMO-utsatt råvare i importert/leverandørledd – opprinnelse bør verifiseres.';

  @override
  String get insectRegExplicit => 'EU-REGELSTATUS: Produktet ser ut til å være i insekt/novel-food-regulert kategori.';

  @override
  String get insectRegNovelFood => 'EU-REGELSTATUS: Produktet kan omfattes av EU-regler for insekter som novel food.';

  @override
  String get insectRegSupplyChain => 'EU-REGELSTATUS: Mulig indirekte relevans via importør/leverandør/produsentkjede.';

  @override
  String get gmoConsExplicit => 'FORBRUKERRISIKO: Produkttekst/etikett indikerer GMO-innhold.';

  @override
  String get gmoConsFeed => 'FORBRUKERRISIKO: Merke/kategori matcher kjent GMO-fôr-eksponering.';

  @override
  String get gmoConsNgt => 'FORBRUKERRISIKO: Kan påvirke forbrukermarkedet, men bør verifiseres mot etikett og produsentinfo.';

  @override
  String get gmoConsSupplyChain => 'FORBRUKERRISIKO: Mulig risiko via leverandørkjede (hvem som selger til hvem). Verifiser etikett og opprinnelse.';

  @override
  String get gmoConsCropOrigin => 'FORBRUKERRISIKO: Inneholder GMO-utsatt råvare (soya/mais/raps/sukkerbete/bomull) importert fra et land der avlingen overveiende er genmodifisert. Sjekk etikett for «uten GMO»-merking.';

  @override
  String get gmoConsCropUnknown => 'FORBRUKERRISIKO: Produktet inneholder en GMO-utsatt råvare (soya/mais/raps/sukkerbete/bomull). Opprinnelse er ukjent – sjekk etikett og opphavsland.';

  @override
  String get insectConsExplicit => 'FORBRUKERRISIKO: Produkttekst/ingredienser indikerer insektsmel eller insektprotein.';

  @override
  String get insectConsNovelFood => 'FORBRUKERRISIKO: Mulig insektsrelatert eksponering, verifiser ingrediensliste.';

  @override
  String get insectConsSupplyChain => 'FORBRUKERRISIKO: Mulig risiko via leverandørkjede (hvem som selger til hvem).';

  @override
  String get noKnownRisk => 'Ingen kjent risiko i denne kategorien.';

  @override
  String get searchBetaNote => 'Beta: Søkefunksjonen er under kontinuerlig forbedring. Dobbeltsjekk alltid produktdetaljer før du tar valg.';

  @override
  String get couldNotOpenLink => 'Kunne ikke åpne lenken';

  @override
  String get eNumberNoDescription => 'Vi har ingen beskrivelse av dette E-stoffet ennå. E-nummeret er en tilsetningsstoff-kode som brukes i EU/EØS.';

  @override
  String get allergensTitle => 'Allergener';

  @override
  String get noAllergensFound => 'Ingen allergener funnet.';

  @override
  String get nutritionTitle => 'Næringsinnhold (per 100 g)';

  @override
  String get noNutritionFound => 'Ingen næringsinformasjon funnet.';

  @override
  String get alertsTitle => 'Varsler';

  @override
  String get alertEvidence => 'Dokumentasjon:';

  @override
  String get alertInternalListNote => 'Varsel: intern liste for merkevare-koblinger';

  @override
  String get alertBrandTrackingNote => 'Varsel: merkevaresporing og offentlig informasjon';

  @override
  String get reportNoteHint => 'Kort notat (f.eks. falsk positiv)';

  @override
  String get report => 'Rapporter';

  @override
  String get send => 'Send';

  @override
  String get reportSaved => 'Takk — rapport lagret.';

  @override
  String get seeUpdatedStatus => 'Se oppdatert status';

  @override
  String get openEuSource => 'Åpne EU-kilde';

  @override
  String get openInsectSource => 'Åpne insektkilde';

  @override
  String get privacyTitle => 'Personvern';

  @override
  String get consentOptional => 'Dette er valgfritt. Hvis du ikke samtykker, blir bruken din ikke sendt til analyse.';

  @override
  String get consentWorksAnyway => 'Appen fungerer uansett, og data kan bli kun på din enhet.';

  @override
  String get readPrivacyPolicy => 'Les personvernreglene';

  @override
  String get allowAnonymousAnalytics => 'Tillat anonym analyse';

  @override
  String get analyticsEnabled => 'Takk – analyse aktivert.';

  @override
  String get analyticsDisabled => 'Analyse deaktivert.';

  @override
  String couldNotOpenLinkError(String error) {
    return 'Kunne ikke åpne lenken: $error';
  }

  @override
  String reportSaveFailed(String error) {
    return 'Kunne ikke lagre rapport: $error';
  }

  @override
  String alertSeverity(String value) {
    return 'Alvorlighet: $value';
  }

  @override
  String alertReason(String value) {
    return 'Årsak: $value';
  }

  @override
  String alertConfidence(String value) {
    return 'Sikkerhet: $value';
  }

  @override
  String matvaretabellenSuggestions(String count) {
    return 'Forslag fra Matvaretabellen: $count';
  }

  @override
  String addedToList(String item, String list) {
    return '«$item» lagt til i $list';
  }

  @override
  String nutritionEnergy(String value) {
    return 'Energi: $value kcal';
  }

  @override
  String nutritionFat(String value) {
    return 'Fett: $value g';
  }

  @override
  String nutritionSaturatedFat(String value) {
    return 'Hvorav mettet fett: $value g';
  }

  @override
  String nutritionCarbohydrates(String value) {
    return 'Karbohydrater: $value g';
  }

  @override
  String nutritionSugars(String value) {
    return 'Hvorav sukkerarter: $value g';
  }

  @override
  String nutritionProtein(String value) {
    return 'Protein: $value g';
  }

  @override
  String nutritionSalt(String value) {
    return 'Salt: $value g';
  }

  @override
  String get countryDataSources => 'Land / datakilder';

  @override
  String get chooseCountryTitle => 'Velg land (prioriterer kilder)';
}
