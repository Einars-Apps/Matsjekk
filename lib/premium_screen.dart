import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'premium_service.dart';

class PremiumScreen extends StatefulWidget {
  final Box innstillingerBox;
  final ValueChanged<bool> onPremiumChanged;

  const PremiumScreen({
    super.key,
    required this.innstillingerBox,
    required this.onPremiumChanged,
  });

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  final PremiumService _premiumService = PremiumService();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _premiumService.initialize(widget.innstillingerBox);
    if (!mounted) return;
    widget.onPremiumChanged(_premiumService.isPremiumActive);
    setState(() {});
  }

  @override
  void dispose() {
    _premiumService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fjern annonser'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _premiumService.isPremiumActive
                    ? Colors.green.withAlpha((0.08 * 255).round())
                    : Colors.orange.withAlpha((0.08 * 255).round()),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color:
                      _premiumService.isPremiumActive ? Colors.green : Colors.orange,
                ),
              ),
              child: Text(
                _premiumService.isPremiumActive
                    ? 'Annonsefri er aktiv ✅'
                    : 'Annonsefri er ikke aktiv enda',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Kjøp annonsefri versjon',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Engangskjøp. Ingen abonnement.\n'
              'Når kjøpet er bekreftet fjernes annonser permanent på denne kontoen.',
            ),
            const SizedBox(height: 16),
            if (_premiumService.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (!_premiumService.isStoreAvailable)
              const Text('Butikk utilgjengelig nå. Prøv igjen senere.')
            else if (_premiumService.products.isEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Kunne ikke hente kjøpsprodukter. Sjekk nettverket og prøv igjen.',
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await _premiumService.loadProducts();
                      if (!mounted) return;
                      setState(() {});
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Prøv igjen'),
                  ),
                ],
              )
            else
              ..._premiumService.products.map(
                (product) => Card(
                  child: ListTile(
                    title: Text(product.title),
                    subtitle: Text(
                      '${product.price} • engangskjøp',
                    ),
                    trailing: _premiumService.isPremiumActive
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : ElevatedButton(
                            onPressed: () async {
                              await _premiumService.buy(product);
                              if (!mounted) return;
                              widget.onPremiumChanged(
                                  _premiumService.isPremiumActive);
                              setState(() {});
                            },
                            child: const Text('Kjøp permanent'),
                          ),
                  ),
                ),
              ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () async {
                await _premiumService.restorePurchases();
                if (!mounted) return;
                widget.onPremiumChanged(_premiumService.isPremiumActive);
                setState(() {});
              },
              icon: const Icon(Icons.restore),
              label: const Text('Gjenopprett kjøp'),
            ),
            if (_premiumService.lastMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _premiumService.lastMessage,
                  style: const TextStyle(color: Colors.black87),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
