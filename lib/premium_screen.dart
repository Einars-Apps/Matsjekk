import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'gen_l10n/app_localizations.dart';

import 'premium_service.dart';
import 'ad_banner.dart';

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
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.premiumTitle ?? 'Remove ads'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            if (!_premiumService.isPremiumActive)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withAlpha((0.08 * 255).round()),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.orange),
                ),
                child: Row(
                  children: [
                    // Reklamebanner til venstre
                    const Expanded(
                      flex: 2,
                      child: AdBanner(),
                    ),
                    const SizedBox(width: 8),
                    // Ad Free-knapp til høyre
                    Expanded(
                      flex: 1,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          // Scroll til kjøpsseksjon
                          Scrollable.ensureVisible(
                            context,
                            duration: const Duration(milliseconds: 400),
                          );
                        },
                        icon: const Icon(Icons.workspace_premium),
                        label: Text(l10n?.buyAdFreeTitle ?? 'Buy ad-free'),
                      ),
                    ),
                  ],
                ),
              ),
            if (!_premiumService.isPremiumActive) const SizedBox(height: 12),
            Text(
              l10n?.buyAdFreeTitle ?? 'Buy ad-free version',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              l10n?.oneTimePurchaseInfo ??
                  'One-time purchase. No subscription.\nAfter purchase confirmation, ads are removed permanently for this account.',
            ),
            const SizedBox(height: 16),
            if (_premiumService.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (!_premiumService.isStoreAvailable)
              Text(l10n?.storeUnavailable ??
                  'Store is unavailable right now. Please try again later.')
            else if (_premiumService.products.isEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n?.productsLoadFailed ??
                        'Could not load purchase products. Check your network and try again.',
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await _premiumService.loadProducts();
                      if (!mounted) return;
                      setState(() {});
                    },
                    icon: const Icon(Icons.refresh),
                    label: Text(l10n?.tryAgain ?? 'Try again'),
                  ),
                ],
              )
            else
              ..._premiumService.products.map(
                (product) => Card(
                  child: ListTile(
                    title: Text(product.title),
                    subtitle: Text(
                      '${product.price} • ${l10n?.oneTimePurchaseLabel ?? 'one-time purchase'}',
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
                            child:
                                Text(l10n?.buyPermanently ?? 'Buy permanently'),
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
              label: Text(l10n?.restorePurchases ?? 'Restore purchases'),
            ),
            if (_premiumService.lastMessageKey != PremiumMessageKey.none)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _translateMessage(_premiumService.lastMessageKey, l10n),
                  style: const TextStyle(color: Colors.black87),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _translateMessage(PremiumMessageKey key, AppLocalizations? l10n) {
    switch (key) {
      case PremiumMessageKey.storeUnavailable:
        return l10n?.storeUnavailable ?? 'Store is unavailable right now. Please try again later.';
      case PremiumMessageKey.purchaseStreamError:
        return l10n?.purchaseStreamError ?? 'Purchase stream failed';
      case PremiumMessageKey.productsLoadFailed:
        return l10n?.productsLoadFailed ?? 'Could not load purchase products.';
      case PremiumMessageKey.productIdNotFound:
        return l10n?.productIdNotFound ?? 'Could not find purchase product.';
      case PremiumMessageKey.paymentConfirmed:
        return l10n?.paymentConfirmed ?? 'Payment confirmed. Ads are now permanently removed.';
      case PremiumMessageKey.purchaseFailed:
        return l10n?.purchaseFailed ?? 'Purchase failed. Please try again.';
      case PremiumMessageKey.purchaseCancelled:
        return l10n?.purchaseCancelled ?? 'Purchase was cancelled.';
      case PremiumMessageKey.none:
        return '';
    }
  }
}
