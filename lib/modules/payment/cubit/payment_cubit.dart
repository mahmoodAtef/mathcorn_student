import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paymob/billing_data.dart';
import 'package:math_corn/core/debugging/loggable.dart';
import 'package:math_corn/core/error/custom_exceptions/payment_exception.dart';
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
      logLine("Payment Started");
      await repository.payWithCard(
        courses: courses,
        context: context,
        price: price,
        billingData: billingData,
      );
      await Future.delayed(Duration(seconds: 2));
      logLine("Payment Ended Successfully");
      emit(state.copyWith(status: PaymentStatus.success, courses: courses));
    } on PaymentException catch (e) {
      logError(e.toString(), error: e);
      emit(state.copyWith(status: PaymentStatus.failure, exception: e));
    } catch (e) {
      logError(e.toString(), error: e);
      final paymentException = PaymentException(
        message: e.toString(),
        type: PaymentErrorType.general,
      );
      emit(
        state.copyWith(
          status: PaymentStatus.failure,
          exception: paymentException,
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
    } on PaymentException catch (e) {
      print("Wallet payment failed: $e");
      emit(state.copyWith(status: PaymentStatus.failure, exception: e));
    } catch (e) {
      print("Wallet payment failed: $e");
      final paymentException = PaymentException(
        message: e.toString(),
        type: PaymentErrorType.wallet,
      );
      emit(
        state.copyWith(
          status: PaymentStatus.failure,
          exception: paymentException,
        ),
      );
    }
  }

  Future<void> createAccessRequest({
    required AccessRequest accessRequest,
  }) async {
    emit(state.copyWith(status: PaymentStatus.loading));

    try {
      _validateAccessRequest(accessRequest);

      print("Creating access request for student: ${accessRequest.studentId}");

      await repository.createAccessRequest(accessRequest: accessRequest);

      print("Access request created successfully");
      emit(state.copyWith(status: PaymentStatus.success));
    } on PaymentException catch (e) {
      print("Access request creation failed: $e");
      emit(state.copyWith(status: PaymentStatus.failure, exception: e));
    } catch (e) {
      print("Access request creation failed: $e");
      final paymentException = PaymentException(
        message: e.toString(),
        type: PaymentErrorType.accessRequest,
      );
      emit(
        state.copyWith(
          status: PaymentStatus.failure,
          exception: paymentException,
        ),
      );
    }
  }

  void _validateAccessRequest(AccessRequest accessRequest) {
    if (accessRequest.studentId.isEmpty) {
      throw PaymentException(
        message: "معرف الطالب مطلوب",
        type: PaymentErrorType.accessRequest,
      );
    }

    if (accessRequest.coursesId.isEmpty) {
      throw PaymentException(
        message: "لم يتم تحديد أي كورسات",
        type: PaymentErrorType.accessRequest,
      );
    }

    if (accessRequest.gradeId.isEmpty) {
      throw PaymentException(
        message: "معرف الصف الدراسي مطلوب",
        type: PaymentErrorType.accessRequest,
      );
    }

    if (accessRequest.studentName.isEmpty) {
      throw PaymentException(
        message: "اسم الطالب مطلوب",
        type: PaymentErrorType.accessRequest,
      );
    }

    if (!accessRequest.attachment.existsSync()) {
      throw PaymentException(
        message: "الملف المرفق مطلوب",
        type: PaymentErrorType.fileUpload,
      );
    }
  }

  void resetPaymentState() {
    emit(PaymentState());
  }

  Future<void> checkPaymentSystemStatus() async {
    emit(state.copyWith(status: PaymentStatus.loading));

    try {
      emit(state.copyWith(status: PaymentStatus.initial));
    } catch (e) {
      emit(
        state.copyWith(
          status: PaymentStatus.failure,
          exception: PaymentException(
            message: "نظام الدفع غير متاح حالياً",
            type: PaymentErrorType.initialization,
          ),
        ),
      );
    }
  }
}
