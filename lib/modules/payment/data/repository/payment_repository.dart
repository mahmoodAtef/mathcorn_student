import 'package:flutter/material.dart';
import 'package:flutter_paymob/billing_data.dart' show BillingData;
import 'package:math_corn/modules/payment/data/models/access_request.dart';
import 'package:math_corn/modules/payment/data/services/payment_services.dart';

class PaymentRepository {
  final PaymentServices services;

  PaymentRepository(this.services);

  Future<void> payWithCard({
    required List<String> courses,
    required BuildContext context,
    required double price,
    required BillingData billingData,
  }) async {
    return await services.payWithCard(
      courses: courses,
      context: context,
      price: price,
      billingData: billingData,
    );
  }

  Future<void> payWithWallet({
    required List<String> courses,
    required BuildContext context,
    required double price,
    required BillingData billingData,
    required String number,
  }) async {
    return await services.payWithWallet(
      courses: courses,
      context: context,
      price: price,
      billingData: billingData,
      number: number,
    );
  }

  Future<void> createAccessRequest({
    required AccessRequest accessRequest,
  }) async {
    return await services.createAccessRequest(accessRequest: accessRequest);
  }
}
