// GENERATED from docs/data/bovaer_processor_status.json – keep in sync
// (test/bovaer_processor_status_test.dart verifies). Every entry must cite
// at least one fetched source URL with date. Unknown = 'ukjent', never red.

class BovaerSource {
  final String url;
  final String date;
  final String note;
  const BovaerSource({required this.url, required this.date, required this.note});
}

class BovaerProcessorStatus {
  final String id;
  final String company;
  final String country;
  final List<String> aliases;
  final String role;
  /// bruker | har_brukt | forsok | stoppet | ukjent | ikke_tillatt
  final String status;
  /// red | yellow | green | none
  final String appColor;
  /// ISO date. Yellow rule: products made before this date may be affected.
  final String? producedBefore;
  final String statusDate;
  final List<BovaerSource> sources;
  final String noteNb;

  const BovaerProcessorStatus({
    required this.id,
    required this.company,
    required this.country,
    required this.aliases,
    required this.role,
    required this.status,
    required this.appColor,
    required this.producedBefore,
    required this.statusDate,
    required this.sources,
    required this.noteNb,
  });
}

const List<BovaerProcessorStatus> bovaerProcessorStatuses = [
  BovaerProcessorStatus(
    id: 'no_tine',
    company: 'TINE SA',
    country: 'NO',
    aliases: ['tine', 'jarlsberg', 'norvegia'],
    role: 'processor',
    status: 'stoppet',
    appColor: 'yellow',
    producedBefore: '2026-01-22',
    statusDate: '2026-01-22',
    sources: [
      BovaerSource(url: 'https://www.tine.no/presserom/nyhetsarkiv/tine-stanser-bruk-av-melk-fra-kyr-som-er-foret-med-bovaer', date: '2026-01-22', note: 'TINE stanser bruk av melk fra kyr foret med Bovaer.'),
      BovaerSource(url: 'https://medlem.tine.no/aktuelt-fra-tine/bruk-av-bovaer-pa-norske-garder-settes-pa-pause', date: '2025-11-12', note: 'Norsk melkeråvare pauser Bovaer på ca. 70 gårder; kontrollert forsøk ved NMBU fortsetter.'),
      BovaerSource(url: 'https://borsen.dagbladet.no/nyheter/raser-mot-tine-svartelistet/84039624', date: '2025-12-31', note: 'TINE bekrefter at NMBU-melk inngikk i TINEs ordinære melkestrøm.'),
    ],
    noteNb: 'Bovaer pauset på gårdene 12.11.2025; NMBU-forsøksmelk inngikk i TINEs ordinære melkestrøm til TINE stanset 22.1.2026. Gul: produkter produsert før 22.1.2026.',
  ),
  BovaerProcessorStatus(
    id: 'no_norsk_melkeravare',
    company: 'Norsk melkeråvare (NMR)',
    country: 'NO',
    aliases: ['norsk melkeråvare'],
    role: 'raw_milk_supplier',
    status: 'stoppet',
    appColor: 'yellow',
    producedBefore: '2026-01-22',
    statusDate: '2026-02-04',
    sources: [
      BovaerSource(url: 'https://medlem.tine.no/aktuelt-fra-tine/bruk-av-bovaer-pa-norske-garder-settes-pa-pause', date: '2025-11-12', note: 'Norsk melkeråvare pauser Bovaer på ca. 70 gårder; kontrollert forsøk ved NMBU fortsetter.'),
      BovaerSource(url: 'https://medlem.tine.no/om-oss/om-norsk-melker%C3%A5vare/slik-er-melkeprisen-bygd-opp', date: 'udatert', note: 'Norsk melkeråvare selger råmelk til TINE, Synnøve Finden, Normilk, Q-Meieriene, Rørosmeieriet, Mondelēz Norge og Valdresmeieriet.'),
      BovaerSource(url: 'https://www.bondebladet.no/felles-meieri-nei-til-bovaer/s/5-150-146202', date: '2026-02-04', note: 'Tine, Q, Synnøve Finden, Normilk, Mondelez og Rørosmeieriet: ingen ønsker gjeninnføring; kriterier ikke oppfylt.'),
    ],
    noteNb: 'Markedsregulator som selger råmelk til alle meierier. Pause på ca. 70 gårder fra 12.11.2025; kriterier for gjeninnføring ikke oppfylt per feb. 2026.',
  ),
  BovaerProcessorStatus(
    id: 'no_q_meieriene',
    company: 'Q-Meieriene (Kavli Norge)',
    country: 'NO',
    aliases: ['q-meieriene', 'q meieriene'],
    role: 'processor',
    status: 'stoppet',
    appColor: 'yellow',
    producedBefore: '2025-11-12',
    statusDate: '2025-11-12',
    sources: [
      BovaerSource(url: 'https://kommunikasjon.ntb.no/pressemelding/17998816/pruduktnyheter-fra-q-q-klimamelk-et-naturlig-valg-for-den-klimabevisste?lang=no&publisherId=89709', date: '2023-09-12', note: 'Q Klimamelk fra 3 Q-gårder med metanhemmende fôrtilskudd, lansert 17.9.2023.'),
      BovaerSource(url: 'https://www.q-meieriene.no/nyheter/q-fansen-har-blitt-hort', date: '2025-11-12', note: 'Q-bønder ikke brukt Bovaer siden 2024; NMR-andelen nå også uten Bovaer.'),
      BovaerSource(url: 'https://www.q-meieriene.no/om-q-meieriene/apenhetsloven', date: '2026-06-26', note: 'Q-Meieriene eies 100 % av Kavli Norge AS.'),
    ],
    noteNb: 'Q Klimamelk (Bovaer, 3 Q-gårder) fra sept. 2023; egne bønder sluttet i 2024; NMR-andel kunne inneholde Bovaer-melk til 12.11.2025 ifølge Q selv.',
  ),
  BovaerProcessorStatus(
    id: 'no_kavli',
    company: 'Kavli Norge',
    country: 'NO',
    aliases: ['kavli'],
    role: 'brand_owner',
    status: 'ukjent',
    appColor: 'yellow',
    producedBefore: '2025-11-12',
    statusDate: '2025-11-12',
    sources: [
      BovaerSource(url: 'https://www.q-meieriene.no/om-q-meieriene/apenhetsloven', date: '2026-06-26', note: 'Q-Meieriene eies 100 % av Kavli Norge AS.'),
      BovaerSource(url: 'https://www.q-meieriene.no/nyheter/q-fansen-har-blitt-hort', date: '2025-11-12', note: 'Q-bønder ikke brukt Bovaer siden 2024; NMR-andelen nå også uten Bovaer.'),
    ],
    noteNb: 'Eier Q-Meieriene. Egen Bovaer-uttalelse for Kavli-merket ikke funnet (ukjent / ikke dokumentert); følger Q-datoen.',
  ),
  BovaerProcessorStatus(
    id: 'no_synnove',
    company: 'Synnøve Finden',
    country: 'NO',
    aliases: ['synnøve', 'synnøve finden', 'synnove'],
    role: 'processor',
    status: 'ukjent',
    appColor: 'yellow',
    producedBefore: '2026-01-22',
    statusDate: '2026-02-04',
    sources: [
      BovaerSource(url: 'https://www.synnove.no/sporsmal-og-svar-om-selskapet/', date: 'udatert', note: '\'Synnøve kjøper melk fra Tine.\''),
      BovaerSource(url: 'https://medlem.tine.no/om-oss/om-norsk-melker%C3%A5vare/slik-er-melkeprisen-bygd-opp', date: 'udatert', note: 'Norsk melkeråvare selger råmelk til TINE, Synnøve Finden, Normilk, Q-Meieriene, Rørosmeieriet, Mondelēz Norge og Valdresmeieriet.'),
      BovaerSource(url: 'https://www.bondebladet.no/felles-meieri-nei-til-bovaer/s/5-150-146202', date: '2026-02-04', note: 'Tine, Q, Synnøve Finden, Normilk, Mondelez og Rørosmeieriet: ingen ønsker gjeninnføring; kriterier ikke oppfylt.'),
    ],
    noteNb: 'Kjøper melk fra Tine/NMR. Ingen egen offentlig Bovaer-uttalelse funnet; deltok på NMR-møtet. Gul fordi NMR-råmelk kan ha inneholdt Bovaer-melk; om NMBU-melk gikk til andre enn TINE etter 12.11.2025 er ukjent.',
  ),
  BovaerProcessorStatus(
    id: 'no_normilk',
    company: 'Normilk',
    country: 'NO',
    aliases: ['normilk'],
    role: 'processor',
    status: 'ukjent',
    appColor: 'yellow',
    producedBefore: '2026-01-22',
    statusDate: '2026-02-04',
    sources: [
      BovaerSource(url: 'https://medlem.tine.no/om-oss/om-norsk-melker%C3%A5vare/slik-er-melkeprisen-bygd-opp', date: 'udatert', note: 'Norsk melkeråvare selger råmelk til TINE, Synnøve Finden, Normilk, Q-Meieriene, Rørosmeieriet, Mondelēz Norge og Valdresmeieriet.'),
      BovaerSource(url: 'https://www.bondebladet.no/felles-meieri-nei-til-bovaer/s/5-150-146202', date: '2026-02-04', note: 'Tine, Q, Synnøve Finden, Normilk, Mondelez og Rørosmeieriet: ingen ønsker gjeninnføring; kriterier ikke oppfylt.'),
    ],
    noteNb: 'NMR-kunde; ingen egen uttalelse funnet.',
  ),
  BovaerProcessorStatus(
    id: 'no_mondelez',
    company: 'Mondelēz Norge',
    country: 'NO',
    aliases: ['freia', 'mondelez'],
    role: 'processor',
    status: 'ukjent',
    appColor: 'yellow',
    producedBefore: '2026-01-22',
    statusDate: '2026-02-04',
    sources: [
      BovaerSource(url: 'https://medlem.tine.no/om-oss/om-norsk-melker%C3%A5vare/slik-er-melkeprisen-bygd-opp', date: 'udatert', note: 'Norsk melkeråvare selger råmelk til TINE, Synnøve Finden, Normilk, Q-Meieriene, Rørosmeieriet, Mondelēz Norge og Valdresmeieriet.'),
      BovaerSource(url: 'https://www.bondebladet.no/felles-meieri-nei-til-bovaer/s/5-150-146202', date: '2026-02-04', note: 'Tine, Q, Synnøve Finden, Normilk, Mondelez og Rørosmeieriet: ingen ønsker gjeninnføring; kriterier ikke oppfylt.'),
    ],
    noteNb: 'NMR-kunde (melk til sjokolade); ingen egen uttalelse funnet.',
  ),
  BovaerProcessorStatus(
    id: 'no_valdresmeieriet',
    company: 'Valdresmeieriet',
    country: 'NO',
    aliases: ['valdresmeieriet'],
    role: 'processor',
    status: 'ukjent',
    appColor: 'yellow',
    producedBefore: '2026-01-22',
    statusDate: 'udatert',
    sources: [
      BovaerSource(url: 'https://medlem.tine.no/om-oss/om-norsk-melker%C3%A5vare/slik-er-melkeprisen-bygd-opp', date: 'udatert', note: 'Norsk melkeråvare selger råmelk til TINE, Synnøve Finden, Normilk, Q-Meieriene, Rørosmeieriet, Mondelēz Norge og Valdresmeieriet.'),
    ],
    noteNb: 'NMR-kunde; ingen egen uttalelse funnet.',
  ),
  BovaerProcessorStatus(
    id: 'no_fjordland',
    company: 'Fjordland',
    country: 'NO',
    aliases: ['fjordland'],
    role: 'processor',
    status: 'ukjent',
    appColor: 'yellow',
    producedBefore: '2026-01-22',
    statusDate: 'udatert',
    sources: [
      BovaerSource(url: 'https://www.fjordland.no/om-fjordland', date: 'udatert', note: 'Eies av TINE 51 %, Nortura 39 %, Hoff 10 %; produksjon hovedsakelig på eiernes anlegg.'),
      BovaerSource(url: 'https://www.tine.no/presserom/nyhetsarkiv/tine-stanser-bruk-av-melk-fra-kyr-som-er-foret-med-bovaer', date: '2026-01-22', note: 'TINE stanser bruk av melk fra kyr foret med Bovaer.'),
    ],
    noteNb: 'Eid av TINE 51 %, Nortura 39 %, Hoff 10 % (ikke Coop). Produksjon hovedsakelig på eiernes anlegg; følger TINE-datoen.',
  ),
  BovaerProcessorStatus(
    id: 'no_ostecompagniet',
    company: 'OsteCompagniet',
    country: 'NO',
    aliases: ['ostecompagniet'],
    role: 'processor',
    status: 'ukjent',
    appColor: 'yellow',
    producedBefore: '2026-01-22',
    statusDate: '2020-05-25',
    sources: [
      BovaerSource(url: 'https://landbruk24.no/ostecompagniet-blir-en-del-av-tine/', date: '2020-05-25', note: 'OsteCompagniet integreres i TINE fra 1.7.2020.'),
      BovaerSource(url: 'https://www.tine.no/presserom/nyhetsarkiv/tine-stanser-bruk-av-melk-fra-kyr-som-er-foret-med-bovaer', date: '2026-01-22', note: 'TINE stanser bruk av melk fra kyr foret med Bovaer.'),
    ],
    noteNb: 'Del av TINE fra 1.7.2020; følger TINE-datoen. Importerte oster: opprinnelse ukjent.',
  ),
  BovaerProcessorStatus(
    id: 'no_rorosmeieriet',
    company: 'Rørosmeieriet',
    country: 'NO',
    aliases: ['rørosmeieriet', 'røros'],
    role: 'processor',
    status: 'ikke_tillatt',
    appColor: 'green',
    producedBefore: null,
    statusDate: 'udatert',
    sources: [
      BovaerSource(url: 'https://rorosmeieriet.no/informasjon-om-okologisk-drift-og-metanhemmeren-bovaer/', date: 'udatert', note: 'Heløkologisk; syntetisk Bovaer ikke tillatt i økologisk drift; økologisk melk fra NMR hentes på egne ruter.'),
    ],
    noteNb: 'Heløkologisk; Bovaer ikke tillatt i økologisk drift; økologisk melk hentes separat.',
  ),
  BovaerProcessorStatus(
    id: 'dk_konvensjonelle_meierier',
    company: 'Danske konvensjonelle melkeprodusenter (sektor)',
    country: 'DK',
    aliases: [],
    role: 'sector',
    status: 'bruker',
    appColor: 'red',
    producedBefore: null,
    statusDate: '2026-09-30',
    sources: [
      BovaerSource(url: 'https://mgtp.dk/nyheder/2026/sep/udvidede-muligheder-for-at-undtage-koeer-fra-fodring-med-metanreduce-rende-foder-fra-oktober-2026', date: '2026-09-30', note: 'Krav i 2026: Bovaer 80 dager/år for konvensjonelle besetninger >50 årskyr; utvidet unntak fra okt. 2026.'),
      BovaerSource(url: 'https://foedevarestyrelsen.dk/foder/markedsfoering-af-foder/fodertilsaetningsstoffer/bovaer', date: 'udatert (lest 2026-10-25)', note: 'Danske studier 2026-2028; første undersøkelse kunne verken påvise eller avvise sammenheng; neste delresultater 2027; EFSA ventes slutten av 2026.'),
      BovaerSource(url: 'https://dca.au.dk/aktuelt/nyheder/vis/artikel/ny-rapport-om-bovaer-ingen-samlet-stigning-i-doedelighed-eller-fald-i-maelkeydelse', date: '2026-05-01', note: 'AU-rapport (73 besetninger): ingen samlet økning i dødelighet/fall i ytelse, men alvorlige enkeltbesetninger og åpne spørsmål.'),
    ],
    noteNb: 'Lovkrav i 2026: Bovaer 80 dager/år (eller fettalternativ) for konvensjonelle besetninger >50 årskyr; unntak for syke dyr. Økologisk unntatt.',
  ),
  BovaerProcessorStatus(
    id: 'dk_arla',
    company: 'Arla Foods (dansk konvensjonell melk)',
    country: 'DK',
    aliases: ['arla'],
    role: 'processor',
    status: 'bruker',
    appColor: 'red',
    producedBefore: null,
    statusDate: '2026-09-30',
    sources: [
      BovaerSource(url: 'https://psst-nyt.dk/arla-svarer-paa-pssts-afsloering-bovaer-reducerer-koeernes-klimaaftryk/', date: '2025-09-18', note: 'Arla Danmark (Rune Pedersen) sitert: Arla anbefaler andelshaverne Bovaer framfor ekstra fett. Sekundærkilde (Psst!) med ordrett svar.'),
      BovaerSource(url: 'https://mgtp.dk/nyheder/2026/sep/udvidede-muligheder-for-at-undtage-koeer-fra-fodring-med-metanreduce-rende-foder-fra-oktober-2026', date: '2026-09-30', note: 'Krav i 2026: Bovaer 80 dager/år for konvensjonelle besetninger >50 årskyr; utvidet unntak fra okt. 2026.'),
      BovaerSource(url: 'https://our-company.dsm-firmenich.com/en/our-company/news/press-releases/legacy-archive/2022/arla-foods-and-dsm-start-large-scale-on-farm-pilot-to-reduce-greenhouse-gas-emissions.html', date: '2022-04-20', note: 'Arla/DSM-pilot: 10 000 kyr, 50+ gårder i Danmark, Sverige og Tyskland.'),
    ],
    noteNb: 'Arla anbefaler andelshaverne Bovaer framfor fett (Arla-sitat 16.9.2025 via Psst!). Økologiske Arla-produkter omfattes ikke.',
  ),
  BovaerProcessorStatus(
    id: 'dk_lurpak',
    company: 'Lurpak (Arla)',
    country: 'DK',
    aliases: ['lurpak'],
    role: 'brand',
    status: 'bruker',
    appColor: 'red',
    producedBefore: null,
    statusDate: '2026-10-22',
    sources: [
      BovaerSource(url: 'https://www.arla.dk/om-arla/nyheder/2026/pressrelease/danmarks-smoerhovedstad-fejrer-125-aar-med-lurpak-3473794/', date: '2026-10-22', note: '97 % av Lurpak produseres på Arlas meieri i Holstebro; resten hos Thise, Nørup og Bornholms Andelsmejeri.'),
      BovaerSource(url: 'https://mgtp.dk/nyheder/2026/sep/udvidede-muligheder-for-at-undtage-koeer-fra-fodring-med-metanreduce-rende-foder-fra-oktober-2026', date: '2026-09-30', note: 'Krav i 2026: Bovaer 80 dager/år for konvensjonelle besetninger >50 årskyr; utvidet unntak fra okt. 2026.'),
      BovaerSource(url: 'https://psst-nyt.dk/arla-svarer-paa-pssts-afsloering-bovaer-reducerer-koeernes-klimaaftryk/', date: '2025-09-18', note: 'Arla Danmark (Rune Pedersen) sitert: Arla anbefaler andelshaverne Bovaer framfor ekstra fett. Sekundærkilde (Psst!) med ordrett svar.'),
    ],
    noteNb: 'Utledet: 97 % produseres i Holstebro av dansk Arla-melk, som omfattes av det danske kravet. Ikke bekreftet per produkt. Økologisk Lurpak omfattes ikke.',
  ),
  BovaerProcessorStatus(
    id: 'dk_castello',
    company: 'Castello (Arla)',
    country: 'DK',
    aliases: ['castello'],
    role: 'brand',
    status: 'ukjent',
    appColor: 'yellow',
    producedBefore: null,
    statusDate: 'ukjent',
    sources: [
      BovaerSource(url: 'https://our-company.dsm-firmenich.com/en/our-company/news/press-releases/legacy-archive/2022/arla-foods-and-dsm-start-large-scale-on-farm-pilot-to-reduce-greenhouse-gas-emissions.html', date: '2022-04-20', note: 'Arla/DSM-pilot: 10 000 kyr, 50+ gårder i Danmark, Sverige og Tyskland.'),
      BovaerSource(url: 'https://mgtp.dk/nyheder/2026/sep/udvidede-muligheder-for-at-undtage-koeer-fra-fodring-med-metanreduce-rende-foder-fra-oktober-2026', date: '2026-09-30', note: 'Krav i 2026: Bovaer 80 dager/år for konvensjonelle besetninger >50 årskyr; utvidet unntak fra okt. 2026.'),
    ],
    noteNb: 'Arla-merke; produksjonssted/melkeopprinnelse per ost ikke dokumentert her. Gul inntil opprinnelse er avklart.',
  ),
  BovaerProcessorStatus(
    id: 'se_arla',
    company: 'Arla Foods (Sverige)',
    country: 'SE',
    aliases: ['arla'],
    role: 'processor',
    status: 'forsok',
    appColor: 'yellow',
    producedBefore: null,
    statusDate: '2022-04-20',
    sources: [
      BovaerSource(url: 'https://our-company.dsm-firmenich.com/en/our-company/news/press-releases/legacy-archive/2022/arla-foods-and-dsm-start-large-scale-on-farm-pilot-to-reduce-greenhouse-gas-emissions.html', date: '2022-04-20', note: 'Arla/DSM-pilot: 10 000 kyr, 50+ gårder i Danmark, Sverige og Tyskland.'),
    ],
    noteNb: 'Inngikk i 2022-piloten; nåværende bruk i Sverige ukjent / ikke dokumentert.',
  ),
  BovaerProcessorStatus(
    id: 'de_arla',
    company: 'Arla Foods (Tyskland)',
    country: 'DE',
    aliases: ['arla'],
    role: 'processor',
    status: 'forsok',
    appColor: 'yellow',
    producedBefore: null,
    statusDate: '2022-04-20',
    sources: [
      BovaerSource(url: 'https://our-company.dsm-firmenich.com/en/our-company/news/press-releases/legacy-archive/2022/arla-foods-and-dsm-start-large-scale-on-farm-pilot-to-reduce-greenhouse-gas-emissions.html', date: '2022-04-20', note: 'Arla/DSM-pilot: 10 000 kyr, 50+ gårder i Danmark, Sverige og Tyskland.'),
    ],
    noteNb: 'Inngikk i 2022-piloten; nåværende bruk i Tyskland ukjent / ikke dokumentert.',
  ),
  BovaerProcessorStatus(
    id: 'gb_arla',
    company: 'Arla Foods UK',
    country: 'GB',
    aliases: ['arla'],
    role: 'processor',
    status: 'stoppet',
    appColor: 'yellow',
    producedBefore: '2025-11-09',
    statusDate: '2025-11-09',
    sources: [
      BovaerSource(url: 'https://www.farminguk.com/news/arla-trial-sees-30-farmers-use-feed-additive-to-cut-emissions_65701.html', date: '2024-11-26', note: 'Arla UK-forsøk på 30 gårder sammen med Morrisons, Aldi og Tesco.'),
      BovaerSource(url: 'https://www.farminguk.com/news/arla-ends-methane-reducing-cow-feed-trial-as-review-begins_67520.html', date: '2025-11-09', note: 'Arla UK-forsøket avsluttet; resultater gjennomgås.'),
      BovaerSource(url: 'https://www.arlafoods.co.uk/arla-bovaer-statement/', date: 'udatert (lest 2026-10-25)', note: '\'Our UK projects on methane-reducing supplements have now ended.\''),
    ],
    noteNb: 'Forsøk på 30 gårder fra nov. 2024; avsluttet (rapportert 9.11.2025). Eksakt sluttdato ukjent – datoen er publiseringsdato.',
  ),
  BovaerProcessorStatus(
    id: 'gb_tesco',
    company: 'Tesco',
    country: 'GB',
    aliases: ['tesco'],
    role: 'retailer',
    status: 'forsok',
    appColor: 'yellow',
    producedBefore: '2025-11-09',
    statusDate: '2024-11-26',
    sources: [
      BovaerSource(url: 'https://www.farminguk.com/news/arla-trial-sees-30-farmers-use-feed-additive-to-cut-emissions_65701.html', date: '2024-11-26', note: 'Arla UK-forsøk på 30 gårder sammen med Morrisons, Aldi og Tesco.'),
      BovaerSource(url: 'https://www.farminguk.com/news/arla-ends-methane-reducing-cow-feed-trial-as-review-begins_67520.html', date: '2025-11-09', note: 'Arla UK-forsøket avsluttet; resultater gjennomgås.'),
    ],
    noteNb: 'Partner i Arla-forsøket (Arla-levert melk).',
  ),
  BovaerProcessorStatus(
    id: 'gb_aldi',
    company: 'Aldi UK',
    country: 'GB',
    aliases: ['aldi'],
    role: 'retailer',
    status: 'forsok',
    appColor: 'yellow',
    producedBefore: '2025-11-09',
    statusDate: '2024-11-26',
    sources: [
      BovaerSource(url: 'https://www.farminguk.com/news/arla-trial-sees-30-farmers-use-feed-additive-to-cut-emissions_65701.html', date: '2024-11-26', note: 'Arla UK-forsøk på 30 gårder sammen med Morrisons, Aldi og Tesco.'),
      BovaerSource(url: 'https://www.farminguk.com/news/arla-ends-methane-reducing-cow-feed-trial-as-review-begins_67520.html', date: '2025-11-09', note: 'Arla UK-forsøket avsluttet; resultater gjennomgås.'),
    ],
    noteNb: 'Partner i Arla-forsøket.',
  ),
  BovaerProcessorStatus(
    id: 'gb_morrisons',
    company: 'Morrisons',
    country: 'GB',
    aliases: ['morrisons'],
    role: 'retailer',
    status: 'forsok',
    appColor: 'yellow',
    producedBefore: '2025-11-09',
    statusDate: '2024-11-26',
    sources: [
      BovaerSource(url: 'https://www.farminguk.com/news/arla-trial-sees-30-farmers-use-feed-additive-to-cut-emissions_65701.html', date: '2024-11-26', note: 'Arla UK-forsøk på 30 gårder sammen med Morrisons, Aldi og Tesco.'),
      BovaerSource(url: 'https://www.farminguk.com/news/arla-ends-methane-reducing-cow-feed-trial-as-review-begins_67520.html', date: '2025-11-09', note: 'Arla UK-forsøket avsluttet; resultater gjennomgås.'),
    ],
    noteNb: 'Partner i Arla-forsøket.',
  ),
  BovaerProcessorStatus(
    id: 'nl_frieslandcampina',
    company: 'FrieslandCampina',
    country: 'NL',
    aliases: ['frieslandcampina', 'campina', 'friesche vlag'],
    role: 'processor',
    status: 'har_brukt',
    appColor: 'yellow',
    producedBefore: null,
    statusDate: '2023-03-30',
    sources: [
      BovaerSource(url: 'https://www.frieslandcampina.com/news/large-scale-pilot-proves-methane-reducing-feed-additive-bovaer-is-ready-for-roll-out-in-the-netherlands/', date: '2023-03-30', note: 'FrieslandCampina-pilot 2022: 158 gårder, 20 000 kyr; åpner for utrulling.'),
    ],
    noteNb: 'Pilot 2022 (158 gårder); utrulling åpnet 2023. Nåværende omfang ukjent / ikke dokumentert.',
  ),
  BovaerProcessorStatus(
    id: 'fi_valio',
    company: 'Valio',
    country: 'FI',
    aliases: ['valio'],
    role: 'processor',
    status: 'stoppet',
    appColor: 'yellow',
    producedBefore: '2026-02-09',
    statusDate: '2026-02-09',
    sources: [
      BovaerSource(url: 'https://www.valio.fi/artikkelit/tietoa-bovaer-rehunlisasta/', date: '2026-02-09', note: 'Valio stanser Bovaer-piloten (noen titalls gårder siden 2022) i påvente av EFSA.'),
    ],
    noteNb: 'Pilot på noen titalls gårder siden 2022, stanset 9.2.2026 i påvente av EFSA.',
  ),
  BovaerProcessorStatus(
    id: 'it_parmalat',
    company: 'Parmalat (Lactalis)',
    country: 'IT',
    aliases: ['parmalat'],
    role: 'processor',
    status: 'forsok',
    appColor: 'yellow',
    producedBefore: null,
    statusDate: '2023-09-04',
    sources: [
      BovaerSource(url: 'https://www.dsm-firmenich.com/anh/news/press-releases/2023/2023-09-04-trials-confirm-efficacy-of-a-methane-reducing-feed-supplement-for-ruminants-in-achieving-reductions-in-methane-emissions-by-dairy-cows.html', date: '2023-09-04', note: 'Parmalat (Lactalis) – forsøk ved Università Cattolica CERZOO i Italia.'),
    ],
    noteNb: 'Forsøk på universitetsgård 2023. Om melken gikk til Parmalat-produkter er ukjent.',
  ),
  BovaerProcessorStatus(
    id: 'fr_bel',
    company: 'Groupe Bel',
    country: 'FR',
    aliases: ['babybel', 'bel'],
    role: 'processor',
    status: 'forsok',
    appColor: 'yellow',
    producedBefore: null,
    statusDate: '2023-10-26',
    sources: [
      BovaerSource(url: 'https://www.groupe-bel.com/en/newsroom/press-releases/promising-pilot-test-to-reduce-enteric-methane-emissions-from-dairy-cows/', date: '2023-10-26', note: 'Bel/APBO-pilot på 5 gårder i Frankrike; utrulling i Bels slovakiske melkebasseng (Babybel til UK, DE, CZ, SK).'),
    ],
    noteNb: 'Pilot på 5 gårder i Frankrike (jan.–mars 2023); utrulling annonsert i Slovakia (Babybel til UK/DE/CZ/SK). Nåværende status ukjent.',
  ),
  BovaerProcessorStatus(
    id: 'ie_ornua',
    company: 'Ornua / Kerrygold',
    country: 'IE',
    aliases: ['ornua', 'kerrygold'],
    role: 'processor',
    status: 'ukjent',
    appColor: 'none',
    producedBefore: null,
    statusDate: '2024-12-18',
    sources: [
      BovaerSource(url: 'https://www.farmersjournal.ie/dairy/news/getting-rid-of-bovaer-is-not-an-option-ornua-848910', date: '2024-12-18', note: 'Ornua: å forkaste Bovaer er ikke et alternativ nå. Ingen dokumentert bruk i Kerrygold-melk.'),
    ],
    noteNb: 'Ingen dokumentert bruk i Kerrygold-melk. Ornua uttalte (des. 2024) at Bovaer ikke kan avskrives. Ikke flagg uten kilde.',
  ),
];

bool _aliasMatches(String text, String alias) {
  final a = alias.trim().toLowerCase();
  if (a.isEmpty) return false;
  // Whole-word match so 'tine' does not hit 'Valentine'/'Martine'.
  final pattern = RegExp('(^|[^a-z0-9æøåäöü])' + RegExp.escape(a) + r'($|[^a-z0-9æøåäöü])');
  return pattern.hasMatch(text.toLowerCase());
}

/// Returns the status entries matching brand/producer text for a country.
List<BovaerProcessorStatus> findBovaerProcessorStatuses(String text, {String? country}) {
  final c = country?.toUpperCase();
  return bovaerProcessorStatuses.where((e) {
    if (c != null && e.country != c) return false;
    return e.aliases.any((a) => _aliasMatches(text, a));
  }).toList();
}

/// Norwegian yellow-rule text, e.g. 'MULIG RISIKO: produkter produsert før 22.01.2026'.
String? bovaerProducedBeforeTextNb(BovaerProcessorStatus e) {
  final d = e.producedBefore;
  if (d == null || e.appColor != 'yellow') return null;
  final p = d.split('-');
  if (p.length != 3) return null;
  return 'MULIG RISIKO (${e.company}): produkter produsert før ${p[2]}.${p[1]}.${p[0]} kan stamme fra melk fra kyr foret med Bovaer. Kilde: ${e.sources.first.url}';
}
