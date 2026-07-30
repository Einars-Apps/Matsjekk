# mat_sjekk AI Coding Guidelines

## Project Overview
**mat_sjekk** is a Norwegian Flutter mobile app that helps conscious consumers identify food products linked to controversial agricultural practices (Bovaer pesticides, GMO fish feed, insect meal). Users scan barcodes to get risk assessments and maintain shopping lists.

## Architecture

### Core Data Flow
1. **Barcode Scanning** → `MobileScannerController` (mobile_scanner package)
2. **API Lookup** → OpenFoodFacts API (`https://world.openfoodfacts.org/api/v2/product/{EAN}.json`)
3. **Risk Analysis** → Rule-based matching against hardcoded brand lists
4. **Local Storage** → Hive boxes for shopping lists, history, settings, and list positions

### Key Components

**[lib/main.dart](lib/main.dart)**
- `ScannerScreen` (main stateful widget) — handles barcode input, list management, settings
- Risk definition constants at top: `bovaerRedBrands`, `bovaerYellowBrands`, `gmoFishRedBrands`, `greenKeywords`
- State management via `StatefulWidget` + Hive boxes (no Provider/Riverpod)
- `_hentInfo(ean)` — fetches product data and triggers risk analysis

**[lib/widgets.dart](lib/widgets.dart)**
- `ProductInfoDialogContent` — displays product details and risk levels
- `RiskLevel` enum: `green` (organic certified), `yellow` (partner brands), `red` (direct links), `unknown`
- `_buildRiskWidget()` — renders risk indicators with icons and explanations

### Data Storage (Hive)
- `'handlelister'` — maps list names to item arrays
- `'historikk'` — maps `'historikk_<listName>'` to scan history with timestamps
- `'innstillinger'` — user preferences (alert toggles)
- `'list_positions'` — drag-drop coordinates for on-canvas lists

## Developer Workflows

### Build & Run
```bash
flutter pub get           # Install dependencies
flutter run              # Debug build (default platform)
flutter run -d [device]  # Run on specific device
```

### Testing & Linting
```bash
flutter analyze          # Lint via analysis_options.yaml
flutter test            # Run widget_test.dart
```

### Key Dependencies
- `mobile_scanner` (v5.2.3) — barcode detection
- `hive_flutter` (v1.1.0) — local data persistence
- `http` (v1.2.2) — API calls to OpenFoodFacts
- `flutter_app_badger` — app icon badge count

## Code Patterns & Conventions

### Risk Analysis Pattern
Risk levels are determined by rule-order (Norwegian labels checked first):
1. Check `greenKeywords` in product labels → `green`
2. Check brand in `bovaerRedBrands`/`gmoFishRedBrands` → `red`
3. Check brand in `bovaerYellowBrands` → `yellow`
4. Otherwise → `unknown`

Example: `_analyzeBovaerRisk(brand, labels)` [main.dart:365-371]

### Hive Persistence
- Always read defaults: `box.get(key, defaultValue: [])`
- Use `ValueListenableBuilder` for reactive UI updates tied to box changes
- Archive checked items on app pause via `_archiveCheckedItems()`

### Localization Setup
- `lib/110n.yaml` — generator config pointing to `lib/l10n/`
- Two ARB files: `app_en.arb` (template), `app_nb.arb` (Norwegian)
- Run `flutter gen-l10n` to generate `AppLocalizations` (not yet integrated in UI)

## Critical Integration Points

**OpenFoodFacts API**
- Endpoint: `/api/v2/product/{EAN}.json`
- Required fields: `product_name`, `brands`, `labels`, `ingredients_text_no`, `nutriscore_grade`, `additives_tags`
- Response: `data['status'] == 1` means product found; `data['product']` contains data

**Ingredient/Additive Parsing**
- E-numbers (additives) extracted from `additives_tags` (remove 'en:' prefix) + regex parse from text
- Pattern in [main.dart:260]: Split on common delimiters (comma, semicolon, parentheses)

**State Lifecycle**
- `WidgetsBindingObserver` tracks app pause → triggers `_archiveCheckedItems()` [main.dart:74-78]
- Drag-drop list positions persisted in real-time to `list_positions` box [main.dart:413-417]

## Important Constraints & Gotchas

1. **No Null Safety in Risk Fields** — Always use `as RiskLevel? ?? RiskLevel.unknown` when extracting from Maps
2. **Duplicate Scan Debouncing** — `_lastEan` tracks last scanned code; resets after 3 seconds to allow re-scans
3. **Brand List Maintenance** — Risk keywords are hardcoded at top of [main.dart](main.dart#L12-L16); update manually or migrate to external config
4. **OpenFoodFacts Coverage** — Not all products exist; failures handled gracefully with SnackBar
5. **Norwegian Language** — UI strings are Norwegian; future multi-language via l10n (currently unused)

## When Adding Features

- **New product attributes?** Add to `_hentInfo()` return map [main.dart:230]
- **New list types?** Extend Hive boxes in `main()` [main.dart:26-30]
- **New risk category?** Add RiskLevel variant in `enum RiskLevel` [widgets.dart:4] + risk analysis method
- **Localization?** Add key to `app_en.arb`, run `flutter gen-l10n`, integrate generated strings
