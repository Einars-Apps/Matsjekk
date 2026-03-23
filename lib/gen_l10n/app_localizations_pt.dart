// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Verificação Alimentar';

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
  String get finnish => 'Finlandês';

  @override
  String get korean => 'Coreano';

  @override
  String get polish => 'Polaco';

  @override
  String get russian => 'Russo';

  @override
  String get chinese => 'Chinês';

  @override
  String get arabic => 'Árabe';

  @override
  String get thai => 'Tailandês';

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
      'RISCO ALTO: A marca é utilizadora confirmada de Bovaer ou pertence a um produtor que o é.';

  @override
  String get gmoHighRisk =>
      'RISCO ALTO: O produtor está vinculado ao uso de ração transgénica.';

  @override
  String get bovaerPossibleRisk =>
      'INCERTO: O produto pode conter leite de um laticínio que recebe leite de explorações com Bovaer.';

  @override
  String get safeProduct => 'SEGURO: O produto é certificado como orgânico.';

  @override
  String get searchHint => 'Pesquisar... (ex. leite)';

  @override
  String get delete => 'Eliminar';

  @override
  String get deleteListConfirmTitle => 'Eliminar lista?';

  @override
  String get deleteListConfirmMessage =>
      'Tem a certeza? Isso também apagará o histórico da lista.';

  @override
  String get unknownProduct => 'Produto desconhecido';

  @override
  String get removeAds => 'Remover anúncios';

  @override
  String get removeAdsInfo =>
      'Remova anúncios para mais espaço na lista de compras';

  @override
  String get removeAdsMenuItem =>
      'Remover anúncios - apoia o desenvolvimento contínuo';

  @override
  String get premiumTitle => 'Remover anúncios';

  @override
  String get premiumActiveStatus => 'Sem anúncios está ativo';

  @override
  String get premiumInactiveStatus => 'Sem anúncios ainda não está ativo';

  @override
  String get buyAdFreeTitle => 'Comprar versão sem anúncios';

  @override
  String get oneTimePurchaseInfo =>
      'Compra única. Sem assinatura.\nApós a confirmação da compra, os anúncios são removidos permanentemente para esta conta.';

  @override
  String get storeUnavailable =>
      'A loja não está disponível no momento. Tente novamente mais tarde.';

  @override
  String get productsLoadFailed =>
      'Não foi possível carregar os produtos de compra. Verifique a sua rede e tente novamente.';

  @override
  String get tryAgain => 'Tentar novamente';

  @override
  String get oneTimePurchaseLabel => 'compra única';

  @override
  String get buyPermanently => 'Comprar permanentemente';

  @override
  String get restorePurchases => 'Restaurar compras';

  @override
  String get analyticsEnabled => 'Obrigado – análise ativada.';

  @override
  String get analyticsDisabled => 'Análise desativada.';

  @override
  String get privacy => 'Privacidade';

  @override
  String get adFreeActive => 'Sem anúncios (ativo)';

  @override
  String get consentLocalOnly =>
      'A aplicação continua a funcionar e os dados podem permanecer apenas no seu dispositivo.';

  @override
  String get allowAnonymousAnalytics => 'Permitir análise anónima';

  @override
  String get consentOptional =>
      'Isto é opcional. Se não consentir, os seus dados de utilização não são enviados para análise.';

  @override
  String get couldNotOpenLink => 'Não foi possível abrir o link';

  @override
  String get howAppWorksSteps =>
      '1. Leia o código de barras do produto.\n2. A app obtém os dados do produto do Open Food Facts.\n3. Os alertas são avaliados de acordo com regras internas de marcas e ingredientes.\n4. Obtém uma visão simples do risco e pode guardar artigos na lista de compras.';

  @override
  String get betaWarning =>
      'Importante: Esta é uma funcionalidade beta. Verifique sempre a informação na embalagem/rótulo.';

  @override
  String get matvaretabellenMatches => 'Resultados Matvaretabellen';

  @override
  String get reportSaved => 'Obrigado — relatório guardado.';

  @override
  String get couldNotSaveReport => 'Não foi possível guardar o relatório';

  @override
  String get seeUpdatedStatus => 'Ver estado atualizado';

  @override
  String get gmoFeedLabel => 'Ração OGM';

  @override
  String get insectMealLabel => 'Farinha de insetos';

  @override
  String get allergensLabel => 'Alérgenos';

  @override
  String get noAllergensFound => 'Nenhum alérgeno encontrado.';

  @override
  String get nutritionPer100g => 'Informação nutricional (por 100g)';

  @override
  String get nutritionSource => 'fonte';

  @override
  String get energyLabel => 'Energia';

  @override
  String get fatLabel => 'Gordura';

  @override
  String get saturatedFatLabel => 'Das quais gordura saturada';

  @override
  String get carbohydratesLabel => 'Hidratos de carbono';

  @override
  String get sugarsLabel => 'Dos quais açúcares';

  @override
  String get proteinLabel => 'Proteína';

  @override
  String get saltLabel => 'Sal';

  @override
  String get noNutritionFound => 'Nenhuma informação nutricional encontrada.';

  @override
  String get unknownName => 'Nome desconhecido';

  @override
  String get noInfo => 'Sem info';

  @override
  String get paymentConfirmed =>
      'Pagamento confirmado. Os anúncios foram removidos permanentemente.';

  @override
  String get purchaseFailed => 'Compra falhou. Tente novamente.';

  @override
  String get purchaseCancelled => 'A compra foi cancelada.';

  @override
  String get purchaseStreamError => 'Fluxo de compra falhou';

  @override
  String get productIdNotFound =>
      'Produto de compra não encontrado. Verifique o ID do produto.';

  @override
  String get internalWarning1 =>
      'Aviso: lista interna para rastreamento de marcas';

  @override
  String get internalWarning2 =>
      'Aviso: rastreamento de marca e informações públicas';

  @override
  String addedToList(String item, String list) {
    return '«$item» adicionado a $list';
  }

  @override
  String get shoppingListMemoryTitle =>
      'Lista de compras: memória e autocompletar';

  @override
  String get shoppingListMemoryHow => 'Como usar a memória da lista de compras';

  @override
  String get shoppingListMemoryIntro =>
      'A lista de compras tem memória e autocompletar:';

  @override
  String get shoppingListMemoryStep1 =>
      '1. + adiciona exatamente o que você digita.';

  @override
  String get shoppingListMemoryStep2 =>
      '2. Enter adiciona a sugestão no campo.';

  @override
  String get shoppingListMemoryStep3 =>
      '3. Toque num produto na lista de memória para adicioná-lo.';

  @override
  String get appReviewTestTitle => 'Códigos de teste App Review';

  @override
  String get appReviewTestSubtitle => 'Abrir produtos demo sem câmera';

  @override
  String get appReviewTestInstructions =>
      'Escolha um código de teste para abrir um produto demo:';

  @override
  String appReviewDemoNotFound(String code) {
    return 'Produto demo não encontrado para $code';
  }

  @override
  String get adPlaceholderText => 'Espaço publicitário ativo';
}
