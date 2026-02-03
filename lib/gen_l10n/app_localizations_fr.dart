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
  String get appDescription =>
      'L\'application utilise Open Food Facts et une liste interne de marques pour identifier les produits contenant du Bovaer, de la farine d\'insectes, des aliments OGM et d\'autres ingrédients controversés.';

  @override
  String get alerts => 'Sélectionner les alertes';

  @override
  String get bovaerAlert => 'Alerte Bovaer';

  @override
  String get insectMealAlert => 'Alerte farine d\'insectes';

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
  String get finnish => 'Finnish';

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
      'RISQUE ÉLEVÉ : Le producteur est directement lié à Bovaer.';

  @override
  String get gmoHighRisk =>
      'RISQUE ÉLEVÉ : Le producteur est lié à l\'utilisation d\'aliments OGM.';

  @override
  String get bovaerPossibleRisk =>
      'RISQUE POSSIBLE : Le producteur est partenaire d\'entreprises liées à Bovaer.';

  @override
  String get safeProduct => 'SÛR : Le produit est certifié biologique.';

  @override
  String get searchHint => 'Search... (e.g. milk)';

  @override
  String get delete => 'Delete';

  @override
  String get deleteListConfirmTitle => 'Delete list?';

  @override
  String get deleteListConfirmMessage =>
      'Are you sure? This will also delete the history for the list.';

  @override
  String get unknownProduct => 'Unknown product';
}
