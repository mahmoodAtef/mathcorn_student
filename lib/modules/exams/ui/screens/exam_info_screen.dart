import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_corn/core/routing/navigation_manager.dart';
import 'package:math_corn/core/services/dep_injection.dart';
import 'package:math_corn/core/widgets/connectivity_widget.dart';
import 'package:math_corn/core/widgets/core_widgets.dart';
import 'package:math_corn/core/widgets/custom_button.dart';
import 'package:math_corn/generated/l10n.dart';
import 'package:math_corn/modules/exams/cubit/exam_cubit.dart';
import 'package:math_corn/modules/exams/ui/screens/exam_screen.dart';
import 'package:sizer/sizer.dart';

class ExamInfoScreen extends StatefulWidget {
  final String examId;

  const ExamInfoScreen({super.key, required this.examId});

  @override
  State<ExamInfoScreen> createState() => _ExamInfoScreenState();
}

class _ExamInfoScreenState extends State<ExamInfoScreen> {
  late ExamCubit _examCubit;
  @override
  void initState() {
    super.initState();
    _examCubit = sl<ExamCubit>();
    _loadExam();
  }

  void _loadExam() {
    _examCubit.getExam(widget.examId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => _examCubit,
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).examInfo),
          centerTitle: true,
          elevation: 0,
          backgroundColor: theme.colorScheme.surface,
          foregroundColor: theme.colorScheme.onSurface,
        ),
        body: SafeArea(
          child: ConnectionWidget(
            onRetry: _loadExam,
            child: BlocBuilder<ExamCubit, ExamState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const CustomLoadingWidget();
                }

                if (state.isFailure) {
                  return Center(
                    child: CustomErrorWidget(
                      exception: state.exception!,
                      height: 40.h,
                    ),
                  );
                }

                if (state.isSuccess && state.exam != null) {
                  return _buildExamInfo(context, state.exam!, theme);
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExamInfo(BuildContext context, exam, ThemeData theme) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Exam Header Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primary.withOpacity(0.8),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exam.title,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (exam.description != null) ...[
                    SizedBox(height: 2.h),
                    Text(
                      exam.description!,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onPrimary.withOpacity(0.9),
                        height: 1.4,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // Exam Details Card
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(5.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).examDetails,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 3.h),

                  // Questions Count
                  _buildDetailRow(
                    context,
                    Icons.quiz_outlined,
                    S.of(context).questionsCount,
                    '${exam.questions.length} ${S.of(context).questions}',
                    theme,
                  ),

                  SizedBox(height: 2.h),

                  // Duration
                  _buildDetailRow(
                    context,
                    Icons.access_time,
                    S.of(context).duration,
                    '${exam.duration} ${S.of(context).minutes}',
                    theme,
                  ),

                  SizedBox(height: 2.h),

                  // Total Points
                  _buildDetailRow(
                    context,
                    Icons.star_outline,
                    S.of(context).totalPoints,
                    '${exam.totalPoints} ${S.of(context).points}',
                    theme,
                  ),

                  SizedBox(height: 2.h),

                  // Passing Score
                  _buildDetailRow(
                    context,
                    Icons.trending_up,
                    S.of(context).passingScore,
                    '${(exam.totalPoints / 2).round()} ${S.of(context).points}',
                    theme,
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // // Instructions Card
          // Card(
          //   elevation: 1,
          //   shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(12),
          //   ),
          //   child: Padding(
          //     padding: EdgeInsets.all(5.w),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Row(
          //           children: [
          //             Icon(
          //               Icons.info_outline,
          //               color: theme.colorScheme.primary,
          //               size: 6.w,
          //             ),
          //             SizedBox(width: 3.w),
          //             Text(
          //               S.of(context).instructions,
          //               style: theme.textTheme.titleMedium?.copyWith(
          //                 fontWeight: FontWeight.w600,
          //                 color: theme.colorScheme.onSurface,
          //               ),
          //             ),
          //           ],
          //         ),
          //         SizedBox(height: 2.h),
          //         _buildInstruction(context, S.of(context).instruction1, theme),
          //         _buildInstruction(context, S.of(context).instruction2, theme),
          //         _buildInstruction(context, S.of(context).instruction3, theme),
          //         _buildInstruction(context, S.of(context).instruction4, theme),
          //       ],
          //     ),
          //   ),
          // ),
          //
          // SizedBox(height: 5.h),

          // Start Exam Button
          Center(
            child: CustomButton(
              text: S.of(context).startExam,
              icon: Icons.play_arrow,
              width: 80.w,
              height: 7.h,
              onPressed: () {
                context.push(
                  BlocProvider.value(
                    value: _examCubit,
                    child: ExamScreen(exam: exam),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    ThemeData theme,
  ) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: theme.colorScheme.primary, size: 5.w),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                value,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInstruction(
    BuildContext context,
    String instruction,
    ThemeData theme,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 1.h),
            width: 1.5.w,
            height: 1.5.w,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              instruction,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.4,
                color: theme.colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
