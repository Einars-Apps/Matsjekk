import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'gen_l10n/app_localizations.dart';
import 'ui_safe.dart';

// Enum for risikonivå
enum RiskLevel { green, yellow, red, unknown }

// --- WIDGET FOR PRODUKTINFO-DIALOG ---
class ProductInfoDialogContent extends StatefulWidget {
  final Map<String, dynamic> info;
  final Function(String) onAddItem;
  const ProductInfoDialogContent(
      {required this.info, required this.onAddItem, super.key});

  @override
<<<<<<< HEAD
  State<ProductInfoDialogContent> createState() => _ProductInfoDialogContentState();
=======
  State<ProductInfoDialogContent> createState() =>
      _ProductInfoDialogContentState();
>>>>>>> 1fd8547f7f4a75b9aeb940f067391e11eaa43643
}

class _ProductInfoDialogContentState extends State<ProductInfoDialogContent> {
  final Set<int> _expanded = <int>{};
  final Map<int, bool> _reporting = {};

  void _toggleExpanded(int i) {
    setState(() {
<<<<<<< HEAD
      if (_expanded.contains(i)) _expanded.remove(i); else _expanded.add(i);
=======
      if (_expanded.contains(i)) {
        _expanded.remove(i);
      } else {
        _expanded.add(i);
      }
>>>>>>> 1fd8547f7f4a75b9aeb940f067391e11eaa43643
    });
  }

  void _startReporting(int i) {
<<<<<<< HEAD
    setState(() { _reporting[i] = true; });
  }

  void _stopReporting(int i) {
    setState(() { _reporting[i] = false; });
=======
    setState(() {
      _reporting[i] = true;
    });
  }

  void _stopReporting(int i) {
    setState(() {
      _reporting[i] = false;
    });
>>>>>>> 1fd8547f7f4a75b9aeb940f067391e11eaa43643
  }

  @override
  Widget build(BuildContext context) {
    final info = widget.info;
    final bildeUrl = info['bildeUrl'] as String? ?? '';
<<<<<<< HEAD
    final nutriscore = (info['nutriscore'] as String?)?.toUpperCase() ?? 'UKJENT';
    final eStoffer = info['eStoffer'] as List<dynamic>? ?? <dynamic>[];
    final allergener = (info['allergener'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? <String>[];
    final naerings = (info['næringsinnhold'] as Map?)?.cast<String,dynamic>() ?? <String,dynamic>{};
    final alerts = (info['alerts'] as List<dynamic>?)?.map((a) => a as Map<String,dynamic>).toList() ?? <Map<String,dynamic>>[];

    return SizedBox(width: double.maxFinite, child: ListView(shrinkWrap: true, children: [
      Container(padding: const EdgeInsets.fromLTRB(20,20,20,10), color: Colors.grey[100], child: Column(children: [ if (bildeUrl.isNotEmpty) ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(bildeUrl, height: 150, fit: BoxFit.contain, errorBuilder: (c,e,s) => const Icon(Icons.image_not_supported))), const SizedBox(height:12), Text(info['navn'] ?? AppLocalizations.of(context)?.productNotFound ?? 'Ukjent produkt', style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center), Text(info['merke'] ?? '', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600])) ])),
      Padding(padding: const EdgeInsets.all(16.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _buildRiskWidget(context, 'Bovaer', info['bovaerRisk'] as RiskLevel? ?? RiskLevel.unknown),
        _buildRiskWidget(context, 'GMO-fôr', info['gmoRisk'] as RiskLevel? ?? RiskLevel.unknown),
        const SizedBox(height:12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context)?.nutriScore ?? 'Nutri-Score', style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: _getNutriScoreColor(nutriscore), borderRadius: BorderRadius.circular(8)),
                  child: Text(nutriscore, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context)?.traceability ?? 'Sporbarhet', style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Color.fromRGBO(33,150,243,0.1), borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      const Icon(Icons.security, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(AppLocalizations.of(context)?.beta ?? 'Beta', style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height:12),
        if ((info['matvareCandidates'] as List<dynamic>?) != null) Padding(padding: const EdgeInsets.only(top:8.0), child: Text('Forslag fra Matvaretabellen: ${(info['matvareCandidates'] as List).length}', style: const TextStyle(fontWeight: FontWeight.bold))),
        if (alerts.isNotEmpty) Padding(
          padding: const EdgeInsets.only(top:8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Alerts', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Wrap(spacing: 8.0, runSpacing: 6.0, children: alerts.asMap().entries.map((entry) {
                final i = entry.key;
                final a = entry.value;
                final sev = (a['severity'] ?? 'unknown').toString();
                Color bg = Colors.grey;
                IconData icon = Icons.info;
                if (sev == 'red') { bg = Colors.red; icon = Icons.error; }
                else if (sev == 'yellow') { bg = Colors.amber; icon = Icons.warning; }
                else if (sev == 'green') { bg = Colors.green; icon = Icons.check_circle; }
                final reason = a['reason'] ?? a['ruleId'] ?? '';

                if (!_expanded.contains(i)) {
                  return ActionChip(
                    avatar: Icon(icon, color: Colors.white, size: 16),
                    backgroundColor: bg.withAlpha((0.9 * 255).round()),
                    label: Text(reason.toString(), style: const TextStyle(color: Colors.white)),
                    onPressed: () => _toggleExpanded(i),
                  );
                }

                // Expanded view with details and inline report flow
                return Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: bg.withAlpha((0.08 * 255).round()), borderRadius: BorderRadius.circular(8)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [Icon(icon, color: bg), const SizedBox(width:8), Expanded(child: Text(reason.toString(), style: const TextStyle(fontWeight: FontWeight.bold))), IconButton(icon: const Icon(Icons.close), onPressed: () => _toggleExpanded(i))]),
                    const SizedBox(height:6),
                    Text('Severity: ${a['severity'] ?? ''}'), const SizedBox(height:4),
                    Text('Reason: ${a['reason'] ?? ''}'), const SizedBox(height:4),
                    Text('Confidence: ${ (a['confidence'] is double) ? (a['confidence'] as double).toStringAsFixed(2) : a['confidence'].toString() }'),
                    const SizedBox(height:8),
                    if (a['evidence'] != null) ...[ Text('Evidence:', style: const TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height:6), ...( (a['evidence'] as List).map((e) => Text(e.toString())).toList() ) ],
                    const SizedBox(height:8),
                    if (_reporting[i] == true) ...[
                      TextField(controller: TextEditingController(), decoration: const InputDecoration(hintText: 'Short note (e.g. false positive)'), maxLines: 3),
                      const SizedBox(height:8),
                      Row(children: [TextButton(onPressed: () => _stopReporting(i), child: const Text('Cancel')), ElevatedButton(onPressed: () {
                        try {
                          final box = Hive.box('alerts_feedback');
                          final entry = {
                            'timestamp': DateTime.now().toIso8601String(),
                            'product': (widget.info['navn'] ?? ''),
                            'gtin': (widget.info['ean'] ?? widget.info['gtin'] ?? ''),
                            'ruleId': a['ruleId'] ?? '',
                            'severity': a['severity'] ?? '',
                            'note': '',
                            'evidence': a['evidence'] ?? [],
                          };
                          final old = box.get('feedback_list', defaultValue: <Map>[]) as List;
                          final newList = List<Map>.from(old)..insert(0, entry);
                          box.put('feedback_list', newList);
                          _stopReporting(i);
                          safeSnack(context, 'Takk — rapport lagret.');
                        } catch (e) {
                          safeSnack(context, 'Kunne ikke lagre rapport: $e');
                        }
                      }, child: const Text('Send'))]),
                    ] else ...[
                      TextButton(onPressed: () => _startReporting(i), child: const Text('Report'))
                    ]
                  ]),
                );
              }).toList()),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Divider(height: 40),
        SizedBox(width: double.infinity, child: ElevatedButton.icon(icon: const Icon(Icons.add_shopping_cart), label: Text(AppLocalizations.of(context)?.addToList ?? 'Add to List'), onPressed: () { widget.onAddItem(widget.info['navn']); Navigator.of(context).pop(); }, style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical:12)),)),
        const Divider(height: 40),
        Text(AppLocalizations.of(context)?.identifiedAdditions ?? 'Identified E-numbers', style: const TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height:8),
        if (eStoffer.isNotEmpty) Wrap(spacing:8.0, runSpacing:4.0, children: eStoffer.map((e) => Chip(label: Text(e.toString(), style: const TextStyle(fontWeight: FontWeight.bold)))).toList()) else Text(AppLocalizations.of(context)?.noAdditionsFound ?? 'No E-numbers found in database.'),
        const SizedBox(height:12), Text('Allergener', style: const TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height:8),
        if (allergener.isNotEmpty) Wrap(spacing:8.0, runSpacing:4.0, children: allergener.map((a) => Chip(label: Text(a, style: const TextStyle(fontWeight: FontWeight.bold)))).toList()) else Text('Ingen allergener funnet.'),
        const SizedBox(height:12), Text('Næringsinnhold (per 100g)', style: const TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height:8),
        if (naerings.isNotEmpty) Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ if (naerings.containsKey('energy_kcal')) Text('Energi: ${naerings['energy_kcal']} kcal'), if (naerings.containsKey('fat')) Text('Fett: ${naerings['fat']} g'), if (naerings.containsKey('saturated_fat')) Text('Hvorav mettet fett: ${naerings['saturated_fat']} g'), if (naerings.containsKey('carbohydrates')) Text('Karbohydrater: ${naerings['carbohydrates']} g'), if (naerings.containsKey('sugars')) Text('Hvorav sukkerarter: ${naerings['sugars']} g'), if (naerings.containsKey('protein')) Text('Protein: ${naerings['protein']} g'), if (naerings.containsKey('salt')) Text('Salt: ${naerings['salt']} g'), ]) else Text('Ingen næringsinformasjon funnet.'),
        const Divider(height:40), Text(AppLocalizations.of(context)?.disclaimer ?? "Disclaimer: This information is for guidance only...", style: const TextStyle(fontSize:12, fontStyle: FontStyle.italic, color: Colors.grey))
      ])),
    ]));
=======
    final nutriscore =
        (info['nutriscore'] as String?)?.toUpperCase() ?? 'UKJENT';
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
                        AppLocalizations.of(context)?.productNotFound ??
                        'Ukjent produkt',
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
                        info['bovaerRisk'] as RiskLevel? ?? RiskLevel.unknown),
                    _buildRiskWidget(context, 'GMO-fôr',
                        info['gmoRisk'] as RiskLevel? ?? RiskLevel.unknown),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
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
                        Column(
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
                              child: Row(
                                children: [
                                  const Icon(Icons.security,
                                      color: Colors.blue),
                                  const SizedBox(width: 8),
                                  Text(
                                      AppLocalizations.of(context)?.beta ??
                                          'Beta',
                                      style: const TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if ((info['matvareCandidates'] as List<dynamic>?) != null)
                      Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                              'Forslag fra Matvaretabellen: ${(info['matvareCandidates'] as List).length}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold))),
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
                                                          'Takk — rapport lagret.');
                                                    } catch (e) {
                                                      safeSnack(context,
                                                          'Kunne ikke lagre rapport: $e');
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
                    const Text('Allergener',
                        style: TextStyle(fontWeight: FontWeight.bold)),
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
                      const Text('Ingen allergener funnet.'),
                    const SizedBox(height: 12),
                    const Text('Næringsinnhold (per 100g)',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    if (naerings.isNotEmpty)
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (naerings.containsKey('energy_kcal'))
                              Text('Energi: ${naerings['energy_kcal']} kcal'),
                            if (naerings.containsKey('fat'))
                              Text('Fett: ${naerings['fat']} g'),
                            if (naerings.containsKey('saturated_fat'))
                              Text(
                                  'Hvorav mettet fett: ${naerings['saturated_fat']} g'),
                            if (naerings.containsKey('carbohydrates'))
                              Text(
                                  'Karbohydrater: ${naerings['carbohydrates']} g'),
                            if (naerings.containsKey('sugars'))
                              Text(
                                  'Hvorav sukkerarter: ${naerings['sugars']} g'),
                            if (naerings.containsKey('protein'))
                              Text('Protein: ${naerings['protein']} g'),
                            if (naerings.containsKey('salt'))
                              Text('Salt: ${naerings['salt']} g'),
                          ])
                    else
                      const Text('Ingen næringsinformasjon funnet.'),
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

  Widget _buildRiskWidget(BuildContext context, String title, RiskLevel risk) {
    if (risk == RiskLevel.unknown) return const SizedBox.shrink();
    final icon = risk == RiskLevel.red
        ? Icons.error
        : (risk == RiskLevel.yellow ? Icons.warning : Icons.check_circle);
    final color = risk == RiskLevel.red
        ? Colors.red
        : (risk == RiskLevel.yellow ? Colors.amber : Colors.green);
    final text = risk == RiskLevel.green
        ? (AppLocalizations.of(context)?.safeProduct ?? 'SAFE')
        : (title == 'Bovaer'
            ? (AppLocalizations.of(context)?.bovaerHighRisk ?? 'HIGH RISK')
            : (AppLocalizations.of(context)?.gmoHighRisk ?? 'HIGH RISK'));
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
>>>>>>> 1fd8547f7f4a75b9aeb940f067391e11eaa43643
  }

  Widget _buildRiskWidget(BuildContext context, String title, RiskLevel risk) {
    if (risk == RiskLevel.unknown) return const SizedBox.shrink();
    final icon = risk == RiskLevel.red ? Icons.error : (risk == RiskLevel.yellow ? Icons.warning : Icons.check_circle);
    final color = risk == RiskLevel.red ? Colors.red : (risk == RiskLevel.yellow ? Colors.amber : Colors.green);
    final text = risk == RiskLevel.green ? (AppLocalizations.of(context)?.safeProduct ?? 'SAFE') : (title == 'Bovaer' ? (AppLocalizations.of(context)?.bovaerHighRisk ?? 'HIGH RISK') : (AppLocalizations.of(context)?.gmoHighRisk ?? 'HIGH RISK'));
    return Container(padding: const EdgeInsets.all(12), margin: const EdgeInsets.only(bottom:8), decoration: BoxDecoration(color: color.withAlpha((0.1 * 255).round()), borderRadius: BorderRadius.circular(8), border: Border.all(color: color)), child: Row(children:[Icon(icon, color: color), const SizedBox(width:8), Expanded(child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)))]));
  }

  Color _getNutriScoreColor(String score) {
    switch (score) { case 'A': return Colors.green; case 'B': return Colors.lightGreen; case 'C': return Colors.yellow; case 'D': return Colors.orange; case 'E': return Colors.red; default: return Colors.grey; }
  }

}


class HandlelisteOverlay extends StatefulWidget {
  final String listeNavn;
  final bool isFullScreen;
  final VoidCallback onClose;
  final VoidCallback onToggleFullScreen;
  final Function(String, String) onRename;
  final VoidCallback onShowSearch;

  const HandlelisteOverlay({
    required this.listeNavn,
    required this.isFullScreen,
    required this.onClose,
    required this.onToggleFullScreen,
    required this.onRename,
    required this.onShowSearch,
    super.key,
  });

  @override
  State<HandlelisteOverlay> createState() => _HandlelisteOverlayState();
}

class _HandlelisteOverlayState extends State<HandlelisteOverlay> {
  final TextEditingController _addItemController = TextEditingController();
  bool _showHistory = false;

  @override
  Widget build(BuildContext context) {
    final height = widget.isFullScreen
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.height * 0.7;
    return Container(
      height: height,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(widget.isFullScreen ? 0 : 20)),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2)
          ]),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: 0.05,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(widget.isFullScreen ? 0 : 20)),
              child: Image.asset('assets/nissefamilie.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => const SizedBox.shrink()),
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: _showHistory ? 2 : 3,
                child: Column(
                  children: [
                    AppBar(
<<<<<<< HEAD
                            title: GestureDetector(
                            onTap: () { 
                              final controller = TextEditingController(text: widget.listeNavn);
                              safeShowDialog(context, AlertDialog(title: Text(AppLocalizations.of(context)?.changeListName ?? 'Endre listenavn'), content: TextField(controller: controller, autocorrect: false), actions: [ TextButton(onPressed: () => safePop(context), child: Text(AppLocalizations.of(context)?.cancel ?? 'Avbryt')), TextButton(onPressed: () { final nyttNavn = controller.text.trim(); if (nyttNavn.isNotEmpty && nyttNavn != widget.listeNavn && !Hive.box('handlelister').containsKey(nyttNavn)) { final varer = Hive.box('handlelister').get(widget.listeNavn, defaultValue: <String>[]); Hive.box('handlelister').delete(widget.listeNavn); Hive.box('handlelister').put(nyttNavn, varer); final hist = Hive.box('historikk').get('historikk_${widget.listeNavn}', defaultValue: <Map<String, String>>[]); Hive.box('historikk').delete('historikk_${widget.listeNavn}'); Hive.box('historikk').put('historikk_$nyttNavn', hist); widget.onRename(widget.listeNavn, nyttNavn); safePop(context); } }, child: Text(AppLocalizations.of(context)?.save ?? 'Lagre'))]));
                            },
                            child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(color: Color.fromRGBO(0,0,0,0.2), borderRadius: BorderRadius.circular(8)),
=======
                        title: GestureDetector(
                            onTap: () {
                              final controller =
                                  TextEditingController(text: widget.listeNavn);
                              safeShowDialog(
                                  context,
                                  AlertDialog(
                                      title: Text(AppLocalizations.of(context)
                                              ?.changeListName ??
                                          'Endre listenavn'),
                                      content: TextField(
                                          controller: controller,
                                          autocorrect: false),
                                      actions: [
                                        TextButton(
                                            onPressed: () => safePop(context),
                                            child: Text(
                                                AppLocalizations.of(context)
                                                        ?.cancel ??
                                                    'Avbryt')),
                                        TextButton(
                                            onPressed: () {
                                              final nyttNavn =
                                                  controller.text.trim();
                                              if (nyttNavn.isNotEmpty &&
                                                  nyttNavn !=
                                                      widget.listeNavn &&
                                                  !Hive.box('handlelister')
                                                      .containsKey(nyttNavn)) {
                                                final varer = Hive.box(
                                                        'handlelister')
                                                    .get(widget.listeNavn,
                                                        defaultValue: <String>[]);
                                                Hive.box('handlelister')
                                                    .delete(widget.listeNavn);
                                                Hive.box('handlelister')
                                                    .put(nyttNavn, varer);
                                                final hist =
                                                    Hive.box('historikk').get(
                                                        'historikk_${widget.listeNavn}',
                                                        defaultValue: <Map<
                                                            String, String>>[]);
                                                Hive.box('historikk').delete(
                                                    'historikk_${widget.listeNavn}');
                                                Hive.box('historikk').put(
                                                    'historikk_$nyttNavn',
                                                    hist);
                                                widget.onRename(
                                                    widget.listeNavn, nyttNavn);
                                                safePop(context);
                                              }
                                            },
                                            child: Text(
                                                AppLocalizations.of(context)
                                                        ?.save ??
                                                    'Lagre'))
                                      ]));
                            },
                            child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                    color: const Color.fromRGBO(0, 0, 0, 0.2),
                                    borderRadius: BorderRadius.circular(8)),
>>>>>>> 1fd8547f7f4a75b9aeb940f067391e11eaa43643
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                        child: Text(widget.listeNavn,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18),
                                            overflow: TextOverflow.ellipsis)),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.edit,
                                        size: 16, color: Colors.white70),
                                  ],
                                ))),
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        automaticallyImplyLeading: false,
                        actions: [
                          IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: widget.onShowSearch),
                          IconButton(
                              icon: const Icon(Icons.history),
                              onPressed: () =>
                                  setState(() => _showHistory = !_showHistory)),
                          IconButton(
                              icon: Icon(widget.isFullScreen
                                  ? Icons.fullscreen_exit
                                  : Icons.fullscreen),
                              onPressed: widget.onToggleFullScreen),
                          IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: widget.onClose)
                        ]),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                              child: TextField(
                                  controller: _addItemController,
                                  decoration: InputDecoration(
                                      hintText: AppLocalizations.of(context)
                                              ?.manualAddItem ??
                                          'Add item manually...',
                                      border: const OutlineInputBorder()))),
                          IconButton(
                              icon: const Icon(Icons.add_circle,
                                  color: Colors.green, size: 40),
                              onPressed: () {
                                final item = _addItemController.text.trim();
                                if (item.isNotEmpty) {
                                  final box = Hive.box('handlelister');
                                  final list = List<String>.from(box.get(
                                      widget.listeNavn,
                                      defaultValue: <String>[]));
                                  list.insert(0, item);
                                  box.put(widget.listeNavn, list);
                                  _addItemController.clear();
                                }
                              }),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ValueListenableBuilder(
                        valueListenable: Hive.box('handlelister')
                            .listenable(keys: [widget.listeNavn]),
                        builder: (_, box, __) {
                          final varer = List<String>.from(box
                              .get(widget.listeNavn, defaultValue: <String>[]));
                          if (varer.isEmpty) {
                            return Center(
                                child: Text(
                                    AppLocalizations.of(context)?.emptyList ??
                                        'List is empty'));
                          }
                          return ReorderableListView(
                            onReorder: (oldIndex, newIndex) {
                              if (newIndex > oldIndex) newIndex--;
                              final item = varer.removeAt(oldIndex);
                              varer.insert(newIndex, item);
                              box.put(widget.listeNavn, varer);
                            },
                            children: varer.asMap().entries.map((entry) {
                              final index = entry.key;
                              final vare = entry.value;
                              final checked = vare.startsWith('✓ ');
                              final displayText =
                                  checked ? vare.substring(2) : vare;
                              return ListTile(
                                key: ValueKey(vare + index.toString()),
                                leading: Icon(
                                    checked
                                        ? Icons.check_box
                                        : Icons.check_box_outline_blank,
                                    color: checked ? Colors.green : null),
                                title: Text(displayText,
                                    style: TextStyle(
                                        decoration: checked
                                            ? TextDecoration.lineThrough
                                            : null,
                                        color: checked ? Colors.grey : null)),
                                trailing: IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () {
                                      varer.removeAt(index);
                                      box.put(widget.listeNavn, varer);
                                    }),
                                onTap: () {
                                  if (checked) {
                                    varer[index] = displayText;
                                  } else {
                                    varer[index] = '✓ $displayText';
                                  }
                                  box.put(widget.listeNavn, varer);
                                },
                              );
                            }).toList(),
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
                            title: Text(AppLocalizations.of(context)?.history ??
                                'History'),
                            backgroundColor: Colors.blueGrey[700],
                            foregroundColor: Colors.white,
                            automaticallyImplyLeading: false,
                            actions: [
                              IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () =>
                                      setState(() => _showHistory = false))
                            ]),
                        Expanded(
                          child: ValueListenableBuilder(
                            valueListenable: Hive.box('historikk').listenable(
                                keys: ['historikk_${widget.listeNavn}']),
                            builder: (_, box, __) {
                              final dynamic oldHist = box.get(
                                  'historikk_${widget.listeNavn}',
                                  defaultValue: []);
                              final hist = (oldHist is List &&
                                      oldHist.isNotEmpty &&
                                      oldHist.first is String)
                                  ? oldHist
                                      .map((e) => {'name': e, 'imageUrl': ''})
                                      .toList()
                                      .cast<Map>()
                                  : List<Map>.from(oldHist);

                              if (hist.isEmpty) {
                                return Center(
                                    child: Text(AppLocalizations.of(context)
                                            ?.noHistory ??
                                        'No history for this list'));
                              }
                              return ListView.builder(
                                itemCount: hist.length,
                                itemBuilder: (_, i) {
                                  final entry = hist[i];
                                  final name =
                                      entry['name'] as String? ?? 'Ukjent';
                                  final imageUrl =
                                      entry['imageUrl'] as String? ?? '';
                                  return ListTile(
                                    leading: imageUrl.isNotEmpty
                                        ? Image.network(imageUrl,
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                            errorBuilder: (c, e, s) =>
                                                const Icon(
                                                    Icons.image_not_supported))
                                        : const Icon(Icons.shopping_basket,
                                            size: 40),
                                    title: Text(name.split(' – ').last),
                                    trailing: IconButton(
                                        icon: const Icon(Icons.add,
                                            color: Colors.green),
                                        onPressed: () {
                                          final vareNavn =
                                              name.split(' – ').last;
                                          final list = List<String>.from(
                                              Hive.box('handlelister').get(
                                                  widget.listeNavn,
                                                  defaultValue: <String>[]));
                                          if (!list.any((item) =>
                                              item.endsWith(vareNavn))) {
                                            list.insert(0, vareNavn);
                                            Hive.box('handlelister')
                                                .put(widget.listeNavn, list);
                                          }
                                        }),
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
<<<<<<< HEAD
       height: height,
       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(isFullScreen ? 0 : 20)), boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2)]),
       child: Column(
         children: [
            AppBar(
              title: Text(AppLocalizations.of(context)?.globalHistory ?? 'Global History'),
              backgroundColor: Colors.blueGrey,
              foregroundColor: Colors.white,
              automaticallyImplyLeading: false,
              actions: [
                IconButton(icon: const Icon(Icons.add_shopping_cart), onPressed: () {
                    // Logikk for å legge til en ny handleliste
                    final controller = TextEditingController();
                    safeShowDialog(context, AlertDialog(
                      title: Text(AppLocalizations.of(context)?.newShoppingList ?? 'New Shopping List'),
                      content: TextField(controller: controller, decoration: InputDecoration(hintText: AppLocalizations.of(context)?.listName ?? 'List Name')),
                      actions: [
                        TextButton(onPressed: () => safePop(context), child: Text(AppLocalizations.of(context)?.cancel ?? 'Cancel')),
                        TextButton(
                          onPressed: () {
                            final navn = controller.text.trim();
                            if (navn.isNotEmpty && !Hive.box('handlelister').containsKey(navn)) {
                              Hive.box('handlelister').put(navn, []);
                            }
                            safePop(context);
                          },
                          child: Text(AppLocalizations.of(context)?.create ?? 'Create'),
                        ),
                      ],
                    ));
                  },
                ),
                IconButton(icon: Icon(isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen), onPressed: onToggleFullScreen),
                IconButton(icon: const Icon(Icons.close), onPressed: onClose),
              ],
            ),
            Expanded(
              child: allHistory.isEmpty
                ? Center(child: Text(AppLocalizations.of(context)?.noHistoryFound ?? 'No history found'))
=======
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
>>>>>>> 1fd8547f7f4a75b9aeb940f067391e11eaa43643
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
