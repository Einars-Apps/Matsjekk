// Curated explanations of common E-numbers (food additives).
//
// Each entry describes what the additive actually is, in plain language.
// `nb` = Norwegian, `en` = English. The UI falls back to English for
// locales without a dedicated translation, and to a generic message for
// E-numbers not in this list.
//
// Sources: EU additive regulation (EC) No 1333/2008, EFSA additive
// re-evaluations, and Matvaretabellen / Mattilsynet additive guidance.

class AdditiveInfo {
  final String name; // Short common name, e.g. "Sitronsyre"
  final String category; // e.g. "Surhetsregulerende middel"
  final String description; // Plain-language "what it actually is"
  final String? origin; // "Syntetisk" / "Naturlig" / "Naturidentisk"
  final String? background; // How it is made / where it comes from
  final String? healthRisk; // Plain-language health assessment

  const AdditiveInfo({
    required this.name,
    required this.category,
    required this.description,
    this.origin,
    this.background,
    this.healthRisk,
  });
}

// Norwegian explanations, keyed by uppercase E-number (e.g. "E300").
const Map<String, AdditiveInfo> _additivesNb = {
  'E100': AdditiveInfo(
    name: 'Kurkumin (gurkemeie)',
    category: 'Fargestoff',
    description:
        'Gul farge utvunnet fra gurkemeierot. Naturlig opprinnelse, regnes som trygt.',
  ),
  'E101': AdditiveInfo(
    name: 'Riboflavin (vitamin B2)',
    category: 'Fargestoff',
    description: 'Gult fargestoff som også er et B-vitamin. Naturlig forekommende.',
  ),
  'E102': AdditiveInfo(
    name: 'Tartrazin',
    category: 'Fargestoff (azofarge)',
    description:
        'Gul syntetisk azofarge. Kan gi allergiske reaksjoner hos enkelte og er knyttet til hyperaktivitet hos barn (advarselsmerking i EU).',
  ),
  'E104': AdditiveInfo(
    name: 'Kinolingult',
    category: 'Fargestoff',
    description:
        'Gul syntetisk farge. Knyttet til hyperaktivitet hos barn (advarselsmerking i EU).',
  ),
  'E110': AdditiveInfo(
    name: 'Paraoransje (Sunset Yellow)',
    category: 'Fargestoff (azofarge)',
    description:
        'Oransje syntetisk azofarge. Knyttet til hyperaktivitet hos barn (advarselsmerking i EU).',
  ),
  'E120': AdditiveInfo(
    name: 'Karmin (cochenille)',
    category: 'Fargestoff',
    description:
        'Rød farge laget av knuste cochenille-skjoldlus. Ikke vegansk; kan gi allergi hos enkelte.',
  ),
  'E122': AdditiveInfo(
    name: 'Azorubin (karmoisin)',
    category: 'Fargestoff (azofarge)',
    description:
        'Rød syntetisk azofarge. Knyttet til hyperaktivitet hos barn (advarselsmerking i EU).',
  ),
  'E124': AdditiveInfo(
    name: 'Ponceau 4R (cochenillerød A)',
    category: 'Fargestoff (azofarge)',
    description:
        'Rød syntetisk azofarge. Knyttet til hyperaktivitet hos barn (advarselsmerking i EU).',
  ),
  'E129': AdditiveInfo(
    name: 'Allurarød AC',
    category: 'Fargestoff (azofarge)',
    description:
        'Rød syntetisk azofarge. Knyttet til hyperaktivitet hos barn (advarselsmerking i EU).',
  ),
  'E131': AdditiveInfo(
    name: 'Patentblått V',
    category: 'Fargestoff',
    description: 'Blå syntetisk farge. Kan gi allergiske reaksjoner hos enkelte.',
  ),
  'E133': AdditiveInfo(
    name: 'Briljantblått FCF',
    category: 'Fargestoff',
    description: 'Blå syntetisk farge brukt i godteri og drikke.',
  ),
  'E140': AdditiveInfo(
    name: 'Klorofyll',
    category: 'Fargestoff',
    description: 'Grønt fargestoff fra planter. Naturlig opprinnelse.',
  ),
  'E150A': AdditiveInfo(
    name: 'Karamell (vanlig)',
    category: 'Fargestoff',
    description: 'Brun farge laget ved oppvarming av sukker. Vanlig i brus og saus.',
  ),
  'E150C': AdditiveInfo(
    name: 'Ammoniakkkaramell',
    category: 'Fargestoff',
    description: 'Brun karamellfarge framstilt med ammoniakk. Brukes i øl og saus.',
  ),
  'E150D': AdditiveInfo(
    name: 'Sulfittammoniakk-karamell',
    category: 'Fargestoff',
    description:
        'Brun karamellfarge i cola-typer. Kan inneholde sporstoffet 4-MEI.',
  ),
  'E160A': AdditiveInfo(
    name: 'Karoten',
    category: 'Fargestoff',
    description: 'Oransje farge (forstadium til vitamin A). Naturlig forekommende.',
  ),
  'E160C': AdditiveInfo(
    name: 'Paprikaekstrakt',
    category: 'Fargestoff',
    description: 'Rød/oransje farge fra paprika. Naturlig opprinnelse.',
  ),
  'E162': AdditiveInfo(
    name: 'Betanin (rødbetrød)',
    category: 'Fargestoff',
    description: 'Rød farge fra rødbeter. Naturlig opprinnelse.',
  ),
  'E163': AdditiveInfo(
    name: 'Antocyaniner',
    category: 'Fargestoff',
    description: 'Rød/blå/lilla farge fra bær og frukt. Naturlig opprinnelse.',
  ),
  'E170': AdditiveInfo(
    name: 'Kalsiumkarbonat',
    category: 'Fargestoff / surhetsregulator',
    description: 'Hvitt stoff (kritt). Også kalsiumkilde. Regnes som trygt.',
  ),
  'E171': AdditiveInfo(
    name: 'Titandioksid',
    category: 'Fargestoff (hvitt)',
    description:
        'Hvitt fargestoff som gir hvit farge og glans, blant annet i godteri, tyggegummi og glasur.',
    origin: 'Syntetisk',
    background:
        'Industrielt framstilt mineralsk pigment (titandioksid i finmalt/nanoform).',
    healthRisk:
        'Forbudt som tilsetningsstoff i mat i EU fra 2022. EFSA konkluderte med at det ikke lenger kan anses som trygt, fordi mulig skade på arvestoffet (DNA) ikke kan utelukkes.',
  ),
  'E200': AdditiveInfo(
    name: 'Sorbinsyre',
    category: 'Konserveringsmiddel',
    description: 'Hindrer mugg og gjær. Regnes som trygt i normale mengder.',
  ),
  'E202': AdditiveInfo(
    name: 'Kaliumsorbat',
    category: 'Konserveringsmiddel',
    description: 'Salt av sorbinsyre. Hindrer mugg. Vanlig i ost, bakevarer og drikke.',
  ),
  'E210': AdditiveInfo(
    name: 'Benzosyre',
    category: 'Konserveringsmiddel',
    description:
        'Hindrer bakterier og sopp. Kan gi reaksjoner hos følsomme; danner benzen sammen med vitamin C ved varme.',
  ),
  'E211': AdditiveInfo(
    name: 'Natriumbenzoat',
    category: 'Konserveringsmiddel',
    description:
        'Hindrer vekst av gjær, mugg og bakterier. Vanlig i brus, dressing og syltede produkter.',
    origin: 'Syntetisk',
    background:
        'Natriumsalt av benzosyre, framstilt industrielt. Benzosyre finnes også naturlig i enkelte bær.',
    healthRisk:
        'Trygt innenfor grenseverdier, men kan danne små mengder benzen sammen med vitamin C (C-vitamin) i sure drikker. Knyttet til hyperaktivitet hos enkelte barn.',
  ),
  'E220': AdditiveInfo(
    name: 'Svoveldioksid',
    category: 'Konserveringsmiddel / antioksidant',
    description:
        'Brukes i tørket frukt og vin. Sulfitt – kan gi reaksjoner hos astmatikere. Allergenmerkes.',
  ),
  'E223': AdditiveInfo(
    name: 'Natriummetabisulfitt',
    category: 'Konserveringsmiddel',
    description: 'Sulfitt brukt i blant annet vin og reker. Kan gi reaksjon hos astmatikere.',
  ),
  'E250': AdditiveInfo(
    name: 'Natriumnitritt',
    category: 'Konserveringsmiddel',
    description:
        'Brukes i spekemat og pølser mot botulisme og for å gi og bevare rød farge.',
    origin: 'Syntetisk',
    background:
        'Industrielt framstilt nitrittsalt. Tilsettes som konserveringssalt (nitritt-/spekesalt) i bearbeidet kjøtt.',
    healthRisk:
        'Hindrer farlig bakterievekst (botulisme), men kan danne nitrosaminer i kroppen og ved steking. Bearbeidet kjøtt er av WHO klassifisert som kreftfremkallende, og høyt inntak frarådes. Underlagt strenge grenseverdier i EU.',
  ),
  'E251': AdditiveInfo(
    name: 'Natriumnitrat',
    category: 'Konserveringsmiddel',
    description:
        'Brukes i spekemat og enkelte oster. Omdannes gradvis til nitritt i produktet.',
    origin: 'Syntetisk',
    background:
        'Industrielt framstilt nitratsalt. Nitrat finnes også naturlig i grønnsaker, men her tilsettes det som konserveringssalt.',
    healthRisk:
        'Omdannes til nitritt og deler samme forsiktighet som E250: mulig dannelse av nitrosaminer, og høyt inntak av bearbeidet kjøtt frarådes. Underlagt grenseverdier i EU.',
  ),
  'E260': AdditiveInfo(
    name: 'Eddiksyre',
    category: 'Surhetsregulator / konservering',
    description: 'Vanlig eddik. Regnes som trygt.',
  ),
  'E270': AdditiveInfo(
    name: 'Melkesyre',
    category: 'Surhetsregulator',
    description: 'Naturlig syre fra fermentering. Regnes som trygt.',
  ),
  'E296': AdditiveInfo(
    name: 'Eplesyre',
    category: 'Surhetsregulator',
    description: 'Syre som finnes naturlig i epler. Gir syrlig smak. Trygt.',
  ),
  'E300': AdditiveInfo(
    name: 'Askorbinsyre (vitamin C)',
    category: 'Antioksidant',
    description:
        'Vitamin C brukt for å hindre at fett og farge harskner/oksiderer.',
    origin: 'Naturidentisk',
    background:
        'Identisk med vitamin C som finnes naturlig i frukt og grønt, men framstilles industrielt (ofte fra glukose).',
    healthRisk:
        'Regnes som trygt og er i tillegg et næringsstoff. Ingen kjent øvre grense ved normalt kosthold.',
  ),
  'E301': AdditiveInfo(
    name: 'Natriumaskorbat',
    category: 'Antioksidant',
    description:
        'Natriumsalt av vitamin C. Hindrer harskning og bevarer farge, blant annet i kjøttprodukter.',
    origin: 'Naturidentisk',
    background:
        'Framstilles industrielt fra askorbinsyre (vitamin C) og natrium.',
    healthRisk:
        'Regnes som trygt. Bidrar dessuten til å redusere dannelse av nitrosaminer i nitritt-konservert kjøtt.',
  ),
  'E306': AdditiveInfo(
    name: 'Tokoferol (vitamin E)',
    category: 'Antioksidant',
    description: 'Naturlig vitamin E som hindrer harskning av fett. Trygt.',
  ),
  'E322': AdditiveInfo(
    name: 'Lecitin',
    category: 'Emulgator',
    description:
        'Binder fett og vann, f.eks. i sjokolade, margarin og bakevarer.',
    origin: 'Naturlig',
    background:
        'Utvinnes fra soya, solsikke eller raps. Soya-lecitin kan komme fra genmodifisert (GMO) soya.',
    healthRisk:
        'Regnes som trygt. Soyalecitin inneholder normalt svært lite allergen, men kan merkes som soya.',
  ),
  'E330': AdditiveInfo(
    name: 'Sitronsyre',
    category: 'Surhetsregulator / antioksidant',
    description:
        'Svært vanlig syre, finnes naturlig i sitrusfrukt. Regnes som trygt.',
  ),
  'E331': AdditiveInfo(
    name: 'Natriumsitrat',
    category: 'Surhetsregulator',
    description: 'Salt av sitronsyre. Brukes i drikke og smelteost. Trygt.',
  ),
  'E338': AdditiveInfo(
    name: 'Fosforsyre',
    category: 'Surhetsregulator',
    description:
        'Gir syrlig smak i cola. Høyt inntak av fosfat kan påvirke kalsiumbalansen.',
  ),
  'E407': AdditiveInfo(
    name: 'Karragenan',
    category: 'Fortykningsmiddel',
    description:
        'Geleringsmiddel fra rødalger. Brukes i melkeprodukter. Noe omdiskutert for tarmen ved høyt inntak.',
  ),
  'E410': AdditiveInfo(
    name: 'Johannesbrødkjernemel',
    category: 'Fortykningsmiddel',
    description: 'Naturlig fortykningsmiddel fra johannesbrødtreet. Trygt.',
  ),
  'E412': AdditiveInfo(
    name: 'Guarkjernemel',
    category: 'Fortykningsmiddel',
    description: 'Naturlig fiber fra guarbønner som gir tykkere konsistens. Trygt.',
  ),
  'E415': AdditiveInfo(
    name: 'Xantangummi',
    category: 'Fortykningsmiddel',
    description: 'Fortykningsmiddel laget ved fermentering. Vanlig i glutenfri mat. Trygt.',
  ),
  'E420': AdditiveInfo(
    name: 'Sorbitol',
    category: 'Søtstoff / fuktbevarer',
    description: 'Sukkeralkohol. Kan virke avførende i store mengder.',
  ),
  'E422': AdditiveInfo(
    name: 'Glyserol',
    category: 'Fuktbevarer',
    description: 'Holder på fukt i bakevarer og godteri. Regnes som trygt.',
  ),
  'E428': AdditiveInfo(
    name: 'Gelatin',
    category: 'Geleringsmiddel / stabilisator',
    description:
        'Geléstoff laget av kokt bindevev, hud og bein fra dyr (oftest svin eller storfe). Gir den geléaktige konsistensen i bl.a. skinke, gelé og vingummi.',
    origin: 'Animalsk',
    background:
        'Utvinnes ved å koke kollagenrikt slakteavfall (svinesvor, hud, bein). Ikke vegansk eller vegetarisk, og kan være uaktuelt for halal/kosher avhengig av kilde.',
    healthRisk:
        'Regnes som trygt å spise. Hovedhensynet er opprinnelse (dyreart) av hensyn til kosthold, religion og allergi.',
  ),
  'E440': AdditiveInfo(
    name: 'Pektin',
    category: 'Geleringsmiddel',
    description: 'Naturlig geléstoff fra frukt. Brukes i syltetøy. Trygt.',
  ),
  'E450': AdditiveInfo(
    name: 'Difosfater',
    category: 'Konsistensmiddel / stabilisator',
    description:
        'Fosfatsalter som binder vann og holder på struktur. Brukes mye i kjøtt- og fiskeprodukter for å øke vanninnhold og saftighet.',
    origin: 'Syntetisk',
    background:
        'Difosfater fremstilles industrielt ved å kombinere fosforsyre med salter som natrium, kalium eller kalsium. Stoffene finnes ikke naturlig i mat og tilføres kun gjennom produksjon.',
    healthRisk:
        'Ifølge EFSA har fosfater lav akutt giftighet og er ikke kreftfremkallende. Høyt totalt inntak av fosfat kan likevel forstyrre kalsium- og fosfatbalansen og er knyttet til negative effekter på hjerte/kar og nyrer. Bruken er derfor underlagt grenseverdier i EU.',
  ),
  'E451': AdditiveInfo(
    name: 'Trifosfater',
    category: 'Konsistensmiddel / stabilisator',
    description:
        'Fosfatsalter i samme gruppe som difosfater. Binder vann, stabiliserer og forbedrer tekstur, særlig i bearbeidet kjøtt og fisk.',
    origin: 'Syntetisk',
    background:
        'Framstilles industrielt fra fosforsyre og natrium/kalium. Forekommer ikke naturlig i mat.',
    healthRisk:
        'Samme vurdering som difosfater (E450): lav akutt giftighet, men høyt samlet fosfatinntak bør begrenses. Underlagt grenseverdier i EU.',
  ),
  'E452': AdditiveInfo(
    name: 'Polyfosfater',
    category: 'Konsistensmiddel / stabilisator',
    description:
        'Fosfatkjeder som binder vann og emulgerer. Brukes i smelteost, kjøtt- og fiskeprodukter.',
    origin: 'Syntetisk',
    background:
        'Industrielt framstilte fosfater. Forekommer ikke naturlig i mat.',
    healthRisk:
        'Som øvrige fosfater: trygt i små mengder, men EFSA anbefaler å begrense samlet fosfatinntak. Underlagt grenseverdier i EU.',
  ),
  'E471': AdditiveInfo(
    name: 'Mono- og diglyserider av fettsyrer',
    category: 'Emulgator',
    description:
        'Binder fett og vann i bakevarer og iskrem. Kan være av plante- eller dyrefett.',
  ),
  'E472E': AdditiveInfo(
    name: 'DATEM',
    category: 'Emulgator',
    description: 'Forbedrer struktur i brød. Regnes som trygt.',
  ),
  'E476': AdditiveInfo(
    name: 'Polyglyserolpolyrisinoleat (PGPR)',
    category: 'Emulgator',
    description: 'Gjør sjokolade lettflytende. Ofte fra ricinusolje. Regnes som trygt.',
  ),
  'E481': AdditiveInfo(
    name: 'Natriumstearoyllaktylat',
    category: 'Emulgator',
    description: 'Forbedrer brøddeig. Regnes som trygt.',
  ),
  'E500': AdditiveInfo(
    name: 'Natriumkarbonat (natron)',
    category: 'Hevemiddel / surhetsregulator',
    description: 'Bakepulver/natron. Regnes som trygt.',
  ),
  'E503': AdditiveInfo(
    name: 'Ammoniumkarbonat (hjortetakksalt)',
    category: 'Hevemiddel',
    description: 'Tradisjonelt hevemiddel i flate kaker. Trygt.',
  ),
  'E535': AdditiveInfo(
    name: 'Natriumferrocyanid',
    category: 'Antiklumpemiddel',
    description: 'Hindrer at salt klumper seg. Trygt i de små mengdene som brukes.',
  ),
  'E551': AdditiveInfo(
    name: 'Silisiumdioksid',
    category: 'Antiklumpemiddel',
    description: 'Holder pulver tørt og rennende. Regnes som trygt.',
  ),
  'E621': AdditiveInfo(
    name: 'Mononatriumglutamat (MSG)',
    category: 'Smaksforsterker',
    description:
        'Forsterker den salte/kjøttfulle umami-smaken. Vanlig i ferdigmat, snacks og buljong.',
    origin: 'Naturidentisk',
    background:
        'Glutamat finnes naturlig i mat som tomat, ost og soya. Tilsatt MSG framstilles industrielt ved fermentering.',
    healthRisk:
        'EFSA og andre myndigheter regner det som trygt for de fleste innenfor grenseverdier. Enkelte rapporterer forbigående ubehag (hodepine, varmefølelse) ved store mengder.',
  ),
  'E627': AdditiveInfo(
    name: 'Dinatriumguanylat',
    category: 'Smaksforsterker',
    description: 'Brukes sammen med MSG for å forsterke smak. Trygt.',
  ),
  'E631': AdditiveInfo(
    name: 'Dinatriuminosinat',
    category: 'Smaksforsterker',
    description: 'Smaksforsterker, ofte av animalsk opprinnelse. Trygt.',
  ),
  'E901': AdditiveInfo(
    name: 'Bivoks',
    category: 'Overflatebehandling',
    description: 'Naturlig voks som gir glans på godteri og frukt. Trygt.',
  ),
  'E903': AdditiveInfo(
    name: 'Karnaubavoks',
    category: 'Overflatebehandling',
    description: 'Plantevoks som gir glans på godteri. Trygt.',
  ),
  'E920': AdditiveInfo(
    name: 'L-cystein',
    category: 'Melbehandlingsmiddel',
    description: 'Mykner deig. Kan være av animalsk opprinnelse. Trygt.',
  ),
  'E950': AdditiveInfo(
    name: 'Acesulfam K',
    category: 'Søtstoff',
    description: 'Kunstig søtstoff uten kalorier. Regnes som trygt innenfor grenseverdier.',
  ),
  'E951': AdditiveInfo(
    name: 'Aspartam',
    category: 'Søtstoff',
    description:
        'Intenst kunstig søtstoff (ca. 200 ganger søtere enn sukker) uten kalorier. Vanlig i «lett»-/sukkerfri drikke.',
    origin: 'Syntetisk',
    background:
        'Framstilt industrielt av to aminosyrer (asparaginsyre og fenylalanin).',
    healthRisk:
        'Trygt innenfor grenseverdier ifølge EFSA. WHO/IARC klassifiserte det i 2023 som «mulig kreftfremkallende», men anbefalt grense ble ikke endret. Må unngås av personer med PKU (fenylketonuri).',
  ),
  'E952': AdditiveInfo(
    name: 'Syklamat',
    category: 'Søtstoff',
    description: 'Kunstig søtstoff. Trygt innenfor grenseverdier (forbudt i USA).',
  ),
  'E954': AdditiveInfo(
    name: 'Sakkarin',
    category: 'Søtstoff',
    description: 'Et av de eldste kunstige søtstoffene. Regnes som trygt innenfor grenseverdier.',
  ),
  'E955': AdditiveInfo(
    name: 'Sukralose',
    category: 'Søtstoff',
    description: 'Kunstig søtstoff laget av sukker. Regnes som trygt innenfor grenseverdier.',
  ),
  'E960': AdditiveInfo(
    name: 'Steviolglykosider (stevia)',
    category: 'Søtstoff',
    description: 'Søtstoff fra stevia-planten. Naturlig opprinnelse, regnes som trygt.',
  ),
  'E965': AdditiveInfo(
    name: 'Maltitol',
    category: 'Søtstoff',
    description: 'Sukkeralkohol. Kan virke avførende i store mengder.',
  ),
  'E967': AdditiveInfo(
    name: 'Xylitol',
    category: 'Søtstoff',
    description: 'Sukkeralkohol med tannvennlig effekt. Avførende i store mengder. Giftig for hunder.',
  ),
};

// English explanations, keyed by uppercase E-number.
const Map<String, AdditiveInfo> _additivesEn = {
  'E100': AdditiveInfo(
    name: 'Curcumin (turmeric)',
    category: 'Colour',
    description: 'Yellow colour from turmeric root. Natural origin, considered safe.',
  ),
  'E101': AdditiveInfo(
    name: 'Riboflavin (vitamin B2)',
    category: 'Colour',
    description: 'Yellow colour that is also a B vitamin. Naturally occurring.',
  ),
  'E102': AdditiveInfo(
    name: 'Tartrazine',
    category: 'Colour (azo dye)',
    description:
        'Yellow synthetic azo dye. May cause allergic reactions and is linked to hyperactivity in children (EU warning label).',
  ),
  'E104': AdditiveInfo(
    name: 'Quinoline Yellow',
    category: 'Colour',
    description: 'Yellow synthetic dye. Linked to hyperactivity in children (EU warning label).',
  ),
  'E110': AdditiveInfo(
    name: 'Sunset Yellow FCF',
    category: 'Colour (azo dye)',
    description: 'Orange synthetic azo dye. Linked to hyperactivity in children (EU warning label).',
  ),
  'E120': AdditiveInfo(
    name: 'Carmine (cochineal)',
    category: 'Colour',
    description:
        'Red colour made from crushed cochineal insects. Not vegan; may cause allergy in some.',
  ),
  'E122': AdditiveInfo(
    name: 'Azorubine (carmoisine)',
    category: 'Colour (azo dye)',
    description: 'Red synthetic azo dye. Linked to hyperactivity in children (EU warning label).',
  ),
  'E124': AdditiveInfo(
    name: 'Ponceau 4R',
    category: 'Colour (azo dye)',
    description: 'Red synthetic azo dye. Linked to hyperactivity in children (EU warning label).',
  ),
  'E129': AdditiveInfo(
    name: 'Allura Red AC',
    category: 'Colour (azo dye)',
    description: 'Red synthetic azo dye. Linked to hyperactivity in children (EU warning label).',
  ),
  'E131': AdditiveInfo(
    name: 'Patent Blue V',
    category: 'Colour',
    description: 'Blue synthetic colour. May cause allergic reactions in some.',
  ),
  'E133': AdditiveInfo(
    name: 'Brilliant Blue FCF',
    category: 'Colour',
    description: 'Blue synthetic colour used in sweets and drinks.',
  ),
  'E140': AdditiveInfo(
    name: 'Chlorophyll',
    category: 'Colour',
    description: 'Green colour from plants. Natural origin.',
  ),
  'E150A': AdditiveInfo(
    name: 'Plain caramel',
    category: 'Colour',
    description: 'Brown colour made by heating sugar. Common in soft drinks and sauces.',
  ),
  'E150C': AdditiveInfo(
    name: 'Ammonia caramel',
    category: 'Colour',
    description: 'Brown caramel colour made with ammonia. Used in beer and sauces.',
  ),
  'E150D': AdditiveInfo(
    name: 'Sulphite ammonia caramel',
    category: 'Colour',
    description: 'Brown caramel colour in cola drinks. May contain trace 4-MEI.',
  ),
  'E160A': AdditiveInfo(
    name: 'Carotene',
    category: 'Colour',
    description: 'Orange colour (precursor to vitamin A). Naturally occurring.',
  ),
  'E160C': AdditiveInfo(
    name: 'Paprika extract',
    category: 'Colour',
    description: 'Red/orange colour from paprika. Natural origin.',
  ),
  'E162': AdditiveInfo(
    name: 'Beetroot red (betanin)',
    category: 'Colour',
    description: 'Red colour from beetroot. Natural origin.',
  ),
  'E163': AdditiveInfo(
    name: 'Anthocyanins',
    category: 'Colour',
    description: 'Red/blue/purple colour from berries and fruit. Natural origin.',
  ),
  'E170': AdditiveInfo(
    name: 'Calcium carbonate',
    category: 'Colour / acidity regulator',
    description: 'White substance (chalk). Also a calcium source. Considered safe.',
  ),
  'E171': AdditiveInfo(
    name: 'Titanium dioxide',
    category: 'Colour (white)',
    description:
        'White colour. Banned as a food additive in the EU from 2022 as it is no longer considered safe (possible DNA damage).',
  ),
  'E200': AdditiveInfo(
    name: 'Sorbic acid',
    category: 'Preservative',
    description: 'Prevents mould and yeast. Considered safe in normal amounts.',
  ),
  'E202': AdditiveInfo(
    name: 'Potassium sorbate',
    category: 'Preservative',
    description: 'Salt of sorbic acid. Prevents mould. Common in cheese, baked goods and drinks.',
  ),
  'E210': AdditiveInfo(
    name: 'Benzoic acid',
    category: 'Preservative',
    description:
        'Prevents bacteria and fungi. May cause reactions in sensitive people; forms benzene with vitamin C when heated.',
  ),
  'E211': AdditiveInfo(
    name: 'Sodium benzoate',
    category: 'Preservative',
    description:
        'Common in soft drinks and dressings. Can form benzene with vitamin C. Linked to hyperactivity in children.',
  ),
  'E220': AdditiveInfo(
    name: 'Sulphur dioxide',
    category: 'Preservative / antioxidant',
    description:
        'Used in dried fruit and wine. A sulphite — may trigger reactions in asthmatics. Labelled as allergen.',
  ),
  'E223': AdditiveInfo(
    name: 'Sodium metabisulphite',
    category: 'Preservative',
    description: 'Sulphite used in wine and shrimp. May cause reactions in asthmatics.',
  ),
  'E250': AdditiveInfo(
    name: 'Sodium nitrite',
    category: 'Preservative',
    description:
        'Used in cured meats against botulism and for red colour. Can form nitrosamines; high processed-meat intake is discouraged.',
  ),
  'E251': AdditiveInfo(
    name: 'Sodium nitrate',
    category: 'Preservative',
    description: 'Used in cured meats. Converts to nitrite. Same caution as E250.',
  ),
  'E260': AdditiveInfo(
    name: 'Acetic acid',
    category: 'Acidity regulator / preservative',
    description: 'Ordinary vinegar. Considered safe.',
  ),
  'E270': AdditiveInfo(
    name: 'Lactic acid',
    category: 'Acidity regulator',
    description: 'Natural acid from fermentation. Considered safe.',
  ),
  'E296': AdditiveInfo(
    name: 'Malic acid',
    category: 'Acidity regulator',
    description: 'Acid naturally found in apples. Adds tartness. Safe.',
  ),
  'E300': AdditiveInfo(
    name: 'Ascorbic acid (vitamin C)',
    category: 'Antioxidant',
    description: 'Vitamin C used to prevent rancidity. Safe and a nutrient.',
  ),
  'E301': AdditiveInfo(
    name: 'Sodium ascorbate',
    category: 'Antioxidant',
    description: 'Salt of vitamin C. Prevents food going rancid. Safe.',
  ),
  'E306': AdditiveInfo(
    name: 'Tocopherol (vitamin E)',
    category: 'Antioxidant',
    description: 'Natural vitamin E that prevents fat going rancid. Safe.',
  ),
  'E322': AdditiveInfo(
    name: 'Lecithin',
    category: 'Emulsifier',
    description:
        'Binds fat and water (e.g. in chocolate). Often from soy or sunflower — soy lecithin may come from GMO soy.',
  ),
  'E330': AdditiveInfo(
    name: 'Citric acid',
    category: 'Acidity regulator / antioxidant',
    description: 'Very common acid, found naturally in citrus fruit. Considered safe.',
  ),
  'E331': AdditiveInfo(
    name: 'Sodium citrate',
    category: 'Acidity regulator',
    description: 'Salt of citric acid. Used in drinks and processed cheese. Safe.',
  ),
  'E338': AdditiveInfo(
    name: 'Phosphoric acid',
    category: 'Acidity regulator',
    description: 'Gives the tang in cola. High phosphate intake may affect calcium balance.',
  ),
  'E407': AdditiveInfo(
    name: 'Carrageenan',
    category: 'Thickener',
    description:
        'Gelling agent from red seaweed. Used in dairy. Somewhat debated for gut health at high intake.',
  ),
  'E410': AdditiveInfo(
    name: 'Locust bean gum',
    category: 'Thickener',
    description: 'Natural thickener from the carob tree. Safe.',
  ),
  'E412': AdditiveInfo(
    name: 'Guar gum',
    category: 'Thickener',
    description: 'Natural fibre from guar beans that thickens texture. Safe.',
  ),
  'E415': AdditiveInfo(
    name: 'Xanthan gum',
    category: 'Thickener',
    description: 'Thickener made by fermentation. Common in gluten-free food. Safe.',
  ),
  'E420': AdditiveInfo(
    name: 'Sorbitol',
    category: 'Sweetener / humectant',
    description: 'Sugar alcohol. Can have a laxative effect in large amounts.',
  ),
  'E422': AdditiveInfo(
    name: 'Glycerol',
    category: 'Humectant',
    description: 'Retains moisture in baked goods and sweets. Considered safe.',
  ),
  'E428': AdditiveInfo(
    name: 'Gelatin',
    category: 'Gelling agent / stabiliser',
    description:
        'A gelling substance made from boiled connective tissue, skin and bones of animals (usually pork or beef). Gives the jelly-like texture in ham, jelly and gummy sweets.',
    origin: 'Animal',
    background:
        'Extracted by boiling collagen-rich slaughter by-products (pork rind, skin, bones). Not vegan or vegetarian, and may not be halal/kosher depending on the source.',
    healthRisk:
        'Considered safe to eat. The main consideration is its origin (animal species) for dietary, religious and allergy reasons.',
  ),
  'E440': AdditiveInfo(
    name: 'Pectin',
    category: 'Gelling agent',
    description: 'Natural gelling agent from fruit. Used in jam. Safe.',
  ),
  'E450': AdditiveInfo(
    name: 'Diphosphates',
    category: 'Stabiliser / texturiser',
    description:
        'Phosphate salts that bind water and hold texture. Widely used in meat and fish products to increase water content and juiciness.',
    origin: 'Synthetic',
    background:
        'Made industrially by combining phosphoric acid with sodium, potassium or calcium salts. Not naturally present in food.',
    healthRisk:
        'According to EFSA, phosphates have low acute toxicity and are not carcinogenic. However, high total phosphate intake can disturb calcium/phosphate balance and is linked to heart and kidney effects, so use is capped by EU limits.',
  ),
  'E451': AdditiveInfo(
    name: 'Triphosphates',
    category: 'Stabiliser / texturiser',
    description:
        'Phosphate salts in the same group as diphosphates. Bind water, stabilise and improve texture, especially in processed meat and fish.',
    origin: 'Synthetic',
    background:
        'Made industrially from phosphoric acid and sodium/potassium. Not naturally present in food.',
    healthRisk:
        'Same assessment as diphosphates (E450): low acute toxicity, but high total phosphate intake should be limited. Capped by EU limits.',
  ),
  'E452': AdditiveInfo(
    name: 'Polyphosphates',
    category: 'Stabiliser / texturiser',
    description:
        'Phosphate chains that bind water and emulsify. Used in processed cheese, meat and fish products.',
    origin: 'Synthetic',
    background: 'Industrially produced phosphates. Not naturally present in food.',
    healthRisk:
        'Like other phosphates: safe in small amounts, but EFSA advises limiting total phosphate intake. Capped by EU limits.',
  ),
  'E471': AdditiveInfo(
    name: 'Mono- and diglycerides of fatty acids',
    category: 'Emulsifier',
    description: 'Binds fat and water in baked goods and ice cream. May be plant or animal fat.',
  ),
  'E472E': AdditiveInfo(
    name: 'DATEM',
    category: 'Emulsifier',
    description: 'Improves bread structure. Considered safe.',
  ),
  'E476': AdditiveInfo(
    name: 'Polyglycerol polyricinoleate (PGPR)',
    category: 'Emulsifier',
    description: 'Makes chocolate flow easily. Often from castor oil. Considered safe.',
  ),
  'E481': AdditiveInfo(
    name: 'Sodium stearoyl lactylate',
    category: 'Emulsifier',
    description: 'Improves bread dough. Considered safe.',
  ),
  'E500': AdditiveInfo(
    name: 'Sodium carbonate (baking soda)',
    category: 'Raising agent / acidity regulator',
    description: 'Baking soda. Considered safe.',
  ),
  'E503': AdditiveInfo(
    name: 'Ammonium carbonate',
    category: 'Raising agent',
    description: 'Traditional raising agent in flat cakes. Safe.',
  ),
  'E535': AdditiveInfo(
    name: 'Sodium ferrocyanide',
    category: 'Anti-caking agent',
    description: 'Prevents salt from clumping. Safe in the small amounts used.',
  ),
  'E551': AdditiveInfo(
    name: 'Silicon dioxide',
    category: 'Anti-caking agent',
    description: 'Keeps powders dry and free-flowing. Considered safe.',
  ),
  'E621': AdditiveInfo(
    name: 'Monosodium glutamate (MSG)',
    category: 'Flavour enhancer',
    description:
        'Enhances umami taste. Safe for most; some report transient discomfort.',
  ),
  'E627': AdditiveInfo(
    name: 'Disodium guanylate',
    category: 'Flavour enhancer',
    description: 'Used with MSG to boost flavour. Safe.',
  ),
  'E631': AdditiveInfo(
    name: 'Disodium inosinate',
    category: 'Flavour enhancer',
    description: 'Flavour enhancer, often of animal origin. Safe.',
  ),
  'E901': AdditiveInfo(
    name: 'Beeswax',
    category: 'Glazing agent',
    description: 'Natural wax that glazes sweets and fruit. Safe.',
  ),
  'E903': AdditiveInfo(
    name: 'Carnauba wax',
    category: 'Glazing agent',
    description: 'Plant wax that glazes sweets. Safe.',
  ),
  'E920': AdditiveInfo(
    name: 'L-cysteine',
    category: 'Flour treatment agent',
    description: 'Softens dough. May be of animal origin. Safe.',
  ),
  'E950': AdditiveInfo(
    name: 'Acesulfame K',
    category: 'Sweetener',
    description: 'Calorie-free artificial sweetener. Considered safe within limits.',
  ),
  'E951': AdditiveInfo(
    name: 'Aspartame',
    category: 'Sweetener',
    description:
        'Artificial sweetener. Safe within limits; must be avoided by people with PKU (phenylketonuria).',
  ),
  'E952': AdditiveInfo(
    name: 'Cyclamate',
    category: 'Sweetener',
    description: 'Artificial sweetener. Safe within limits (banned in the USA).',
  ),
  'E954': AdditiveInfo(
    name: 'Saccharin',
    category: 'Sweetener',
    description: 'One of the oldest artificial sweeteners. Considered safe within limits.',
  ),
  'E955': AdditiveInfo(
    name: 'Sucralose',
    category: 'Sweetener',
    description: 'Artificial sweetener made from sugar. Considered safe within limits.',
  ),
  'E960': AdditiveInfo(
    name: 'Steviol glycosides (stevia)',
    category: 'Sweetener',
    description: 'Sweetener from the stevia plant. Natural origin, considered safe.',
  ),
  'E965': AdditiveInfo(
    name: 'Maltitol',
    category: 'Sweetener',
    description: 'Sugar alcohol. Can have a laxative effect in large amounts.',
  ),
  'E967': AdditiveInfo(
    name: 'Xylitol',
    category: 'Sweetener',
    description: 'Sugar alcohol that is tooth-friendly. Laxative in large amounts. Toxic to dogs.',
  ),
};

/// Returns the explanation for an E-number for the given locale code,
/// or null if the additive is not in the database.
///
/// [eNumber] is normalised to uppercase without spaces (e.g. "e 330" -> "E330").
/// [localeCode] uses the two-letter language code; Norwegian ("nb"/"no")
/// returns Norwegian text, everything else falls back to English.
AdditiveInfo? lookupAdditiveInfo(String eNumber, String localeCode) {
  final key = eNumber.toUpperCase().replaceAll(' ', '').trim();
  final isNorwegian =
      localeCode.toLowerCase() == 'nb' || localeCode.toLowerCase() == 'no';
  if (isNorwegian) {
    return _additivesNb[key];
  }
  return _additivesEn[key];
}

// --- Detection of additives written by name (not E-number) ---
//
// Many products list additives by their common name (e.g. "natriumbenzoat",
// "aspartam") instead of the E-number, so a plain "E\d{3,4}" regex misses
// them. This curated map links the most commonly-listed additive NAMES (and
// some English variants) to their E-number, so we can surface the E-numbers
// people care about. Keys are lowercase substrings matched against the
// ingredient text. Kept deliberately specific to avoid false positives.
const Map<String, String> _additiveNameToENumber = {
  // Colours people care about (azo dyes etc.)
  'tartrazin': 'E102',
  'kinolingult': 'E104',
  'paraoransje': 'E110',
  'sunset yellow': 'E110',
  'karmin': 'E120',
  'cochenille': 'E120',
  'cochineal': 'E120',
  'azorubin': 'E122',
  'karmoisin': 'E122',
  'ponceau': 'E124',
  'allurarød': 'E129',
  'allura red': 'E129',
  'patentblå': 'E131',
  'patent blue': 'E131',
  'briljantblå': 'E133',
  'brilliant blue': 'E133',
  'titandioksid': 'E171',
  'titanium dioxide': 'E171',
  // Preservatives
  'sorbinsyre': 'E200',
  'sorbic acid': 'E200',
  'kaliumsorbat': 'E202',
  'potassium sorbate': 'E202',
  'benzosyre': 'E210',
  'benzoic acid': 'E210',
  'natriumbenzoat': 'E211',
  'sodium benzoate': 'E211',
  'svoveldioksid': 'E220',
  'sulphur dioxide': 'E220',
  'sulfur dioxide': 'E220',
  'natriummetabisulfitt': 'E223',
  'sodium metabisulphite': 'E223',
  'natriumnitritt': 'E250',
  'sodium nitrite': 'E250',
  'natriumnitrat': 'E251',
  'sodium nitrate': 'E251',
  // Acids / antioxidants
  'askorbinsyre': 'E300',
  'ascorbic acid': 'E300',
  'natriumaskorbat': 'E301',
  'sodium ascorbate': 'E301',
  'tokoferol': 'E306',
  'tocopherol': 'E306',
  'lecitin': 'E322',
  'lecithin': 'E322',
  'sitronsyre': 'E330',
  'citric acid': 'E330',
  'natriumsitrat': 'E331',
  'sodium citrate': 'E331',
  'fosforsyre': 'E338',
  'phosphoric acid': 'E338',
  // Thickeners / emulsifiers
  'karragenan': 'E407',
  'carrageenan': 'E407',
  'johannesbrødkjernemel': 'E410',
  'locust bean gum': 'E410',
  'guarkjernemel': 'E412',
  'guar gum': 'E412',
  'xantangummi': 'E415',
  'xanthan gum': 'E415',
  'pektin': 'E440',
  'pectin': 'E440',
  // Phosphates (texturisers/stabilisers in meat & fish)
  'difosfat': 'E450',
  'difosfater': 'E450',
  'diphosphate': 'E450',
  'trifosfat': 'E451',
  'trifosfater': 'E451',
  'triphosphate': 'E451',
  'polyfosfat': 'E452',
  'polyfosfater': 'E452',
  'polyphosphate': 'E452',
  // Flavour enhancers
  'mononatriumglutamat': 'E621',
  'natriumglutamat': 'E621',
  'monosodium glutamate': 'E621',
  // Sweeteners
  'acesulfam': 'E950',
  'acesulfame': 'E950',
  'aspartam': 'E951',
  'aspartame': 'E951',
  'syklamat': 'E952',
  'cyclamate': 'E952',
  'sakkarin': 'E954',
  'saccharin': 'E954',
  'sukralose': 'E955',
  'sucralose': 'E955',
  'steviolglykosid': 'E960',
  'steviol glycoside': 'E960',
  'maltitol': 'E965',
  'xylitol': 'E967',
};

/// Scans free-text ingredients and returns any E-numbers whose additive name
/// appears in the text. This complements the `E\d{3,4}` regex so additives
/// written only by name are still surfaced.
List<String> detectAdditivesByName(String ingredients) {
  final lower = ingredients.toLowerCase();
  final found = <String>{};
  _additiveNameToENumber.forEach((name, eNumber) {
    if (lower.contains(name)) {
      found.add(eNumber);
    }
  });
  return found.toList();
}
