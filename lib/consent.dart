import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'config/links.dart';
import 'gen_l10n/app_localizations.dart';
import 'ad_banner.dart';

class ConsentDialog extends StatefulWidget {
  final bool showAdBanner;
  final bool markPrivacyNoticeSeen;
  final String? initialMessage;

  const ConsentDialog({
    super.key,
    this.showAdBanner = false,
    this.markPrivacyNoticeSeen = false,
    this.initialMessage,
  });

  @override
  State<ConsentDialog> createState() => _ConsentDialogState();
}

class _ConsentDialogState extends State<ConsentDialog> {
  bool _optIn = false;

  @override
  void initState() {
    super.initState();
    final box = Hive.box('innstillinger');
    _optIn = box.get('analytics_opt_in', defaultValue: false) as bool;
  }

  void _save(bool value) async {
    final box = Hive.box('innstillinger');
    await box.put('analytics_opt_in', value);
    if (widget.markPrivacyNoticeSeen) {
      await box.put('privacy_notice_seen', true);
    }
    if (!mounted) return;
    Navigator.of(context).pop();
    final l10n = AppLocalizations.of(context);
    final snack = value
        ? (l10n?.analyticsEnabled ?? 'Thanks - analytics enabled.')
        : (l10n?.analyticsDisabled ?? 'Analytics disabled.');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(snack)));
  }

  Future<void> _close() async {
    final box = Hive.box('innstillinger');
    if (widget.markPrivacyNoticeSeen) {
      await box.put('privacy_notice_seen', true);
    }
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> _openPrivacyPolicy() async {
    final locale = AppLocalizations.of(context)?.localeName ?? 'nb';
    final uri =
        Uri.parse('$kPublicPrivacyPolicyBaseUrl?lang=${locale.toLowerCase()}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n?.privacy ?? 'Privacy'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showAdBanner) ...[
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: AdBanner(),
            ),
          ],
          if (widget.initialMessage != null) ...[
            Text(widget.initialMessage!),
            const SizedBox(height: 8),
          ],
          Text(l10n?.consentOptional ??
              'This is optional. If you do not consent, your usage is not sent to analytics.'),
          const SizedBox(height: 8),
          Text(l10n?.consentLocalOnly ??
              'The app still works, and data can remain only on your device.'),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: _openPrivacyPolicy,
              icon: const Icon(Icons.open_in_new),
              label: const Text('Read privacy policy'),
            ),
          ),
          const SizedBox(height: 12),
          Row(children: [
            Text(l10n?.allowAnonymousAnalytics ?? 'Allow anonymous analytics'),
            const Spacer(),
            Switch(value: _optIn, onChanged: (v) => setState(() => _optIn = v))
          ])
        ],
      ),
      // Build actions and interactive switch outside of const children
      actions: [
        TextButton(
            onPressed: _close,
            child: Text(l10n?.close ?? l10n?.cancel ?? 'Close')),
        ElevatedButton(
            onPressed: () => _save(_optIn), child: Text(l10n?.save ?? 'Save'))
      ],
    );
  }
}
