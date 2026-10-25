// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get appTitle => 'Ruoka-tarkistus';

  @override
  String get scanBarcode => 'Skannaa viivakoodi';

  @override
  String get productNotFound => 'Tuotetta ei löytynyt tietokannasta.';

  @override
  String get addToList => 'Lisää ostoslistalle';

  @override
  String get shoppingLists => 'Ostoslistat';

  @override
  String get history => 'Historia';

  @override
  String get settings => 'Asetukset';

  @override
  String get about => 'Tietoja sovelluksesta';

  @override
  String get howAppWorks => 'Kuinka sovellus toimii';

  @override
  String get appDescription => 'Sovellus käyttää Open Food Facts -tietokantaa ja sisäistä merkkilistaa havaitakseen tuotteita, joissa voi olla Bovaer, hyönteislantaa, GMO-rehua ja muita kiistanalaisia aineosia.';

  @override
  String get alerts => 'Valitse hälytykset';

  @override
  String get bovaerAlert => 'Bovaer-hälytys';

  @override
  String get insectMealAlert => 'Hyönteislanta-hälytys';

  @override
  String get ngtAlert => 'Piilotetun GMO:n (NGT) varoitus';

  @override
  String get gmoFishAlert => 'GMO-kalarehu -hälytys';

  @override
  String get highRisk => 'KORKEA RISKI';

  @override
  String get possibleRisk => 'MAHDOLLINEN RISKI';

  @override
  String get safe => 'TURVALLINEN';

  @override
  String get unknown => 'TUNNISTAMATON';

  @override
  String get bovaerRiskDesc => 'Tuottajalla on suora yhteys Bovaeriin.';

  @override
  String get insectMealRiskDesc => 'Tuote saattaa sisältää hyönteisproteiinia.';

  @override
  String get gmoFishRiskDesc => 'Tuottaja liittyy GMO-rehun käyttöön.';

  @override
  String get safeDesc => 'Tuote on luomusertifioitu.';

  @override
  String get nutriScore => 'Nutri-Score';

  @override
  String get traceability => 'Jäljitettävyys';

  @override
  String get beta => 'Beta';

  @override
  String get close => 'Sulje';

  @override
  String get create => 'Luo';

  @override
  String get search => 'Hae';

  @override
  String get searchProducts => 'Hae tuotteita';

  @override
  String get noResults => 'Ei tuloksia';

  @override
  String get newList => 'Uusi lista';

  @override
  String get deleteList => 'Poista pitkällä painalluksella';

  @override
  String get language => 'Kieli';

  @override
  String get selectLanguage => 'Valitse kieli';

  @override
  String get norwegian => 'Norja';

  @override
  String get swedish => 'Ruotsi';

  @override
  String get danish => 'Tanska';

  @override
  String get dutch => 'Hollanti';

  @override
  String get french => 'Ranska';

  @override
  String get english => 'Englanti';

  @override
  String get german => 'Saksa';

  @override
  String get italian => 'Italia';

  @override
  String get spanish => 'Espanja';

  @override
  String get portuguese => 'Portugali';

  @override
  String get finnish => 'Suomi';

  @override
  String get changeListName => 'Vaihda listan nimeä';

  @override
  String get cancel => 'Peruuta';

  @override
  String get save => 'Tallenna';

  @override
  String get manualAddItem => 'Lisää tuote manuaalisesti...';

  @override
  String get emptyList => 'Lista on tyhjä';

  @override
  String get noHistory => 'Ei historiaa tälle listalle';

  @override
  String get globalHistory => 'Koko historia';

  @override
  String get newShoppingList => 'Uusi ostoslista';

  @override
  String get listName => 'Listan nimi';

  @override
  String get noHistoryFound => 'Ei historiaa';

  @override
  String get addedItems => 'E-aineet';

  @override
  String get identifiedAdditions => 'Tunnistetut E-aineet';

  @override
  String get noAdditionsFound => 'Ei E-aineita tietokannassa.';

  @override
  String get disclaimer => 'Vastuuvapaus: Tämä tieto on ohjeellinen ja perustuu julkisesti saatavilla olevaan dataan. Tarkista tuotteen pakkauksesta tai ota yhteyttä valmistajaan saadaksesi 100% tarkan tiedon.';

  @override
  String get bovaerHighRisk => 'KORKEA RISKI: Valmistajalla on suora yhteys Bovaeriin.';

  @override
  String get gmoHighRisk => 'KORKEA RISKI: Valmistaja liittyy GMO-rehun käyttöön.';

  @override
  String get bovaerPossibleRisk => 'MAHDOLLINEN RISKI: Valmistaja on kumppani yritysten kanssa, jotka liittyvät Bovaeriin.';

  @override
  String get safeProduct => 'TURVALLINEN: Tuote on luomusertifioitu.';

  @override
  String get searchHint => 'Hae... (esim. maito)';

  @override
  String get delete => 'Poista';

  @override
  String get deleteListConfirmTitle => 'Poistetaanko lista?';

  @override
  String get deleteListConfirmMessage => 'Haluatko varmasti poistaa? Tämä poistaa myös listan historian.';

  @override
  String get unknownProduct => 'Tuntematon tuote';

  @override
  String get removeAds => 'Poista mainokset';

  @override
  String get removeAdsInfo => 'Poista mainokset saadaksesi lisää tilaa ostoslistaan';

  @override
  String get removeAdsMenuItem => 'Poista mainokset (49 kr) — tukee jatkokehitystä';

  @override
  String get gmoRegExplicit => 'EU-SÄÄNTELYN TILA: Tuote näyttää kuuluvan GMO/NGT-säänneltyyn luokkaan.';

  @override
  String get gmoRegFeedChain => 'EU-SÄÄNTELYN TILA: Voi kuulua GMO/NGT-sääntelyn piiriin rehuketjun kautta.';

  @override
  String get gmoRegNgt => 'EU-SÄÄNTELYN TILA: Tuote voi kuulua uuden geenimuokkausta (NGT) koskevan EU-päätöksen piiriin.';

  @override
  String get gmoRegSupplyChain => 'EU-SÄÄNTELYN TILA: Mahdollinen välillinen GMO/NGT-merkitys maahantuojan/toimittajan/tuottajan ketjun kautta.';

  @override
  String get gmoRegCropOrigin => 'EU-SÄÄNTELYN TILA: GMO-altis raaka-aine, jonka alkuperä on Amerikka/EU:n ulkopuoli – voi edellyttää EU:n GMO-merkintää.';

  @override
  String get gmoRegCropUnknown => 'EU-SÄÄNTELYN TILA: GMO-altis raaka-aine tuonti-/toimittajaportaassa – alkuperä kannattaa tarkistaa.';

  @override
  String get insectRegExplicit => 'EU-SÄÄNTELYN TILA: Tuote näyttää kuuluvan hyönteisiä/uuselintarvikkeita koskevan sääntelyn piiriin.';

  @override
  String get insectRegNovelFood => 'EU-SÄÄNTELYN TILA: Tuote voi kuulua EU:n hyönteisiä uuselintarvikkeina koskevien sääntöjen piiriin.';

  @override
  String get insectRegSupplyChain => 'EU-SÄÄNTELYN TILA: Mahdollinen välillinen merkitys maahantuojan/toimittajan/tuottajan ketjun kautta.';

  @override
  String get gmoConsExplicit => 'KULUTTAJARISKI: Tuoteteksti/etiketti viittaa GMO-sisältöön.';

  @override
  String get gmoConsFeed => 'KULUTTAJARISKI: Merkki/luokka vastaa tunnettua altistumista GMO-rehulle.';

  @override
  String get gmoConsNgt => 'KULUTTAJARISKI: Voi vaikuttaa kuluttajamarkkinoihin, mutta tarkista etiketti ja tuottajan tiedot.';

  @override
  String get gmoConsSupplyChain => 'KULUTTAJARISKI: Mahdollinen riski toimitusketjun kautta (kuka myy kenelle). Tarkista etiketti ja alkuperä.';

  @override
  String get gmoConsCropOrigin => 'KULUTTAJARISKI: Sisältää GMO-altista raaka-ainetta (soija/maissi/rapsi/sokerijuurikas/puuvilla), joka on tuotu maasta, jossa viljelykasvi on pääosin muuntogeeninen. Tarkista etiketistä ”GMO-vapaa”-merkintä.';

  @override
  String get gmoConsCropUnknown => 'KULUTTAJARISKI: Tuote sisältää GMO-altista raaka-ainetta (soija/maissi/rapsi/sokerijuurikas/puuvilla). Alkuperä on tuntematon – tarkista etiketti ja alkuperämaa.';

  @override
  String get insectConsExplicit => 'KULUTTAJARISKI: Tuoteteksti/ainesosat viittaavat hyönteisjauhoon tai hyönteisproteiiniin.';

  @override
  String get insectConsNovelFood => 'KULUTTAJARISKI: Mahdollinen hyönteisiin liittyvä altistus, tarkista ainesosaluettelo.';

  @override
  String get insectConsSupplyChain => 'KULUTTAJARISKI: Mahdollinen riski toimitusketjun kautta (kuka myy kenelle).';

  @override
  String get noKnownRisk => 'Ei tunnettua riskiä tässä luokassa.';

  @override
  String get searchBetaNote => 'Beta: Hakutoimintoa parannetaan jatkuvasti. Tarkista aina tuotetiedot ennen valintojen tekemistä.';

  @override
  String get couldNotOpenLink => 'Linkkiä ei voitu avata';

  @override
  String get eNumberNoDescription => 'Meillä ei ole vielä kuvausta tästä lisäaineesta. E-koodi on EU:ssa/ETA:ssa käytetty lisäainekoodi.';

  @override
  String get allergensTitle => 'Allergeenit';

  @override
  String get noAllergensFound => 'Allergeeneja ei löytynyt.';

  @override
  String get nutritionTitle => 'Ravintosisältö (100 g kohti)';

  @override
  String get noNutritionFound => 'Ravintotietoja ei löytynyt.';

  @override
  String get alertsTitle => 'Varoitukset';

  @override
  String get alertEvidence => 'Näyttö:';

  @override
  String get alertInternalListNote => 'Varoitus: sisäinen luettelo tuotemerkkien yhteyksistä';

  @override
  String get alertBrandTrackingNote => 'Varoitus: tuotemerkkien seuranta ja julkinen tieto';

  @override
  String get reportNoteHint => 'Lyhyt huomautus (esim. väärä hälytys)';

  @override
  String get report => 'Ilmoita';

  @override
  String get send => 'Lähetä';

  @override
  String get reportSaved => 'Kiitos — ilmoitus tallennettu.';

  @override
  String get seeUpdatedStatus => 'Katso päivitetty tila';

  @override
  String get openEuSource => 'Avaa EU-lähde';

  @override
  String get openInsectSource => 'Avaa hyönteislähde';

  @override
  String get privacyTitle => 'Tietosuoja';

  @override
  String get consentOptional => 'Tämä on vapaaehtoista. Jos et anna suostumusta, käyttötietojasi ei lähetetä analysoitavaksi.';

  @override
  String get consentWorksAnyway => 'Sovellus toimii joka tapauksessa, ja tiedot voivat pysyä vain laitteellasi.';

  @override
  String get readPrivacyPolicy => 'Lue tietosuojakäytäntö';

  @override
  String get allowAnonymousAnalytics => 'Salli anonyymi analytiikka';

  @override
  String get analyticsEnabled => 'Kiitos – analytiikka käytössä.';

  @override
  String get analyticsDisabled => 'Analytiikka poistettu käytöstä.';

  @override
  String couldNotOpenLinkError(String error) {
    return 'Linkkiä ei voitu avata: $error';
  }

  @override
  String reportSaveFailed(String error) {
    return 'Ilmoitusta ei voitu tallentaa: $error';
  }

  @override
  String alertSeverity(String value) {
    return 'Vakavuus: $value';
  }

  @override
  String alertReason(String value) {
    return 'Syy: $value';
  }

  @override
  String alertConfidence(String value) {
    return 'Varmuus: $value';
  }

  @override
  String matvaretabellenSuggestions(String count) {
    return 'Ehdotuksia Matvaretabellenista: $count';
  }

  @override
  String addedToList(String item, String list) {
    return '”$item” lisätty listaan $list';
  }

  @override
  String nutritionEnergy(String value) {
    return 'Energia: $value kcal';
  }

  @override
  String nutritionFat(String value) {
    return 'Rasva: $value g';
  }

  @override
  String nutritionSaturatedFat(String value) {
    return 'josta tyydyttynyttä rasvaa: $value g';
  }

  @override
  String nutritionCarbohydrates(String value) {
    return 'Hiilihydraatit: $value g';
  }

  @override
  String nutritionSugars(String value) {
    return 'josta sokereita: $value g';
  }

  @override
  String nutritionProtein(String value) {
    return 'Proteiini: $value g';
  }

  @override
  String nutritionSalt(String value) {
    return 'Suola: $value g';
  }

  @override
  String get countryDataSources => 'Maa / tietolähteet';

  @override
  String get chooseCountryTitle => 'Valitse maa (priorisoi lähteet)';
}
