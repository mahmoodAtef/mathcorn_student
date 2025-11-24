// build image loading builder functions and imager error builder functions

import 'package:flutter/material.dart';
import 'package:math_corn/core/error/exception_manager.dart';

Widget defaultImageErrorBuilder(context, object, stackTrace) {
  Exception e = object as Exception;
  String errorMessage = ExceptionManager.getMessage(e);
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.image_not_supported_outlined),
        Expanded(child: Text(errorMessage)),
      ],
    ),
  );
}
