// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Verificador de Alimentos';

  @override
  String get scanBarcode => 'Escanear código de barras';

  @override
  String get productNotFound => 'Producto no encontrado en la base de datos.';

  @override
  String get addToList => 'Añadir a lista de compra';

  @override
  String get shoppingLists => 'Listas de compra';

  @override
  String get history => 'Historial';

  @override
  String get settings => 'Configuración';

  @override
  String get about => 'Acerca de la app';

  @override
  String get howAppWorks => 'Cómo la app obtiene información';

  @override
  String get appDescription => 'La app utiliza Open Food Facts y una lista interna de marcas para identificar productos con Bovaer, harina de insectos, alimentos transgénicos y otros ingredientes controvertidos.';

  @override
  String get alerts => 'Seleccionar alertas';

  @override
  String get bovaerAlert => 'Alerta Bovaer';

  @override
  String get insectMealAlert => 'Alerta harina de insectos';

  @override
  String get ngtAlert => 'Alerta de OMG oculto (NGT)';

  @override
  String get gmoFishAlert => 'Alimentos transgénicos (Peces)';

  @override
  String get highRisk => 'RIESGO ALTO';

  @override
  String get possibleRisk => 'RIESGO POSIBLE';

  @override
  String get safe => 'SEGURO';

  @override
  String get unknown => 'DESCONOCIDO';

  @override
  String get bovaerRiskDesc => 'El productor está directamente vinculado a Bovaer.';

  @override
  String get insectMealRiskDesc => 'El producto puede contener harina de insectos.';

  @override
  String get gmoFishRiskDesc => 'El productor está vinculado al uso de alimentos transgénicos.';

  @override
  String get safeDesc => 'El producto está certificado como orgánico.';

  @override
  String get nutriScore => 'Nutri-Score';

  @override
  String get traceability => 'Trazabilidad';

  @override
  String get beta => 'Beta';

  @override
  String get close => 'Cerrar';

  @override
  String get create => 'Crear';

  @override
  String get search => 'Buscar';

  @override
  String get searchProducts => 'Buscar productos';

  @override
  String get noResults => 'Sin resultados';

  @override
  String get newList => 'Nueva lista';

  @override
  String get deleteList => 'Pulsa largo para eliminar';

  @override
  String get language => 'Idioma';

  @override
  String get selectLanguage => 'Seleccionar idioma';

  @override
  String get norwegian => 'Noruego';

  @override
  String get swedish => 'Sueco';

  @override
  String get danish => 'Danés';

  @override
  String get dutch => 'Holandés';

  @override
  String get french => 'Francés';

  @override
  String get english => 'Inglés';

  @override
  String get german => 'Alemán';

  @override
  String get italian => 'Italiano';

  @override
  String get spanish => 'Español';

  @override
  String get portuguese => 'Portugués';

  @override
  String get finnish => 'Finés';

  @override
  String get changeListName => 'Cambiar nombre de lista';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get manualAddItem => 'Añadir artículo manualmente...';

  @override
  String get emptyList => 'La lista está vacía';

  @override
  String get noHistory => 'Sin historial para esta lista';

  @override
  String get globalHistory => 'Historial global';

  @override
  String get newShoppingList => 'Nueva lista de compra';

  @override
  String get listName => 'Nombre de lista';

  @override
  String get noHistoryFound => 'Sin historial';

  @override
  String get addedItems => 'Aditivos E';

  @override
  String get identifiedAdditions => 'Aditivos E identificados';

  @override
  String get noAdditionsFound => 'Ningún aditivo E encontrado en la base de datos.';

  @override
  String get disclaimer => 'Aviso legal: Esta información es solo orientativa y se basa en datos disponibles públicamente. Para información 100% precisa, consulte el envase del producto o póngase en contacto con el fabricante.';

  @override
  String get bovaerHighRisk => 'RIESGO ALTO: El productor está directamente vinculado a Bovaer.';

  @override
  String get gmoHighRisk => 'RIESGO ALTO: El productor está vinculado al uso de alimentos transgénicos.';

  @override
  String get bovaerPossibleRisk => 'RIESGO POSIBLE: El productor es socio de empresas vinculadas a Bovaer.';

  @override
  String get safeProduct => 'SEGURO: El producto está certificado como orgánico.';

  @override
  String get searchHint => 'Buscar... (p. ej., leche)';

  @override
  String get delete => 'Eliminar';

  @override
  String get deleteListConfirmTitle => '¿Eliminar la lista?';

  @override
  String get deleteListConfirmMessage => '¿Seguro? También se eliminará el historial de la lista.';

  @override
  String get unknownProduct => 'Producto desconocido';

  @override
  String get removeAds => 'Quitar anuncios';

  @override
  String get removeAdsInfo => 'Quita los anuncios para tener más espacio en la lista de la compra';

  @override
  String get removeAdsMenuItem => 'Quitar anuncios (49 kr): apoya el desarrollo';

  @override
  String get gmoRegExplicit => 'ESTADO NORMATIVO UE: El producto parece pertenecer a una categoría regulada de OMG/NGT.';

  @override
  String get gmoRegFeedChain => 'ESTADO NORMATIVO UE: Puede estar sujeto a las normas de OMG/NGT a través de la cadena de piensos.';

  @override
  String get gmoRegNgt => 'ESTADO NORMATIVO UE: El producto puede verse afectado por la nueva decisión de la UE sobre edición genética (NGT).';

  @override
  String get gmoRegSupplyChain => 'ESTADO NORMATIVO UE: Posible relevancia indirecta de OMG/NGT a través de la cadena importador/proveedor/productor.';

  @override
  String get gmoRegCropOrigin => 'ESTADO NORMATIVO UE: Materia prima propensa a OMG de origen americano/no UE – puede activar la obligación de etiquetado de OMG de la UE.';

  @override
  String get gmoRegCropUnknown => 'ESTADO NORMATIVO UE: Materia prima propensa a OMG en la fase de importación/proveedor – conviene verificar el origen.';

  @override
  String get insectRegExplicit => 'ESTADO NORMATIVO UE: El producto parece pertenecer a una categoría regulada de insectos/nuevos alimentos.';

  @override
  String get insectRegNovelFood => 'ESTADO NORMATIVO UE: El producto puede estar sujeto a las normas de la UE sobre insectos como nuevos alimentos.';

  @override
  String get insectRegSupplyChain => 'ESTADO NORMATIVO UE: Posible relevancia indirecta a través de la cadena importador/proveedor/productor.';

  @override
  String get gmoConsExplicit => 'RIESGO PARA EL CONSUMIDOR: El texto/la etiqueta del producto indica contenido de OMG.';

  @override
  String get gmoConsFeed => 'RIESGO PARA EL CONSUMIDOR: La marca/categoría coincide con una exposición conocida a piensos OMG.';

  @override
  String get gmoConsNgt => 'RIESGO PARA EL CONSUMIDOR: Puede afectar al mercado de consumo, pero conviene comprobarlo en la etiqueta y con la información del productor.';

  @override
  String get gmoConsSupplyChain => 'RIESGO PARA EL CONSUMIDOR: Posible riesgo a través de la cadena de suministro (quién vende a quién). Verifica la etiqueta y el origen.';

  @override
  String get gmoConsCropOrigin => 'RIESGO PARA EL CONSUMIDOR: Contiene una materia prima propensa a OMG (soja/maíz/colza/remolacha azucarera/algodón) importada de un país donde el cultivo es mayoritariamente transgénico. Busca en la etiqueta la mención “sin OMG”.';

  @override
  String get gmoConsCropUnknown => 'RIESGO PARA EL CONSUMIDOR: El producto contiene una materia prima propensa a OMG (soja/maíz/colza/remolacha azucarera/algodón). Origen desconocido: comprueba la etiqueta y el país de origen.';

  @override
  String get insectConsExplicit => 'RIESGO PARA EL CONSUMIDOR: El texto/los ingredientes del producto indican harina o proteína de insectos.';

  @override
  String get insectConsNovelFood => 'RIESGO PARA EL CONSUMIDOR: Posible exposición relacionada con insectos, comprueba la lista de ingredientes.';

  @override
  String get insectConsSupplyChain => 'RIESGO PARA EL CONSUMIDOR: Posible riesgo a través de la cadena de suministro (quién vende a quién).';

  @override
  String get noKnownRisk => 'Ningún riesgo conocido en esta categoría.';

  @override
  String get searchBetaNote => 'Beta: la búsqueda se mejora continuamente. Comprueba siempre los detalles del producto antes de decidir.';

  @override
  String get couldNotOpenLink => 'No se ha podido abrir el enlace';

  @override
  String get eNumberNoDescription => 'Todavía no tenemos una descripción de este aditivo. El número E es un código de aditivos usado en la UE/EEE.';

  @override
  String get allergensTitle => 'Alérgenos';

  @override
  String get noAllergensFound => 'No se han encontrado alérgenos.';

  @override
  String get nutritionTitle => 'Información nutricional (por 100 g)';

  @override
  String get noNutritionFound => 'No se ha encontrado información nutricional.';

  @override
  String get alertsTitle => 'Alertas';

  @override
  String get alertEvidence => 'Evidencias:';

  @override
  String get alertInternalListNote => 'Alerta: lista interna de vínculos entre marcas';

  @override
  String get alertBrandTrackingNote => 'Alerta: seguimiento de marcas e información pública';

  @override
  String get reportNoteHint => 'Nota breve (p. ej., falso positivo)';

  @override
  String get report => 'Reportar';

  @override
  String get send => 'Enviar';

  @override
  String get reportSaved => 'Gracias: informe guardado.';

  @override
  String get seeUpdatedStatus => 'Ver estado actualizado';

  @override
  String get openEuSource => 'Abrir fuente de la UE';

  @override
  String get openInsectSource => 'Abrir fuente sobre insectos';

  @override
  String get privacyTitle => 'Privacidad';

  @override
  String get consentOptional => 'Es opcional. Si no das tu consentimiento, tu uso no se envía para análisis.';

  @override
  String get consentWorksAnyway => 'La app funciona igualmente y los datos pueden quedarse solo en tu dispositivo.';

  @override
  String get readPrivacyPolicy => 'Leer la política de privacidad';

  @override
  String get allowAnonymousAnalytics => 'Permitir análisis anónimo';

  @override
  String get analyticsEnabled => 'Gracias: análisis activado.';

  @override
  String get analyticsDisabled => 'Análisis desactivado.';

  @override
  String couldNotOpenLinkError(String error) {
    return 'No se ha podido abrir el enlace: $error';
  }

  @override
  String reportSaveFailed(String error) {
    return 'No se ha podido guardar el informe: $error';
  }

  @override
  String alertSeverity(String value) {
    return 'Gravedad: $value';
  }

  @override
  String alertReason(String value) {
    return 'Motivo: $value';
  }

  @override
  String alertConfidence(String value) {
    return 'Confianza: $value';
  }

  @override
  String matvaretabellenSuggestions(String count) {
    return 'Sugerencias de Matvaretabellen: $count';
  }

  @override
  String addedToList(String item, String list) {
    return '\"$item\" añadido a $list';
  }

  @override
  String nutritionEnergy(String value) {
    return 'Energía: $value kcal';
  }

  @override
  String nutritionFat(String value) {
    return 'Grasas: $value g';
  }

  @override
  String nutritionSaturatedFat(String value) {
    return 'de las cuales saturadas: $value g';
  }

  @override
  String nutritionCarbohydrates(String value) {
    return 'Hidratos de carbono: $value g';
  }

  @override
  String nutritionSugars(String value) {
    return 'de los cuales azúcares: $value g';
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
  String get countryDataSources => 'País / fuentes de datos';

  @override
  String get chooseCountryTitle => 'Elegir país (prioriza fuentes)';

  @override
  String get privacyIntro => 'Lee la política de privacidad la primera vez que uses la app. Puedes usarla sin análisis y tus datos de compra se quedan en tu dispositivo.';
}
