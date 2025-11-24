import 'package:flutter/material.dart';
import 'package:math_corn/core/routing/navigation_manager.dart';
import 'package:math_corn/core/services/dep_injection.dart';
import 'package:math_corn/generated/l10n.dart';
import 'package:math_corn/modules/courses/data/models/lecture.dart';
import 'package:math_corn/modules/library/cubit/library_cubit.dart';
import 'package:sizer/sizer.dart';

class LibraryDialogs {
  static void showRemoveConfirmationDialog({
    required BuildContext context,
    required Lecture lecture,
    required VoidCallback onRemove,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return _RemoveConfirmationDialog(lecture: lecture, onRemove: onRemove);
      },
    );
  }

  static void showSuccessSnackbar({
    required BuildContext context,
    required String message,
    required bool isAdd,
  }) {
    final theme = Theme.of(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isAdd ? Icons.bookmark_added : Icons.bookmark_remove,
              color: isAdd
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onError,
              size: 5.w,
            ),
            SizedBox(width: 3.w),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isAdd
            ? theme.colorScheme.primary
            : theme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(4.w),
        duration: const Duration(seconds: 3),
        action: isAdd
            ? SnackBarAction(
                label: S.of(context).viewLibrary,
                textColor: theme.colorScheme.onPrimary,
                onPressed: () {
                  context.pop();
                },
              )
            : null,
      ),
    );
  }
}

class _RemoveConfirmationDialog extends StatelessWidget {
  final Lecture lecture;
  final VoidCallback onRemove;

  const _RemoveConfirmationDialog({
    required this.lecture,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(
            Icons.bookmark_remove,
            color: theme.colorScheme.error,
            size: 6.w,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              S.of(context).removeFromLibrary,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: Text(
        S.of(context).confirmRemoveFromLibrary,
        style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            S.of(context).cancel,
            style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            sl<LibraryCubit>().removeLecture(lecture);
            onRemove();
            Navigator.of(context).pop();
            LibraryDialogs.showSuccessSnackbar(
              context: context,
              message: S.of(context).removedFromLibrary,
              isAdd: false,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.error,
            foregroundColor: theme.colorScheme.onError,
          ),
          child: Text(S.of(context).remove),
        ),
      ],
    );
  }
}
