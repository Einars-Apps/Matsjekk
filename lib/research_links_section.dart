import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

/// Public endpoint for the curated, human-verified research links.
const String kResearchLinksUrl = 'https://matsjekk.com/data/research_links.json';

/// One research reference with its funding/mandate context.
class ResearchLink {
  final Map<String, String> title;
  final String publisher;
  final int? year;

  /// independent | public | academic | ngo | industry | unknown
  final String funding;
  final Map<String, String> mandate;
  final bool peerReviewed;
  final String url;

  const ResearchLink({
    required this.title,
    required this.publisher,
    required this.year,
    required this.funding,
    required this.mandate,
    required this.peerReviewed,
    required this.url,
  });

  /// True when this study is producer/industry-funded.
  bool get isIndustry => funding.toLowerCase() == 'industry';

  bool get hasValidUrl {
    final u = Uri.tryParse(url.trim());
    return u != null &&
        (u.scheme == 'http' || u.scheme == 'https') &&
        u.host.isNotEmpty;
  }

  static Map<String, String> _strMap(dynamic raw) {
    if (raw is Map) {
      return raw.map((k, v) => MapEntry(k.toString(), v.toString()));
    }
    if (raw is String && raw.isNotEmpty) return {'en': raw};
    return const {};
  }

  factory ResearchLink.fromJson(Map<String, dynamic> json) {
    final yearRaw = json['year'];
    return ResearchLink(
      title: _strMap(json['title']),
      publisher: (json['publisher'] ?? '').toString(),
      year: yearRaw is int ? yearRaw : int.tryParse('${yearRaw ?? ''}'),
      funding: (json['funding'] ?? 'unknown').toString(),
      mandate: _strMap(json['mandate']),
      peerReviewed: json['peer_reviewed'] == true,
      url: (json['url'] ?? '').toString().trim(),
    );
  }

  String titleFor(String locale) => _pick(title, locale);
  String mandateFor(String locale) => _pick(mandate, locale);

  static String _pick(Map<String, String> m, String locale) {
    final code = locale.split(RegExp('[_-]')).first.toLowerCase();
    return m[code] ?? m['en'] ?? (m.isNotEmpty ? m.values.first : '');
  }
}

/// Loads and caches [kResearchLinksUrl] in memory for the app session.
class ResearchLinksRepository {
  static Map<String, List<ResearchLink>>? _cache;

  /// Returns themes -> links. Cached after first successful fetch.
  static Future<Map<String, List<ResearchLink>>> load() async {
    if (_cache != null) return _cache!;
    try {
      final res = await http
          .get(Uri.parse(kResearchLinksUrl))
          .timeout(const Duration(seconds: 8));
      if (res.statusCode != 200) return {};
      final decoded = json.decode(res.body);
      final themes = (decoded is Map ? decoded['themes'] : null);
      final out = <String, List<ResearchLink>>{};
      if (themes is Map) {
        themes.forEach((key, value) {
          if (value is List) {
            out[key.toString()] = value
                .whereType<Map>()
                .map((e) => ResearchLink.fromJson(e.cast<String, dynamic>()))
                .where((l) => l.hasValidUrl)
                .toList();
          }
        });
      }
      _cache = out;
      return out;
    } catch (_) {
      return {};
    }
  }
}

/// A user-friendly "📚 Forskning" section that lets users dig deeper and
/// clearly separates independent/official research from producer-funded
/// research. Self-contained: fetches its own data and shows nothing on error.
class ResearchLinksSection extends StatefulWidget {
  /// Theme keys to show, in order (e.g. ['bovaer','ngt_gmo','insect_meal']).
  /// When null, shows every theme found in the data.
  final List<String>? themeKeys;

  const ResearchLinksSection({super.key, this.themeKeys});

  @override
  State<ResearchLinksSection> createState() => _ResearchLinksSectionState();
}

class _ResearchLinksSectionState extends State<ResearchLinksSection> {
  late Future<Map<String, List<ResearchLink>>> _future;

  @override
  void initState() {
    super.initState();
    _future = ResearchLinksRepository.load();
  }

  String get _locale {
    final code = Localizations.maybeLocaleOf(context)?.languageCode ?? 'nb';
    return code.toLowerCase();
  }

  Future<void> _open(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  // ── Localized labels ──
  String _t(String nb, String en) => _locale == 'nb' ? nb : en;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, List<ResearchLink>>>(
      future: _future,
      builder: (context, snap) {
        final data = snap.data;
        if (data == null || data.isEmpty) return const SizedBox.shrink();

        final keys = widget.themeKeys ?? data.keys.toList();
        final all = <ResearchLink>[];
        for (final k in keys) {
          final list = data[k];
          if (list != null) all.addAll(list);
        }
        if (all.isEmpty) return const SizedBox.shrink();

        final independent = all.where((l) => !l.isIndustry).toList();
        final industry = all.where((l) => l.isIndustry).toList();

        return Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Theme(
            data: Theme.of(context)
                .copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(horizontal: 8),
              childrenPadding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              leading: const Text('📚', style: TextStyle(fontSize: 20)),
              title: Text(
                _t('Forskning – grav dypere', 'Research – dig deeper'),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                _t(
                  'Vi skiller tydelig mellom uavhengig og produsentfinansiert forskning.',
                  'We clearly separate independent and producer-funded research.',
                ),
                style: const TextStyle(fontSize: 11),
              ),
              children: [
                if (independent.isNotEmpty) ...[
                  _groupHeader(
                    '🟢',
                    _t('Uavhengig & offentlig', 'Independent & official'),
                    _t(
                      'Myndigheter og uavhengige fagmiljøer. Mandat: vurdere trygghet/effekt nøytralt.',
                      'Authorities and independent experts. Mandate: assess safety/effect neutrally.',
                    ),
                    const Color(0xFF2E7D32),
                  ),
                  ...independent.map(_card),
                ],
                if (industry.isNotEmpty) ...[
                  _groupHeader(
                    '🟡',
                    _t('Produsent-/bransjefinansiert',
                        'Producer/industry-funded'),
                    _t(
                      'Betalt av produsent/bransje. Mandat: ofte å dokumentere for godkjenning/markedsføring.',
                      'Paid by producer/industry. Mandate: often to document for approval/marketing.',
                    ),
                    const Color(0xFFF9A825),
                  ),
                  ...industry.map(_card),
                ],
                const SizedBox(height: 4),
                Text(
                  _t(
                    'Lenkene er kuratert og verifisert manuelt. Dette er kunnskapsgrunnlag, ikke en fasit.',
                    'Links are curated and verified manually. This is background knowledge, not a verdict.',
                  ),
                  style: TextStyle(
                      fontSize: 10, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _groupHeader(
      String emoji, String title, String desc, Color color) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 13),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 2),
            child: Text(desc,
                style: TextStyle(fontSize: 10, color: Colors.grey[700])),
          ),
        ],
      ),
    );
  }

  Widget _card(ResearchLink l) {
    final meta = <String>[
      if (l.publisher.isNotEmpty) l.publisher,
      if (l.year != null) '${l.year}',
    ].join(' · ');

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.titleFor(_locale),
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 13)),
          if (meta.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(meta,
                  style:
                      TextStyle(fontSize: 11, color: Colors.grey[700])),
            ),
          if (l.mandateFor(_locale).isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                l.mandateFor(_locale),
                style: const TextStyle(
                    fontSize: 11, fontStyle: FontStyle.italic),
              ),
            ),
          const SizedBox(height: 6),
          Row(
            children: [
              if (l.peerReviewed)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 2),
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E7D32).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _t('Fagfellevurdert', 'Peer-reviewed'),
                    style: const TextStyle(
                        fontSize: 10, color: Color(0xFF2E7D32)),
                  ),
                ),
              const Spacer(),
              TextButton.icon(
                onPressed: () => _open(l.url),
                icon: const Icon(Icons.open_in_new, size: 15),
                label: Text(_t('Åpne kilde', 'Open source'),
                    style: const TextStyle(fontSize: 12)),
                style: TextButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6),
                    minimumSize: const Size(0, 30)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
