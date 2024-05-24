import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:hostels/variables/util_variables.dart';

void toast(
    {required BuildContext context,
    required String txt,
    Color? backgroundColor}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(txt),
      backgroundColor: backgroundColor,
      margin: EdgeInsets.only(bottom: 10.h),
      duration: const Duration(milliseconds: 3500),
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 13,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}

void awesomeToast(
    {required BuildContext context,
    required String txt,
    required String title,
    required ContentType contentType}) {
  final snackBar = SnackBar(
    padding: EdgeInsets.only(top: 40.o),

    /// need to set following properties for best effect of awesome_snackbar_content
    ///
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      messageFontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
      inMaterialBanner: true,
      title: title,
      message: txt,

      /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
      contentType: contentType,
    ),
  );
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
