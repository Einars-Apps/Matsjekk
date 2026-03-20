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
  String get appDescription =>
      'La app utiliza Open Food Facts y una lista interna de marcas para identificar productos con Bovaer, harina de insectos, alimentos transgénicos y otros ingredientes controvertidos.';

  @override
  String get alerts => 'Seleccionar alertas';

  @override
  String get bovaerAlert => 'Alerta Bovaer';

  @override
  String get insectMealAlert => 'Alerta harina de insectos';

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
  String get bovaerRiskDesc =>
      'El productor está directamente vinculado a Bovaer.';

  @override
  String get insectMealRiskDesc =>
      'El producto puede contener harina de insectos.';

  @override
  String get gmoFishRiskDesc =>
      'El productor está vinculado al uso de alimentos transgénicos.';

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
  String get finnish => 'Finlandés';

  @override
  String get korean => 'Coreano';

  @override
  String get polish => 'Polaco';

  @override
  String get russian => 'Ruso';

  @override
  String get chinese => 'Chino';

  @override
  String get arabic => 'Árabe';

  @override
  String get thai => 'Tailandés';

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
  String get noAdditionsFound =>
      'Ningún aditivo E encontrado en la base de datos.';

  @override
  String get disclaimer =>
      'Aviso legal: Esta información es solo orientativa y se basa en datos disponibles públicamente. Para información 100% precisa, consulte el envase del producto o póngase en contacto con el fabricante.';

  @override
  String get bovaerHighRisk =>
      'RIESGO ALTO: La marca es usuaria confirmada de Bovaer o pertenece a un productor que lo es.';

  @override
  String get gmoHighRisk =>
      'RIESGO ALTO: El productor está vinculado al uso de alimentos transgénicos.';

  @override
  String get bovaerPossibleRisk =>
      'INCIERTO: El producto puede contener leche de una central lechera que recibe leche de granjas con Bovaer.';

  @override
  String get safeProduct =>
      'SEGURO: El producto está certificado como orgánico.';

  @override
  String get searchHint => 'Buscar... (ej. leche)';

  @override
  String get delete => 'Eliminar';

  @override
  String get deleteListConfirmTitle => '¿Eliminar lista?';

  @override
  String get deleteListConfirmMessage =>
      '¿Estás seguro? Esto también eliminará el historial de la lista.';

  @override
  String get unknownProduct => 'Producto desconocido';

  @override
  String get removeAds => 'Quitar anuncios';

  @override
  String get removeAdsInfo =>
      'Quita anuncios para tener más espacio en la lista de compras';

  @override
  String get removeAdsMenuItem =>
      'Quitar anuncios (49 kr) - apoya el desarrollo continuo';

  @override
  String get premiumTitle => 'Quitar anuncios';

  @override
  String get premiumActiveStatus => 'Sin anuncios está activo';

  @override
  String get premiumInactiveStatus => 'Sin anuncios aún no está activado';

  @override
  String get buyAdFreeTitle => 'Comprar versión sin anuncios';

  @override
  String get oneTimePurchaseInfo =>
      'Compra única. Sin suscripción.\nDespués de confirmar la compra, los anuncios se eliminan permanentemente para esta cuenta.';

  @override
  String get storeUnavailable =>
      'La tienda no está disponible en este momento. Inténtalo de nuevo más tarde.';

  @override
  String get productsLoadFailed =>
      'No se pudieron cargar los productos de compra. Revisa tu red e inténtalo de nuevo.';

  @override
  String get tryAgain => 'Intentar de nuevo';

  @override
  String get oneTimePurchaseLabel => 'compra única';

  @override
  String get buyPermanently => 'Comprar permanentemente';

  @override
  String get restorePurchases => 'Restaurar compras';

  @override
  String get analyticsEnabled => 'Gracias – análisis activado.';

  @override
  String get analyticsDisabled => 'Análisis desactivado.';

  @override
  String get privacy => 'Privacidad';

  @override
  String get adFreeActive => 'Sin anuncios (activo)';

  @override
  String get consentLocalOnly =>
      'La aplicación sigue funcionando y los datos pueden permanecer solo en tu dispositivo.';

  @override
  String get allowAnonymousAnalytics => 'Permitir análisis anónimo';

  @override
  String get consentOptional =>
      'Esto es opcional. Si no das tu consentimiento, tus datos de uso no se envían a análisis.';
}
