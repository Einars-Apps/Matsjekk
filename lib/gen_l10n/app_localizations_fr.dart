// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Vérif Aliment';

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
  String get appDescription =>
      'L\'application utilise Open Food Facts et une liste interne de marques pour identifier les produits contenant du Bovaer, de la farine d\'insectes, des aliments OGM et d\'autres ingrédients controversés.';

  @override
  String get alerts => 'Sélectionner les alertes';

  @override
  String get bovaerAlert => 'Alerte Bovaer';

  @override
  String get insectMealAlert => 'Alerte farine d\'insectes';

  @override
  String get ngtAlert => 'Hidden GMO (NGT) Alert';

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
  String get insectMealRiskDesc =>
      'Le produit peut contenir de la farine d\'insectes.';

  @override
  String get gmoFishRiskDesc =>
      'Le producteur est lié à l\'utilisation d\'aliments OGM.';

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
  String get finnish => 'Finlandais';

  @override
  String get korean => 'Coréen';

  @override
  String get polish => 'Polonais';

  @override
  String get russian => 'Russe';

  @override
  String get chinese => 'Chinois';

  @override
  String get arabic => 'Arabe';

  @override
  String get thai => 'Thaïlandais';

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
  String get noAdditionsFound =>
      'Aucun additif E trouvé dans la base de données.';

  @override
  String get disclaimer =>
      'Clause de non-responsabilité : Ces informations sont à titre informatif uniquement et basées sur des données accessibles au public. Pour 100% d\'informations exactes, consultez l\'emballage du produit ou contactez le fabricant.';

  @override
  String get bovaerHighRisk =>
      'RISQUE ÉLEVÉ : Cette marque est un utilisateur confirmé de Bovaer ou appartient à un producteur qui l\'est.';

  @override
  String get gmoHighRisk =>
      'RISQUE ÉLEVÉ : Le producteur est lié à l\'utilisation d\'aliments OGM.';

  @override
  String get bovaerPossibleRisk =>
      'INCERTAIN : Le produit peut contenir du lait d\'une laiterie qui reçoit du lait de fermes Bovaer.';

  @override
  String get safeProduct => 'SÛR : Le produit est certifié biologique.';

  @override
  String get searchHint => 'Rechercher... (ex. lait)';

  @override
  String get delete => 'Supprimer';

  @override
  String get deleteListConfirmTitle => 'Supprimer la liste ?';

  @override
  String get deleteListConfirmMessage =>
      'Êtes-vous sûr ? Cela supprimera également l\'historique de la liste.';

  @override
  String get unknownProduct => 'Produit inconnu';

  @override
  String get removeAds => 'Supprimer les publicités';

  @override
  String get removeAdsInfo =>
      'Supprimez les publicités pour plus d\'espace dans la liste de courses';

  @override
  String get removeAdsMenuItem =>
      'Supprimer les publicités - soutient le développement';

  @override
  String get premiumTitle => 'Supprimer les publicités';

  @override
  String get premiumActiveStatus => 'Sans publicité est actif';

  @override
  String get premiumInactiveStatus => 'Sans publicité n\'est pas encore activé';

  @override
  String get buyAdFreeTitle => 'Acheter la version sans publicité';

  @override
  String get oneTimePurchaseInfo =>
      'Achat unique. Pas d\'abonnement.\nAprès confirmation de l\'achat, les publicités sont supprimées définitivement pour ce compte.';

  @override
  String get storeUnavailable =>
      'Le magasin n\'est pas disponible actuellement. Veuillez réessayer plus tard.';

  @override
  String get productsLoadFailed =>
      'Impossible de charger les produits d\'achat. Vérifiez votre réseau et réessayez.';

  @override
  String get purchaseNotAvailableOnDevice =>
      'In-app purchases are not available on this device. If you have already purchased ad-free, it will be restored automatically.';

  @override
  String get tryAgain => 'Réessayer';

  @override
  String get oneTimePurchaseLabel => 'achat unique';

  @override
  String get buyPermanently => 'Acheter définitivement';

  @override
  String get restorePurchases => 'Restaurer les achats';

  @override
  String get analyticsEnabled => 'Merci – analyse activée.';

  @override
  String get analyticsDisabled => 'Analyse désactivée.';

  @override
  String get privacy => 'Confidentialité';

  @override
  String get adFreeActive => 'Sans publicité (actif)';

  @override
  String get consentLocalOnly =>
      'L\'application continue de fonctionner et les données peuvent rester uniquement sur votre appareil.';

  @override
  String get allowAnonymousAnalytics => 'Autoriser l\'analyse anonyme';

  @override
  String get consentOptional =>
      'C\'est facultatif. Si vous ne consentez pas, vos données d\'utilisation ne sont pas envoyées à l\'analyse.';

  @override
  String get couldNotOpenLink => 'Impossible d\'ouvrir le lien';

  @override
  String get howAppWorksSteps =>
      '1. Scannez le code-barres du produit.\n2. L\'appli récupère les données produit depuis Open Food Facts.\n3. Les alertes sont évaluées selon les règles internes de marques et d\'ingrédients.\n4. Vous obtenez un aperçu simple du risque et pouvez sauvegarder des articles dans votre liste de courses.';

  @override
  String get betaWarning =>
      'Important : Ceci est une fonctionnalité bêta. Vérifiez toujours les informations sur l\'emballage/étiquette.';

  @override
  String get matvaretabellenMatches => 'Résultats Matvaretabellen';

  @override
  String get reportSaved => 'Merci — rapport enregistré.';

  @override
  String get couldNotSaveReport => 'Impossible d\'enregistrer le rapport';

  @override
  String get seeUpdatedStatus => 'Voir le statut mis à jour';

  @override
  String get gmoFeedLabel => 'Alimentation OGM';

  @override
  String get insectMealLabel => 'Farine d\'insectes';

  @override
  String get ngtLabel => 'Hidden GMO (NGT)';

  @override
  String get allergensLabel => 'Allergènes';

  @override
  String get noAllergensFound => 'Aucun allergène trouvé.';

  @override
  String get nutritionPer100g => 'Valeurs nutritionnelles (pour 100g)';

  @override
  String get nutritionSource => 'source';

  @override
  String get energyLabel => 'Énergie';

  @override
  String get fatLabel => 'Matières grasses';

  @override
  String get saturatedFatLabel => 'Dont acides gras saturés';

  @override
  String get carbohydratesLabel => 'Glucides';

  @override
  String get sugarsLabel => 'Dont sucres';

  @override
  String get proteinLabel => 'Protéines';

  @override
  String get saltLabel => 'Sel';

  @override
  String get noNutritionFound => 'Aucune information nutritionnelle trouvée.';

  @override
  String get unknownName => 'Nom inconnu';

  @override
  String get noInfo => 'Pas d\'info';

  @override
  String get paymentConfirmed =>
      'Paiement confirmé. Les publicités sont maintenant supprimées définitivement.';

  @override
  String get purchaseFailed => 'L\'achat a échoué. Veuillez réessayer.';

  @override
  String get purchaseCancelled => 'L\'achat a été annulé.';

  @override
  String get purchaseStreamError => 'Flux d\'achat échoué';

  @override
  String get productIdNotFound =>
      'Produit d\'achat introuvable. Vérifiez l\'ID du produit.';

  @override
  String get internalWarning1 => 'Avis : liste interne de suivi des marques';

  @override
  String get internalWarning2 =>
      'Avis : suivi de marque et informations publiques';

  @override
  String addedToList(String item, String list) {
    return '«$item» ajouté à $list';
  }

  @override
  String get shoppingListMemoryTitle =>
      'Liste de courses : mémoire et saisie automatique';

  @override
  String get shoppingListMemoryHow =>
      'Comment utiliser la mémoire de la liste de courses';

  @override
  String get shoppingListMemoryIntro =>
      'La liste de courses a une mémoire et une saisie automatique :';

  @override
  String get shoppingListMemoryStep1 =>
      '1. + ajoute exactement ce que vous tapez.';

  @override
  String get shoppingListMemoryStep2 =>
      '2. Entrée ajoute la suggestion dans le champ.';

  @override
  String get shoppingListMemoryStep3 =>
      '3. Appuyez sur un produit dans la liste mémoire pour l’ajouter.';

  @override
  String get appReviewTestTitle => 'Codes de test App Review';

  @override
  String get appReviewTestSubtitle => 'Ouvrir des produits démo sans caméra';

  @override
  String get appReviewTestInstructions =>
      'Choisissez un code de test pour ouvrir un produit démo :';

  @override
  String appReviewDemoNotFound(String code) {
    return 'Produit démo non trouvé pour $code';
  }

  @override
  String get adPlaceholderText => 'Emplacement publicitaire actif';
}
