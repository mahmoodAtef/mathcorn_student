import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paymob/billing_data.dart';
import 'package:math_corn/modules/payment/data/models/access_request.dart';
import 'package:math_corn/modules/payment/data/repository/payment_repository.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final PaymentRepository repository;

  PaymentCubit({required this.repository}) : super(PaymentState());

  Future<void> payWithCard({
    required List<String> courses,
    required BuildContext context,
    required double price,
    required BillingData billingData,
  }) async {
    emit(state.copyWith(status: PaymentStatus.loading));

    try {
      print("Starting card payment for courses: $courses, price: $price");

      await repository.payWithCard(
        courses: courses,
        context: context,
        price: price,
        billingData: billingData,
      );

      print("Card payment completed successfully");
      emit(state.copyWith(status: PaymentStatus.success, courses: courses));
    } on Exception catch (e) {
      print("Card payment failed: $e");
      emit(
        state.copyWith(
          status: PaymentStatus.failure,
          exception: e,
          errorMessage: _getErrorMessage(e),
        ),
      );
    } catch (e) {
      print("Unexpected error in card payment: $e");
      final exception = Exception(
        "خطأ غير متوقع في عملية الدفع: ${e.toString()}",
      );
      emit(
        state.copyWith(
          status: PaymentStatus.failure,
          exception: exception,
          errorMessage: _getErrorMessage(exception),
        ),
      );
    }
  }

  Future<void> payWithWallet({
    required List<String> courses,
    required BuildContext context,
    required double price,
    required String walletId,
    required BillingData billingData,
  }) async {
    emit(state.copyWith(status: PaymentStatus.loading));

    try {
      await repository.payWithWallet(
        courses: courses,
        context: context,
        price: price,
        number: walletId,
        billingData: billingData,
      );

      print("Wallet payment completed successfully");
      emit(state.copyWith(status: PaymentStatus.success, courses: courses));
    } on Exception catch (e) {
      print("Wallet payment failed: $e");
      emit(
        state.copyWith(
          status: PaymentStatus.failure,
          exception: e,
          errorMessage: _getErrorMessage(e),
        ),
      );
    } catch (e) {
      print("Unexpected error in wallet payment: $e");
      final exception = Exception(
        "خطأ غير متوقع في عملية الدفع بالمحفظة: ${e.toString()}",
      );
      emit(
        state.copyWith(
          status: PaymentStatus.failure,
          exception: exception,
          errorMessage: _getErrorMessage(exception),
        ),
      );
    }
  }

  Future<void> createAccessRequest({
    required AccessRequest accessRequest,
  }) async {
    emit(state.copyWith(status: PaymentStatus.loading));

    try {
      // التحقق من صحة بيانات طلب الوصول
      _validateAccessRequest(accessRequest);

      print("Creating access request for student: ${accessRequest.studentId}");

      await repository.createAccessRequest(accessRequest: accessRequest);

      print("Access request created successfully");
      emit(state.copyWith(status: PaymentStatus.success));
    } on Exception catch (e) {
      print("Access request creation failed: $e");
      emit(
        state.copyWith(
          status: PaymentStatus.failure,
          exception: e,
          errorMessage: _getErrorMessage(e),
        ),
      );
    } catch (e) {
      print("Unexpected error in access request: $e");
      final exception = Exception(
        "خطأ غير متوقع في إنشاء طلب الوصول: ${e.toString()}",
      );
      emit(
        state.copyWith(
          status: PaymentStatus.failure,
          exception: exception,
          errorMessage: _getErrorMessage(exception),
        ),
      );
    }
  }

  // التحقق من صحة بيانات طلب الوصول
  void _validateAccessRequest(AccessRequest accessRequest) {
    if (accessRequest.studentId.isEmpty) {
      throw Exception("معرف الطالب مطلوب");
    }

    if (accessRequest.coursesId.isEmpty) {
      throw Exception("لم يتم تحديد أي كورسات");
    }

    if (accessRequest.gradeId.isEmpty) {
      throw Exception("معرف الصف الدراسي مطلوب");
    }

    if (accessRequest.studentName.isEmpty) {
      throw Exception("اسم الطالب مطلوب");
    }

    if (!accessRequest.attachment.existsSync()) {
      throw Exception("الملف المرفق مطلوب");
    }
  }

  // تحويل رسائل الخطأ إلى رسائل مفهومة للمستخدم
  String _getErrorMessage(Exception exception) {
    final errorMsg = exception.toString().toLowerCase();

    if (errorMsg.contains('api key')) {
      return 'خطأ في إعدادات نظام الدفع - يرجى المحاولة لاحقاً';
    } else if (errorMsg.contains('network') || errorMsg.contains('internet')) {
      return 'خطأ في الاتصال بالإنترنت - يرجى التحقق من اتصالك';
    } else if (errorMsg.contains('payment failed')) {
      return 'فشلت عملية الدفع - يرجى التحقق من بيانات الدفع';
    } else if (errorMsg.contains('insufficient funds')) {
      return 'الرصيد غير كافي لإتمام العملية';
    } else if (errorMsg.contains('invalid card')) {
      return 'بيانات الكارت غير صحيحة';
    } else if (errorMsg.contains('expired')) {
      return 'انتهت صلاحية بيانات الدفع';
    } else if (errorMsg.contains('timeout')) {
      return 'انتهت مهلة العملية - يرجى المحاولة مرة أخرى';
    } else if (errorMsg.contains('wallet')) {
      return 'خطأ في بيانات المحفظة الإلكترونية';
    } else if (errorMsg.contains('file') || errorMsg.contains('upload')) {
      return 'خطأ في رفع الملف - يرجى اختيار ملف آخر';
    }

    // إذا لم نتعرف على نوع الخطأ، نرجع الرسالة الأصلية
    return exception.toString().replaceAll('Exception: ', '');
  }

  // إعادة تعيين حالة الدفع
  void resetPaymentState() {
    emit(PaymentState());
  }

  // التحقق من اتصال نظام الدفع
  Future<void> checkPaymentSystemStatus() async {
    emit(state.copyWith(status: PaymentStatus.loading));

    try {
      // يمكنك إضافة طريقة في repository للتحقق من حالة النظام
      // await repository.checkConnection();

      emit(state.copyWith(status: PaymentStatus.initial));
    } catch (e) {
      emit(
        state.copyWith(
          status: PaymentStatus.failure,
          exception: Exception("نظام الدفع غير متاح حالياً"),
        ),
      );
    }
  }
}
