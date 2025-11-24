import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_corn/core/widgets/custom_button.dart';
import 'package:math_corn/generated/l10n.dart';
import 'package:math_corn/modules/exams/cubit/exam_cubit.dart';
import 'package:math_corn/modules/exams/data/models/exam.dart';
import 'package:math_corn/modules/exams/ui/widgets/question_widget.dart';
import 'package:sizer/sizer.dart';

class ExamScreen extends StatefulWidget {
  final Exam exam;

  const ExamScreen({super.key, required this.exam});

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  late PageController _pageController;
  late List<int?> _answers;
  late Timer _timer;
  late int _remainingTime;
  int _currentQuestionIndex = 0;
  bool _isSubmitted = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _answers = List.filled(widget.exam.questions.length, null);
    _remainingTime = widget.exam.duration * 60; // Convert minutes to seconds
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _submitExam();
      }
    });
  }

  void _submitExam() {
    if (!_isSubmitted) {
      _timer.cancel();
      setState(() {
        _isSubmitted = true;
      });

      // Convert nullable list to non-nullable list with default value -1 for unanswered questions
      final answersToSubmit = _answers.map((answer) => answer ?? -1).toList();
      context.read<ExamCubit>().submitExam(answersToSubmit);
    }
  }

  String _formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final remainingSeconds = seconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () => _showExitDialog(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.exam.title),
          centerTitle: true,
          elevation: 0,
          backgroundColor: theme.colorScheme.surface,
          foregroundColor: theme.colorScheme.onSurface,
          actions: [
            // Timer Display
            Container(
              margin: EdgeInsets.only(right: 4.w),
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: _remainingTime < 300
                    ? theme.colorScheme.error.withOpacity(0.1)
                    : theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _remainingTime < 300
                      ? theme.colorScheme.error
                      : theme.colorScheme.primary,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.access_time,
                    size: 4.w,
                    color: _remainingTime < 300
                        ? theme.colorScheme.error
                        : theme.colorScheme.primary,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    _formatTime(_remainingTime),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _remainingTime < 300
                          ? theme.colorScheme.error
                          : theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: BlocListener<ExamCubit, ExamState>(
          listener: (context, state) {
            if (state.isSubmitted) {
              _showResultsDialog(context, state);
            }
          },
          child: Column(
            children: [
              // Progress Bar
              _buildProgressBar(theme, context),

              // Questions PageView
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentQuestionIndex = index;
                    });
                  },
                  itemCount: widget.exam.questions.length,
                  itemBuilder: (context, index) {
                    return QuestionWidget(
                      question: widget.exam.questions[index],
                      currentQuestionIndex: index,
                      totalQuestions: widget.exam.questions.length,
                      selectedAnswer: _answers[index],
                      isSubmitted: _isSubmitted,
                      onAnswerSelected: (answerIndex) {
                        setState(() {
                          _answers[index] = answerIndex;
                        });
                      },
                    );
                  },
                ),
              ),

              // Navigation Buttons
              _buildNavigationButtons(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar(ThemeData theme, BuildContext context) {
    final progress = (_currentQuestionIndex + 1) / widget.exam.questions.length;
    final S s = S.of(context);
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${S.of(context).question} ${_currentQuestionIndex + 1} ${S.of(context).ofText} ${widget.exam.questions.length}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: theme.colorScheme.surfaceVariant,
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.primary,
            ),
            minHeight: 1.h,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(ThemeData theme) {
    final isLastQuestion =
        _currentQuestionIndex == widget.exam.questions.length - 1;
    final isFirstQuestion = _currentQuestionIndex == 0;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Previous Button
          if (!isFirstQuestion)
            Expanded(
              child: CustomButton(
                text: S.of(context).previous,
                type: ButtonType.outlined,
                icon: Icons.arrow_back,
                onPressed: _isSubmitted
                    ? null
                    : () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
              ),
            ),

          if (!isFirstQuestion && !isLastQuestion) SizedBox(width: 4.w),

          // Next/Submit Button
          Expanded(
            child: CustomButton(
              text: isLastQuestion
                  ? S.of(context).submitExam
                  : S.of(context).next,
              icon: isLastQuestion ? Icons.check : Icons.arrow_forward,
              onPressed: _isSubmitted
                  ? null
                  : () {
                      if (isLastQuestion) {
                        _showSubmitConfirmationDialog(context);
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _showExitDialog(BuildContext context) async {
    if (_isSubmitted) return true;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).exitExam),
        content: Text(S.of(context).exitExamConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(S.of(context).cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              S.of(context).exit,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  void _showSubmitConfirmationDialog(BuildContext context) {
    final unansweredCount = _answers.where((answer) => answer == null).length;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(S.of(context).submitExam),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(S.of(context).submitExamConfirmation),
              if (unansweredCount > 0) ...[
                SizedBox(height: 2.h),
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.error.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning,
                        color: Theme.of(context).colorScheme.error,
                        size: 5.w,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          '${S.of(context).unansweredQuestions}: $unansweredCount',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(S.of(context).cancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _submitExam();
              },
              child: Text(S.of(context).submit),
            ),
          ],
        );
      },
    );
  }

  void _showResultsDialog(BuildContext context, ExamState state) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                state.isPassed!
                    ? Icons.celebration
                    : Icons.sentiment_dissatisfied,
                color: state.isPassed!
                    ? Colors.green
                    : Theme.of(context).colorScheme.error,
                size: 8.w,
              ),
              SizedBox(width: 3.w),
              Text(
                state.isPassed!
                    ? S.of(context).congratulations
                    : S.of(context).betterLuckNextTime,
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: state.isPassed!
                      ? Colors.green.withOpacity(0.1)
                      : Theme.of(context).colorScheme.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: state.isPassed!
                        ? Colors.green
                        : Theme.of(context).colorScheme.error,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      '${S.of(context).yourScore}:',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      '${state.totalPoints}/${widget.exam.totalPoints}',
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: state.isPassed!
                                ? Colors.green
                                : Theme.of(context).colorScheme.error,
                          ),
                    ),
                    Text(
                      '${((state.totalPoints! / widget.exam.totalPoints) * 100).round()}%',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: state.isPassed!
                            ? Colors.green
                            : Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            CustomButton(
              text: S.of(context).finish,
              width: 30.w,
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
