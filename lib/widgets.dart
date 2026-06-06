import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'gen_l10n/app_localizations.dart';
import 'ui_safe.dart';
import 'package:url_launcher/url_launcher.dart';
import 'ad_banner.dart';

// Enum for risikonivå
enum RiskLevel { green, yellow, red, unknown }

// --- WIDGET FOR PRODUKTINFO-DIALOG ---
class ProductInfoDialogContent extends StatefulWidget {
  final Map<String, dynamic> info;
  final Function(String) onAddItem;
  const ProductInfoDialogContent(
      {required this.info, required this.onAddItem, super.key});

  @override
  State<ProductInfoDialogContent> createState() =>
      _ProductInfoDialogContentState();
}

class _ProductInfoDialogContentState extends State<ProductInfoDialogContent> {
  final Set<int> _expanded = <int>{};
  final Map<int, bool> _reporting = {};

  void _toggleExpanded(int i) {
    setState(() {
      if (_expanded.contains(i)) {
        _expanded.remove(i);
      } else {
        _expanded.add(i);
      }
    });
  }

  void _startReporting(int i) {
    setState(() {
      _reporting[i] = true;
    });
  }

  void _stopReporting(int i) {
    setState(() {
      _reporting[i] = false;
    });
  }

  Future<void> _openUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (!mounted) return;
        safeSnack(context, 'Kunne ikke åpne lenken');
      }
    } catch (e) {
      if (!mounted) return;
      safeSnack(context, 'Kunne ikke åpne lenken: $e');
    }
  }

  String _farmShopsLabel(BuildContext context) {
    final code =
        (AppLocalizations.of(context)?.localeName ?? 'nb').toLowerCase();
    switch (code) {
      case 'en':
        return 'Find Farm Shops';
      case 'sv':
        return 'Hitta Gårdsbutiker';
      case 'da':
        return 'Find Gårdbutikker';
      case 'fi':
        return 'Löydä Tilamyymälät';
      case 'de':
        return 'Hofläden Finden';
      case 'nl':
        return 'Vind Boerderijwinkels';
      case 'fr':
        return 'Trouver Fermes-Boutiques';
      case 'it':
        return 'Trova Botteghe Agricole';
      case 'pt':
        return 'Encontrar Lojas de Quinta';
      case 'es':
        return 'Encontrar Tiendas de Granja';
      case 'ko':
        return '농장 직판장 찾기';
      case 'pl':
        return 'Znajdz sklepy gospodarskie';
      case 'ru':
        return 'Найти фермерские магазины';
      case 'zh':
        return '查找农场商店';
      case 'ar':
        return 'ابحث عن متاجر المزارع';
      case 'th':
        return 'ค้นหาร้านฟาร์ม';
      case 'nb':
      default:
        return 'Finn Gårdsbutikker';
    }
  }

  String _internalWarningLine1(BuildContext context) {
    return AppLocalizations.of(context)?.internalWarning1 ?? 'Notice: internal list for brand-link tracking';
  }

  String _internalWarningLine2(BuildContext context) {
    return AppLocalizations.of(context)?.internalWarning2 ?? 'Notice: brand tracking and public information';
  }

  String _farmShopsUrl(BuildContext context) {
    final code =
        (AppLocalizations.of(context)?.localeName ?? 'nb').toLowerCase();
    return 'https://matsjekk.com/gardsbutikker.html?lang=$code';
  }

  String _methodUrl(BuildContext context) {
    final code =
        (AppLocalizations.of(context)?.localeName ?? 'nb').toLowerCase();
    return 'https://matsjekk.com/editorial-method.html?lang=$code';
  }

  // Kort metodikk-forklaring: vi følger spredningskjeden etter føre-var.
  String _methodText(BuildContext context) {
    final code =
        (AppLocalizations.of(context)?.localeName ?? 'nb').toLowerCase();
    switch (code) {
      case 'en':
        return 'How we assess: much is hidden from the public, so we follow the whole chain — producer, exporter, importer, store chains, processing and country of origin — using the precautionary principle. This is not proof, but a basis for your own informed choice.';
      case 'sv':
        return 'Så bedömer vi: mycket är dolt för allmänheten, så vi följer hela kedjan — producent, exportör, importör, butikskedjor, förädling och ursprungsland — enligt försiktighetsprincipen. Detta är inget bevis, men ett underlag för ditt eget val.';
      case 'da':
        return 'Sådan vurderer vi: meget er skjult for offentligheden, så vi følger hele kæden — producent, eksportør, importør, butikskæder, forarbejdning og oprindelsesland — ud fra forsigtighedsprincippet. Det er ikke bevis, men et grundlag for dit eget valg.';
      case 'fi':
        return 'Näin arvioimme: paljon on piilossa yleisöltä, joten seuraamme koko ketjua — tuottaja, viejä, tuoja, kauppaketjut, jalostus ja alkuperämaa — varovaisuusperiaatteen mukaisesti. Tämä ei ole todiste, vaan peruste omalle valinnallesi.';
      case 'de':
        return 'So bewerten wir: vieles bleibt der Öffentlichkeit verborgen, daher verfolgen wir die gesamte Kette — Hersteller, Exporteur, Importeur, Handelsketten, Verarbeitung und Herkunftsland — nach dem Vorsorgeprinzip. Das ist kein Beweis, sondern eine Grundlage für deine eigene Entscheidung.';
      case 'nl':
        return 'Hoe wij beoordelen: veel blijft verborgen voor het publiek, dus volgen we de hele keten — producent, exporteur, importeur, winkelketens, verwerking en land van herkomst — volgens het voorzorgsbeginsel. Dit is geen bewijs, maar een basis voor je eigen keuze.';
      case 'fr':
        return 'Notre méthode : beaucoup est caché au public, nous suivons donc toute la chaîne — producteur, exportateur, importateur, chaînes de magasins, transformation et pays d\'origine — selon le principe de précaution. Ce n\'est pas une preuve, mais une base pour votre propre choix.';
      case 'it':
        return 'Come valutiamo: molto è nascosto al pubblico, quindi seguiamo l\'intera catena — produttore, esportatore, importatore, catene di negozi, trasformazione e paese d\'origine — secondo il principio di precauzione. Non è una prova, ma una base per la tua scelta.';
      case 'pt':
        return 'Como avaliamos: muito está oculto do público, por isso seguimos toda a cadeia — produtor, exportador, importador, cadeias de lojas, processamento e país de origem — pelo princípio da precaução. Não é prova, mas uma base para a sua escolha.';
      case 'es':
        return 'Cómo evaluamos: mucho está oculto al público, por eso seguimos toda la cadena — productor, exportador, importador, cadenas de tiendas, procesamiento y país de origen — según el principio de precaución. No es una prueba, sino una base para tu propia decisión.';
      case 'nb':
      default:
        return 'Slik vurderer vi: mye er skjult for offentligheten, så vi følger hele kjeden — produsent, eksportør, importør, butikkjeder, videreforedling og opprinnelsesland — etter føre-var-prinsippet. Dette er ikke et bevis, men et grunnlag for ditt eget informerte valg.';
    }
  }

  String _methodLinkLabel(BuildContext context) {
    final code =
        (AppLocalizations.of(context)?.localeName ?? 'nb').toLowerCase();
    switch (code) {
      case 'en':
        return 'Read our method';
      case 'sv':
        return 'Läs vår metod';
      case 'da':
        return 'Læs vores metode';
      case 'fi':
        return 'Lue menetelmämme';
      case 'de':
        return 'Unsere Methode lesen';
      case 'nl':
        return 'Lees onze methode';
      case 'fr':
        return 'Lire notre méthode';
      case 'it':
        return 'Leggi il nostro metodo';
      case 'pt':
        return 'Leia o nosso método';
      case 'es':
        return 'Lee nuestro método';
      case 'nb':
      default:
        return 'Les vår metode';
    }
  }

  // CTA-tittel når et produkt er rødt/gult: du har et valg.
  String _buyDirectTitle(BuildContext context) {
    final code =
        (AppLocalizations.of(context)?.localeName ?? 'nb').toLowerCase();
    switch (code) {
      case 'en':
        return 'You have a choice';
      case 'sv':
        return 'Du har ett val';
      case 'da':
        return 'Du har et valg';
      case 'fi':
        return 'Sinulla on valinta';
      case 'de':
        return 'Du hast die Wahl';
      case 'nl':
        return 'Jij hebt een keuze';
      case 'fr':
        return 'Vous avez le choix';
      case 'it':
        return 'Hai una scelta';
      case 'pt':
        return 'Você tem uma escolha';
      case 'es':
        return 'Tú decides';
      case 'nb':
      default:
        return 'Du har et valg';
    }
  }

  String _buyDirectBody(BuildContext context) {
    final code =
        (AppLocalizations.of(context)?.localeName ?? 'nb').toLowerCase();
    switch (code) {
      case 'en':
        return 'Want to be sure? Buy directly from the producer — find a farm shop near you.';
      case 'sv':
        return 'Vill du vara säker? Köp direkt från producenten — hitta en gårdsbutik nära dig.';
      case 'da':
        return 'Vil du være sikker? Køb direkte fra producenten — find en gårdbutik nær dig.';
      case 'fi':
        return 'Haluatko olla varma? Osta suoraan tuottajalta — löydä tilamyymälä läheltäsi.';
      case 'de':
        return 'Auf Nummer sicher gehen? Kaufe direkt beim Erzeuger — finde einen Hofladen in deiner Nähe.';
      case 'nl':
        return 'Zeker weten? Koop rechtstreeks bij de producent — vind een boerderijwinkel bij jou in de buurt.';
      case 'fr':
        return 'Vous voulez être sûr ? Achetez directement au producteur — trouvez une ferme-boutique près de chez vous.';
      case 'it':
        return 'Vuoi essere sicuro? Compra direttamente dal produttore — trova una bottega agricola vicino a te.';
      case 'pt':
        return 'Quer ter certeza? Compre diretamente do produtor — encontre uma loja de quinta perto de si.';
      case 'es':
        return '¿Quieres estar seguro? Compra directamente al productor — encuentra una tienda de granja cerca de ti.';
      case 'nb':
      default:
        return 'Vil du være sikker? Kjøp direkte fra produsenten — finn en gårdsbutikk i nærheten.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final info = widget.info;
    final bildeUrl = info['bildeUrl'] as String? ?? '';
    final nutriscore =
        (info['nutriscore'] as String?)?.toUpperCase() ?? (AppLocalizations.of(context)?.unknown ?? 'UNKNOWN');
    final eStoffer = info['eStoffer'] as List<dynamic>? ?? <dynamic>[];
    final allergener = (info['allergener'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        <String>[];
    final naerings =
        (info['næringsinnhold'] as Map?)?.cast<String, dynamic>() ??
            <String, dynamic>{};
    final alerts = (info['alerts'] as List<dynamic>?)
            ?.map((a) => a as Map<String, dynamic>)
            .toList() ??
        <Map<String, dynamic>>[];
    final bovaerRiskUrl = (info['bovaerRiskUrl'] as String? ?? '').trim();

    bool isRedOrYellow(dynamic value) =>
        value == RiskLevel.red || value == RiskLevel.yellow;
    final hasRedOrYellow = isRedOrYellow(info['bovaerRisk']) ||
        isRedOrYellow(info['gmoRisk']) ||
        isRedOrYellow(info['insectRisk']);

    return SizedBox(
        width: double.maxFinite,
        child: ListView(shrinkWrap: true, children: [
          Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              color: Colors.grey[100],
              child: Column(children: [
                if (bildeUrl.isNotEmpty)
                  ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(bildeUrl,
                          height: 150,
                          fit: BoxFit.contain,
                          errorBuilder: (c, e, s) =>
                              const Icon(Icons.image_not_supported))),
                const SizedBox(height: 12),
                Text(
                    info['navn'] ??
                        AppLocalizations.of(context)?.unknownProduct ??
                        'Unknown product',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center),
                Text(info['merke'] ?? '',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.grey[600]))
              ])),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRiskWidget(context, 'Bovaer',
                        info['bovaerRisk'] as RiskLevel? ?? RiskLevel.unknown,
                        customText: (info['bovaerRiskText'] ?? '').toString()),
                    if (bovaerRiskUrl.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: TextButton.icon(
                          onPressed: () => _openUrl(bovaerRiskUrl),
                          icon: const Icon(Icons.open_in_new, size: 18),
                          label: Text(AppLocalizations.of(context)?.seeUpdatedStatus ?? 'See updated status'),
                        ),
                      ),
                    _buildRiskWidget(context, AppLocalizations.of(context)?.gmoFeedLabel ?? 'GMO Feed',
                        info['gmoRisk'] as RiskLevel? ?? RiskLevel.unknown),
                    _buildRiskWidget(context, AppLocalizations.of(context)?.insectMealLabel ?? 'Insect Meal',
                        info['insectRisk'] as RiskLevel? ?? RiskLevel.unknown,
                        customText:
                            (info['insectRiskText'] ?? '').toString()),
                    // Metodikk-banner: forklarer føre-var/spredningskjede.
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(33, 150, 243, 0.08),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: const Color.fromRGBO(33, 150, 243, 0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.info_outline,
                                  size: 18, color: Colors.blueGrey),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _methodText(context),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton.icon(
                              onPressed: () => _openUrl(_methodUrl(context)),
                              icon: const Icon(Icons.open_in_new, size: 16),
                              label: Text(_methodLinkLabel(context)),
                              style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4),
                                  minimumSize: const Size(0, 32)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Kjøp direkte fra produsent — vises kun ved rød/gul risiko.
                    if (hasRedOrYellow) ...[
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(76, 175, 80, 0.10),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: const Color.fromRGBO(76, 175, 80, 0.4)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.eco,
                                    size: 20, color: Colors.green),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _buyDirectTitle(context),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _buyDirectBody(context),
                              style: const TextStyle(fontSize: 13),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () =>
                                    _openUrl(_farmShopsUrl(context)),
                                icon: const Icon(Icons.storefront),
                                label: Text(_farmShopsLabel(context)),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  AppLocalizations.of(context)?.nutriScore ??
                                      'Nutri-Score',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                    color: _getNutriScoreColor(nutriscore),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Text(nutriscore,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  AppLocalizations.of(context)?.traceability ??
                                      'Sporbarhet',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color:
                                        const Color.fromRGBO(33, 150, 243, 0.1),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.security,
                                            color: Colors.blue),
                                        const SizedBox(width: 8),
                                        Text(
                                            AppLocalizations.of(context)
                                                    ?.beta ??
                                                'Beta',
                                            style: const TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Viktig: Dette er en beta-funksjon. Verifiser alltid informasjon mot pakning/etikett.',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if ((info['matvareCandidates'] as List<dynamic>?) !=
                            null &&
                        (info['matvareCandidates'] as List).isNotEmpty)
                      Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(AppLocalizations.of(context)?.matvaretabellenMatches ?? 'Matvaretabellen matches',
                                  style:
                                      const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              ...(info['matvareCandidates'] as List)
                                  .take(3)
                                  .map((c) {
                                final cMap = c as Map<String, dynamic>;
                                final name = cMap['name'] ?? '';
                                final url = cMap['url'] as String? ?? '';
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  child: InkWell(
                                    onTap: url.isNotEmpty
                                        ? () => launchUrl(Uri.parse(url),
                                            mode:
                                                LaunchMode.externalApplication)
                                        : null,
                                    child: Row(children: [
                                      const Icon(Icons.restaurant_menu,
                                          size: 16, color: Colors.green),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(name.toString(),
                                            style: TextStyle(
                                                color: url.isNotEmpty
                                                    ? Colors.blue
                                                    : null,
                                                decoration: url.isNotEmpty
                                                    ? TextDecoration.underline
                                                    : null)),
                                      ),
                                    ]),
                                  ),
                                );
                              }),
                            ],
                          )),
                    if (alerts.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Alerts',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Wrap(
                                spacing: 8.0,
                                runSpacing: 6.0,
                                children: alerts.asMap().entries.map((entry) {
                                  final i = entry.key;
                                  final a = entry.value;
                                  final sev =
                                      (a['severity'] ?? 'unknown').toString();
                                  Color bg = Colors.grey;
                                  IconData icon = Icons.info;
                                  if (sev == 'red') {
                                    bg = Colors.red;
                                    icon = Icons.error;
                                  } else if (sev == 'yellow') {
                                    bg = Colors.amber;
                                    icon = Icons.warning;
                                  } else if (sev == 'green') {
                                    bg = Colors.green;
                                    icon = Icons.check_circle;
                                  }
                                  final reason =
                                      a['reason'] ?? a['ruleId'] ?? '';

                                  if (!_expanded.contains(i)) {
                                    return ActionChip(
                                      avatar: Icon(icon,
                                          color: Colors.white, size: 16),
                                      backgroundColor:
                                          bg.withAlpha((0.9 * 255).round()),
                                      label: Text(reason.toString(),
                                          style: const TextStyle(
                                              color: Colors.white)),
                                      onPressed: () => _toggleExpanded(i),
                                    );
                                  }

                                  // Expanded view with details and inline report flow
                                  return Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color:
                                            bg.withAlpha((0.08 * 255).round()),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(children: [
                                            Icon(icon, color: bg),
                                            const SizedBox(width: 8),
                                            Expanded(
                                                child: Text(reason.toString(),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold))),
                                            IconButton(
                                                icon: const Icon(Icons.close),
                                                onPressed: () =>
                                                    _toggleExpanded(i))
                                          ]),
                                          const SizedBox(height: 6),
                                          Text(
                                              'Severity: ${a['severity'] ?? ''}'),
                                          const SizedBox(height: 4),
                                          Text('Reason: ${a['reason'] ?? ''}'),
                                          const SizedBox(height: 4),
                                          Text(
                                              'Confidence: ${(a['confidence'] is double) ? (a['confidence'] as double).toStringAsFixed(2) : a['confidence'].toString()}'),
                                          const SizedBox(height: 8),
                                          if (a['evidence'] != null) ...[
                                            const Text('Evidence:',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            const SizedBox(height: 6),
                                            ...((a['evidence'] as List)
                                                .map((e) => Text(e.toString()))
                                                .toList())
                                          ],
                                          // Add source and internal list info for red/yellow alerts
                                          if (sev == 'red' ||
                                              sev == 'yellow') ...[
                                            const SizedBox(height: 8),
                                            const SizedBox(height: 4),
                                            Text(_internalWarningLine1(context),
                                              style: const TextStyle(
                                                fontStyle:
                                                  FontStyle.italic)),
                                            const SizedBox(height: 4),
                                            Text(_internalWarningLine2(context),
                                              style: const TextStyle(
                                                fontStyle:
                                                  FontStyle.italic)),
                                            const SizedBox(height: 8),
                                            ElevatedButton.icon(
                                              onPressed: () => _openUrl(
                                                  _farmShopsUrl(context)),
                                              icon:
                                                  const Icon(Icons.open_in_new),
                                              label: Text(
                                                  _farmShopsLabel(context)),
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.blue),
                                            ),
                                          ],
                                          const SizedBox(height: 8),
                                          if (_reporting[i] == true) ...[
                                            TextField(
                                                controller:
                                                    TextEditingController(),
                                                decoration: const InputDecoration(
                                                    hintText:
                                                        'Short note (e.g. false positive)'),
                                                maxLines: 3),
                                            const SizedBox(height: 8),
                                            Row(children: [
                                              TextButton(
                                                  onPressed: () =>
                                                      _stopReporting(i),
                                                  child: const Text('Cancel')),
                                              ElevatedButton(
                                                  onPressed: () {
                                                    try {
                                                      final box = Hive.box(
                                                          'alerts_feedback');
                                                      final entry = {
                                                        'timestamp': DateTime
                                                                .now()
                                                            .toIso8601String(),
                                                        'product': (widget
                                                                .info['navn'] ??
                                                            ''),
                                                        'gtin': (widget
                                                                .info['ean'] ??
                                                            widget
                                                                .info['gtin'] ??
                                                            ''),
                                                        'ruleId':
                                                            a['ruleId'] ?? '',
                                                        'severity':
                                                            a['severity'] ?? '',
                                                        'note': '',
                                                        'evidence':
                                                            a['evidence'] ?? [],
                                                      };
                                                      final old = box.get(
                                                              'feedback_list',
                                                              defaultValue: <Map>[])
                                                          as List;
                                                      final newList =
                                                          List<Map>.from(old)
                                                            ..insert(0, entry);
                                                      box.put('feedback_list',
                                                          newList);
                                                      _stopReporting(i);
                                                      safeSnack(context,
                                                          AppLocalizations.of(context)?.reportSaved ?? 'Thanks — report saved.');
                                                    } catch (e) {
                                                      safeSnack(context,
                                                          '${AppLocalizations.of(context)?.couldNotSaveReport ?? 'Could not save report'}: $e');
                                                    }
                                                  },
                                                  child: const Text('Send'))
                                            ]),
                                          ] else ...[
                                            TextButton(
                                                onPressed: () =>
                                                    _startReporting(i),
                                                child: const Text('Report'))
                                          ]
                                        ]),
                                  );
                                }).toList()),
                          ],
                        ),
                      ),
                    const SizedBox(height: 12),
                    const Divider(height: 40),
                    SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.add_shopping_cart),
                          label: Text(AppLocalizations.of(context)?.addToList ??
                              'Add to List'),
                          onPressed: () {
                            widget.onAddItem(widget.info['navn']);
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12)),
                        )),
                    const Divider(height: 40),
                    Text(
                        AppLocalizations.of(context)?.identifiedAdditions ??
                            'Identified E-numbers',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    if (eStoffer.isNotEmpty)
                      Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: eStoffer
                              .map((e) => Chip(
                                  label: Text(e.toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold))))
                              .toList())
                    else
                      Text(AppLocalizations.of(context)?.noAdditionsFound ??
                          'No E-numbers found in database.'),
                    const SizedBox(height: 12),
                    Text(AppLocalizations.of(context)?.allergensLabel ?? 'Allergens',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    if (allergener.isNotEmpty)
                      Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: allergener
                              .map((a) => Chip(
                                  label: Text(a,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold))))
                              .toList())
                    else
                      Text(AppLocalizations.of(context)?.noAllergensFound ?? 'No allergens found.'),
                    const SizedBox(height: 12),
                    Text(
                        '${AppLocalizations.of(context)?.nutritionPer100g ?? 'Nutrition (per 100g)'}${info['næringsinnholdKilde'] != null ? ' — ${AppLocalizations.of(context)?.nutritionSource ?? 'source'}: ${info['næringsinnholdKilde']}' : ''}',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    if (naerings.isNotEmpty)
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (naerings.containsKey('energy_kcal'))
                              Text('${AppLocalizations.of(context)?.energyLabel ?? 'Energy'}: ${naerings['energy_kcal']} kcal'),
                            if (naerings.containsKey('fat'))
                              Text('${AppLocalizations.of(context)?.fatLabel ?? 'Fat'}: ${naerings['fat']} g'),
                            if (naerings.containsKey('saturated_fat'))
                              Text(
                                  '${AppLocalizations.of(context)?.saturatedFatLabel ?? 'Of which saturated fat'}: ${naerings['saturated_fat']} g'),
                            if (naerings.containsKey('carbohydrates'))
                              Text(
                                  '${AppLocalizations.of(context)?.carbohydratesLabel ?? 'Carbohydrates'}: ${naerings['carbohydrates']} g'),
                            if (naerings.containsKey('sugars'))
                              Text(
                                  '${AppLocalizations.of(context)?.sugarsLabel ?? 'Of which sugars'}: ${naerings['sugars']} g'),
                            if (naerings.containsKey('protein'))
                              Text('${AppLocalizations.of(context)?.proteinLabel ?? 'Protein'}: ${naerings['protein']} g'),
                            if (naerings.containsKey('salt'))
                              Text('${AppLocalizations.of(context)?.saltLabel ?? 'Salt'}: ${naerings['salt']} g'),
                          ])
                    else
                      Text(AppLocalizations.of(context)?.noNutritionFound ?? 'No nutrition information found.'),
                    const Divider(height: 40),
                    Text(
                        AppLocalizations.of(context)?.disclaimer ??
                            "Disclaimer: This information is for guidance only...",
                        style: const TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey))
                  ])),
        ]));
  }

  Widget _buildRiskWidget(BuildContext context, String title, RiskLevel risk,
      {String customText = ''}) {
    if (risk == RiskLevel.unknown) return const SizedBox.shrink();
    final icon = risk == RiskLevel.red
        ? Icons.error
        : (risk == RiskLevel.yellow ? Icons.warning : Icons.check_circle);
    final color = risk == RiskLevel.red
        ? Colors.red
        : (risk == RiskLevel.yellow ? Colors.amber : Colors.green);
    final trimmedCustomText = customText.trim();
    final text = trimmedCustomText.isNotEmpty
        ? trimmedCustomText
        : risk == RiskLevel.green
            ? (AppLocalizations.of(context)?.safeProduct ?? 'SAFE')
            : risk == RiskLevel.yellow
                ? (title == 'Bovaer'
                    ? (AppLocalizations.of(context)?.bovaerPossibleRisk ??
                        'POSSIBLE RISK')
                    : (AppLocalizations.of(context)?.gmoHighRisk ??
                        'HIGH RISK'))
                : (title == 'Bovaer'
                    ? (AppLocalizations.of(context)?.bovaerHighRisk ??
                        'HIGH RISK')
                    : (AppLocalizations.of(context)?.gmoHighRisk ??
                        'HIGH RISK'));
    return Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
            color: color.withAlpha((0.1 * 255).round()),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color)),
        child: Row(children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Expanded(
              child: Text(text,
                  style: const TextStyle(fontWeight: FontWeight.bold)))
        ]));
  }

  Color _getNutriScoreColor(String score) {
    switch (score) {
      case 'A':
        return Colors.green;
      case 'B':
        return Colors.lightGreen;
      case 'C':
        return Colors.yellow;
      case 'D':
        return Colors.orange;
      case 'E':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class HandlelisteOverlay extends StatefulWidget {
  final String listeNavn;
  final bool isFullScreen;
  final VoidCallback onClose;
  final VoidCallback onToggleFullScreen;
  final Function(String, String) onRename;
  final VoidCallback onShowSearch;
  final bool showPremiumUpsell;
  final VoidCallback? onPremiumTap;

  const HandlelisteOverlay({
    required this.listeNavn,
    required this.isFullScreen,
    required this.onClose,
    required this.onToggleFullScreen,
    required this.onRename,
    required this.onShowSearch,
    this.showPremiumUpsell = false,
    this.onPremiumTap,
    super.key,
  });

  @override
  State<HandlelisteOverlay> createState() => _HandlelisteOverlayState();
}

class _HandlelisteOverlayState extends State<HandlelisteOverlay> {
  final TextEditingController _addItemController = TextEditingController();
  final FocusNode _addItemFocusNode = FocusNode();
  bool _showHistory = false;
  String _inlineSuggestion = '';
  List<String> _dropdownSuggestions = [];

  @override
  void initState() {
    super.initState();
    _addItemController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final text = _addItemController.text;
    if (text.isEmpty) {
      setState(() {
        _inlineSuggestion = '';
        _dropdownSuggestions = [];
      });
      return;
    }
    final suggestions = _getSuggestions(text);
    // Inline: best startsWith match
    final lowerText = text.toLowerCase();
    String inline = '';
    for (final s in suggestions) {
      if (s.toLowerCase().startsWith(lowerText)) {
        // Preserve user's typed casing + append the rest from suggestion
        inline = text + s.substring(text.length);
        break;
      }
    }
    setState(() {
      _inlineSuggestion = inline;
      _dropdownSuggestions = suggestions;
    });
  }

  void _addItem(String item) {
    final trimmed = item.trim();
    if (trimmed.isEmpty) return;
    final box = Hive.box('handlelister');
    final list = List<String>.from(box.get(widget.listeNavn, defaultValue: <String>[]));
    list.insert(0, trimmed);
    box.put(widget.listeNavn, list);
    // Track frequency
    final memBox = Hive.box('product_memory');
    final freqKey = 'freq_${widget.listeNavn}';
    final freq = Map<String, int>.from(memBox.get(freqKey, defaultValue: <String, int>{}));
    freq[trimmed] = (freq[trimmed] ?? 0) + 1;
    memBox.put(freqKey, freq);
    _addItemController.clear();
    setState(() {
      _inlineSuggestion = '';
      _dropdownSuggestions = [];
    });
  }

  void _submitField(String value) {
    // If inline suggestion is showing, accept it; otherwise use typed text
    final toAdd = _inlineSuggestion.isNotEmpty ? _inlineSuggestion : value;
    _addItem(toAdd);
    Future.microtask(() => _addItemFocusNode.requestFocus());
  }

  List<String> _getSuggestions(String query) {
    final memBox = Hive.box('product_memory');
    final freqKey = 'freq_${widget.listeNavn}';
    final freq = Map<String, int>.from(memBox.get(freqKey, defaultValue: <String, int>{}));
    if (freq.isEmpty) return [];
    final lowerQuery = query.toLowerCase();
    final matches = freq.entries
        .where((e) => e.key.toLowerCase().contains(lowerQuery))
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return matches.take(6).map((e) => e.key).toList();
  }

  @override
  void dispose() {
    _addItemController.removeListener(_onTextChanged);
    _addItemController.dispose();
    _addItemFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = widget.isFullScreen
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.height * 0.62;
    return Container(
      height: height,
      color: Colors.white,
      child: Column(
        children: [
          // Premium-oppgradering og reklamefelt håndteres i premium_screen.dart nå
          // ...existing code...
          AppBar(
            title: Row(
              children: [
                Flexible(
                  child: Text(
                    widget.listeNavn,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.edit, size: 16, color: Colors.white70),
              ],
            ),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: widget.onShowSearch,
              ),
              IconButton(
                icon: const Icon(Icons.history),
                onPressed: () => setState(() => _showHistory = !_showHistory),
              ),
              IconButton(
                icon: Icon(widget.isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen),
                onPressed: widget.onToggleFullScreen,
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: widget.onClose,
              ),
            ],
          ),
          if (widget.showPremiumUpsell)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.orange.withAlpha((0.08 * 255).round()),
                border: Border(bottom: BorderSide(color: Colors.orange.shade200)),
              ),
              child: Row(
                children: [
                  const Expanded(
                    flex: 2,
                    child: AdBanner(),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: widget.onPremiumTap,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.workspace_premium, color: Colors.white, size: 20),
                            const SizedBox(height: 2),
                            Text(
                              AppLocalizations.of(context)?.buyAdFreeTitle ?? 'Kjøp reklamefri versjon',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Stack(
                                  children: [
                                    // Ghost text layer (behind real text)
                                    if (_inlineSuggestion.isNotEmpty)
                                      IgnorePointer(
                                        child: TextField(
                                          controller: TextEditingController(text: _inlineSuggestion),
                                          enabled: false,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                          ),
                                          style: TextStyle(color: Colors.grey.shade400),
                                        ),
                                      ),
                                    // Real text field
                                    TextField(
                                      controller: _addItemController,
                                      focusNode: _addItemFocusNode,
                                      decoration: InputDecoration(
                                        hintText: _inlineSuggestion.isEmpty
                                            ? (AppLocalizations.of(context)?.manualAddItem ?? 'Legg til vare manuelt...')
                                            : null,
                                        border: const OutlineInputBorder(),
                                        filled: true,
                                        fillColor: _inlineSuggestion.isNotEmpty ? Colors.transparent : null,
                                      ),
                                      style: const TextStyle(color: Colors.black),
                                      onSubmitted: _submitField,
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle, color: Colors.green, size: 40),
                                onPressed: () {
                                  _addItem(_addItemController.text);
                                  _addItemFocusNode.requestFocus();
                                },
                              ),
                            ],
                          ),
                          // Dropdown suggestions
                          if (_dropdownSuggestions.isNotEmpty)
                            Material(
                              elevation: 4,
                              borderRadius: BorderRadius.circular(8),
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(maxHeight: 240),
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount: _dropdownSuggestions.length,
                                  itemBuilder: (context, index) {
                                    final option = _dropdownSuggestions[index];
                                    return ListTile(
                                      dense: true,
                                      title: Text(option),
                                      onTap: () {
                                        _addItem(option);
                                        _addItemFocusNode.requestFocus();
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ValueListenableBuilder(
                        valueListenable: Hive.box('handlelister').listenable(keys: [widget.listeNavn]),
                        builder: (_, box, __) {
                          final varer = List<String>.from(box.get(widget.listeNavn, defaultValue: <String>[]));
                          if (varer.isEmpty) {
                            return Center(child: Text(AppLocalizations.of(context)?.emptyList ?? 'List is empty'));
                          }
                          return ReorderableListView(
                            onReorder: (oldIndex, newIndex) {
                              if (newIndex > oldIndex) newIndex--;
                              final item = varer.removeAt(oldIndex);
                              varer.insert(newIndex, item);
                              box.put(widget.listeNavn, varer);
                            },
                            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewPadding.bottom + 120),
                            children: varer.asMap().entries.map((entry) {
                              final index = entry.key;
                              final vare = entry.value;
                              final checked = vare.startsWith('✓ ');
                              final displayText = checked ? vare.substring(2) : vare;
                              return ListTile(
                                key: ValueKey(vare + index.toString()),
                                leading: Icon(checked ? Icons.check_box : Icons.check_box_outline_blank, color: checked ? Colors.green : null),
                                title: Text(displayText, style: TextStyle(decoration: checked ? TextDecoration.lineThrough : null, color: checked ? Colors.grey : null)),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    varer.removeAt(index);
                                    box.put(widget.listeNavn, varer);
                                  },
                                ),
                                onTap: () {
                                  if (checked) {
                                    varer[index] = displayText;
                                  } else {
                                    varer[index] = '✓ $displayText';
                                  }
                                  box.put(widget.listeNavn, varer);
                                },
                              );
                            }).toList()
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              if (_showHistory)
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Colors.grey[100],
                    child: Column(
                      children: [
                        AppBar(
                          title: Text(AppLocalizations.of(context)?.history ?? 'History'),
                          backgroundColor: Colors.blueGrey[700],
                          foregroundColor: Colors.white,
                          automaticallyImplyLeading: false,
                          actions: [
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => setState(() => _showHistory = false),
                            ),
                          ],
                        ),
                        Expanded(
                          child: ValueListenableBuilder(
                            valueListenable: Hive.box('historikk').listenable(keys: ['historikk_${widget.listeNavn}']),
                            builder: (_, box, __) {
                              final dynamic oldHist = box.get('historikk_${widget.listeNavn}', defaultValue: []);
                              final hist = (oldHist is List && oldHist.isNotEmpty && oldHist.first is String)
                                  ? oldHist.map((e) => {'name': e, 'imageUrl': ''}).toList().cast<Map>()
                                  : List<Map>.from(oldHist);
                              if (hist.isEmpty) {
                                return Center(child: Text(AppLocalizations.of(context)?.noHistory ?? 'No history for this list'));
                              }
                              return ListView.builder(
                                itemCount: hist.length,
                                itemBuilder: (_, i) {
                                  final entry = hist[i];
                                  final name = entry['name'] as String? ?? 'Ukjent';
                                  final imageUrl = entry['imageUrl'] as String? ?? '';
                                  return ListTile(
                                    leading: imageUrl.isNotEmpty
                                        ? Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.image_not_supported))
                                        : const Icon(Icons.shopping_basket, size: 40),
                                    title: Text(name.split(' – ').last),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.add, color: Colors.green),
                                      onPressed: () {
                                        final vareNavn = name.split(' – ').last;
                                        final list = List<String>.from(Hive.box('handlelister').get(widget.listeNavn, defaultValue: <String>[]));
                                        if (!list.any((item) => item.endsWith(vareNavn))) {
                                          list.insert(0, vareNavn);
                                          Hive.box('handlelister').put(widget.listeNavn, list);
                                        }
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox.shrink(),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          ),
        ],
      ),
    );
  }
}

class GlobalHistorikkOverlay extends StatelessWidget {
  final bool isFullScreen;
  final VoidCallback onClose;
  final VoidCallback onToggleFullScreen;
  final Function(String, String) onAddItem;

  const GlobalHistorikkOverlay(
      {required this.isFullScreen,
      required this.onClose,
      required this.onToggleFullScreen,
      required this.onAddItem,
      super.key});

  @override
  Widget build(BuildContext context) {
    final height = isFullScreen
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.height * 0.6;
    final historikkBox = Hive.box('historikk');

    List<Map> allHistory = [];
    for (var key in historikkBox.keys) {
      final dynamic oldList = historikkBox.get(key, defaultValue: []);
      if (oldList is List && oldList.isNotEmpty) {
        if (oldList.first is String) {
          allHistory.addAll(oldList
              .map((e) => {'name': e, 'imageUrl': ''})
              .toList()
              .cast<Map>());
        } else {
          allHistory.addAll(List<Map>.from(oldList));
        }
      }
    }
    allHistory
        .sort((a, b) => (b['name'] as String).compareTo(a['name'] as String));

    return Container(
      height: height,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(isFullScreen ? 0 : 20)),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2)
          ]),
      child: Column(
        children: [
          AppBar(
            title: Text(AppLocalizations.of(context)?.globalHistory ??
                'Global History'),
            backgroundColor: Colors.blueGrey,
            foregroundColor: Colors.white,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.add_shopping_cart),
                onPressed: () {
                  // Logikk for å legge til en ny handleliste
                  final controller = TextEditingController();
                  safeShowDialog(
                      context,
                      AlertDialog(
                        title: Text(
                            AppLocalizations.of(context)?.newShoppingList ??
                                'New Shopping List'),
                        content: TextField(
                            controller: controller,
                            decoration: InputDecoration(
                                hintText:
                                    AppLocalizations.of(context)?.listName ??
                                        'List Name')),
                        actions: [
                          TextButton(
                              onPressed: () => safePop(context),
                              child: Text(
                                  AppLocalizations.of(context)?.cancel ??
                                      'Cancel')),
                          TextButton(
                            onPressed: () {
                              final navn = controller.text.trim();
                              if (navn.isNotEmpty &&
                                  !Hive.box('handlelister').containsKey(navn)) {
                                Hive.box('handlelister').put(navn, []);
                              }
                              safePop(context);
                            },
                            child: Text(AppLocalizations.of(context)?.create ??
                                'Create'),
                          ),
                        ],
                      ));
                },
              ),
              IconButton(
                  icon: Icon(
                      isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen),
                  onPressed: onToggleFullScreen),
              IconButton(icon: const Icon(Icons.close), onPressed: onClose),
            ],
          ),
          Expanded(
            child: allHistory.isEmpty
                ? Center(
                    child: Text(AppLocalizations.of(context)?.noHistoryFound ??
                        'No history found'))
                : ListView.builder(
                    itemCount: allHistory.length,
                    itemBuilder: (_, i) {
                      final entry = allHistory[i];
                      final name = entry['name'] as String? ?? 'Ukjent';
                      final imageUrl = entry['imageUrl'] as String? ?? '';
                      return ListTile(
                        leading: imageUrl.isNotEmpty
                            ? Image.network(imageUrl,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (c, e, s) =>
                                    const Icon(Icons.image_not_supported))
                            : const Icon(Icons.shopping_basket, size: 40),
                        title: Text(name),
                        trailing: IconButton(
                          icon: const Icon(Icons.add_shopping_cart,
                              color: Colors.green),
                          onPressed: () {
                            final vareNavn = name.split(' – ').last;
                            onAddItem(vareNavn, imageUrl);
                          },
                        ),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}
