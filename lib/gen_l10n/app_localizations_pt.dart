// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Verificador de Alimentos';

  @override
  String get scanBarcode => 'Escanear código de barras';

  @override
  String get productNotFound => 'Produto não encontrado no banco de dados.';

  @override
  String get addToList => 'Adicionar à lista de compras';

  @override
  String get shoppingLists => 'Listas de compras';

  @override
  String get history => 'Histórico';

  @override
  String get settings => 'Configurações';

  @override
  String get about => 'Sobre o app';

  @override
  String get howAppWorks => 'Como o app obtém informações';

  @override
  String get appDescription =>
      'O app usa Open Food Facts e uma lista interna de marcas para identificar produtos com Bovaer, farinha de insetos, ração transgênica e outros ingredientes controversos.';

  @override
  String get alerts => 'Selecionar alertas';

  @override
  String get bovaerAlert => 'Alerta Bovaer';

  @override
  String get insectMealAlert => 'Alerta farinha de insetos';

  @override
  String get gmoFishAlert => 'Ração transgênica (Peixe)';

  @override
  String get highRisk => 'RISCO ALTO';

  @override
  String get possibleRisk => 'RISCO POSSÍVEL';

  @override
  String get safe => 'SEGURO';

  @override
  String get unknown => 'DESCONHECIDO';

  @override
  String get bovaerRiskDesc =>
      'O produtor está diretamente vinculado ao Bovaer.';

  @override
  String get insectMealRiskDesc => 'O produto pode conter farinha de insetos.';

  @override
  String get gmoFishRiskDesc =>
      'O produtor está vinculado ao uso de ração transgênica.';

  @override
  String get safeDesc => 'O produto é certificado como orgânico.';

  @override
  String get nutriScore => 'Nutri-Score';

  @override
  String get traceability => 'Rastreabilidade';

  @override
  String get beta => 'Beta';

  @override
  String get close => 'Fechar';

  @override
  String get create => 'Criar';

  @override
  String get search => 'Pesquisar';

  @override
  String get searchProducts => 'Pesquisar produtos';

  @override
  String get noResults => 'Nenhum resultado';

  @override
  String get newList => 'Nova lista';

  @override
  String get deleteList => 'Pressione por mais tempo para excluir';

  @override
  String get language => 'Idioma';

  @override
  String get selectLanguage => 'Selecionar idioma';

  @override
  String get norwegian => 'Norueguês';

  @override
  String get swedish => 'Sueco';

  @override
  String get danish => 'Dinamarquês';

  @override
  String get dutch => 'Holandês';

  @override
  String get french => 'Francês';

  @override
  String get english => 'Inglês';

  @override
  String get german => 'Alemão';

  @override
  String get italian => 'Italiano';

  @override
  String get spanish => 'Espanhol';

  @override
  String get portuguese => 'Português';

  @override
  String get finnish => 'Finnish';

  @override
  String get changeListName => 'Alterar nome da lista';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Salvar';

  @override
  String get manualAddItem => 'Adicionar item manualmente...';

  @override
  String get emptyList => 'A lista está vazia';

  @override
  String get noHistory => 'Sem histórico para esta lista';

  @override
  String get globalHistory => 'Histórico global';

  @override
  String get newShoppingList => 'Nova lista de compras';

  @override
  String get listName => 'Nome da lista';

  @override
  String get noHistoryFound => 'Nenhum histórico encontrado';

  @override
  String get addedItems => 'Aditivos E';

  @override
  String get identifiedAdditions => 'Aditivos E identificados';

  @override
  String get noAdditionsFound =>
      'Nenhum aditivo E encontrado no banco de dados.';

  @override
  String get disclaimer =>
      'Aviso de reséva: Esta informação é apenas orientativa e baseada em dados disponíveis publicamente. Para informações 100% precisas, consulte a embalagem do produto ou entre em contato com o fabricante.';

  @override
  String get bovaerHighRisk =>
      'RISCO ALTO: O produtor está diretamente vinculado ao Bovaer.';

  @override
  String get gmoHighRisk =>
      'RISCO ALTO: O produtor está vinculado ao uso de ração transgénica.';

  @override
  String get bovaerPossibleRisk =>
      'RISCO POSSÍVEL: O produtor é parceiro de empresas vinculadas ao Bovaer.';

  @override
  String get safeProduct => 'SEGURO: O produto é certificado como orgânico.';

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
