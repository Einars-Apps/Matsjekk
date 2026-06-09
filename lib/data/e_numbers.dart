/// Norwegian descriptions for E-numbers (food additives).
///
/// Source/registers: the EU food additive database (Regulation (EC)
/// No 1333/2008) and the OpenFoodFacts additives taxonomy. Keys are normalized
/// E-codes without sub-letters (e.g. "E300", not "E300i"). Use
/// [eNumberDescription] to look up a description for an arbitrary code.
const Map<String, String> eNumberDescriptions = {
  // --- Fargestoffer (E100–E199) ---
  'E100': 'Kurkumin (gurkemeie) – gult naturlig fargestoff.',
  'E101': 'Riboflavin (vitamin B2) – gult fargestoff.',
  'E102': 'Tartrazin – gult syntetisk fargestoff. Kan gi reaksjon hos enkelte.',
  'E104': 'Kinolingult – gult syntetisk fargestoff.',
  'E110': 'Paraoransje (Sunset Yellow) – oransje syntetisk fargestoff.',
  'E120': 'Karmin/koisjenill – rødt fargestoff laget av insekter.',
  'E122': 'Azorubin (karmoisin) – rødt syntetisk fargestoff.',
  'E124': 'Ponceau 4R (cochenillerødt A) – rødt syntetisk fargestoff.',
  'E127': 'Erytrosin – rødt syntetisk fargestoff.',
  'E129': 'Allurarødt AC – rødt syntetisk fargestoff.',
  'E131': 'Patentblått V – blått syntetisk fargestoff.',
  'E132': 'Indigotin (indigokarmin) – blått syntetisk fargestoff.',
  'E133': 'Briljantblått FCF – blått syntetisk fargestoff.',
  'E140': 'Klorofyll – grønt naturlig fargestoff.',
  'E141': 'Kobberkomplekser av klorofyll – grønt fargestoff.',
  'E142': 'Grønt S – grønt syntetisk fargestoff.',
  'E150A': 'Karamellfarge (vanlig) – brunt fargestoff.',
  'E150B': 'Karamellfarge (kaustisk sulfitt) – brunt fargestoff.',
  'E150C': 'Karamellfarge (ammoniakkprosess) – brunt fargestoff.',
  'E150D': 'Karamellfarge (sulfitt-ammoniakk) – brunt fargestoff, vanlig i cola.',
  'E151': 'Briljantsort BN – sort syntetisk fargestoff.',
  'E153': 'Vegetabilsk kull (karbon) – sort fargestoff.',
  'E155': 'Brunt HT – brunt syntetisk fargestoff.',
  'E160A': 'Karoten – oransje/gult fargestoff, forløper til vitamin A.',
  'E160B': 'Annatto (bixin) – oransje naturlig fargestoff.',
  'E160C': 'Paprikaekstrakt – rødt naturlig fargestoff.',
  'E160D': 'Lykopen – rødt naturlig fargestoff (fra tomat).',
  'E160E': 'Beta-apo-8′-karotenal – oransje fargestoff.',
  'E161B': 'Lutein – gult naturlig fargestoff.',
  'E162': 'Rødbetrødt (betanin) – rødt naturlig fargestoff.',
  'E163': 'Antocyaniner – rødt/blått fargestoff fra bær og frukt.',
  'E170': 'Kalsiumkarbonat – hvitt fargestoff/surhetsregulerende.',
  'E171': 'Titandioksid – hvitt fargestoff. Forbudt som tilsetning i EU fra 2022.',
  'E172': 'Jernoksider og -hydroksider – gult/rødt/sort fargestoff.',
  'E173': 'Aluminium – sølvfarget fargestoff (overflate).',
  'E174': 'Sølv – fargestoff (overflate, dekor).',
  'E175': 'Gull – fargestoff (overflate, dekor).',
  'E180': 'Litolrubin BK – rødt fargestoff (bl.a. på osteskorpe).',

  // --- Konserveringsmidler (E200–E299) ---
  'E200': 'Sorbinsyre – konserveringsmiddel mot mugg og gjær.',
  'E202': 'Kaliumsorbat – konserveringsmiddel mot mugg og gjær.',
  'E203': 'Kalsiumsorbat – konserveringsmiddel.',
  'E210': 'Benzosyre – konserveringsmiddel.',
  'E211': 'Natriumbenzoat – konserveringsmiddel, vanlig i brus.',
  'E212': 'Kaliumbenzoat – konserveringsmiddel.',
  'E213': 'Kalsiumbenzoat – konserveringsmiddel.',
  'E214': 'Etyl-p-hydroksybenzoat – konserveringsmiddel (paraben).',
  'E218': 'Metyl-p-hydroksybenzoat – konserveringsmiddel (paraben).',
  'E220': 'Svoveldioksid – konserveringsmiddel/antioksidant. Kan gi reaksjon hos astmatikere.',
  'E221': 'Natriumsulfitt – konserveringsmiddel og antioksidant.',
  'E222': 'Natriumhydrogensulfitt – konserveringsmiddel.',
  'E223': 'Natriummetabisulfitt – konserveringsmiddel og antioksidant.',
  'E224': 'Kaliummetabisulfitt – konserveringsmiddel.',
  'E249': 'Kaliumnitritt – konserveringsmiddel i kjøttvarer.',
  'E250': 'Natriumnitritt – konserveringsmiddel i bacon og pølser.',
  'E251': 'Natriumnitrat – konserveringsmiddel i kjøttvarer.',
  'E252': 'Kaliumnitrat – konserveringsmiddel, bl.a. i spekemat.',
  'E260': 'Eddiksyre – surhetsregulerende/konserveringsmiddel.',
  'E261': 'Kaliumacetat – surhetsregulerende middel.',
  'E262': 'Natriumacetat – surhetsregulerende middel.',
  'E270': 'Melkesyre – surhetsregulerende middel.',
  'E280': 'Propionsyre – konserveringsmiddel mot mugg (bl.a. i brød).',
  'E281': 'Natriumpropionat – konserveringsmiddel.',
  'E282': 'Kalsiumpropionat – konserveringsmiddel (bl.a. i brød).',
  'E290': 'Karbondioksid – kullsyre/pakkegass.',
  'E296': 'Eplesyre – surhetsregulerende middel.',
  'E297': 'Fumarsyre – surhetsregulerende middel.',

  // --- Antioksidanter og surhetsregulerende (E300–E399) ---
  'E300': 'Askorbinsyre (vitamin C) – antioksidant.',
  'E301': 'Natriumaskorbat – antioksidant (vitamin C-salt).',
  'E302': 'Kalsiumaskorbat – antioksidant.',
  'E304': 'Askorbylpalmitat – antioksidant (fettløselig vitamin C).',
  'E306': 'Tokoferol (vitamin E) – naturlig antioksidant.',
  'E307': 'Alfa-tokoferol – antioksidant (vitamin E).',
  'E316': 'Natriumerytorbat – antioksidant.',
  'E319': 'TBHQ – syntetisk antioksidant.',
  'E320': 'BHA – syntetisk antioksidant.',
  'E321': 'BHT – syntetisk antioksidant.',
  'E322': 'Lecitin – emulgator, ofte fra soya eller solsikke.',
  'E325': 'Natriumlaktat – surhetsregulerende/fuktbevarende.',
  'E326': 'Kaliumlaktat – surhetsregulerende middel.',
  'E327': 'Kalsiumlaktat – surhetsregulerende middel.',
  'E330': 'Sitronsyre – surhetsregulerende middel og antioksidant.',
  'E331': 'Natriumsitrat – surhetsregulerende middel.',
  'E332': 'Kaliumsitrat – surhetsregulerende middel.',
  'E333': 'Kalsiumsitrat – surhetsregulerende middel.',
  'E334': 'Vinsyre – surhetsregulerende middel.',
  'E335': 'Natriumtartrat – surhetsregulerende middel.',
  'E336': 'Kaliumtartrat – surhetsregulerende middel.',
  'E338': 'Fosforsyre – surhetsregulerende middel, vanlig i cola.',
  'E339': 'Natriumfosfat – surhetsregulerende og stabilisator.',
  'E340': 'Kaliumfosfat – surhetsregulerende middel/stabilisator.',
  'E341': 'Kalsiumfosfat – surhetsregulerende/hevemiddel.',
  'E343': 'Magnesiumfosfat – surhetsregulerende middel.',
  'E392': 'Ekstrakt av rosmarin – naturlig antioksidant.',

  // --- Fortykningsmidler, stabilisatorer, emulgatorer (E400–E499) ---
  'E400': 'Alginsyre – fortykningsmiddel fra tang.',
  'E401': 'Natriumalginat – fortykningsmiddel fra tang.',
  'E402': 'Kaliumalginat – fortykningsmiddel.',
  'E406': 'Agar – geleringsmiddel fra alger.',
  'E407': 'Karragenan – fortykningsmiddel fra rødalger.',
  'E410': 'Johannesbrødkjernemel – naturlig fortykningsmiddel.',
  'E412': 'Guarkjernemel – naturlig fortykningsmiddel.',
  'E413': 'Tragantgummi – fortykningsmiddel/stabilisator.',
  'E414': 'Gummi arabicum (akasiegummi) – stabilisator.',
  'E415': 'Xantangummi – fortykningsmiddel.',
  'E417': 'Taragummi – fortykningsmiddel.',
  'E418': 'Gellangummi – fortykningsmiddel/geleringsmiddel.',
  'E420': 'Sorbitol – sukkeralkohol/søtningsmiddel.',
  'E421': 'Mannitol – sukkeralkohol/søtningsmiddel.',
  'E422': 'Glyserol – fuktbevarende middel.',
  'E440': 'Pektin – geleringsmiddel fra frukt, brukes i syltetøy.',
  'E450': 'Difosfater – hevemiddel/stabilisator.',
  'E451': 'Trifosfater – stabilisator (bl.a. i kjøttvarer).',
  'E452': 'Polyfosfater – stabilisator.',
  'E460': 'Cellulose – fortykningsmiddel/fyllstoff.',
  'E461': 'Metylcellulose – fortykningsmiddel.',
  'E464': 'Hydroksypropylmetylcellulose – fortykningsmiddel.',
  'E466': 'Karboksymetylcellulose (CMC) – fortykningsmiddel.',
  'E471': 'Mono- og diglyserider av fettsyrer – emulgator.',
  'E472A': 'Eddiksyreestere av mono-/diglyserider – emulgator.',
  'E472B': 'Melkesyreestere av mono-/diglyserider – emulgator.',
  'E472C': 'Sitronsyreestere av mono-/diglyserider – emulgator.',
  'E472E': 'Estere av mono- og diglyserider – emulgator, vanlig i brød.',
  'E473': 'Sukkerestere av fettsyrer – emulgator.',
  'E475': 'Polyglyserolestere av fettsyrer – emulgator.',
  'E476': 'Polyglyserol-polyrisinoleat (PGPR) – emulgator (bl.a. i sjokolade).',
  'E481': 'Natriumstearoyllaktylat – emulgator (bl.a. i brød).',
  'E482': 'Kalsiumstearoyllaktylat – emulgator.',
  'E491': 'Sorbitanmonostearat – emulgator.',

  // --- pH-regulering og antiklumpemidler (E500–E599) ---
  'E500': 'Natriumkarbonat – hevemiddel/surhetsregulerende.',
  'E501': 'Kaliumkarbonat – surhetsregulerende middel.',
  'E503': 'Ammoniumkarbonat (hjortetakksalt) – hevemiddel.',
  'E504': 'Magnesiumkarbonat – surhetsregulerende/antiklumpemiddel.',
  'E507': 'Saltsyre – surhetsregulerende middel.',
  'E509': 'Kalsiumklorid – stabilisator/fortykningsmiddel.',
  'E516': 'Kalsiumsulfat – stabilisator/fast stoff.',
  'E524': 'Natriumhydroksid – surhetsregulerende middel.',
  'E551': 'Silisiumdioksid – antiklumpemiddel.',
  'E552': 'Kalsiumsilikat – antiklumpemiddel.',
  'E553B': 'Talkum – antiklumpemiddel/overflatemiddel.',
  'E575': 'Glukonsyrelakton – surhetsregulerende/hevemiddel.',

  // --- Smaksforsterkere (E600–E699) ---
  'E620': 'Glutaminsyre – smaksforsterker.',
  'E621': 'Mononatriumglutamat (MSG) – smaksforsterker.',
  'E622': 'Monokaliumglutamat – smaksforsterker.',
  'E627': 'Dinatriumguanylat – smaksforsterker.',
  'E631': 'Dinatriuminosinat – smaksforsterker.',
  'E635': 'Dinatrium-5′-ribonukleotid – smaksforsterker.',

  // --- Glansmidler, gasser og diverse (E900–E999) ---
  'E900': 'Dimetylpolysiloksan – skumdempende middel.',
  'E901': 'Bivoks – overflatebehandling/glansmiddel.',
  'E903': 'Karnaubavoks – glansmiddel, bl.a. på godteri.',
  'E904': 'Skjellakk – glansmiddel (overflate).',
  'E920': 'L-cystein – melbehandlingsmiddel (bl.a. i bakverk).',
  'E938': 'Argon – pakkegass.',
  'E939': 'Helium – pakkegass.',
  'E941': 'Nitrogen – pakkegass.',
  'E942': 'Lystgass (dinitrogenoksid) – drivgass (bl.a. i kremfløte).',
  'E948': 'Oksygen – pakkegass.',
  'E950': 'Acesulfam K – kunstig søtningsmiddel.',
  'E951': 'Aspartam – kunstig søtningsmiddel.',
  'E952': 'Cyklamat – kunstig søtningsmiddel.',
  'E953': 'Isomalt – sukkeralkohol/søtningsmiddel.',
  'E954': 'Sakkarin – kunstig søtningsmiddel.',
  'E955': 'Sukralose – kunstig søtningsmiddel.',
  'E957': 'Taumatin – søtningsmiddel/smaksforsterker.',
  'E960': 'Steviolglykosider (stevia) – søtningsmiddel fra planten stevia.',
  'E961': 'Neotam – kunstig søtningsmiddel.',
  'E965': 'Maltitol – sukkeralkohol/søtningsmiddel.',
  'E966': 'Laktitol – sukkeralkohol/søtningsmiddel.',
  'E967': 'Xylitol – sukkeralkohol/søtningsmiddel.',
  'E968': 'Erytritol – sukkeralkohol/søtningsmiddel.',

  // --- Øvrige (E1000+) ---
  'E1100': 'Amylase – enzym (bl.a. i bakverk).',
  'E1103': 'Invertase – enzym.',
  'E1105': 'Lysozym – konserveringsmiddel/enzym.',
  'E1400': 'Dekstrin – modifisert stivelse/fortykningsmiddel.',
  'E1404': 'Oksidert stivelse – fortykningsmiddel.',
  'E1410': 'Monostivelsesfosfat – modifisert stivelse.',
  'E1412': 'Distivelsesfosfat – modifisert stivelse/fortykningsmiddel.',
  'E1414': 'Acetylert distivelsesfosfat – modifisert stivelse.',
  'E1420': 'Acetylert stivelse – modifisert stivelse.',
  'E1422': 'Acetylert distivelsesadipat – modifisert stivelse.',
  'E1442': 'Hydroksypropyldistivelsesfosfat – modifisert stivelse.',
  'E1450': 'Stivelsesnatriumoktenylsuksinat – emulgator/stabilisator.',
  'E1505': 'Trietylsitrat – bæremiddel/løsemiddel.',
  'E1510': 'Etanol – løsemiddel/bæremiddel.',
  'E1518': 'Glyseroltriacetat (triacetin) – fuktbevarende/bæremiddel.',
  'E1520': 'Propylenglykol – fuktbevarende middel/bæremiddel.',
};


/// Looks up a Norwegian description for an E-number code.
///
/// Handles variants such as "E300i", "E 300", "300" and lowercase input by
/// normalizing to the base code (e.g. "E300"). Returns `null` when the code
/// is not in [eNumberDescriptions].
String? eNumberDescription(String code) {
  // Keep only alphanumerics, uppercase, ensure leading "E".
  var normalized = code.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
  if (normalized.isEmpty) return null;
  if (!normalized.startsWith('E')) {
    normalized = 'E$normalized';
  }
  // Exact match first (covers entries with sub-letters like E150A, E472E).
  final exact = eNumberDescriptions[normalized];
  if (exact != null) return exact;
  // Strip trailing letters/sub-codes (e.g. E300I -> E300) and retry.
  final match = RegExp(r'^E(\d+)').firstMatch(normalized);
  if (match != null) {
    return eNumberDescriptions['E${match.group(1)}'];
  }
  return null;
}
