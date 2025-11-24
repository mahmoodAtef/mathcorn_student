import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:math_corn/core/error/handlers/auth_exception_handler.dart';
import 'package:math_corn/core/error/handlers/firebase_exception_handler.dart';

import 'handlers/unexpected_exception_handler.dart';

abstract class ExceptionHandler {
  String handle(Exception exception);
  String getIconPath(Exception exception);
}

class ExceptionManager {
  static final Map<Type, ExceptionHandler> _handlers = {
    FirebaseAuthException: FirebaseAuthExceptionHandler(),
    FirebaseException: FirebaseExceptionHandler(),
    UnexpectedExceptionHandler: UnexpectedExceptionHandler(),
  };

  static String getMessage(Exception exception) {
    return _handlers[exception.runtimeType]?.handle(exception) ??
        _handlers[UnexpectedExceptionHandler]!.handle(exception);
  }

  static String getIconPath(Exception exception) {
    return _handlers[exception.runtimeType]?.getIconPath(exception) ??
        _handlers[UnexpectedExceptionHandler]!.getIconPath(exception);
  }

  static void showMessage(Exception exception) {
    Fluttertoast.showToast(msg: getMessage(exception));
  }
}
