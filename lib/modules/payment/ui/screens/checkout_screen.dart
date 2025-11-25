import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paymob/billing_data.dart';
import 'package:math_corn/core/error/exception_manager.dart';
import 'package:math_corn/core/routing/navigation_manager.dart';
import 'package:math_corn/core/services/dep_injection.dart';
import 'package:math_corn/core/widgets/core_widgets.dart';
import 'package:math_corn/core/widgets/custom_button.dart';
import 'package:math_corn/core/widgets/custom_text_field.dart';
import 'package:math_corn/generated/l10n.dart';
import 'package:math_corn/modules/courses/data/models/course.dart';
import 'package:math_corn/modules/main/ui/screens/main_screen.dart';
import 'package:math_corn/modules/payment/cubit/payment_cubit.dart';
import 'package:math_corn/modules/payment/data/models/access_request.dart';
import 'package:math_corn/modules/student/cubit/student_cubit.dart';
import 'package:sizer/sizer.dart';

enum PaymentMethod { card, wallet, accessRequest }

class CheckoutScreen extends StatefulWidget {
  final List<Course> cartCourses;
  final double totalPrice;

  const CheckoutScreen({
    super.key,
    required this.cartCourses,
    required this.totalPrice,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  PaymentMethod _selectedPaymentMethod = PaymentMethod.card;
  final _formKey = GlobalKey<FormState>();
  File? _selectedFile;
  String? _selectedFileName;

  // Form controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _walletIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  void _initializeUserData() {
    final studentState = context.read<StudentCubit>().state;
    if (studentState.student != null) {
      final student = studentState.student!;
      _nameController.text = student.name ?? '';
      _emailController.text = student.email ?? '';
      _phoneController.text = student.studentPhone ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _walletIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = S.of(context);

    return BlocProvider(
      create: (context) => sl<PaymentCubit>(),
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.checkout), centerTitle: true),
        body: MultiBlocListener(
          listeners: [
            BlocListener<PaymentCubit, PaymentState>(
              listener: (context, state) {
                if (state.isSuccess) {
                  if (_selectedPaymentMethod == PaymentMethod.accessRequest) {
                    _onAccessRequestSuccess(context);
                  } else {
                    _onPaymentSuccess(context, state.courses ?? []);
                  }
                } else if (state.isFailure) {
                  ExceptionManager.showMessage(state.exception!);
                }
              },
            ),
            BlocListener<StudentCubit, StudentState>(
              listener: (context, state) {
                if (state.status == StudentStatus.gotProfile) {
                  _navigateToSuccess(context);
                }
              },
            ),
          ],
          child: CustomScrollView(
            slivers: [
              // Order Summary Section
              SliverToBoxAdapter(child: _buildOrderSummary(context)),

              // Billing Information Section
              SliverToBoxAdapter(child: _buildBillingForm(context)),

              // Payment Method Section
              SliverToBoxAdapter(child: _buildPaymentMethodSection(context)),

              // Pay Button Section
              SliverToBoxAdapter(child: _buildActionButton(context)),

              SliverToBoxAdapter(child: SizedBox(height: 5.h)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = S.of(context);

    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.orderSummary,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2.h),

          // Courses List
          ...widget.cartCourses.map(
            (course) => Padding(
              padding: EdgeInsets.only(bottom: 1.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      course.name,
                      style: theme.textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    _selectedPaymentMethod == PaymentMethod.accessRequest
                        ? 'طلب وصول'
                        : '${course.newPrice ?? course.oldPrice ?? 0} ${l10n.currency}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color:
                          _selectedPaymentMethod == PaymentMethod.accessRequest
                          ? theme.colorScheme.secondary
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Divider(height: 3.h),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.total,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _selectedPaymentMethod == PaymentMethod.accessRequest
                    ? l10n.accessRequest
                    : '${widget.totalPrice.toStringAsFixed(0)} ${l10n.currency}',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: _selectedPaymentMethod == PaymentMethod.accessRequest
                      ? theme.colorScheme.secondary
                      : theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBillingForm(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = S.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.billingInformation,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 3.h),

            // Name
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: l10n.name,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.firstNameRequired;
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(width: 3.w),
              ],
            ),
            SizedBox(height: 2.h),

            // Email
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: l10n.email,
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.emailRequired;
                }
                if (!value.contains('@')) {
                  return l10n.invalidEmail;
                }
                return null;
              },
            ),
            SizedBox(height: 2.h),

            // Phone
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: l10n.phone,
                prefixIcon: Icon(Icons.phone_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.phoneRequired;
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodSection(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = S.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _selectedPaymentMethod == PaymentMethod.accessRequest
                ? l10n.accessRequest
                : l10n.paymentMethod,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 3.h),

          // Card Payment Option
          _buildPaymentOption(
            context,
            PaymentMethod.card,
            l10n.creditCard,
            Icons.credit_card,
          ),
          SizedBox(height: 2.h),

          // Wallet Payment Option
          _buildPaymentOption(
            context,
            PaymentMethod.wallet,
            l10n.mobileWallet,
            Icons.account_balance_wallet,
          ),
          SizedBox(height: 2.h),

          // Access Request Option
          _buildPaymentOption(
            context,
            PaymentMethod.accessRequest,
            'طلب الوصول للكورسات',
            Icons.request_page_outlined,
          ),

          // Wallet ID Input (show only if wallet is selected)
          if (_selectedPaymentMethod == PaymentMethod.wallet) ...[
            SizedBox(height: 2.h),
            CustomTextField(
              controller: _walletIdController,
              label: l10n.walletNumber,
              autofillHints: [AutofillHints.telephoneNumberLocal],
              prefixIcon: Icons.phone,
              hint: "01xxxxxxxxx",
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (_selectedPaymentMethod == PaymentMethod.wallet &&
                    (value == null || value.trim().isEmpty)) {
                  return l10n.walletNumberRequired;
                }
                return null;
              },
            ),
          ],

          // File Attachment (show only if access request is selected)
          if (_selectedPaymentMethod == PaymentMethod.accessRequest) ...[
            SizedBox(height: 2.h),
            _buildFileAttachment(context),
          ],
        ],
      ),
    );
  }

  Widget _buildFileAttachment(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).requiredAttachments,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          S.of(context).requiredAttachmentsDescription,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.outline,
          ),
        ),
        SizedBox(height: 2.h),
        InkWell(
          onTap: _pickFile,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border.all(
                color: theme.colorScheme.outline.withOpacity(0.3),
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(12),
              color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
            ),
            child: Column(
              children: [
                Icon(
                  _selectedFile != null
                      ? Icons.attach_file
                      : Icons.cloud_upload_outlined,
                  size: 8.w,
                  color: theme.colorScheme.primary,
                ),
                SizedBox(height: 1.h),
                Text(
                  _selectedFile != null
                      ? _selectedFileName ?? ""
                      : S.of(context).selectImage,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: _selectedFile != null
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline,
                    fontWeight: _selectedFile != null ? FontWeight.w500 : null,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (_selectedFile != null) ...[
                  SizedBox(height: 1.h),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedFile = null;
                        _selectedFileName = null;
                      });
                    },
                    icon: Icon(Icons.close, size: 4.w),
                    label: Text(S.of(context).removeFile),
                    style: TextButton.styleFrom(
                      foregroundColor: theme.colorScheme.error,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _selectedFile = File(result.files.single.path!);
          _selectedFileName = result.files.single.name;
        });
      }
    } catch (e) {
      _showErrorMessage(context, S.of(context).filePickerError);
    }
  }

  Widget _buildPaymentOption(
    BuildContext context,
    PaymentMethod method,
    String title,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    final isSelected = _selectedPaymentMethod == method;

    return InkWell(
      onTap: () => setState(() => _selectedPaymentMethod = method),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          color: isSelected
              ? theme.colorScheme.primaryContainer.withOpacity(0.1)
              : null,
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                size: 5.w,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? theme.colorScheme.primary : null,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: theme.colorScheme.primary,
                size: 5.w,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    final l10n = S.of(context);

    return BlocBuilder<PaymentCubit, PaymentState>(
      builder: (context, paymentState) {
        String buttonText;
        IconData buttonIcon;

        switch (_selectedPaymentMethod) {
          case PaymentMethod.card:
          case PaymentMethod.wallet:
            buttonText = l10n.payNow;
            buttonIcon = Icons.payment;
            break;
          case PaymentMethod.accessRequest:
            buttonText = l10n.sendAccessRequest;
            buttonIcon = Icons.send;
            break;
        }

        return Container(
          margin: EdgeInsets.all(4.w),
          child: paymentState.isLoading
              ? CustomLoadingWidget()
              : CustomButton(
                  text: buttonText,
                  onPressed: () {
                    if (paymentState.isLoading) {
                      return;
                    }
                    _processAction(context);
                  },
                  icon: buttonIcon,
                  height: 7.h,
                ),
        );
      },
    );
  }

  void _processAction(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedPaymentMethod == PaymentMethod.accessRequest) {
      _processAccessRequest(context);
    } else {
      _processPayment(context);
    }
  }

  void _processPayment(BuildContext context) {
    final courseIds = widget.cartCourses.map((course) => course.id).toList();

    final billingData = BillingData(
      firstName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
    );

    final paymentCubit = context.read<PaymentCubit>();

    if (_selectedPaymentMethod == PaymentMethod.card) {
      paymentCubit.payWithCard(
        courses: courseIds,
        context: context,
        price: widget.totalPrice,
        billingData: billingData,
      );
    } else if (_selectedPaymentMethod == PaymentMethod.wallet) {
      if (_walletIdController.text.trim().isEmpty) {
        _showErrorMessage(context, S.of(context).walletNumberRequired);
        return;
      }

      paymentCubit.payWithWallet(
        courses: courseIds,
        context: context,
        price: widget.totalPrice,
        walletId: _walletIdController.text.trim(),
        billingData: billingData,
      );
    }
  }

  void _processAccessRequest(BuildContext context) {
    if (_selectedFile == null) {
      _showErrorMessage(context, S.of(context).pleaseSelectFile);
      return;
    }

    final studentState = context.read<StudentCubit>().state;
    final student = studentState.student;

    if (student == null) {
      _showErrorMessage(context, ExceptionManager.getMessage(Exception()));
      return;
    }

    final courseIds = widget.cartCourses.map((course) => course.id).toList();

    final accessRequest = AccessRequest(
      studentId: student.uid ?? '',
      coursesId: courseIds,
      gradeId: student.gradeId ?? '',
      attachment: _selectedFile!,
      studentName: student.name ?? '',
    );

    context.read<PaymentCubit>().createAccessRequest(
      accessRequest: accessRequest,
    );
  }

  void _onPaymentSuccess(BuildContext context, List<String> courseIds) {
    final studentCubit = context.read<StudentCubit>();
    studentCubit.addCoursesToOnGoing(courseIds);
  }

  void _onAccessRequestSuccess(BuildContext context) {
    final l10n = S.of(context);
    final theme = Theme.of(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.accessRequestSent),
        backgroundColor: theme.colorScheme.onSecondary,
        duration: Duration(seconds: 4),
      ),
    );
    context.pushAndRemove(MainScreen());
  }

  void _navigateToSuccess(BuildContext context) {
    final l10n = S.of(context);
    final theme = Theme.of(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.paymentSuccessful),
        backgroundColor: theme.colorScheme.primary,
        duration: Duration(seconds: 3),
      ),
    );

    Future.delayed(Duration(milliseconds: 500), () {
      if (context.mounted) {
        context.pushAndRemove(MainScreen());
      }
    });
  }

  void _showErrorMessage(BuildContext context, String message) {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: theme.colorScheme.error,
        duration: Duration(seconds: 4),
      ),
    );
  }
}
