import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'gen_l10n/app_localizations.dart';
import 'ad_banner.dart';

class ConsentDialog extends StatefulWidget {
  final bool showAdBanner;

  const ConsentDialog({super.key, this.showAdBanner = false});

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
    if (!mounted) return;
    Navigator.of(context).pop();
    final l10n = AppLocalizations.of(context);
    final snack = value
        ? (l10n?.analyticsEnabled ?? 'Thanks - analytics enabled.')
        : (l10n?.analyticsDisabled ?? 'Analytics disabled.');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(snack)));
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
          Text(l10n?.consentOptional ??
              'This is optional. If you do not consent, your usage is not sent to analytics.'),
          const SizedBox(height: 8),
          Text(l10n?.consentLocalOnly ??
              'The app still works, and data can remain only on your device.'),
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
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n?.cancel ?? 'Cancel')),
        ElevatedButton(
            onPressed: () => _save(_optIn), child: Text(l10n?.save ?? 'Save'))
      ],
    );
  }
}
