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
  String get finnish => 'Finnish';

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
  String get searchHint => 'Search... (e.g. milk)';

  @override
  String get delete => 'Delete';

  @override
  String get deleteListConfirmTitle => 'Delete list?';

  @override
  String get deleteListConfirmMessage => 'Are you sure? This will also delete the history for the list.';

  @override
  String get unknownProduct => 'Unknown product';
}
