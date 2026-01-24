import 'package:flutter/material.dart';

Future<T?> safeShowDialog<T>(BuildContext context, Widget dialog, {bool barrierDismissible = true}) {
  if (!context.mounted) return Future.value(null);
  return showDialog<T>(context: context, barrierDismissible: barrierDismissible, builder: (_) => dialog);
}

Future<T?> safeShowDialogBuilder<T>(BuildContext context, WidgetBuilder builder, {bool barrierDismissible = true}) {
  if (!context.mounted) return Future.value(null);
  return showDialog<T>(context: context, barrierDismissible: barrierDismissible, builder: builder);
}

void safePop(BuildContext context, [result]) {
  if (context.mounted) Navigator.of(context).pop(result);
}

void safeSnack(BuildContext context, String message, {Duration duration = const Duration(seconds: 2)}) {
  if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), duration: duration));
}
