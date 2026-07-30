import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'gen_l10n/app_localizations.dart';

// Enum for risikonivå
enum RiskLevel { green, yellow, red, unknown }

// --- WIDGET FOR PRODUKTINFO-DIALOG ---
class ProductInfoDialogContent extends StatelessWidget {
  final Map<String, dynamic> info;
  final Function(String) onAddItem;
  const ProductInfoDialogContent({required this.info, required this.onAddItem, super.key});

  Widget _buildRiskWidget(BuildContext context, String title, RiskLevel risk) {
     IconData iconData;
    Color color;
    String text;

    switch (risk) {
      case RiskLevel.red:
        iconData = Icons.error; color = Colors.red;
        text = title == 'Bovaer' 
          ? (AppLocalizations.of(context)?.bovaerHighRisk ?? "HIGH RISK: Producer directly linked to Bovaer.")
          : (AppLocalizations.of(context)?.gmoHighRisk ?? "HIGH RISK: Producer linked to GMO fish feed.");
        break;
      case RiskLevel.yellow:
        iconData = Icons.warning; color = Colors.amber; 
        text = AppLocalizations.of(context)?.bovaerPossibleRisk ?? "POSSIBLE RISK: Producer is a partner with companies linked to Bovaer.";
        break;
      case RiskLevel.green:
        iconData = Icons.check_circle; color = Colors.green; 
        text = AppLocalizations.of(context)?.safeProduct ?? "SAFE: Product is certified organic.";
        break;
      case RiskLevel.unknown:
      default:
        return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(12.0),
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: color, width: 1)),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [ Icon(iconData, color: color, size: 28), const SizedBox(width: 10), Expanded(child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)))]),
    );
  }

  Color _getNutriScoreColor(String score) {
    switch (score) {
      case 'A': return Colors.green;
      case 'B': return Colors.lightGreen;
      case 'C': return Colors.yellow;
      case 'D': return Colors.orange;
      case 'E': return Colors.red;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bovaerRisk = info['bovaerRisk'] as RiskLevel? ?? RiskLevel.unknown;
    final gmoRisk = info['gmoRisk'] as RiskLevel? ?? RiskLevel.unknown;
    final bildeUrl = info['bildeUrl'] as String? ?? '';
    final nutriscore = info['nutriscore'] as String? ?? 'UKJENT';
    final eStoffer = info['eStoffer'] as List<dynamic>? ?? [];

    return SizedBox(
      width: double.maxFinite,
      child: ListView(
        shrinkWrap: true,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            color: Colors.grey[100],
            child: Column(
              children: [
                if (bildeUrl.isNotEmpty) ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(bildeUrl, height: 150, fit: BoxFit.contain, loadingBuilder: (context, child, progress) => progress == null ? child : const Center(child: CircularProgressIndicator()), errorBuilder: (context, error, stack) => const Icon(Icons.image_not_supported, size: 50, color: Colors.grey))),
                const SizedBox(height: 12),
                Text(info['navn'] ?? AppLocalizations.of(context)?.productNotFound ?? 'Ukjent produkt', style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
                Text(info['merke'] ?? '', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]), textAlign: TextAlign.center),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRiskWidget(context, 'Bovaer', bovaerRisk),
                _buildRiskWidget(context, 'GMO-fôr', gmoRisk),
                const SizedBox(height: 20),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [ Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ Text(AppLocalizations.of(context)?.nutriScore ?? 'Nutri-Score', style: const TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 4), Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: _getNutriScoreColor(nutriscore), borderRadius: BorderRadius.circular(8)), child: Text(nutriscore, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)))]), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ Text(AppLocalizations.of(context)?.traceability ?? 'Sporbarhet', style: const TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 4), Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Row(children: [ const Icon(Icons.security, color: Colors.blue), const SizedBox(width: 8), Text(AppLocalizations.of(context)?.beta ?? 'Beta', style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold))]))])]),
                const Divider(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add_shopping_cart),
                    label: Text(AppLocalizations.of(context)?.addToList ?? 'Add to List'),
                    onPressed: () {
                      onAddItem(info['navn']);
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const Divider(height: 40),
                Text(AppLocalizations.of(context)?.identifiedAdditions ?? 'Identified E-numbers', style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                if (eStoffer.isNotEmpty) Wrap(spacing: 8.0, runSpacing: 4.0, children: eStoffer.map((e) => Chip(label: Text(e.toString(), style: const TextStyle(fontWeight: FontWeight.bold)))).toList()) else Text(AppLocalizations.of(context)?.noAdditionsFound ?? 'No E-numbers found in database.'),
                const Divider(height: 40),
                Text(AppLocalizations.of(context)?.disclaimer ?? "Disclaimer: This information is for guidance only...", style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey))
              ],
            ),
          ),
        ],
      ),
    );
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
    final height = widget.isFullScreen ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.height * 0.7;
    return Container(
      height: height,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(widget.isFullScreen ? 0 : 20)), boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2)]),
      child: Stack(
        fit: StackFit.expand,
        children: [
           Opacity(
             opacity: 0.05,
             child: ClipRRect(
               borderRadius: BorderRadius.vertical(top: Radius.circular(widget.isFullScreen ? 0 : 20)),
               child: Image.asset('assets/nissefamilie.jpg', fit: BoxFit.cover, errorBuilder: (c,e,s) => const SizedBox.shrink()),
             ),
           ),
          Row(
            children: [
              Expanded(
                flex: _showHistory ? 2 : 3,
                child: Column(
                  children: [
                    AppBar(
                            title: GestureDetector(
                            onTap: () { 
                              final controller = TextEditingController(text: widget.listeNavn);
                              showDialog(context: context, builder: (_) => AlertDialog(title: Text(AppLocalizations.of(context)?.changeListName ?? 'Endre listenavn'), content: TextField(controller: controller, autocorrect: false), actions: [ TextButton(onPressed: () => Navigator.pop(context), child: Text(AppLocalizations.of(context)?.cancel ?? 'Avbryt')), TextButton(onPressed: () { final nyttNavn = controller.text.trim(); if (nyttNavn.isNotEmpty && nyttNavn != widget.listeNavn && !Hive.box('handlelister').containsKey(nyttNavn)) { final varer = Hive.box('handlelister').get(widget.listeNavn, defaultValue: <String>[]); Hive.box('handlelister').delete(widget.listeNavn); Hive.box('handlelister').put(nyttNavn, varer); final hist = Hive.box('historikk').get('historikk_${widget.listeNavn}', defaultValue: <Map<String, String>>[]); Hive.box('historikk').delete('historikk_${widget.listeNavn}'); Hive.box('historikk').put('historikk_$nyttNavn', hist); widget.onRename(widget.listeNavn, nyttNavn); Navigator.pop(context); } }, child: Text(AppLocalizations.of(context)?.save ?? 'Lagre'))]));
                            },
                            child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(color: Colors.black.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(child: Text(widget.listeNavn, style: const TextStyle(color: Colors.white, fontSize: 18), overflow: TextOverflow.ellipsis)),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.edit, size: 16, color: Colors.white70),
                                  ],
                                ))),
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        automaticallyImplyLeading: false,
                        actions: [ 
                          IconButton(icon: const Icon(Icons.search), onPressed: widget.onShowSearch),
                          IconButton(icon: const Icon(Icons.history), onPressed: () => setState(() => _showHistory = !_showHistory)),
                          IconButton(icon: Icon(widget.isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen), onPressed: widget.onToggleFullScreen),
                          IconButton(icon: const Icon(Icons.close), onPressed: widget.onClose)
                        ]),
                     Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(child: TextField(controller: _addItemController, decoration: InputDecoration(hintText: AppLocalizations.of(context)?.manualAddItem ?? 'Add item manually...', border: const OutlineInputBorder()))),
                          IconButton(
                              icon: const Icon(Icons.add_circle, color: Colors.green, size: 40),
                              onPressed: () {
                                final item = _addItemController.text.trim();
                                if (item.isNotEmpty) {
                                  final box = Hive.box('handlelister');
                                  final list = List<String>.from(box.get(widget.listeNavn, defaultValue: <String>[]));
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
                        valueListenable: Hive.box('handlelister').listenable(keys: [widget.listeNavn]),
                        builder: (_, box, __) {
                          final varer = List<String>.from(box.get(widget.listeNavn, defaultValue: <String>[]));
                          if (varer.isEmpty) {
                            return Center(child: Text(AppLocalizations.of(context)?.emptyList ?? 'List is empty'));
                          }
                          return ReorderableListView(
                            onReorder: (oldIndex, newIndex) { if (newIndex > oldIndex) newIndex--; final item = varer.removeAt(oldIndex); varer.insert(newIndex, item); box.put(widget.listeNavn, varer); },
                            children: varer.asMap().entries.map((entry) {
                              final index = entry.key;
                              final vare = entry.value;
                              final checked = vare.startsWith('✓ ');
                              final displayText = checked ? vare.substring(2) : vare;
                              return ListTile(
                                key: ValueKey(vare + index.toString()),
                                leading: Icon(checked ? Icons.check_box : Icons.check_box_outline_blank, color: checked ? Colors.green : null),
                                title: Text(displayText, style: TextStyle(decoration: checked ? TextDecoration.lineThrough : null, color: checked ? Colors.grey : null)),
                                trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () { varer.removeAt(index); box.put(widget.listeNavn, varer); }),
                                onTap: () { if (checked) { varer[index] = displayText; } else { varer[index] = '✓ $displayText'; } box.put(widget.listeNavn, varer); },
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
                        AppBar(title: Text(AppLocalizations.of(context)?.history ?? 'History'), backgroundColor: Colors.blueGrey[700], foregroundColor: Colors.white, automaticallyImplyLeading: false, actions: [IconButton(icon: const Icon(Icons.close), onPressed: () => setState(() => _showHistory = false))]),
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
                                    trailing: IconButton(icon: const Icon(Icons.add, color: Colors.green), onPressed: () { 
                                      final vareNavn = name.split(' – ').last;
                                      final list = List<String>.from(Hive.box('handlelister').get(widget.listeNavn, defaultValue: <String>[])); 
                                      if (!list.any((item) => item.endsWith(vareNavn))) { 
                                        list.insert(0, vareNavn); 
                                        Hive.box('handlelister').put(widget.listeNavn, list); 
                                      } 
                                    }),
                                  );
                                },
                              );
                            },
                          ),
                        ),
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

  const GlobalHistorikkOverlay({
    required this.isFullScreen,
    required this.onClose,
    required this.onToggleFullScreen,
    required this.onAddItem,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final height = isFullScreen ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.height * 0.6;
    final historikkBox = Hive.box('historikk');

    List<Map> allHistory = [];
    for(var key in historikkBox.keys) {
      final dynamic oldList = historikkBox.get(key, defaultValue: []);
      if (oldList is List && oldList.isNotEmpty) {
        if (oldList.first is String) {
          allHistory.addAll(oldList.map((e) => {'name': e, 'imageUrl': ''}).toList().cast<Map>());
        } else {
          allHistory.addAll(List<Map>.from(oldList));
        }
      }
    }
    allHistory.sort((a,b) => (b['name'] as String).compareTo(a['name'] as String));

    return Container(
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
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(AppLocalizations.of(context)?.newShoppingList ?? 'New Shopping List'),
                        content: TextField(controller: controller, decoration: InputDecoration(hintText: AppLocalizations.of(context)?.listName ?? 'List Name')),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context), child: Text(AppLocalizations.of(context)?.cancel ?? 'Cancel')),
                          TextButton(
                            onPressed: () {
                              final navn = controller.text.trim();
                              if (navn.isNotEmpty && !Hive.box('handlelister').containsKey(navn)) {
                                Hive.box('handlelister').put(navn, []);
                              }
                              Navigator.pop(context);
                            },
                            child: Text(AppLocalizations.of(context)?.create ?? 'Create'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                IconButton(icon: Icon(isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen), onPressed: onToggleFullScreen),
                IconButton(icon: const Icon(Icons.close), onPressed: onClose),
              ],
            ),
            Expanded(
              child: allHistory.isEmpty
                ? Center(child: Text(AppLocalizations.of(context)?.noHistoryFound ?? 'No history found'))
                : ListView.builder(
                    itemCount: allHistory.length,
                    itemBuilder: (_, i) {
                        final entry = allHistory[i];
                        final name = entry['name'] as String? ?? 'Ukjent';
                        final imageUrl = entry['imageUrl'] as String? ?? '';
                        return ListTile(
                          leading: imageUrl.isNotEmpty 
                              ? Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.image_not_supported))
                              : const Icon(Icons.shopping_basket, size: 40),
                          title: Text(name),
                          trailing: IconButton(
                            icon: const Icon(Icons.add_shopping_cart, color: Colors.green),
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
