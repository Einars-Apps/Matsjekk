# Forslag: Bovaer-status for kjøpere/foredlere av melk (utkast, ikke flettet)

## Slik lagres risiko i dag
- `lib/data/risk_brands_by_country.dart`: lister per land (`bovaer_red`, `bovaer_yellow`, `factory_customer_yellow`) uten kilde-URL per oppføring.
- `lib/data/factory_customer_relations.dart`: fabrikk -> kunde, med generelle kildesider.
- `lib/main.dart` (`_analyzeBovaerRiskWithText`): hardkodet rekkefølge (økologisk -> grønn, 'arla' -> rød, 'apetina' -> rød, 'tine' -> gul, deretter lister). Ren substring-match (f.eks. 'tine' treffer 'Valentine').
- Fjernlister: `docs/supplier_rules_v2.json` via `remote_risk_rules_service.dart`.

## Forslaget i denne grenen
- `docs/data/bovaer_processor_status.json`: én oppføring per selskap/land med status
  (bruker / har_brukt / forsok / stoppet / ukjent / ikke_tillatt), app-farge, `produced_before`,
  statusdato og kilder (URL + dato + notat). Regel: `ukjent` er aldri rød.
- `lib/data/bovaer_processor_status.dart`: generert speiling av JSON + `findBovaerProcessorStatuses()`
  med helords-match og `bovaerProducedBeforeTextNb()` for gul regel «produsert før <dato>».
- `test/bovaer_processor_status_test.dart`: synk JSON/Dart, kildekrav, TINE forblir gul (22.01.2026), helords-match.

## Ikke gjort (krever beslutning)
- Koble inn i `_analyzeBovaerRiskWithText` (forslag: slå opp her før de gamle listene; vis notat + første kilde-URL).
- Nedgradere/kildebelegge røde oppføringer uten kilde i `risk_brands_by_country.dart` (Müller, Valio, DOC/A-ware, Anchor m.fl.).
- `docs/data/eu_decisions_auto.json` er ikke rørt.
