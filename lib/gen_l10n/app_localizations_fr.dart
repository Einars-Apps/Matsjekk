// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Vérificateur Alimentaire';

  @override
  String get scanBarcode => 'Scanner le code-barres';

  @override
  String get productNotFound => 'Produit non trouvé dans la base de données.';

  @override
  String get addToList => 'Ajouter à la liste de courses';

  @override
  String get shoppingLists => 'Listes de courses';

  @override
  String get history => 'Historique';

  @override
  String get settings => 'Paramètres';

  @override
  String get about => 'À propos de l\'application';

  @override
  String get howAppWorks => 'Comment l\'application récupère les informations';

  @override
  String get appDescription => 'L\'application utilise Open Food Facts et une liste interne de marques pour identifier les produits contenant du Bovaer, de la farine d\'insectes, des aliments OGM et d\'autres ingrédients controversés.';

  @override
  String get alerts => 'Sélectionner les alertes';

  @override
  String get bovaerAlert => 'Alerte Bovaer';

  @override
  String get insectMealAlert => 'Alerte farine d\'insectes';

  @override
  String get ngtAlert => 'Alerte OGM cachés (NGT)';

  @override
  String get gmoFishAlert => 'Aliment OGM (Poisson)';

  @override
  String get highRisk => 'RISQUE ÉLEVÉ';

  @override
  String get possibleRisk => 'RISQUE POSSIBLE';

  @override
  String get safe => 'SÛR';

  @override
  String get unknown => 'INCONNU';

  @override
  String get bovaerRiskDesc => 'Le producteur est directement lié à Bovaer.';

  @override
  String get insectMealRiskDesc => 'Le produit peut contenir de la farine d\'insectes.';

  @override
  String get gmoFishRiskDesc => 'Le producteur est lié à l\'utilisation d\'aliments OGM.';

  @override
  String get safeDesc => 'Le produit est certifié biologique.';

  @override
  String get nutriScore => 'Nutri-Score';

  @override
  String get traceability => 'Traçabilité';

  @override
  String get beta => 'Bêta';

  @override
  String get close => 'Fermer';

  @override
  String get create => 'Créer';

  @override
  String get search => 'Rechercher';

  @override
  String get searchProducts => 'Rechercher des produits';

  @override
  String get noResults => 'Aucun résultat';

  @override
  String get newList => 'Nouvelle liste';

  @override
  String get deleteList => 'Appuyez longtemps pour supprimer';

  @override
  String get language => 'Langue';

  @override
  String get selectLanguage => 'Sélectionner la langue';

  @override
  String get norwegian => 'Norvégien';

  @override
  String get swedish => 'Suédois';

  @override
  String get danish => 'Danois';

  @override
  String get dutch => 'Néerlandais';

  @override
  String get french => 'Français';

  @override
  String get english => 'Anglais';

  @override
  String get german => 'Allemand';

  @override
  String get italian => 'Italien';

  @override
  String get spanish => 'Espagnol';

  @override
  String get portuguese => 'Portugais';

  @override
  String get finnish => 'Finnois';

  @override
  String get changeListName => 'Modifier le nom de la liste';

  @override
  String get cancel => 'Annuler';

  @override
  String get save => 'Enregistrer';

  @override
  String get manualAddItem => 'Ajouter un article manuellement...';

  @override
  String get emptyList => 'La liste est vide';

  @override
  String get noHistory => 'Aucun historique pour cette liste';

  @override
  String get globalHistory => 'Historique global';

  @override
  String get newShoppingList => 'Nouvelle liste de courses';

  @override
  String get listName => 'Nom de la liste';

  @override
  String get noHistoryFound => 'Aucun historique trouvé';

  @override
  String get addedItems => 'Additifs E';

  @override
  String get identifiedAdditions => 'Additifs E identifiés';

  @override
  String get noAdditionsFound => 'Aucun additif E trouvé dans la base de données.';

  @override
  String get disclaimer => 'Clause de non-responsabilité : Ces informations sont à titre informatif uniquement et basées sur des données accessibles au public. Pour 100% d\'informations exactes, consultez l\'emballage du produit ou contactez le fabricant.';

  @override
  String get bovaerHighRisk => 'RISQUE ÉLEVÉ : Le producteur est directement lié à Bovaer.';

  @override
  String get gmoHighRisk => 'RISQUE ÉLEVÉ : Le producteur est lié à l\'utilisation d\'aliments OGM.';

  @override
  String get bovaerPossibleRisk => 'RISQUE POSSIBLE : Le producteur est partenaire d\'entreprises liées à Bovaer.';

  @override
  String get safeProduct => 'SÛR : Le produit est certifié biologique.';

  @override
  String get searchHint => 'Rechercher... (ex. lait)';

  @override
  String get delete => 'Supprimer';

  @override
  String get deleteListConfirmTitle => 'Supprimer la liste ?';

  @override
  String get deleteListConfirmMessage => 'Êtes-vous sûr ? L’historique de la liste sera également supprimé.';

  @override
  String get unknownProduct => 'Produit inconnu';

  @override
  String get removeAds => 'Supprimer les publicités';

  @override
  String get removeAdsInfo => 'Supprimez les publicités pour plus de place dans la liste de courses';

  @override
  String get removeAdsMenuItem => 'Supprimer les publicités (49 kr) – soutient le développement';

  @override
  String get gmoRegExplicit => 'STATUT RÉGLEMENTAIRE UE : Le produit semble relever d’une catégorie réglementée OGM/NGT.';

  @override
  String get gmoRegFeedChain => 'STATUT RÉGLEMENTAIRE UE : Peut relever des règles OGM/NGT via la chaîne d’alimentation animale.';

  @override
  String get gmoRegNgt => 'STATUT RÉGLEMENTAIRE UE : Le produit peut être concerné par la nouvelle décision de l’UE sur l’édition génomique (NGT).';

  @override
  String get gmoRegSupplyChain => 'STATUT RÉGLEMENTAIRE UE : Pertinence OGM/NGT indirecte possible via la chaîne importateur/fournisseur/producteur.';

  @override
  String get gmoRegCropOrigin => 'STATUT RÉGLEMENTAIRE UE : Matière première à risque OGM d’origine américaine/hors UE – peut déclencher l’obligation d’étiquetage OGM de l’UE.';

  @override
  String get gmoRegCropUnknown => 'STATUT RÉGLEMENTAIRE UE : Matière première à risque OGM au stade importation/fournisseur – l’origine doit être vérifiée.';

  @override
  String get insectRegExplicit => 'STATUT RÉGLEMENTAIRE UE : Le produit semble relever d’une catégorie réglementée insectes/nouveaux aliments.';

  @override
  String get insectRegNovelFood => 'STATUT RÉGLEMENTAIRE UE : Le produit peut relever des règles de l’UE sur les insectes en tant que nouveaux aliments.';

  @override
  String get insectRegSupplyChain => 'STATUT RÉGLEMENTAIRE UE : Pertinence indirecte possible via la chaîne importateur/fournisseur/producteur.';

  @override
  String get gmoConsExplicit => 'RISQUE CONSOMMATEUR : Le texte/l’étiquette du produit indique la présence d’OGM.';

  @override
  String get gmoConsFeed => 'RISQUE CONSOMMATEUR : La marque/catégorie correspond à une exposition connue à des aliments pour animaux OGM.';

  @override
  String get gmoConsNgt => 'RISQUE CONSOMMATEUR : Peut concerner le marché de consommation, mais à vérifier sur l’étiquette et auprès du producteur.';

  @override
  String get gmoConsSupplyChain => 'RISQUE CONSOMMATEUR : Risque possible via la chaîne d’approvisionnement (qui vend à qui). Vérifiez l’étiquette et l’origine.';

  @override
  String get gmoConsCropOrigin => 'RISQUE CONSOMMATEUR : Contient une matière première à risque OGM (soja/maïs/colza/betterave sucrière/coton) importée d’un pays où la culture est majoritairement génétiquement modifiée. Recherchez la mention « sans OGM » sur l’étiquette.';

  @override
  String get gmoConsCropUnknown => 'RISQUE CONSOMMATEUR : Le produit contient une matière première à risque OGM (soja/maïs/colza/betterave sucrière/coton). Origine inconnue – vérifiez l’étiquette et le pays d’origine.';

  @override
  String get insectConsExplicit => 'RISQUE CONSOMMATEUR : Le texte/les ingrédients du produit indiquent de la farine ou des protéines d’insectes.';

  @override
  String get insectConsNovelFood => 'RISQUE CONSOMMATEUR : Exposition possible liée aux insectes, vérifiez la liste des ingrédients.';

  @override
  String get insectConsSupplyChain => 'RISQUE CONSOMMATEUR : Risque possible via la chaîne d’approvisionnement (qui vend à qui).';

  @override
  String get noKnownRisk => 'Aucun risque connu dans cette catégorie.';

  @override
  String get searchBetaNote => 'Bêta : la recherche est en amélioration continue. Vérifiez toujours les détails du produit avant de faire un choix.';

  @override
  String get couldNotOpenLink => 'Impossible d’ouvrir le lien';

  @override
  String get eNumberNoDescription => 'Nous n’avons pas encore de description de cet additif. Le numéro E est un code d’additif utilisé dans l’UE/EEE.';

  @override
  String get allergensTitle => 'Allergènes';

  @override
  String get noAllergensFound => 'Aucun allergène trouvé.';

  @override
  String get nutritionTitle => 'Valeurs nutritionnelles (pour 100 g)';

  @override
  String get noNutritionFound => 'Aucune information nutritionnelle trouvée.';

  @override
  String get alertsTitle => 'Alertes';

  @override
  String get alertEvidence => 'Éléments :';

  @override
  String get alertInternalListNote => 'Alerte : liste interne des liens entre marques';

  @override
  String get alertBrandTrackingNote => 'Alerte : suivi des marques et informations publiques';

  @override
  String get reportNoteHint => 'Note courte (ex. faux positif)';

  @override
  String get report => 'Signaler';

  @override
  String get send => 'Envoyer';

  @override
  String get reportSaved => 'Merci — signalement enregistré.';

  @override
  String get seeUpdatedStatus => 'Voir le statut à jour';

  @override
  String get openEuSource => 'Ouvrir la source UE';

  @override
  String get openInsectSource => 'Ouvrir la source sur les insectes';

  @override
  String get privacyTitle => 'Confidentialité';

  @override
  String get consentOptional => 'C’est facultatif. Sans votre consentement, votre utilisation n’est pas envoyée pour analyse.';

  @override
  String get consentWorksAnyway => 'L’application fonctionne dans tous les cas, et les données peuvent rester uniquement sur votre appareil.';

  @override
  String get readPrivacyPolicy => 'Lire la politique de confidentialité';

  @override
  String get allowAnonymousAnalytics => 'Autoriser l’analyse anonyme';

  @override
  String get analyticsEnabled => 'Merci – analyse activée.';

  @override
  String get analyticsDisabled => 'Analyse désactivée.';

  @override
  String couldNotOpenLinkError(String error) {
    return 'Impossible d’ouvrir le lien : $error';
  }

  @override
  String reportSaveFailed(String error) {
    return 'Impossible d’enregistrer le signalement : $error';
  }

  @override
  String alertSeverity(String value) {
    return 'Gravité : $value';
  }

  @override
  String alertReason(String value) {
    return 'Raison : $value';
  }

  @override
  String alertConfidence(String value) {
    return 'Confiance : $value';
  }

  @override
  String matvaretabellenSuggestions(String count) {
    return 'Suggestions de Matvaretabellen : $count';
  }

  @override
  String addedToList(String item, String list) {
    return '« $item » ajouté à $list';
  }

  @override
  String nutritionEnergy(String value) {
    return 'Énergie : $value kcal';
  }

  @override
  String nutritionFat(String value) {
    return 'Matières grasses : $value g';
  }

  @override
  String nutritionSaturatedFat(String value) {
    return 'dont acides gras saturés : $value g';
  }

  @override
  String nutritionCarbohydrates(String value) {
    return 'Glucides : $value g';
  }

  @override
  String nutritionSugars(String value) {
    return 'dont sucres : $value g';
  }

  @override
  String nutritionProtein(String value) {
    return 'Protéines : $value g';
  }

  @override
  String nutritionSalt(String value) {
    return 'Sel : $value g';
  }

  @override
  String get countryDataSources => 'Pays / sources de données';

  @override
  String get chooseCountryTitle => 'Choisir le pays (priorise les sources)';

  @override
  String get privacyIntro => 'Veuillez lire la politique de confidentialité lors de la première utilisation. Vous pouvez utiliser l\'application sans analyse, et vos données de courses restent sur votre appareil.';
}
