import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'config/links.dart';

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
    final snack = value ? 'Takk - analyse aktivert.' : 'Analyse deaktivert.';
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
    return AlertDialog(
      title: const Text('Personvern'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.initialMessage != null) ...[
            Text(widget.initialMessage!),
            const SizedBox(height: 8),
          ],
          const Text(
              'Dette er valgfritt. Hvis du ikke samtykker, blir bruken din ikke sendt til analyse.'),
          const SizedBox(height: 8),
          const Text(
              'Appen fungerer uansett, og data kan bli kun pa din enhet.'),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: _openPrivacyPolicy,
              icon: const Icon(Icons.open_in_new),
              label: const Text('Les personvernreglene'),
            ),
          ),
          const SizedBox(height: 12),
          Row(children: [
            const Text('Tillat anonym analyse'),
            const Spacer(),
            Switch(value: _optIn, onChanged: (v) => setState(() => _optIn = v))
          ])
        ],
      ),
      // Build actions and interactive switch outside of const children
      actions: [
        TextButton(onPressed: _close, child: const Text('Lukk')),
        ElevatedButton(
            onPressed: () => _save(_optIn), child: const Text('Lagre'))
      ],
    );
  }
}
