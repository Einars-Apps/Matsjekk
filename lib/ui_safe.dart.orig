import 'package:flutter/material.dart';

<<<<<<< HEAD
Future<T?> safeShowDialog<T>(BuildContext context, Widget dialog, {bool barrierDismissible = true}) {
  if (!context.mounted) return Future.value(null);
  return showDialog<T>(context: context, barrierDismissible: barrierDismissible, builder: (_) => dialog);
}

Future<T?> safeShowDialogBuilder<T>(BuildContext context, WidgetBuilder builder, {bool barrierDismissible = true}) {
  if (!context.mounted) return Future.value(null);
  return showDialog<T>(context: context, barrierDismissible: barrierDismissible, builder: builder);
=======
Future<T?> safeShowDialog<T>(BuildContext context, Widget dialog,
    {bool barrierDismissible = true}) {
  if (!context.mounted) return Future.value(null);
  return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => dialog);
}

Future<T?> safeShowDialogBuilder<T>(BuildContext context, WidgetBuilder builder,
    {bool barrierDismissible = true}) {
  if (!context.mounted) return Future.value(null);
  return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: builder);
>>>>>>> 1fd8547f7f4a75b9aeb940f067391e11eaa43643
}

void safePop(BuildContext context, [result]) {
  if (context.mounted) Navigator.of(context).pop(result);
}

<<<<<<< HEAD
void safeSnack(BuildContext context, String message, {Duration duration = const Duration(seconds: 2)}) {
  if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), duration: duration));
=======
void safeSnack(BuildContext context, String message,
    {Duration duration = const Duration(seconds: 2)}) {
  if (context.mounted) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message), duration: duration));
  }
>>>>>>> 1fd8547f7f4a75b9aeb940f067391e11eaa43643
}
