import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_corn/core/routing/navigation_manager.dart';
import 'package:math_corn/core/services/dep_injection.dart';
import 'package:math_corn/core/widgets/core_widgets.dart';
import 'package:math_corn/generated/l10n.dart';
import 'package:math_corn/modules/courses/data/models/lecture.dart';
import 'package:math_corn/modules/courses/ui/screens/lecture_details_screen.dart';
import 'package:math_corn/modules/library/cubit/library_cubit.dart';
import 'package:math_corn/modules/library/ui/widgets/library_header.dart';
import 'package:sizer/sizer.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<LibraryCubit>()..getLibrary(),
      child: const _LibraryPageContent(),
    );
  }
}

class _LibraryPageContent extends StatelessWidget {
  const _LibraryPageContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final S l10n = S.of(context);

    return BlocConsumer<LibraryCubit, LibraryState>(
      // Only rebuild when lectures list actually changes
      buildWhen: (previous, current) => previous.lectures != current.lectures,

      // Listen to status changes for showing messages
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        _handleStateChanges(context, state);
      },

      builder: (context, state) {
        return CustomScrollView(
          slivers: [
            const LibraryHeader(),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
                child: Text(
                  l10n.savedLectures,
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            if (state.isEmpty)
              SliverFillRemaining(child: _buildEmptyLibrary(context))
            else
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                sliver: SliverList.builder(
                  itemCount: state.lectures.length,
                  itemBuilder: (context, index) {
                    final lecture = state.lectures[index];
                    return _LectureCard(
                      lecture: lecture,
                      key: ValueKey(
                        lecture.id,
                      ), // Use lecture ID as key for better performance
                    );
                  },
                ),
              ),
            SliverToBoxAdapter(child: SizedBox(height: 10.h)),
          ],
        );
      },
    );
  }

  void _handleStateChanges(BuildContext context, LibraryState state) {
    final theme = Theme.of(context);
    final l10n = S.of(context);

    switch (state.status) {
      case LibraryStatus.lectureAdded:
        _showSnackBar(context, l10n.addedToLibrary, theme.colorScheme.primary);
        break;

      case LibraryStatus.lectureRemoved:
        _showSnackBar(
          context,
          l10n.removedFromLibrary,
          theme.colorScheme.error,
        );
        break;

      case LibraryStatus.lectureAlreadyExists:
        _showSnackBar(
          context,
          l10n.lectureAlreadyInLibrary,
          theme.colorScheme.secondary,
        );
        break;

      case LibraryStatus.failure:
        _showSnackBar(
          context,
          state.exception?.toString() ?? l10n.genericError,
          theme.colorScheme.error,
        );
        break;

      default:
        break;
    }
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildEmptyLibrary(BuildContext context) {
    return Center(
      child: Padding(padding: EdgeInsets.all(8.w), child: const NoDataWidget()),
    );
  }
}

class _LectureCard extends StatelessWidget {
  final Lecture lecture;

  const _LectureCard({required this.lecture, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.only(bottom: 3.h),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _navigateToLecture(lecture, context),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Row(
            children: [
              // Content Type Icon
              Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getContentTypeIcon(lecture.contentType),
                  color: theme.colorScheme.primary,
                  size: 5.w,
                ),
              ),
              SizedBox(width: 4.w),

              // Lecture Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lecture.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 1.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.w,
                        vertical: 0.5.h,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _getContentTypeLabel(lecture.contentType, context),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSecondaryContainer,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Action Buttons
              BlocBuilder<LibraryCubit, LibraryState>(
                buildWhen: (previous, current) =>
                    previous.isProcessing != current.isProcessing,
                builder: (context, state) {
                  return Row(
                    children: [
                      IconButton(
                        onPressed: state.isProcessing
                            ? null
                            : () => _navigateToLecture(lecture, context),
                        icon: Icon(
                          Icons.play_circle_filled,
                          color: state.isProcessing
                              ? theme.disabledColor
                              : theme.colorScheme.primary,
                          size: 7.w,
                        ),
                      ),
                      IconButton(
                        onPressed: state.isProcessing
                            ? null
                            : () => _removeFromLibrary(context, lecture),
                        icon: state.isRemoving
                            ? SizedBox(
                                width: 6.w,
                                height: 6.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: theme.colorScheme.error,
                                ),
                              )
                            : Icon(
                                Icons.delete_outline,
                                color: theme.colorScheme.error,
                                size: 6.w,
                              ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getContentTypeIcon(String contentType) {
    switch (contentType.toLowerCase()) {
      case 'video':
        return Icons.play_circle_outline;
      case 'pdf':
        return Icons.picture_as_pdf;
      default:
        return Icons.play_circle_outline;
    }
  }

  String _getContentTypeLabel(String contentType, BuildContext context) {
    switch (contentType.toLowerCase()) {
      case 'video':
        return S.of(context).video;
      case 'pdf':
        return 'PDF';
      default:
        return 'محتوى';
    }
  }

  void _navigateToLecture(Lecture lecture, BuildContext context) {
    context.push(LectureContentScreen(lecture: lecture));
  }

  void _removeFromLibrary(BuildContext context, Lecture lecture) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        final theme = Theme.of(context);
        return AlertDialog(
          title: Text(
            S.of(context).removeFromLibrary,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(S.of(context).confirmRemoveFromLibrary),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(S.of(context).cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<LibraryCubit>().removeLecture(lecture);
              },
              child: Text(
                S.of(context).remove,
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ),
          ],
        );
      },
    );
  }
}
