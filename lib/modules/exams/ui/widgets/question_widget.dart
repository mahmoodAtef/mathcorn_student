import 'package:flutter/material.dart';
import 'package:math_corn/core/widgets/image_builders.dart';
import 'package:math_corn/generated/l10n.dart';
import 'package:math_corn/modules/exams/data/models/question.dart';
import 'package:sizer/sizer.dart';

class QuestionWidget extends StatelessWidget {
  final Question question;
  final int currentQuestionIndex;
  final int totalQuestions;
  final int? selectedAnswer;
  final bool isSubmitted;
  final void Function(int answerIndex) onAnswerSelected;

  const QuestionWidget({
    super.key,
    required this.question,
    required this.currentQuestionIndex,
    required this.totalQuestions,
    required this.selectedAnswer,
    required this.isSubmitted,
    required this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.all(2.w),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Question Header
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 3.w,
                      vertical: 1.h,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${currentQuestionIndex + 1}/$totalQuestions',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (question.points != null) ...[
                    SizedBox(width: 2.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 1.h,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: theme.colorScheme.secondary,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '${question.points} ${S.of(context).points}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),

              SizedBox(height: 3.h),

              // Question Text
              Text(
                question.question,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),

              // Question Image (if exists)
              if (question.image != null) ...[
                SizedBox(height: 2.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    question.image!,
                    width: double.infinity,
                    height: 25.h,
                    fit: BoxFit.cover,
                    errorBuilder: defaultImageErrorBuilder,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: double.infinity,
                        height: 25.h,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],

              SizedBox(height: 3.h),

              // Answer Options
              ...List.generate(
                question.options.length,
                (index) => _buildOptionItem(
                  context,
                  index,
                  question.options[index],
                  theme,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionItem(
    BuildContext context,
    int index,
    String option,
    ThemeData theme,
  ) {
    final isSelected = selectedAnswer == index;
    final isCorrect = index == question.correctAnswerIndex;
    final isWrong = isSelected && !isCorrect && isSubmitted;

    // Colors based on state
    Color? backgroundColor;
    Color? borderColor;
    Color? textColor;
    IconData? icon;

    if (isSubmitted) {
      if (isCorrect) {
        backgroundColor = Colors.green.withOpacity(0.1);
        borderColor = Colors.green;
        textColor = Colors.green.shade700;
        icon = Icons.check_circle;
      } else if (isWrong) {
        backgroundColor = Colors.red.withOpacity(0.1);
        borderColor = Colors.red;
        textColor = Colors.red.shade700;
        icon = Icons.cancel;
      } else {
        backgroundColor = theme.colorScheme.surface;
        borderColor = theme.colorScheme.outline.withOpacity(0.3);
        textColor = theme.colorScheme.onSurface;
      }
    } else if (isSelected) {
      backgroundColor = theme.colorScheme.primary.withOpacity(0.1);
      borderColor = theme.colorScheme.primary;
      textColor = theme.colorScheme.primary;
      icon = Icons.radio_button_checked;
    } else {
      backgroundColor = theme.colorScheme.surface;
      borderColor = theme.colorScheme.outline.withOpacity(0.3);
      textColor = theme.colorScheme.onSurface;
      icon = Icons.radio_button_unchecked;
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: InkWell(
        onTap: isSubmitted ? null : () => onAnswerSelected(index),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: borderColor!,
              width: isSelected || (isSubmitted && isCorrect) ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              // Option letter/number
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: isSelected || (isSubmitted && isCorrect)
                      ? borderColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: borderColor, width: 1.5),
                ),
                child: Center(
                  child: Text(
                    String.fromCharCode(65 + index), // A, B, C, D
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: isSelected || (isSubmitted && isCorrect)
                          ? theme.colorScheme.onPrimary
                          : borderColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              SizedBox(width: 3.w),

              // Option text
              Expanded(
                child: Text(
                  option,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: textColor,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    height: 1.3,
                  ),
                ),
              ),

              // Status icon (for submitted state)
              if (isSubmitted && (isCorrect || isWrong)) ...[
                SizedBox(width: 2.w),
                Icon(icon, color: borderColor, size: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
