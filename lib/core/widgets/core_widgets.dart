import 'package:flutter/material.dart';
import 'package:math_corn/core/utils/assets_manager.dart';
import 'package:math_corn/generated/l10n.dart';
import 'package:sizer/sizer.dart';

import '../error/exception_manager.dart';

class CustomErrorWidget extends StatelessWidget {
  final Exception exception;
  final double? height;

  const CustomErrorWidget({super.key, required this.exception, this.height});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: SizedBox(
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Image(
                height: height != null ? height! * 0.8 : 80.h,
                width: 80.w,
                image: AssetImage(ExceptionManager.getIconPath(exception)),
                fit: BoxFit.contain,
                // color: theme.colorScheme.error,
                colorBlendMode: BlendMode.overlay,
              ),
            ),
            Expanded(
              child: Text(
                ExceptionManager.getMessage(exception),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomLoadingWidget extends StatelessWidget {
  const CustomLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }
}

class NoDataWidget extends StatelessWidget {
  final double? height;

  const NoDataWidget({super.key, this.height});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: height ?? 20.h,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Image(image: AssetImage(AssetsManager.noDataFound)),
            ),
            SizedBox(height: 2.h),
            Text(S.of(context).noDataFound, style: theme.textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}

showErrorDialog(BuildContext context, Exception exception) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              ExceptionManager.getIconPath(exception),
              width: 64,
              height: 64,
            ),
            const SizedBox(height: 16),
            Text(
              ExceptionManager.getMessage(exception),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    },
  );
}

showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      );
    },
  );
}
