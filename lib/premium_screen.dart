import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'l10n/draft_locale_copy.dart';
import 'premium_service.dart';
import 'ui_safe.dart';

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
    final copy = draftPurchaseCopy(appLanguageCode(Localizations.localeOf(context)));
    final title = copy?.shortTitle ?? 'Fjern annonser';
    final active = copy?.active ?? 'Annonsefri er aktiv ✅';
    final inactive = copy?.inactive ?? 'Annonsefri er ikke aktiv enda';
    final heading = copy?.heading ?? 'Kjøp annonsefri versjon';
    final body = copy?.body ??
        'Engangskjøp. Ingen abonnement.\n'
            'Når kjøpet er bekreftet fjernes annonser permanent på denne kontoen.';
    final retry = copy?.retry ?? 'Prøv igjen';
    final oneTime = copy?.oneTimeSuffix ?? 'engangskjøp';
    final buy = copy?.buy ?? 'Kjøp permanent';
    final restore = copy?.restore ?? 'Gjenopprett kjøp';
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
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
                _premiumService.isPremiumActive ? active : inactive,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 12),
            RobustLabel(
              heading,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(body),
            const SizedBox(height: 16),
            if (_premiumService.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (!_premiumService.isStoreAvailable)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(copy?.storeUnavailable ??
                      'Butikk utilgjengelig nå. Prøv igjen senere.'),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () async {
                      setState(() => _premiumService.isLoading = true);
                      await _initialize();
                    },
                    icon: const Icon(Icons.refresh),
                    label: Text(retry),
                  ),
                ],
              )
            else if (_premiumService.offers.isEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_emptyCatalogMessage(copy)),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () async {
                      setState(() => _premiumService.isLoading = true);
                      await _initialize();
                    },
                    icon: const Icon(Icons.refresh),
                    label: Text(retry),
                  ),
                ],
              )
            else
              ..._premiumService.offers.map(
                (product) => Card(
                  child: ListTile(
                    title: Text(product.title),
                    subtitle: Text(
                      '${product.priceLabel} • $oneTime',
                    ),
                    trailing: _premiumService.isPremiumActive
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : ElevatedButton(
                            onPressed: () async {
                              await _premiumService.buyLifetime();
                              if (!mounted) return;
                              widget.onPremiumChanged(
                                  _premiumService.isPremiumActive);
                              setState(() {});
                            },
                            child: Text(buy),
                          ),
                  ),
                ),
              ),
            const SizedBox(height: 8),
            if (!_premiumService.isLoading &&
                (_premiumService.usesHuaweiIap || Platform.isIOS))
              TextButton.icon(
              onPressed: () async {
                await _premiumService.restorePurchases();
                if (!mounted) return;
                widget.onPremiumChanged(_premiumService.isPremiumActive);
                setState(() {});
              },
              icon: const Icon(Icons.restore),
              label: Text(restore),
            ),
            if (_premiumService.lastMessage.isNotEmpty &&
                _premiumService.offers.isNotEmpty)
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

  String _emptyCatalogMessage(DraftPurchaseCopy? copy) {
    switch (_premiumService.catalogStatus) {
      case PurchaseCatalogStatus.productNotReturned:
        return copy?.productNotReturned ?? _premiumService.lastMessage;
      case PurchaseCatalogStatus.queryFailed:
        return copy?.productsUnavailable ?? _premiumService.lastMessage;
      default:
        return _premiumService.lastMessage.isNotEmpty
            ? _premiumService.lastMessage
            : (copy?.productsUnavailable ??
                'Kunne ikke hente kjøpsprodukter. Prøv igjen.');
    }
  }
}
