import 'package:flutter/material.dart';
import 'package:math_corn/core/routing/navigation_manager.dart';
import 'package:math_corn/generated/l10n.dart';
import 'package:math_corn/modules/courses/data/models/lecture.dart';
import 'package:sizer/sizer.dart';

class LectureInfoDialog {
  static void show({required BuildContext context, required Lecture lecture}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _LectureInfoDialogContent(lecture: lecture);
      },
    );
  }
}

class _LectureInfoDialogContent extends StatelessWidget {
  final Lecture lecture;

  const _LectureInfoDialogContent({required this.lecture});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      backgroundColor: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: _buildDialogTitle(theme),
      content: _buildDialogContent(theme, context),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text(
            S.of(context).close,
            style: TextStyle(color: theme.colorScheme.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildDialogTitle(ThemeData theme) {
    return Row(
      children: [
        Icon(Icons.info_outline, color: theme.colorScheme.primary, size: 6.w),
        SizedBox(width: 2.w),
        Text(
          'Lecture Info', // You can localize this
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDialogContent(ThemeData theme, BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(
          'Lecture Name', // You can localize this
          lecture.name,
          theme,
        ),
        SizedBox(height: 2.h),
        _buildInfoRow(
          'Content Type', // You can localize this
          lecture.contentType,
          theme,
        ),
        if (lecture.examId != null) ...[
          SizedBox(height: 2.h),
          _buildInfoRow(
            'Has Exam', // You can localize this
            'Yes', // You can localize this
            theme,
          ),
        ],
        if (lecture.fileUrl != null) ...[
          SizedBox(height: 2.h),
          _buildInfoRow(
            'Has Attachment', // You can localize this
            'Yes', // You can localize this
            theme,
          ),
        ],
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 25.w,
          child: Text(
            '$label:',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
