import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'config/links.dart';
import 'gen_l10n/app_localizations.dart';

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
    final l = AppLocalizations.of(context);
    final snack = value
        ? (l?.analyticsEnabled ?? 'Thanks — analytics enabled.')
        : (l?.analyticsDisabled ?? 'Analytics disabled.');
    final box = Hive.box('innstillinger');
    await box.put('analytics_opt_in', value);
    if (widget.markPrivacyNoticeSeen) {
      await box.put('privacy_notice_seen', true);
    }
    if (!mounted) return;
    Navigator.of(context).pop();
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
    final locale = Localizations.localeOf(context).languageCode;
    final uri =
        Uri.parse('$kPublicPrivacyPolicyBaseUrl?lang=${locale.toLowerCase()}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l?.privacyTitle ?? 'Privacy'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.initialMessage != null) ...[
            Text(widget.initialMessage!),
            const SizedBox(height: 8),
          ],
          Text(l?.consentOptional ??
              'This is optional. If you don’t consent, your usage is not sent for analytics.'),
          const SizedBox(height: 8),
          Text(l?.consentWorksAnyway ??
              'The app works either way, and data can stay on your device only.'),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: _openPrivacyPolicy,
              icon: const Icon(Icons.open_in_new),
              label: Text(l?.readPrivacyPolicy ?? 'Read the privacy policy'),
            ),
          ),
          const SizedBox(height: 12),
          Row(children: [
            Flexible(
                child: Text(
                    l?.allowAnonymousAnalytics ?? 'Allow anonymous analytics')),
            const SizedBox(width: 8),
            Switch(value: _optIn, onChanged: (v) => setState(() => _optIn = v))
          ])
        ],
      ),
      // Build actions and interactive switch outside of const children
      actions: [
        TextButton(onPressed: _close, child: Text(l?.close ?? 'Close')),
        ElevatedButton(
            onPressed: () => _save(_optIn), child: Text(l?.save ?? 'Save'))
      ],
    );
  }
}
