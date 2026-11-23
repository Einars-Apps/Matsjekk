import 'dart:convert';

import '../models/scan_warning.dart';

/// Embedded copy of docs/data/warning_research.json.
/// test/scan_warning_model_test.dart checks that the two stay identical.
const String kWarningResearchJson = r'''{
  "checked_on": "2026-11-14",
  "disclaimer_nb": "Generell forskning, ikke dokumentasjon for dette merket",
  "disclaimer_en": "General research, not documentation for this brand",
  "_note": "Bakgrunn til varsel-popupen. Tekstene er lest 14.11.2026 fra fri fulltekst (Publications Office / EUR-Lex-CELEX, PubMed Central, European Commission). De dokumenterer ikke ett merke. EUR-Lex HTML ligger bak en bot-vegg her; samme rettsakt er lest via publications.europa.eu CELEX, som er den frie OJ-teksten EUR-Lex viser.",
  "entries": [
    {
      "id": "eu-2022-565",
      "topic": "bovaer",
      "kind": "act",
      "species": null,
      "url": "https://publications.europa.eu/resource/celex/32022R0565",
      "date": "2022-04-07",
      "publisher": "Official Journal of the European Union",
      "quote_or_note": "COMMISSION IMPLEMENTING REGULATION (EU) 2022/565 of 7 April 2022 concerning the authorisation of a preparation of 3-nitrooxypropanol as a feed additive for dairy cows and cows for reproduction (holder of the authorisation: DSM Nutritional Products Ltd, represented in the Union by DSM Nutritional Products Sp. z o.o.)",
      "last_checked": "2026-11-14"
    },
    {
      "id": "eu-2022-565-consolidated",
      "topic": "bovaer",
      "kind": "act",
      "species": null,
      "url": "https://publications.europa.eu/resource/celex/02022R0565-20260205",
      "date": "2026-02-05",
      "publisher": "Publications Office of the European Union",
      "quote_or_note": "This text is meant purely as a documentation tool and has no legal effect. Note: the consolidated annex read on 14 Nov 2026 still names 3-nitrooxypropanol (CELEX 02022R0565 — EN — 05.02.2026).",
      "last_checked": "2026-11-14"
    },
    {
      "id": "efsa-3nop-2021",
      "topic": "bovaer",
      "kind": "opinion",
      "species": null,
      "url": "https://pmc.ncbi.nlm.nih.gov/articles/PMC8603004/",
      "date": "2021",
      "publisher": "EFSA Journal (PubMed Central, PMID 34824644)",
      "quote_or_note": "Following a request from the European Commission, EFSA was asked to deliver a scientific opinion on the safety and efficacy of Bovaer® 10 as a zootechnical additive for ruminants for milk production and reproduction.",
      "last_checked": "2026-11-14"
    },
    {
      "id": "eu-2021-882",
      "topic": "insekter",
      "kind": "act",
      "species": "tenebrio",
      "url": "https://publications.europa.eu/resource/celex/32021R0882",
      "date": "2021-06-01",
      "publisher": "Official Journal of the European Union",
      "quote_or_note": "COMMISSION IMPLEMENTING REGULATION (EU) 2021/882 of 1 June 2021 authorising the placing on the market of dried Tenebrio molitor larva as a novel food under Regulation (EU) 2015/2283 of the European Parliament and of the Council, and amending Commission Implementing Regulation (EU) 2017/2470",
      "last_checked": "2026-11-14"
    },
    {
      "id": "eu-2021-1975",
      "topic": "insekter",
      "kind": "act",
      "species": "locusta",
      "url": "https://publications.europa.eu/resource/celex/32021R1975",
      "date": "2021-11-12",
      "publisher": "Official Journal of the European Union",
      "quote_or_note": "COMMISSION IMPLEMENTING REGULATION (EU) 2021/1975 of 12 November 2021 authorising the placing on the market of frozen, dried and powder forms of Locusta migratoria as a novel food under Regulation (EU) 2015/2283 of the European Parliament and of the Council and amending Commission Implementing Regulation (EU) 2017/2470",
      "last_checked": "2026-11-14"
    },
    {
      "id": "eu-2022-188",
      "topic": "insekter",
      "kind": "act",
      "species": "acheta",
      "url": "https://publications.europa.eu/resource/celex/32022R0188",
      "date": "2022-02-10",
      "publisher": "Official Journal of the European Union",
      "quote_or_note": "COMMISSION IMPLEMENTING REGULATION (EU) 2022/188 of 10 February 2022 authorising the placing on the market of frozen, dried and powder forms of Acheta domesticus as a novel food under Regulation (EU) 2015/2283 of the European Parliament and of the Council, and amending Commission Implementing Regulation (EU) 2017/2470",
      "last_checked": "2026-11-14"
    },
    {
      "id": "eu-2023-5",
      "topic": "insekter",
      "kind": "act",
      "species": "acheta",
      "url": "https://publications.europa.eu/resource/celex/32023R0005",
      "date": "2023-01-03",
      "publisher": "Official Journal of the European Union",
      "quote_or_note": "COMMISSION IMPLEMENTING REGULATION (EU) 2023/5 of 3 January 2023 authorising the placing on the market of Acheta domesticus (house cricket) partially defatted powder as a novel food and amending Implementing Regulation (EU) 2017/2470",
      "last_checked": "2026-11-14"
    },
    {
      "id": "eu-2023-58",
      "topic": "insekter",
      "kind": "act",
      "species": "alphitobius",
      "url": "https://publications.europa.eu/resource/celex/32023R0058",
      "date": "2023-01-05",
      "publisher": "Official Journal of the European Union",
      "quote_or_note": "COMMISSION IMPLEMENTING REGULATION (EU) 2023/58 of 5 January 2023 authorising the placing on the market of the frozen, paste, dried and powder forms of Alphitobius diaperinus larvae (lesser mealworm) as a novel food and amending Implementing Regulation (EU) 2017/2470",
      "last_checked": "2026-11-14"
    },
    {
      "id": "eu-2015-2283",
      "topic": "insekter",
      "kind": "framework",
      "species": null,
      "url": "https://publications.europa.eu/resource/celex/32015R2283",
      "date": "2015-11-25",
      "publisher": "Official Journal of the European Union",
      "quote_or_note": "REGULATION (EU) 2015/2283 OF THE EUROPEAN PARLIAMENT AND OF THE COUNCIL of 25 November 2015 on novel foods, amending Regulation (EU) No 1169/2011 of the European Parliament and of the Council and repealing Regulation (EC) No 258/97 of the European Parliament and of the Council and Commission Regulation (EC) No 1852/2001",
      "last_checked": "2026-11-14"
    },
    {
      "id": "efsa-tenebrio-2021",
      "topic": "insekter",
      "kind": "opinion",
      "species": "tenebrio",
      "url": "https://pmc.ncbi.nlm.nih.gov/articles/PMC7805300/",
      "date": "2021",
      "publisher": "EFSA Journal (PubMed Central, PMID 33488808)",
      "quote_or_note": "Following a request from the European Commission, the EFSA Panel on Nutrition, Novel Foods and Food Allergens (NDA) was asked to deliver an opinion on dried yellow mealworm (Tenebrio molitor larva) as a novel food (NF) pursuant to Regulation (EU) 2015/2283.",
      "last_checked": "2026-11-14"
    },
    {
      "id": "efsa-locusta-2021",
      "topic": "insekter",
      "kind": "opinion",
      "species": "locusta",
      "url": "https://pmc.ncbi.nlm.nih.gov/articles/PMC8251647/",
      "date": "2021",
      "publisher": "EFSA Journal (PubMed Central, PMID 34249158)",
      "quote_or_note": "Following a request from the European Commission, the EFSA Panel on Nutrition, Novel Food and Food Allergens (NDA) was asked to deliver an opinion on the safety of frozen and dried formulations from migratory locust (Locusta migratoria) as a novel food pursuant to Regulation (EU) 2015/2283.",
      "last_checked": "2026-11-14"
    },
    {
      "id": "efsa-acheta-2021",
      "topic": "insekter",
      "kind": "opinion",
      "species": "acheta",
      "url": "https://pmc.ncbi.nlm.nih.gov/articles/PMC8369844/",
      "date": "2021",
      "publisher": "EFSA Journal (PubMed Central, PMID 34429777)",
      "quote_or_note": "Following a request from the European Commission, the EFSA Panel on Nutrition, Novel Food and Food Allergens (NDA) was asked to deliver an opinion on the safety of frozen and dried formulations from house crickets (Acheta domesticus) as a novel food pursuant to Regulation (EU) 2015/2283.",
      "last_checked": "2026-11-14"
    },
    {
      "id": "efsa-acheta-powder-2022",
      "topic": "insekter",
      "kind": "opinion",
      "species": "acheta",
      "url": "https://pmc.ncbi.nlm.nih.gov/articles/PMC9104259/",
      "date": "2022",
      "publisher": "EFSA Journal (PubMed Central, PMID 35592022)",
      "quote_or_note": "Following a request from the European Commission, the EFSA Panel on Nutrition, Novel Foods and Food Allergens (NDA) was asked to deliver an opinion on defatted house cricket (Acheta domesticus) powder as a novel food (NF) pursuant to Regulation (EU) 2015/2283.",
      "last_checked": "2026-11-14"
    },
    {
      "id": "efsa-alphitobius-2022",
      "topic": "insekter",
      "kind": "opinion",
      "species": "alphitobius",
      "url": "https://pmc.ncbi.nlm.nih.gov/articles/PMC9251881/",
      "date": "2022",
      "publisher": "EFSA Journal (PubMed Central, PMID 35814920)",
      "quote_or_note": "Following a request from the European Commission, the EFSA Panel on Nutrition, Novel Foods and Food Allergens (NDA) was asked to deliver an opinion on frozen and dried formulations from whole lesser mealworm (Alphitobius diaperinus larva) as a novel food (NF) pursuant to Regulation (EU) 2015/2283.",
      "last_checked": "2026-11-14"
    },
    {
      "id": "ec-1829-2003",
      "topic": "gmo",
      "kind": "act",
      "species": null,
      "url": "https://publications.europa.eu/resource/celex/32003R1829",
      "date": "2003-09-22",
      "publisher": "EUR-Lex",
      "quote_or_note": "Regulation (EC) No 1829/2003 of the European Parliament and of the Council of 22 September 2003 on genetically modified food and feed (Text with EEA relevance)",
      "last_checked": "2026-11-14"
    },
    {
      "id": "eu-gmo-register",
      "topic": "gmo",
      "kind": "register",
      "species": null,
      "url": "https://food.ec.europa.eu/food-safety/genetically-modified-organisms/gmo-register_en",
      "date": "udatert",
      "publisher": "European Commission",
      "quote_or_note": "This search engine covers the Community register of GM food and feed (Regulation (EC) 1829/2003) and the GM products withdrawn from the market.",
      "last_checked": "2026-11-14"
    },
    {
      "id": "eu-2026-1388",
      "topic": "ngt",
      "kind": "act",
      "species": null,
      "url": "https://publications.europa.eu/resource/celex/32026R1388",
      "date": "2026-06-17",
      "publisher": "Official Journal of the European Union",
      "quote_or_note": "REGULATION (EU) 2026/1388 OF THE EUROPEAN PARLIAMENT AND OF THE COUNCIL of 17 June 2026 on plants obtained by certain new genomic techniques and their products, and amending Regulation (EU) 2017/625. Note from the same text: shall apply from 17 July 2028.",
      "last_checked": "2026-11-14"
    }
  ]
}
''';

class WarningResearchEntry {
  final String id;
  final WarningTopic topic;
  final String kind;
  final String? species;
  final WarningCitation citation;

  const WarningResearchEntry({
    required this.id,
    required this.topic,
    required this.kind,
    required this.species,
    required this.citation,
  });
}

WarningTopic _topic(String raw) {
  return WarningTopic.values.firstWhere((t) => t.name == raw);
}

List<WarningResearchEntry> parseWarningResearch(String raw) {
  final decoded = json.decode(raw) as Map<String, dynamic>;
  final list = decoded['entries'] as List<dynamic>;
  return list.map((item) {
    final map = item as Map<String, dynamic>;
    final species = map['species'];
    return WarningResearchEntry(
      id: map['id'] as String,
      topic: _topic(map['topic'] as String),
      kind: map['kind'] as String,
      species: species is String && species.isNotEmpty ? species : null,
      citation: WarningCitation(
        url: map['url'] as String,
        date: map['date'] as String,
        publisher: map['publisher'] as String,
        quoteOrNote: map['quote_or_note'] as String,
        lastChecked: map['last_checked'] as String,
      ),
    );
  }).toList();
}

final List<WarningResearchEntry> warningResearchEntries =
    parseWarningResearch(kWarningResearchJson);

String warningResearchDisclaimer({required bool norwegian}) {
  final decoded = json.decode(kWarningResearchJson) as Map<String, dynamic>;
  return norwegian
      ? decoded['disclaimer_nb'] as String
      : decoded['disclaimer_en'] as String;
}
