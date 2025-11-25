import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paymob/billing_data.dart' show BillingData;
import 'package:flutter_paymob/flutter_paymob.dart';
import 'package:math_corn/core/error/custom_exceptions/payment_exception.dart';
import 'package:math_corn/modules/payment/data/models/access_request.dart';

class PaymentServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FlutterPaymob _flutterPaymob = FlutterPaymob.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  static const String _apiKey =
      "ZXlKaGJHY2lPaUpJVXpVeE1pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SmpiR0Z6Y3lJNklrMWxjbU5vWVc1MElpd2ljSEp2Wm1sc1pWOXdheUk2TVRBM01qSTVNeXdpYm1GdFpTSTZJbWx1YVhScFlXd2lmUS41WFZFcG5NQ0h4MVFSckxTRkc4dGtQQkVqM2htcUNoV2ZUZkZEYVNKbUNDbUVJNnZGU2k2M1dwQ3NWX3kzbHNldEVwOEFWQWhxR3NTRVBYZTNNMVU5Zw==";
  static const int _integrationID = 5257755;
  static const int _walletIntegrationId = 5257761;
  static const int _iFrameID = 954388;

  Future<void> payWithCard({
    required List<String> courses,
    required BuildContext context,
    required double price,
    required BillingData billingData,
  }) async {
    try {
      _validatePaymentInput(courses, price);
      await _initializePaymob();

      final Completer<void> paymentCompleter = Completer<void>();

      _flutterPaymob.payWithCard(
        amount: price,
        context: context,
        currency: "EGP",
        appBarColor: Theme.of(context).primaryColor,
        billingData: billingData,
        onPayment: (paymentResponse) async {
          try {
            if (paymentResponse.success) {
              await addCoursesToUser(courses);
              if (!paymentCompleter.isCompleted) {
                paymentCompleter.complete();
              }
            } else {
              if (!paymentCompleter.isCompleted) {
                paymentCompleter.completeError(
                  PaymentException(
                    message: paymentResponse.message ?? "فشل في عملية الدفع",
                    type: PaymentErrorType.paymentFailed,
                  ),
                );
              }
            }
          } catch (e) {
            if (!paymentCompleter.isCompleted) {
              paymentCompleter.completeError(_createPaymentException(e));
            }
          }
        },
      );

      await paymentCompleter.future.timeout(
        Duration(minutes: 5),
        onTimeout: () {
          throw PaymentException(
            message: "انتهت مهلة عملية الدفع",
            type: PaymentErrorType.timeout,
          );
        },
      );
    } catch (e) {
      throw _createPaymentException(e);
    }
  }

  Future<void> payWithWallet({
    required List<String> courses,
    required BuildContext context,
    required double price,
    required BillingData billingData,
    required String number,
  }) async {
    try {
      _validatePaymentInput(courses, price);

      if (number.isEmpty) {
        throw PaymentException(
          message: "رقم المحفظة مطلوب",
          type: PaymentErrorType.wallet,
        );
      }

      await _initializePaymob();

      final Completer<void> paymentCompleter = Completer<void>();

      _flutterPaymob.payWithWallet(
        number: number,
        amount: price,
        context: context,
        currency: "EGP",
        appBarColor: Theme.of(context).primaryColor,
        billingData: billingData,
        onPayment: (paymentResponse) async {
          try {
            if (paymentResponse.success) {
              await addCoursesToUser(courses);
              if (!paymentCompleter.isCompleted) {
                paymentCompleter.complete();
              }
            } else {
              if (!paymentCompleter.isCompleted) {
                paymentCompleter.completeError(
                  PaymentException(
                    message: paymentResponse.message ?? "فشل في عملية الدفع",
                    type: PaymentErrorType.wallet,
                  ),
                );
              }
            }
          } catch (e) {
            if (!paymentCompleter.isCompleted) {
              paymentCompleter.completeError(_createPaymentException(e));
            }
          }
        },
      );

      await paymentCompleter.future.timeout(
        Duration(minutes: 5),
        onTimeout: () {
          throw PaymentException(
            message: "انتهت مهلة عملية الدفع",
            type: PaymentErrorType.timeout,
          );
        },
      );
    } catch (e) {
      throw _createPaymentException(e);
    }
  }

  Future<void> addCoursesToUser(List<String> courses) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw PaymentException(
          message: "المستخدم غير مسجل الدخول",
          type: PaymentErrorType.general,
        );
      }

      await _firestore.collection('users').doc(user.uid).update({
        "onGoing": FieldValue.arrayUnion(courses),
        "cart": [],
      });
    } on FirebaseException catch (e) {
      throw PaymentException(
        message: "خطأ في إضافة الكورسات للمستخدم",
        type: PaymentErrorType.general,
      );
    } catch (e) {
      throw PaymentException(
        message: "خطأ في إضافة الكورسات للمستخدم",
        type: PaymentErrorType.general,
      );
    }
  }

  Future<void> _initializePaymob() async {
    try {
      if (_apiKey.isEmpty || _apiKey == "YOUR_ACTUAL_API_KEY_HERE") {
        throw PaymentException(
          message: "API Key غير محدد - يرجى إضافة مفتاح API الصحيح",
          type: PaymentErrorType.apiKey,
        );
      }

      await _flutterPaymob.initialize(
        apiKey: _apiKey,
        integrationID: _integrationID,
        walletIntegrationId: _walletIntegrationId,
        iFrameID: _iFrameID,
      );
    } catch (e) {
      throw PaymentException(
        message: "خطأ في تهيئة نظام الدفع",
        type: PaymentErrorType.initialization,
      );
    }
  }

  Future<void> createAccessRequest({
    required AccessRequest accessRequest,
  }) async {
    try {
      String fileUrl = await uploadFile(file: accessRequest.attachment);
      accessRequest = accessRequest.updateFileUrl(fileUrl: fileUrl);

      await _firestore.collection('accessRequests').add(accessRequest.toJson());
    } on FirebaseException catch (e) {
      throw PaymentException(
        message: "خطأ في إنشاء طلب الوصول",
        type: PaymentErrorType.accessRequest,
      );
    } catch (e) {
      throw _createPaymentException(e);
    }
  }

  Future<String> uploadFile({required File file}) async {
    try {
      if (!file.existsSync()) {
        throw PaymentException(
          message: "الملف غير موجود",
          type: PaymentErrorType.fileUpload,
        );
      }

      final String fileName =
          'access_requests/${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
      final Reference ref = _firebaseStorage.ref().child(fileName);
      final UploadTask task = ref.putFile(file);
      final TaskSnapshot snapshot = await task.whenComplete(() {});
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } on FirebaseException catch (e) {
      throw PaymentException(
        message: "خطأ في رفع الملف",
        type: PaymentErrorType.fileUpload,
      );
    } catch (e) {
      throw PaymentException(
        message: "خطأ في رفع الملف",
        type: PaymentErrorType.fileUpload,
      );
    }
  }

  void _validatePaymentInput(List<String> courses, double price) {
    if (courses.isEmpty) {
      throw PaymentException(
        message: "قائمة الكورسات فارغة",
        type: PaymentErrorType.general,
      );
    }

    if (price <= 0) {
      throw PaymentException(
        message: "المبلغ غير صحيح",
        type: PaymentErrorType.general,
      );
    }
  }

  PaymentException _createPaymentException(Object e) {
    if (e is PaymentException) {
      return e;
    }

    final errorMsg = e.toString().toLowerCase();

    if (errorMsg.contains("api key")) {
      return PaymentException(
        message: e.toString(),
        type: PaymentErrorType.apiKey,
      );
    } else if (errorMsg.contains("network") || errorMsg.contains("internet")) {
      return PaymentException(
        message: e.toString(),
        type: PaymentErrorType.network,
      );
    } else if (errorMsg.contains("payment failed")) {
      return PaymentException(
        message: e.toString(),
        type: PaymentErrorType.paymentFailed,
      );
    } else if (errorMsg.contains("insufficient funds")) {
      return PaymentException(
        message: e.toString(),
        type: PaymentErrorType.insufficientFunds,
      );
    } else if (errorMsg.contains("invalid card")) {
      return PaymentException(
        message: e.toString(),
        type: PaymentErrorType.invalidCard,
      );
    } else if (errorMsg.contains("expired")) {
      return PaymentException(
        message: e.toString(),
        type: PaymentErrorType.expired,
      );
    } else if (errorMsg.contains("timeout")) {
      return PaymentException(
        message: e.toString(),
        type: PaymentErrorType.timeout,
      );
    } else if (errorMsg.contains("wallet")) {
      return PaymentException(
        message: e.toString(),
        type: PaymentErrorType.wallet,
      );
    } else if (errorMsg.contains("file") || errorMsg.contains("upload")) {
      return PaymentException(
        message: e.toString(),
        type: PaymentErrorType.fileUpload,
      );
    }

    return PaymentException(
      message: e.toString().replaceAll('Exception: ', ''),
      type: PaymentErrorType.general,
    );
  }
}
