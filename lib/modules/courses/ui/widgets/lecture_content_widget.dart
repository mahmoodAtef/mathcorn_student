import 'package:flutter/material.dart';
import 'package:math_corn/generated/l10n.dart';
import 'package:math_corn/modules/courses/data/models/lecture.dart';
import 'package:math_corn/modules/courses/ui/widgets/pdf_viewer.dart';
import 'package:math_corn/modules/courses/ui/widgets/video_player.dart';
import 'package:sizer/sizer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LectureContentWidget extends StatelessWidget {
  final Lecture lecture;
  final YoutubePlayerController? youtubeController;
  final VoidCallback onRetry;

  const LectureContentWidget({
    super.key,
    required this.lecture,
    this.youtubeController,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final contentType = lecture.contentType.toLowerCase();

    if (contentType == 'video') {
      return VideoPlayerWidget(
        controller: youtubeController,
        lecture: lecture,
        onRetry: onRetry,
      );
    } else if (contentType == 'pdf') {
      return OnlinePdfViewerWidget(
        pdfUrl: lecture.url,
        lectureName: lecture.name,
      );
    }

    return _buildUnsupportedContentWidget(context);
  }

  Widget _buildUnsupportedContentWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.error.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 12.w,
            color: Theme.of(context).colorScheme.error,
          ),
          SizedBox(height: 3.h),
          Text(
            S.of(context).unsupportedContentType,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.onErrorContainer,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
