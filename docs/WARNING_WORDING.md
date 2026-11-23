# Ordlyd i varsel-popupen

Dette gjelder teksten i popupen for Bovaer/3-NOP, GMO, NGT og insekter som ny mat. Stempel og farge i datafilene eies av den ukentlige risikorutinen. Popupen endrer ikke de fargene.

## Hva vi skriver

- Norsk er primærtekst. Engelsk finnes der appen allerede skiller `nb` og øvrige språk.
- Vi skriver egne setninger. Vi kopierer ikke tekster fra Trygg Mat.
- Fakta knyttes til en kilde: utgiver og dato står ved notatet. På nivå 2 vises notatet slik det er lagret, med «Sist kontrollert».
- Vi skiller tre ting:
  - dokumentert bruk (kilden beskriver bruk, for Bovaer status `bruker`)
  - delvis, avsluttet, forsøk eller ufullstendig grunnlag (gult)
  - bakgrunnsforskning (nivå 3)
- Rødt brukes bare når bruk er dokumentert og det finnes en https-kilde. Uten kilde vises ikke popupen. Da står det «Ingen dokumentert kilde for dette merket», og dagens stempeltekst blir værende.
- Når kildene er EU-vedtak og ikke et merke, står det «Ikke dokumentert for dette merket».
- Si fra når grunnlaget er ufullstendig. Setningene slutter med at informasjonen kan være ufullstendig.

## Hva vi ikke skriver

- Ingen helsepåstander. Ikke «trygt», «farlig», «skadelig» eller tilsvarende i vår egen tekst.
- Ikke «trygg» om grønt. Grønt betyr at kildene sier at bruk ikke er tillatt i den produksjonen.
- Nivå 3 er merket «Generell forskning, ikke dokumentasjon for dette merket». De lenkene forklarer regelverk eller en EFSA-uttalelse. De beviser ikke hva ett merke har gjort.
- Et notat som følger med en eksisterende kilde vises som notat fra den kilden, ikke som Matsjekks konklusjon om helse.

## Nivåer

1. Hva det gjelder, hvem som står bak, og hva man kan sjekke (produksjons- eller pakkedato, landkode i det ovale stempelet).
2. Se kilder: utgiver, dato, kort notat, sist kontrollert, åpne lenke.
3. Uavhengig forskning: bare bakgrunn, med merkingen over.

## Kilder

Popup-tekst for merker hentes fra `docs/data/bovaer_processor_status.json` og, når en oppføring har `source_url`, fra `docs/data/ngt_suppliers.json`. `docs/data/risk.json` og `docs/supplier_rules_v2.json` brukes ikke som popup-tekst. Bakgrunn ligger i `docs/data/warning_research.json` og er lest mot fri fulltekst. En lenke som ikke lot seg lese, er ikke tatt med.
