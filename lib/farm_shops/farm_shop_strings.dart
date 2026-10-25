import 'package:flutter/widgets.dart';

/// Localised strings for the in-app farm shop map, in every language the app
/// supports (nb, en, sv, da, fi, de, nl, fr, it, pt, es).
///
/// Kept in a self-contained file (like the other farm-shop labels in
/// main.dart/widgets.dart) so this feature does not have to regenerate
/// lib/gen_l10n.
class FarmShopStrings {
  FarmShopStrings(this.languageCode);

  factory FarmShopStrings.of(BuildContext context) {
    final code = Localizations.maybeLocaleOf(context)?.languageCode ?? 'nb';
    return FarmShopStrings(code);
  }

  final String languageCode;

  static const supportedLanguages = [
    'nb', 'en', 'sv', 'da', 'fi', 'de', 'nl', 'fr', 'it', 'pt', 'es' //
  ];

  String _t(String key) {
    final lang = _values.containsKey(languageCode)
        ? languageCode
        : (languageCode == 'no' || languageCode == 'nn' ? 'nb' : 'en');
    return _values[lang]![key] ?? _values['en']![key] ?? key;
  }

  String get title => _t('title');
  String get menuTitle => _t('menuTitle');
  String get searchHint => _t('searchHint');
  String get organicOnly => _t('organicOnly');
  String get organic => _t('organic');
  String get useMyLocation => _t('useMyLocation');
  String get sortFromMapCentre => _t('sortFromMapCentre');
  String get country => _t('country');
  String get loading => _t('loading');
  String get loadError => _t('loadError');
  String get offlineData => _t('offlineData');
  String get retry => _t('retry');
  String get noResults => _t('noResults');
  String get directions => _t('directions');
  String get website => _t('website');
  String get call => _t('call');
  String get source => _t('source');
  String get sells => _t('sells');
  String get noAddress => _t('noAddress');
  String get close => _t('close');
  String get dataNote => _t('dataNote');
  String get couldNotOpen => _t('couldNotOpen');
  String get openWebVersion => _t('openWebVersion');
  String get locationTitle => _t('locationTitle');
  String get locationBody => _t('locationBody');
  String get allow => _t('allow');
  String get notNow => _t('notNow');
  String get locationDenied => _t('locationDenied');
  String get locationDeniedForever => _t('locationDeniedForever');
  String get locationServiceOff => _t('locationServiceOff');
  String get openSettings => _t('openSettings');
  String get sortedFromYou => _t('sortedFromYou');
  String get sortedFromCentre => _t('sortedFromCentre');

  String shopCount(int n) => _t('shopCount').replaceAll('{n}', '$n');
  String distance(double km) {
    final value = km < 10 ? km.toStringAsFixed(1) : km.round().toString();
    final localized =
        languageCode == 'en' ? value : value.replaceAll('.', ',');
    return _t('distance').replaceAll('{km}', localized);
  }

  static const Map<String, Map<String, String>> _values = {
    'nb': {
      'title': 'Gårdsbutikker',
      'menuTitle': 'Gårdsbutikker og lokalmat',
      'searchHint': 'Søk på navn, sted eller vare',
      'organicOnly': 'Kun økologisk',
      'organic': 'Økologisk',
      'useMyLocation': 'Bruk min posisjon',
      'sortFromMapCentre': 'Sorter fra kartets midtpunkt',
      'country': 'Land',
      'loading': 'Laster gårdsbutikker …',
      'loadError':
          'Kunne ikke laste gårdsbutikker. Sjekk nettforbindelsen og prøv igjen.',
      'offlineData': 'Viser lagrede data (uten nett).',
      'retry': 'Prøv igjen',
      'noResults': 'Ingen gårdsbutikker funnet.',
      'shopCount': '{n} gårdsbutikker',
      'distance': '{km} km',
      'directions': 'Veibeskrivelse',
      'website': 'Nettside',
      'call': 'Ring',
      'source': 'Kilde',
      'sells': 'Selger',
      'noAddress': 'Adresse ikke oppgitt',
      'close': 'Lukk',
      'dataNote':
          'Data fra åpne kilder. Sjekk åpningstider hos butikken før du drar.',
      'couldNotOpen': 'Kunne ikke åpne lenken',
      'openWebVersion': 'Åpne på matsjekk.com',
      'locationTitle': 'Vis gårdsbutikker nær deg?',
      'locationBody':
          'Matsjekk kan bruke posisjonen din til å sortere gårdsbutikker etter avstand. Posisjonen brukes bare på telefonen og lagres ikke.',
      'allow': 'Tillat',
      'notNow': 'Ikke nå',
      'locationDenied':
          'Uten posisjon viser vi kartet fra midten av valgt land. Du kan søke på sted.',
      'locationDeniedForever':
          'Posisjon er slått av for Matsjekk. Du kan slå den på i innstillingene.',
      'locationServiceOff': 'Posisjonstjenester er slått av på telefonen.',
      'openSettings': 'Innstillinger',
      'sortedFromYou': 'Sortert etter avstand fra deg',
      'sortedFromCentre': 'Sortert etter avstand fra kartets midtpunkt',
    },
    'en': {
      'title': 'Farm shops',
      'menuTitle': 'Farm shops & local food',
      'searchHint': 'Search name, place or product',
      'organicOnly': 'Organic only',
      'organic': 'Organic',
      'useMyLocation': 'Use my location',
      'sortFromMapCentre': 'Sort from map centre',
      'country': 'Country',
      'loading': 'Loading farm shops …',
      'loadError':
          'Could not load farm shops. Check your connection and try again.',
      'offlineData': 'Showing saved data (offline).',
      'retry': 'Try again',
      'noResults': 'No farm shops found.',
      'shopCount': '{n} farm shops',
      'distance': '{km} km',
      'directions': 'Directions',
      'website': 'Website',
      'call': 'Call',
      'source': 'Source',
      'sells': 'Sells',
      'noAddress': 'No address given',
      'close': 'Close',
      'dataNote':
          'Data from open sources. Check opening hours with the shop before you go.',
      'couldNotOpen': 'Could not open the link',
      'openWebVersion': 'Open on matsjekk.com',
      'locationTitle': 'Show farm shops near you?',
      'locationBody':
          'Matsjekk can use your location to sort farm shops by distance. Your location is only used on your phone and is not stored.',
      'allow': 'Allow',
      'notNow': 'Not now',
      'locationDenied':
          'Without your location the map starts at the centre of the selected country. You can search for a place.',
      'locationDeniedForever':
          'Location is turned off for Matsjekk. You can turn it on in Settings.',
      'locationServiceOff': 'Location services are turned off on your phone.',
      'openSettings': 'Settings',
      'sortedFromYou': 'Sorted by distance from you',
      'sortedFromCentre': 'Sorted by distance from the map centre',
    },
    'sv': {
      'title': 'Gårdsbutiker',
      'menuTitle': 'Gårdsbutiker och lokal mat',
      'searchHint': 'Sök på namn, ort eller vara',
      'organicOnly': 'Endast ekologiskt',
      'organic': 'Ekologisk',
      'useMyLocation': 'Använd min position',
      'sortFromMapCentre': 'Sortera från kartans mitt',
      'country': 'Land',
      'loading': 'Laddar gårdsbutiker …',
      'loadError':
          'Kunde inte ladda gårdsbutiker. Kontrollera anslutningen och försök igen.',
      'offlineData': 'Visar sparade data (offline).',
      'retry': 'Försök igen',
      'noResults': 'Inga gårdsbutiker hittades.',
      'shopCount': '{n} gårdsbutiker',
      'distance': '{km} km',
      'directions': 'Vägbeskrivning',
      'website': 'Webbplats',
      'call': 'Ring',
      'source': 'Källa',
      'sells': 'Säljer',
      'noAddress': 'Ingen adress angiven',
      'close': 'Stäng',
      'dataNote':
          'Data från öppna källor. Kontrollera öppettider med butiken innan du åker.',
      'couldNotOpen': 'Kunde inte öppna länken',
      'openWebVersion': 'Öppna på matsjekk.com',
      'locationTitle': 'Visa gårdsbutiker nära dig?',
      'locationBody':
          'Matsjekk kan använda din position för att sortera gårdsbutiker efter avstånd. Positionen används bara i telefonen och sparas inte.',
      'allow': 'Tillåt',
      'notNow': 'Inte nu',
      'locationDenied':
          'Utan position visar vi kartan från mitten av valt land. Du kan söka på ort.',
      'locationDeniedForever':
          'Plats är avstängd för Matsjekk. Du kan slå på den i Inställningar.',
      'locationServiceOff': 'Platstjänster är avstängda i telefonen.',
      'openSettings': 'Inställningar',
      'sortedFromYou': 'Sorterat efter avstånd från dig',
      'sortedFromCentre': 'Sorterat efter avstånd från kartans mitt',
    },
    'da': {
      'title': 'Gårdbutikker',
      'menuTitle': 'Gårdbutikker og lokal mad',
      'searchHint': 'Søg på navn, sted eller vare',
      'organicOnly': 'Kun økologisk',
      'organic': 'Økologisk',
      'useMyLocation': 'Brug min position',
      'sortFromMapCentre': 'Sortér fra kortets midte',
      'country': 'Land',
      'loading': 'Henter gårdbutikker …',
      'loadError':
          'Kunne ikke hente gårdbutikker. Tjek forbindelsen, og prøv igen.',
      'offlineData': 'Viser gemte data (offline).',
      'retry': 'Prøv igen',
      'noResults': 'Ingen gårdbutikker fundet.',
      'shopCount': '{n} gårdbutikker',
      'distance': '{km} km',
      'directions': 'Rutevejledning',
      'website': 'Hjemmeside',
      'call': 'Ring',
      'source': 'Kilde',
      'sells': 'Sælger',
      'noAddress': 'Ingen adresse angivet',
      'close': 'Luk',
      'dataNote':
          'Data fra åbne kilder. Tjek åbningstider hos butikken, før du kører.',
      'couldNotOpen': 'Kunne ikke åbne linket',
      'openWebVersion': 'Åbn på matsjekk.com',
      'locationTitle': 'Vis gårdbutikker nær dig?',
      'locationBody':
          'Matsjekk kan bruge din position til at sortere gårdbutikker efter afstand. Positionen bruges kun på telefonen og gemmes ikke.',
      'allow': 'Tillad',
      'notNow': 'Ikke nu',
      'locationDenied':
          'Uden position viser vi kortet fra midten af det valgte land. Du kan søge på sted.',
      'locationDeniedForever':
          'Placering er slået fra for Matsjekk. Du kan slå den til i Indstillinger.',
      'locationServiceOff': 'Placeringstjenester er slået fra på telefonen.',
      'openSettings': 'Indstillinger',
      'sortedFromYou': 'Sorteret efter afstand fra dig',
      'sortedFromCentre': 'Sorteret efter afstand fra kortets midte',
    },
    'fi': {
      'title': 'Tilamyymälät',
      'menuTitle': 'Tilamyymälät ja lähiruoka',
      'searchHint': 'Hae nimellä, paikalla tai tuotteella',
      'organicOnly': 'Vain luomu',
      'organic': 'Luomu',
      'useMyLocation': 'Käytä sijaintiani',
      'sortFromMapCentre': 'Lajittele kartan keskeltä',
      'country': 'Maa',
      'loading': 'Ladataan tilamyymälöitä …',
      'loadError':
          'Tilamyymälöitä ei voitu ladata. Tarkista yhteys ja yritä uudelleen.',
      'offlineData': 'Näytetään tallennetut tiedot (offline).',
      'retry': 'Yritä uudelleen',
      'noResults': 'Tilamyymälöitä ei löytynyt.',
      'shopCount': '{n} tilamyymälää',
      'distance': '{km} km',
      'directions': 'Reittiohjeet',
      'website': 'Verkkosivu',
      'call': 'Soita',
      'source': 'Lähde',
      'sells': 'Myy',
      'noAddress': 'Osoitetta ei ole annettu',
      'close': 'Sulje',
      'dataNote':
          'Tiedot avoimista lähteistä. Tarkista aukioloajat myymälästä ennen lähtöä.',
      'couldNotOpen': 'Linkkiä ei voitu avata',
      'openWebVersion': 'Avaa matsjekk.com-sivulla',
      'locationTitle': 'Näytetäänkö lähelläsi olevat tilamyymälät?',
      'locationBody':
          'Matsjekk voi käyttää sijaintiasi tilamyymälöiden lajitteluun etäisyyden mukaan. Sijaintia käytetään vain puhelimessa eikä sitä tallenneta.',
      'allow': 'Salli',
      'notNow': 'Ei nyt',
      'locationDenied':
          'Ilman sijaintia kartta alkaa valitun maan keskeltä. Voit hakea paikan nimellä.',
      'locationDeniedForever':
          'Sijainti on poistettu käytöstä Matsjekkille. Voit ottaa sen käyttöön asetuksista.',
      'locationServiceOff': 'Sijaintipalvelut ovat pois päältä puhelimessa.',
      'openSettings': 'Asetukset',
      'sortedFromYou': 'Lajiteltu etäisyyden mukaan sinusta',
      'sortedFromCentre': 'Lajiteltu etäisyyden mukaan kartan keskeltä',
    },
    'de': {
      'title': 'Hofläden',
      'menuTitle': 'Hofläden & regionale Lebensmittel',
      'searchHint': 'Name, Ort oder Produkt suchen',
      'organicOnly': 'Nur Bio',
      'organic': 'Bio',
      'useMyLocation': 'Meinen Standort verwenden',
      'sortFromMapCentre': 'Ab Kartenmitte sortieren',
      'country': 'Land',
      'loading': 'Hofläden werden geladen …',
      'loadError':
          'Hofläden konnten nicht geladen werden. Prüfe deine Verbindung und versuche es erneut.',
      'offlineData': 'Gespeicherte Daten werden angezeigt (offline).',
      'retry': 'Erneut versuchen',
      'noResults': 'Keine Hofläden gefunden.',
      'shopCount': '{n} Hofläden',
      'distance': '{km} km',
      'directions': 'Route',
      'website': 'Website',
      'call': 'Anrufen',
      'source': 'Quelle',
      'sells': 'Verkauft',
      'noAddress': 'Keine Adresse angegeben',
      'close': 'Schließen',
      'dataNote':
          'Daten aus offenen Quellen. Prüfe die Öffnungszeiten beim Hofladen, bevor du losfährst.',
      'couldNotOpen': 'Link konnte nicht geöffnet werden',
      'openWebVersion': 'Auf matsjekk.com öffnen',
      'locationTitle': 'Hofläden in deiner Nähe anzeigen?',
      'locationBody':
          'Matsjekk kann deinen Standort nutzen, um Hofläden nach Entfernung zu sortieren. Der Standort wird nur auf deinem Handy verwendet und nicht gespeichert.',
      'allow': 'Erlauben',
      'notNow': 'Nicht jetzt',
      'locationDenied':
          'Ohne Standort startet die Karte in der Mitte des gewählten Landes. Du kannst nach einem Ort suchen.',
      'locationDeniedForever':
          'Der Standortzugriff ist für Matsjekk deaktiviert. Du kannst ihn in den Einstellungen aktivieren.',
      'locationServiceOff': 'Die Ortungsdienste sind auf deinem Handy aus.',
      'openSettings': 'Einstellungen',
      'sortedFromYou': 'Nach Entfernung von dir sortiert',
      'sortedFromCentre': 'Nach Entfernung von der Kartenmitte sortiert',
    },
    'nl': {
      'title': 'Boerderijwinkels',
      'menuTitle': 'Boerderijwinkels & lokaal voedsel',
      'searchHint': 'Zoek op naam, plaats of product',
      'organicOnly': 'Alleen biologisch',
      'organic': 'Biologisch',
      'useMyLocation': 'Mijn locatie gebruiken',
      'sortFromMapCentre': 'Sorteer vanaf midden van de kaart',
      'country': 'Land',
      'loading': 'Boerderijwinkels laden …',
      'loadError':
          'Kon boerderijwinkels niet laden. Controleer je verbinding en probeer het opnieuw.',
      'offlineData': 'Opgeslagen gegevens worden getoond (offline).',
      'retry': 'Opnieuw proberen',
      'noResults': 'Geen boerderijwinkels gevonden.',
      'shopCount': '{n} boerderijwinkels',
      'distance': '{km} km',
      'directions': 'Route',
      'website': 'Website',
      'call': 'Bellen',
      'source': 'Bron',
      'sells': 'Verkoopt',
      'noAddress': 'Geen adres opgegeven',
      'close': 'Sluiten',
      'dataNote':
          'Gegevens uit open bronnen. Controleer de openingstijden bij de winkel voordat je gaat.',
      'couldNotOpen': 'Kon de link niet openen',
      'openWebVersion': 'Openen op matsjekk.com',
      'locationTitle': 'Boerderijwinkels bij jou in de buurt tonen?',
      'locationBody':
          'Matsjekk kan je locatie gebruiken om boerderijwinkels op afstand te sorteren. Je locatie wordt alleen op je telefoon gebruikt en niet opgeslagen.',
      'allow': 'Toestaan',
      'notNow': 'Niet nu',
      'locationDenied':
          'Zonder locatie begint de kaart in het midden van het gekozen land. Je kunt op plaats zoeken.',
      'locationDeniedForever':
          'Locatie staat uit voor Matsjekk. Je kunt dit aanzetten in Instellingen.',
      'locationServiceOff': 'Locatievoorzieningen staan uit op je telefoon.',
      'openSettings': 'Instellingen',
      'sortedFromYou': 'Gesorteerd op afstand van jou',
      'sortedFromCentre': 'Gesorteerd op afstand van het midden van de kaart',
    },
    'fr': {
      'title': 'Fermes-boutiques',
      'menuTitle': 'Fermes-boutiques & produits locaux',
      'searchHint': 'Rechercher un nom, un lieu ou un produit',
      'organicOnly': 'Bio uniquement',
      'organic': 'Bio',
      'useMyLocation': 'Utiliser ma position',
      'sortFromMapCentre': 'Trier depuis le centre de la carte',
      'country': 'Pays',
      'loading': 'Chargement des fermes-boutiques …',
      'loadError':
          'Impossible de charger les fermes-boutiques. Vérifiez votre connexion et réessayez.',
      'offlineData': 'Données enregistrées affichées (hors ligne).',
      'retry': 'Réessayer',
      'noResults': 'Aucune ferme-boutique trouvée.',
      'shopCount': '{n} fermes-boutiques',
      'distance': '{km} km',
      'directions': 'Itinéraire',
      'website': 'Site web',
      'call': 'Appeler',
      'source': 'Source',
      'sells': 'Vend',
      'noAddress': 'Adresse non indiquée',
      'close': 'Fermer',
      'dataNote':
          'Données issues de sources ouvertes. Vérifiez les horaires auprès de la boutique avant de partir.',
      'couldNotOpen': 'Impossible d’ouvrir le lien',
      'openWebVersion': 'Ouvrir sur matsjekk.com',
      'locationTitle': 'Afficher les fermes-boutiques près de vous ?',
      'locationBody':
          'Matsjekk peut utiliser votre position pour trier les fermes-boutiques par distance. Votre position est utilisée uniquement sur votre téléphone et n’est pas enregistrée.',
      'allow': 'Autoriser',
      'notNow': 'Pas maintenant',
      'locationDenied':
          'Sans votre position, la carte démarre au centre du pays choisi. Vous pouvez rechercher un lieu.',
      'locationDeniedForever':
          'La localisation est désactivée pour Matsjekk. Vous pouvez l’activer dans les Réglages.',
      'locationServiceOff':
          'Les services de localisation sont désactivés sur votre téléphone.',
      'openSettings': 'Réglages',
      'sortedFromYou': 'Triées par distance depuis vous',
      'sortedFromCentre': 'Triées par distance depuis le centre de la carte',
    },
    'it': {
      'title': 'Botteghe agricole',
      'menuTitle': 'Botteghe agricole e cibo locale',
      'searchHint': 'Cerca nome, luogo o prodotto',
      'organicOnly': 'Solo biologico',
      'organic': 'Biologico',
      'useMyLocation': 'Usa la mia posizione',
      'sortFromMapCentre': 'Ordina dal centro della mappa',
      'country': 'Paese',
      'loading': 'Caricamento botteghe agricole …',
      'loadError':
          'Impossibile caricare le botteghe agricole. Controlla la connessione e riprova.',
      'offlineData': 'Dati salvati (offline).',
      'retry': 'Riprova',
      'noResults': 'Nessuna bottega agricola trovata.',
      'shopCount': '{n} botteghe agricole',
      'distance': '{km} km',
      'directions': 'Indicazioni',
      'website': 'Sito web',
      'call': 'Chiama',
      'source': 'Fonte',
      'sells': 'Vende',
      'noAddress': 'Indirizzo non indicato',
      'close': 'Chiudi',
      'dataNote':
          'Dati da fonti aperte. Verifica gli orari con la bottega prima di andare.',
      'couldNotOpen': 'Impossibile aprire il link',
      'openWebVersion': 'Apri su matsjekk.com',
      'locationTitle': 'Mostrare le botteghe agricole vicino a te?',
      'locationBody':
          'Matsjekk può usare la tua posizione per ordinare le botteghe agricole per distanza. La posizione viene usata solo sul telefono e non viene salvata.',
      'allow': 'Consenti',
      'notNow': 'Non ora',
      'locationDenied':
          'Senza posizione la mappa parte dal centro del paese scelto. Puoi cercare un luogo.',
      'locationDeniedForever':
          'La posizione è disattivata per Matsjekk. Puoi attivarla nelle Impostazioni.',
      'locationServiceOff': 'I servizi di localizzazione sono disattivati sul telefono.',
      'openSettings': 'Impostazioni',
      'sortedFromYou': 'Ordinate per distanza da te',
      'sortedFromCentre': 'Ordinate per distanza dal centro della mappa',
    },
    'pt': {
      'title': 'Lojas de quinta',
      'menuTitle': 'Lojas de quinta e comida local',
      'searchHint': 'Pesquisar nome, local ou produto',
      'organicOnly': 'Só biológico',
      'organic': 'Biológico',
      'useMyLocation': 'Usar a minha localização',
      'sortFromMapCentre': 'Ordenar a partir do centro do mapa',
      'country': 'País',
      'loading': 'A carregar lojas de quinta …',
      'loadError':
          'Não foi possível carregar as lojas de quinta. Verifique a ligação e tente novamente.',
      'offlineData': 'A mostrar dados guardados (offline).',
      'retry': 'Tentar novamente',
      'noResults': 'Nenhuma loja de quinta encontrada.',
      'shopCount': '{n} lojas de quinta',
      'distance': '{km} km',
      'directions': 'Direções',
      'website': 'Site',
      'call': 'Ligar',
      'source': 'Fonte',
      'sells': 'Vende',
      'noAddress': 'Morada não indicada',
      'close': 'Fechar',
      'dataNote':
          'Dados de fontes abertas. Confirme o horário com a loja antes de ir.',
      'couldNotOpen': 'Não foi possível abrir a ligação',
      'openWebVersion': 'Abrir em matsjekk.com',
      'locationTitle': 'Mostrar lojas de quinta perto de si?',
      'locationBody':
          'A Matsjekk pode usar a sua localização para ordenar as lojas de quinta por distância. A localização só é usada no telemóvel e não é guardada.',
      'allow': 'Permitir',
      'notNow': 'Agora não',
      'locationDenied':
          'Sem localização, o mapa começa no centro do país escolhido. Pode pesquisar um local.',
      'locationDeniedForever':
          'A localização está desativada para a Matsjekk. Pode ativá-la nas Definições.',
      'locationServiceOff':
          'Os serviços de localização estão desativados no telemóvel.',
      'openSettings': 'Definições',
      'sortedFromYou': 'Ordenadas por distância de si',
      'sortedFromCentre': 'Ordenadas por distância do centro do mapa',
    },
    'es': {
      'title': 'Tiendas de granja',
      'menuTitle': 'Tiendas de granja y comida local',
      'searchHint': 'Buscar nombre, lugar o producto',
      'organicOnly': 'Solo ecológico',
      'organic': 'Ecológico',
      'useMyLocation': 'Usar mi ubicación',
      'sortFromMapCentre': 'Ordenar desde el centro del mapa',
      'country': 'País',
      'loading': 'Cargando tiendas de granja …',
      'loadError':
          'No se pudieron cargar las tiendas de granja. Comprueba la conexión e inténtalo de nuevo.',
      'offlineData': 'Mostrando datos guardados (sin conexión).',
      'retry': 'Reintentar',
      'noResults': 'No se encontraron tiendas de granja.',
      'shopCount': '{n} tiendas de granja',
      'distance': '{km} km',
      'directions': 'Cómo llegar',
      'website': 'Sitio web',
      'call': 'Llamar',
      'source': 'Fuente',
      'sells': 'Vende',
      'noAddress': 'Dirección no indicada',
      'close': 'Cerrar',
      'dataNote':
          'Datos de fuentes abiertas. Consulta el horario con la tienda antes de ir.',
      'couldNotOpen': 'No se pudo abrir el enlace',
      'openWebVersion': 'Abrir en matsjekk.com',
      'locationTitle': '¿Mostrar tiendas de granja cerca de ti?',
      'locationBody':
          'Matsjekk puede usar tu ubicación para ordenar las tiendas de granja por distancia. La ubicación solo se usa en tu teléfono y no se guarda.',
      'allow': 'Permitir',
      'notNow': 'Ahora no',
      'locationDenied':
          'Sin tu ubicación, el mapa empieza en el centro del país elegido. Puedes buscar un lugar.',
      'locationDeniedForever':
          'La ubicación está desactivada para Matsjekk. Puedes activarla en Ajustes.',
      'locationServiceOff':
          'Los servicios de ubicación están desactivados en tu teléfono.',
      'openSettings': 'Ajustes',
      'sortedFromYou': 'Ordenadas por distancia desde ti',
      'sortedFromCentre': 'Ordenadas por distancia desde el centro del mapa',
    },
  };

  /// Exposed for tests: every language must define every key.
  static Map<String, Map<String, String>> get allValues => _values;
}
