// Popup model for a scan warning.
//
// Wording rules: docs/WARNING_WORDING.md.
// A warning with no https source is not shown. Red is only kept when
// documentedUse is true (a source documents use, not only background).

enum WarningTopic { bovaer, gmo, ngt, insekter }

enum WarningLevel { red, yellow, green }

class WarningCitation {
  final String url;
  final String date;
  final String publisher;
  final String quoteOrNote;
  final String lastChecked;

  const WarningCitation({
    required this.url,
    required this.date,
    required this.publisher,
    required this.quoteOrNote,
    required this.lastChecked,
  });

  bool get isHttps => url.trim().startsWith('https://');
}

class ScanWarning {
  final String id;
  final WarningTopic topic;
  final String whatNb;
  final String whatEn;
  final String who;
  final String? whoEn;
  final String howNb;
  final String howEn;

  /// Level requested by the sourced record. Use [popupLevel] in the UI.
  final WarningLevel level;

  /// True only when a source documents use (for Bovaer: status `bruker`).
  final bool documentedUse;

  /// False when the sources are general EU acts, not a company record.
  final bool brandSpecific;

  final List<WarningCitation> sources;
  final List<WarningCitation> research;

  const ScanWarning({
    required this.id,
    required this.topic,
    required this.whatNb,
    required this.whatEn,
    required this.who,
    this.whoEn,
    required this.howNb,
    required this.howEn,
    required this.level,
    required this.documentedUse,
    this.brandSpecific = true,
    this.sources = const [],
    this.research = const [],
  });

  bool get hasSource => sources.any((s) => s.isHttps);

  /// Null when the popup must not show this warning.
  /// Red without documented use is lowered to yellow, never shown as red.
  WarningLevel? get popupLevel {
    if (!hasSource) return null;
    if (level == WarningLevel.red && !documentedUse) {
      return WarningLevel.yellow;
    }
    return level;
  }

  bool get showInPopup => popupLevel != null;

  String what(bool norwegian) => norwegian ? whatNb : whatEn;
  String how(bool norwegian) => norwegian ? howNb : howEn;
  String whoText(bool norwegian) =>
      norwegian || whoEn == null || whoEn!.isEmpty ? who : whoEn!;
}

const String kResearchDisclaimerNb =
    'Generell forskning, ikke dokumentasjon for dette merket';
const String kResearchDisclaimerEn =
    'General research, not documentation for this brand';

const String kNoDocumentedSourceNb = 'Ingen dokumentert kilde for dette merket.';
const String kNoDocumentedSourceEn = 'No documented source for this brand.';

const String kUnsourcedWhoNb = 'Ikke dokumentert for dette merket';
const String kUnsourcedWhoEn = 'Not documented for this brand';
