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
  String get appDescription => 'O app usa Open Food Facts e uma lista interna de marcas para identificar produtos com Bovaer, farinha de insetos, ração transgênica e outros ingredientes controversos.';

  @override
  String get alerts => 'Selecionar alertas';

  @override
  String get bovaerAlert => 'Alerta Bovaer';

  @override
  String get insectMealAlert => 'Alerta farinha de insetos';

  @override
  String get ngtAlert => 'Alerta de OGM oculto (NGT)';

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
  String get bovaerRiskDesc => 'O produtor está diretamente vinculado ao Bovaer.';

  @override
  String get insectMealRiskDesc => 'O produto pode conter farinha de insetos.';

  @override
  String get gmoFishRiskDesc => 'O produtor está vinculado ao uso de ração transgênica.';

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
  String get noAdditionsFound => 'Nenhum aditivo E encontrado no banco de dados.';

  @override
  String get disclaimer => 'Aviso de reséva: Esta informação é apenas orientativa e baseada em dados disponíveis publicamente. Para informações 100% precisas, consulte a embalagem do produto ou entre em contato com o fabricante.';

  @override
  String get bovaerHighRisk => 'RISCO ALTO: O produtor está diretamente vinculado ao Bovaer.';

  @override
  String get gmoHighRisk => 'RISCO ALTO: O produtor está vinculado ao uso de ração transgénica.';

  @override
  String get bovaerPossibleRisk => 'RISCO POSSÍVEL: O produtor é parceiro de empresas vinculadas ao Bovaer.';

  @override
  String get safeProduct => 'SEGURO: O produto é certificado como orgânico.';

  @override
  String get searchHint => 'Pesquisar... (ex.: leite)';

  @override
  String get delete => 'Eliminar';

  @override
  String get deleteListConfirmTitle => 'Eliminar lista?';

  @override
  String get deleteListConfirmMessage => 'Tem a certeza? Isto também elimina o histórico da lista.';

  @override
  String get unknownProduct => 'Produto desconhecido';

  @override
  String get removeAds => 'Remover anúncios';

  @override
  String get removeAdsInfo => 'Remova os anúncios para ter mais espaço na lista de compras';

  @override
  String get removeAdsMenuItem => 'Remover anúncios (49 kr) – apoia o desenvolvimento';

  @override
  String get gmoRegExplicit => 'ESTADO REGULAMENTAR UE: O produto parece pertencer a uma categoria regulamentada de OGM/NGT.';

  @override
  String get gmoRegFeedChain => 'ESTADO REGULAMENTAR UE: Pode estar abrangido pelas regras de OGM/NGT através da cadeia de rações.';

  @override
  String get gmoRegNgt => 'ESTADO REGULAMENTAR UE: O produto pode estar abrangido pela nova decisão da UE sobre edição genética (NGT).';

  @override
  String get gmoRegSupplyChain => 'ESTADO REGULAMENTAR UE: Possível relevância indireta de OGM/NGT através da cadeia importador/fornecedor/produtor.';

  @override
  String get gmoRegCropOrigin => 'ESTADO REGULAMENTAR UE: Matéria-prima suscetível a OGM de origem americana/não UE – pode implicar a rotulagem obrigatória de OGM da UE.';

  @override
  String get gmoRegCropUnknown => 'ESTADO REGULAMENTAR UE: Matéria-prima suscetível a OGM na fase de importação/fornecimento – a origem deve ser verificada.';

  @override
  String get insectRegExplicit => 'ESTADO REGULAMENTAR UE: O produto parece pertencer a uma categoria regulamentada de insetos/novos alimentos.';

  @override
  String get insectRegNovelFood => 'ESTADO REGULAMENTAR UE: O produto pode estar abrangido pelas regras da UE para insetos como novos alimentos.';

  @override
  String get insectRegSupplyChain => 'ESTADO REGULAMENTAR UE: Possível relevância indireta através da cadeia importador/fornecedor/produtor.';

  @override
  String get gmoConsExplicit => 'RISCO PARA O CONSUMIDOR: O texto/rótulo do produto indica conteúdo de OGM.';

  @override
  String get gmoConsFeed => 'RISCO PARA O CONSUMIDOR: Marca/categoria corresponde a exposição conhecida a rações OGM.';

  @override
  String get gmoConsNgt => 'RISCO PARA O CONSUMIDOR: Pode afetar o mercado de consumo, mas deve ser verificado no rótulo e na informação do produtor.';

  @override
  String get gmoConsSupplyChain => 'RISCO PARA O CONSUMIDOR: Possível risco através da cadeia de fornecimento (quem vende a quem). Verifique o rótulo e a origem.';

  @override
  String get gmoConsCropOrigin => 'RISCO PARA O CONSUMIDOR: Contém matéria-prima suscetível a OGM (soja/milho/colza/beterraba sacarina/algodão) importada de um país onde a cultura é predominantemente geneticamente modificada. Procure no rótulo a indicação “sem OGM”.';

  @override
  String get gmoConsCropUnknown => 'RISCO PARA O CONSUMIDOR: O produto contém uma matéria-prima suscetível a OGM (soja/milho/colza/beterraba sacarina/algodão). Origem desconhecida – verifique o rótulo e o país de origem.';

  @override
  String get insectConsExplicit => 'RISCO PARA O CONSUMIDOR: O texto/ingredientes do produto indicam farinha ou proteína de insetos.';

  @override
  String get insectConsNovelFood => 'RISCO PARA O CONSUMIDOR: Possível exposição relacionada com insetos, verifique a lista de ingredientes.';

  @override
  String get insectConsSupplyChain => 'RISCO PARA O CONSUMIDOR: Possível risco através da cadeia de fornecimento (quem vende a quem).';

  @override
  String get noKnownRisk => 'Nenhum risco conhecido nesta categoria.';

  @override
  String get searchBetaNote => 'Beta: a pesquisa está em melhoria contínua. Verifique sempre os detalhes do produto antes de decidir.';

  @override
  String get couldNotOpenLink => 'Não foi possível abrir a ligação';

  @override
  String get eNumberNoDescription => 'Ainda não temos uma descrição deste aditivo. O número E é um código de aditivos usado na UE/EEE.';

  @override
  String get allergensTitle => 'Alergénios';

  @override
  String get noAllergensFound => 'Nenhum alergénio encontrado.';

  @override
  String get nutritionTitle => 'Informação nutricional (por 100 g)';

  @override
  String get noNutritionFound => 'Nenhuma informação nutricional encontrada.';

  @override
  String get alertsTitle => 'Alertas';

  @override
  String get alertEvidence => 'Evidência:';

  @override
  String get alertInternalListNote => 'Alerta: lista interna de ligações entre marcas';

  @override
  String get alertBrandTrackingNote => 'Alerta: rastreio de marcas e informação pública';

  @override
  String get reportNoteHint => 'Nota curta (ex.: falso positivo)';

  @override
  String get report => 'Reportar';

  @override
  String get send => 'Enviar';

  @override
  String get reportSaved => 'Obrigado — relatório guardado.';

  @override
  String get seeUpdatedStatus => 'Ver estado atualizado';

  @override
  String get openEuSource => 'Abrir fonte da UE';

  @override
  String get openInsectSource => 'Abrir fonte sobre insetos';

  @override
  String get privacyTitle => 'Privacidade';

  @override
  String get consentOptional => 'Isto é opcional. Se não consentir, a sua utilização não é enviada para análise.';

  @override
  String get consentWorksAnyway => 'A app funciona de qualquer forma e os dados podem ficar apenas no seu dispositivo.';

  @override
  String get readPrivacyPolicy => 'Ler a política de privacidade';

  @override
  String get allowAnonymousAnalytics => 'Permitir análise anónima';

  @override
  String get analyticsEnabled => 'Obrigado – análise ativada.';

  @override
  String get analyticsDisabled => 'Análise desativada.';

  @override
  String couldNotOpenLinkError(String error) {
    return 'Não foi possível abrir a ligação: $error';
  }

  @override
  String reportSaveFailed(String error) {
    return 'Não foi possível guardar o relatório: $error';
  }

  @override
  String alertSeverity(String value) {
    return 'Gravidade: $value';
  }

  @override
  String alertReason(String value) {
    return 'Motivo: $value';
  }

  @override
  String alertConfidence(String value) {
    return 'Confiança: $value';
  }

  @override
  String matvaretabellenSuggestions(String count) {
    return 'Sugestões da Matvaretabellen: $count';
  }

  @override
  String addedToList(String item, String list) {
    return '\"$item\" adicionado a $list';
  }

  @override
  String nutritionEnergy(String value) {
    return 'Energia: $value kcal';
  }

  @override
  String nutritionFat(String value) {
    return 'Lípidos: $value g';
  }

  @override
  String nutritionSaturatedFat(String value) {
    return 'dos quais saturados: $value g';
  }

  @override
  String nutritionCarbohydrates(String value) {
    return 'Hidratos de carbono: $value g';
  }

  @override
  String nutritionSugars(String value) {
    return 'dos quais açúcares: $value g';
  }

  @override
  String nutritionProtein(String value) {
    return 'Proteínas: $value g';
  }

  @override
  String nutritionSalt(String value) {
    return 'Sal: $value g';
  }

  @override
  String get countryDataSources => 'País / fontes de dados';

  @override
  String get chooseCountryTitle => 'Escolher país (prioriza fontes)';

  @override
  String get privacyIntro => 'Leia a política de privacidade na primeira utilização da app. Pode usar a app sem análise, e os seus dados de compras ficam no seu dispositivo.';
}
