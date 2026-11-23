import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/scan_warning_catalog.dart';
import '../gen_l10n/app_localizations.dart';
import '../models/scan_warning.dart';
import '../ui_safe.dart';

/// Three-step warning popup: what/who/how, sources, then general research.
class ScanWarningDialog extends StatelessWidget {
  final List<ScanWarning> warnings;
  final List<WarningCitation>? researchOnly;
  final bool? norwegianOverride;
  final int initialPage;

  const ScanWarningDialog({
    super.key,
    required this.warnings,
    this.researchOnly,
    this.norwegianOverride,
    this.initialPage = 0,
  });

  const ScanWarningDialog.research({
    super.key,
    required List<WarningCitation> entries,
    this.norwegianOverride,
  })  : warnings = const [],
        researchOnly = entries,
        initialPage = 2;

  @override
  Widget build(BuildContext context) {
    final nb = _isNorwegian(context, norwegianOverride);
    return AlertDialog(
      key: const Key('scan-warning-dialog'),
      contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      content: SizedBox(
        width: double.maxFinite,
        child: ScanWarningPages(
          warnings: warnings,
          researchOnly: researchOnly,
          norwegianOverride: norwegianOverride,
          initialPage: initialPage,
        ),
      ),
      actions: [
        TextButton(
          key: const Key('warning-close'),
          onPressed: () => Navigator.of(context).maybePop(),
          child: Text(
            AppLocalizations.of(context)?.close ?? (nb ? 'Lukk' : 'Close'),
          ),
        ),
      ],
    );
  }
}

class ScanWarningPages extends StatefulWidget {
  final List<ScanWarning> warnings;
  final List<WarningCitation>? researchOnly;
  final bool? norwegianOverride;
  final int initialPage;

  const ScanWarningPages({
    super.key,
    required this.warnings,
    this.researchOnly,
    this.norwegianOverride,
    this.initialPage = 0,
  });

  @override
  State<ScanWarningPages> createState() => _ScanWarningPagesState();
}

class _ScanWarningPagesState extends State<ScanWarningPages> {
  /// 0 overview, 1 sources, 2 research.
  late int _page;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _page = widget.researchOnly != null ? 2 : widget.initialPage;
  }

  bool get _nb => _isNorwegian(context, widget.norwegianOverride);

  ScanWarning? get _warning =>
      widget.warnings.isEmpty ? null : widget.warnings[_index];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _pageTitle(),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          if (_page == 0) _overview(),
          if (_page == 1) _sources(),
          if (_page == 2) _research(),
          if (_page != 0 && widget.researchOnly == null)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () => setState(() => _page = 0),
                child: Text(_nb ? 'Tilbake' : 'Back'),
              ),
            ),
        ],
      ),
    );
  }

  String _pageTitle() {
    if (_page == 1) return _nb ? 'Kilder' : 'Sources';
    if (_page == 2) return _nb ? 'Uavhengig forskning' : 'Independent research';
    return _nb ? 'Varsel' : 'Warning';
  }

  Widget _overview() {
    if (widget.warnings.isEmpty) {
      return Text(_nb ? kNoDocumentedSourceNb : kNoDocumentedSourceEn);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < widget.warnings.length; i++) ...[
          if (widget.warnings.length > 1)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                _topicLabel(widget.warnings[i].topic),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          _levelChip(widget.warnings[i]),
          const SizedBox(height: 8),
          _section(
            _nb ? 'Hva det gjelder' : 'What this is about',
            widget.warnings[i].what(_nb),
          ),
          _section(
            _nb ? 'Hvem som står bak' : 'Who is behind it',
            widget.warnings[i].whoText(_nb),
          ),
          _section(
            _nb ? 'Hva du kan sjekke' : 'What you can check',
            widget.warnings[i].how(_nb),
          ),
          Wrap(
            spacing: 8,
            children: [
              OutlinedButton(
                key: Key('see-sources-${widget.warnings[i].id}'),
                onPressed: () => setState(() {
                  _index = i;
                  _page = 1;
                }),
                child: Text(_nb ? 'Se kilder' : 'See sources'),
              ),
              OutlinedButton(
                key: Key('see-research-${widget.warnings[i].id}'),
                onPressed: () => setState(() {
                  _index = i;
                  _page = 2;
                }),
                child: Text(_nb ? 'Uavhengig forskning' : 'Independent research'),
              ),
            ],
          ),
          if (i != widget.warnings.length - 1) const Divider(height: 28),
        ],
      ],
    );
  }

  Widget _sources() {
    final warning = _warning;
    if (warning == null || warning.sources.isEmpty) {
      return Text(_nb ? kNoDocumentedSourceNb : kNoDocumentedSourceEn);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!warning.brandSpecific)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              _nb
                  ? 'Disse kildene er generelle EU-tekster. De dokumenterer ikke dette merket.'
                  : 'These sources are general EU texts. They do not document this brand.',
            ),
          ),
        for (final source in warning.sources) _citationCard(source),
      ],
    );
  }

  Widget _research() {
    final entries = widget.researchOnly ?? _warning?.research ?? const [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          key: const Key('research-disclaimer'),
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF3E0),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFFFB74D)),
          ),
          child: Text(
            _nb ? kResearchDisclaimerNb : kResearchDisclaimerEn,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        if (entries.isEmpty)
          Text(_nb
              ? 'Ingen forskningsoppføringer i denne versjonen.'
              : 'No research entries in this version.')
        else
          for (final entry in entries) _citationCard(entry),
      ],
    );
  }

  Widget _citationCard(WarningCitation citation) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            citation.publisher,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          Text(formatWarningDate(citation.date)),
          const SizedBox(height: 6),
          Text(citation.quoteOrNote),
          const SizedBox(height: 6),
          Text(
            _nb
                ? 'Sist kontrollert: ${formatWarningDate(citation.lastChecked)}'
                : 'Last checked: ${formatWarningDate(citation.lastChecked)}',
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => _open(citation.url),
              child: Text(_nb ? 'Åpne lenke' : 'Open link'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(String heading, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(heading, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(body),
        ],
      ),
    );
  }

  Widget _levelChip(ScanWarning warning) {
    final level = warning.popupLevel ?? warning.level;
    final color = switch (level) {
      WarningLevel.red => Colors.red.shade700,
      WarningLevel.yellow => Colors.amber.shade800,
      WarningLevel.green => Colors.green.shade700,
    };
    final label = switch (level) {
      WarningLevel.red => _nb
          ? 'Rødt: kildene dokumenterer bruk'
          : 'Red: the sources document use',
      WarningLevel.yellow => _nb
          ? 'Gult: begrenset eller ufullstendig grunnlag'
          : 'Yellow: limited or incomplete basis',
      WarningLevel.green => _nb
          ? 'Grønt: kildene sier at dette ikke er tillatt her'
          : 'Green: the sources say this is not permitted here',
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 13)),
    );
  }

  String _topicLabel(WarningTopic topic) {
    return switch (topic) {
      WarningTopic.bovaer => 'Bovaer / 3-NOP',
      WarningTopic.gmo => 'GMO',
      WarningTopic.ngt => 'NGT',
      WarningTopic.insekter => _nb ? 'Insekter' : 'Insects',
    };
  }

  Future<void> _open(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    try {
      final ok = await canLaunchUrl(uri);
      if (!ok) {
        if (mounted) safeSnack(context, _nb ? 'Kunne ikke åpne lenken' : 'Could not open the link');
        return;
      }
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      if (mounted) {
        safeSnack(context, _nb ? 'Kunne ikke åpne lenken' : 'Could not open the link');
      }
    }
  }
}

bool _isNorwegian(BuildContext context, bool? override) {
  if (override != null) return override;
  final code =
      (AppLocalizations.of(context)?.localeName ?? 'nb').toLowerCase();
  return code == 'nb' || code == 'no';
}
