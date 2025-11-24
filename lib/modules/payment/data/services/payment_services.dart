import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paymob/billing_data.dart' show BillingData;
import 'package:flutter_paymob/flutter_paymob.dart';
import 'package:math_corn/modules/payment/data/models/access_request.dart';

class PaymentServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FlutterPaymob _flutterPaymob = FlutterPaymob.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  // تأكد من استخدام الـ API Key الصحيح من لوحة تحكم Paymob
  static const String _apiKey =
      "ZXlKaGJHY2lPaUpJVXpVeE1pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SmpiR0Z6Y3lJNklrMWxjbU5vWVc1MElpd2ljSEp2Wm1sc1pWOXdheUk2TVRBM01qSTVNeXdpYm1GdFpTSTZJbWx1YVhScFlXd2lmUS41WFZFcG5NQ0h4MVFSckxTRkc4dGtQQkVqM2htcUNoV2ZUZkZEYVNKbUNDbUVJNnZGU2k2M1dwQ3NWX3kzbHNldEVwOEFWQWhxR3NTRVBYZTNNMVU5Zw=="; // ضع هنا الـ API key الصحيح
  static const int _integrationID = 5257755; // تأكد من Integration ID
  static const int _walletIntegrationId = 5257761;
  static const int _iFrameID = 954388;

  Future<void> payWithCard({
    required List<String> courses,
    required BuildContext context,
    required double price,
    required BillingData billingData,
  }) async {
    try {
      // التحقق من صحة البيانات قبل البدء
      if (courses.isEmpty) {
        throw Exception("قائمة الكورسات فارغة");
      }

      if (price <= 0) {
        throw Exception("المبلغ غير صحيح");
      }

      await _initializePaymob();

      bool paymentCompleted = false;
      String? errorMessage;

      await _flutterPaymob.payWithCard(
        amount: price,
        context: context,
        currency: "EGP",
        appBarColor: Theme.of(context).primaryColor,
        billingData: billingData,
        onPayment: (paymentResponse) async {
          print("Payment Response: ${paymentResponse.success}");
          print("Payment Message: ${paymentResponse.message}");

          if (paymentResponse.success) {
            try {
              await addCoursesToUser(courses);
              paymentCompleted = true;
              print("Courses added successfully");
            } catch (e) {
              print("Error adding courses: $e");
              errorMessage = "فشل في إضافة الكورسات: ${e.toString()}";
            }
          } else {
            print("Payment failed: ${paymentResponse.message}");
            errorMessage = paymentResponse.message ?? "فشل في عملية الدفع";
          }
        },
      );

      if (!paymentCompleted) {
        throw Exception(errorMessage ?? "فشل في إتمام عملية الدفع");
      }
    } catch (e) {
      print("Payment with card error: $e");
      // تحسين رسالة الخطأ
      String errorMsg = e.toString();
      if (errorMsg.contains("Error getting API key")) {
        errorMsg = "خطأ في مفتاح API - يرجى التحقق من صحة البيانات";
      } else if (errorMsg.contains("Network")) {
        errorMsg = "خطأ في الاتصال بالإنترنت";
      }
      throw Exception("خطأ في عملية الدفع بالكارت: $errorMsg");
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
      // التحقق من صحة البيانات
      if (courses.isEmpty) {
        throw Exception("قائمة الكورسات فارغة");
      }

      if (price <= 0) {
        throw Exception("المبلغ غير صحيح");
      }

      if (number.isEmpty) {
        throw Exception("رقم المحفظة مطلوب");
      }

      await _initializePaymob();

      bool paymentCompleted = false;
      String? errorMessage;

      await _flutterPaymob.payWithWallet(
        number: number,
        amount: price,
        context: context,
        currency: "EGP",
        appBarColor: Theme.of(context).primaryColor,
        billingData: billingData,
        onPayment: (paymentResponse) async {
          print("Wallet Payment Response: ${paymentResponse.success}");
          print("Wallet Payment Message: ${paymentResponse.message}");

          if (paymentResponse.success) {
            try {
              await addCoursesToUser(courses);
              paymentCompleted = true;
              print("Courses added successfully via wallet");
            } catch (e) {
              print("Error adding courses via wallet: $e");
              errorMessage = "فشل في إضافة الكورسات: ${e.toString()}";
            }
          } else {
            print("Wallet payment failed: ${paymentResponse.message}");
            errorMessage = paymentResponse.message ?? "فشل في عملية الدفع";
          }
        },
      );

      if (!paymentCompleted) {
        throw Exception(errorMessage ?? "فشل في إتمام عملية الدفع");
      }
    } catch (e) {
      print("Payment with wallet error: $e");
      // تحسين رسالة الخطأ
      String errorMsg = e.toString();
      if (errorMsg.contains("Error getting API key")) {
        errorMsg = "خطأ في مفتاح API - يرجى التحقق من صحة البيانات";
      } else if (errorMsg.contains("Network")) {
        errorMsg = "خطأ في الاتصال بالإنترنت";
      }
      throw Exception("خطأ في عملية الدفع بالمحفظة: $errorMsg");
    }
  }

  Future<void> addCoursesToUser(List<String> courses) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception("المستخدم غير مسجل الدخول");
      }

      print("Adding courses to user: ${user.uid}");
      print("Courses: $courses");

      await _firestore.collection('users').doc(user.uid).update({
        "onGoing": FieldValue.arrayUnion(courses),
        "cart": [],
      });

      print("Courses added successfully to Firestore");
    } catch (e) {
      print("Error adding courses to user: $e");
      throw Exception("خطأ في إضافة الكورسات للمستخدم: ${e.toString()}");
    }
  }

  Future<void> _initializePaymob() async {
    try {
      print("Initializing Paymob...");

      // التحقق من وجود الـ API key
      if (_apiKey.isEmpty || _apiKey == "YOUR_ACTUAL_API_KEY_HERE") {
        throw Exception("API Key غير محدد - يرجى إضافة مفتاح API الصحيح");
      }

      await _flutterPaymob.initialize(
        apiKey: _apiKey,
        integrationID: _integrationID,
        walletIntegrationId: _walletIntegrationId,
        iFrameID: _iFrameID,
      );

      print("Paymob initialized successfully");
    } catch (e) {
      print("Error initializing Paymob: $e");

      // تحسين رسالة الخطأ حسب نوع المشكلة
      String errorMsg = e.toString();
      if (errorMsg.contains("API Key")) {
        errorMsg = "مفتاح API غير صحيح أو منتهي الصلاحية";
      } else if (errorMsg.contains("Network") ||
          errorMsg.contains("SocketException")) {
        errorMsg = "خطأ في الاتصال بالإنترنت";
      } else if (errorMsg.contains("integrationID")) {
        errorMsg = "معرف التكامل غير صحيح";
      }

      throw Exception("خطأ في تهيئة نظام الدفع: $errorMsg");
    }
  }

  Future<void> createAccessRequest({
    required AccessRequest accessRequest,
  }) async {
    try {
      print("Creating access request...");

      String fileUrl = await uploadFile(file: accessRequest.attachment);
      accessRequest = accessRequest.updateFileUrl(fileUrl: fileUrl);

      await _firestore.collection('accessRequests').add(accessRequest.toJson());

      print("Access request created successfully");
    } catch (e) {
      print("Error creating access request: $e");
      throw Exception("خطأ في إنشاء طلب الوصول: ${e.toString()}");
    }
  }

  Future<String> uploadFile({required File file}) async {
    try {
      print("Uploading file: ${file.path}");

      // تحقق من وجود الملف
      if (!file.existsSync()) {
        throw Exception("الملف غير موجود");
      }

      // في الحالة الحقيقية، استخدم Firebase Storage
      final String fileName =
          'access_requests/${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
      final Reference ref = _firebaseStorage.ref().child(fileName);
      final UploadTask task = ref.putFile(file);
      final TaskSnapshot snapshot = await task.whenComplete(() {});
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      print("File uploaded successfully: $downloadUrl");
      return downloadUrl;

      // return "https://images.pexels.com/photos/33356121/pexels-photo-33356121.jpeg";
    } catch (e) {
      print("Error uploading file: $e");
      throw Exception("خطأ في رفع الملف: ${e.toString()}");
    }
  }

  // طريقة للتحقق من حالة اتصال Paymob
  Future<bool> checkPaymobConnection() async {
    await _initializePaymob();
    return true;
  }
}
