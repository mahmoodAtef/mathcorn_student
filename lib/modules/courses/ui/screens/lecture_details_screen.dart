import 'package:flutter/material.dart';
import 'package:math_corn/core/services/dep_injection.dart';
import 'package:math_corn/generated/l10n.dart';
import 'package:math_corn/modules/courses/data/models/lecture.dart';
import 'package:math_corn/modules/courses/ui/logic/syetem_ui_manager.dart';
import 'package:math_corn/modules/courses/ui/widgets/exam_section_widget.dart';
import 'package:math_corn/modules/courses/ui/widgets/lecture_app_bar.dart';
import 'package:math_corn/modules/courses/ui/widgets/lecture_content_widget.dart';
import 'package:math_corn/modules/courses/ui/widgets/lecture_header_widget.dart';
import 'package:math_corn/modules/courses/ui/widgets/lecture_info_dialog.dart';
import 'package:math_corn/modules/courses/ui/widgets/pdf_viewer.dart';
import 'package:math_corn/modules/library/cubit/library_cubit.dart';
import 'package:math_corn/modules/library/ui/widgets/library_dialogs.dart';
import 'package:sizer/sizer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LectureContentScreen extends StatefulWidget {
  final Lecture lecture;

  const LectureContentScreen({super.key, required this.lecture});

  @override
  State<LectureContentScreen> createState() => _LectureContentScreenState();
}

class _LectureContentScreenState extends State<LectureContentScreen> {
  YoutubePlayerController? _youtubeController;
  bool _isFullScreen = false;
  bool _isInLibrary = false;

  @override
  void initState() {
    super.initState();
    if (widget.lecture.contentType.toLowerCase() == 'video') {
      _initializeYoutubePlayer();
    }
    _checkLibraryStatus();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Move system UI setup here after context is ready
    SystemUIManager.resetSystemUI(context);
  }

  void _checkLibraryStatus() {
    final libraryCubit = sl<LibraryCubit>();
    _isInLibrary = libraryCubit.state.lectures.any(
      (lecture) => lecture.id == widget.lecture.id,
    );
  }

  void _initializeYoutubePlayer() {
    if (widget.lecture.url.isNotEmpty) {
      String? videoId = YoutubePlayer.convertUrlToId(widget.lecture.url);

      if (videoId != null) {
        _youtubeController = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
            enableCaption: true,
            captionLanguage: 'ar',
            showLiveFullscreenButton: true,
            controlsVisibleAtStart: true,
            hideControls: false,
            disableDragSeek: false,
            loop: false,
            forceHD: false,
          ),
        );
        _youtubeController!.addListener(_youtubePlayerListener);
      }
    }
  }

  void _youtubePlayerListener() {
    if (_youtubeController != null) {
      bool isCurrentlyFullScreen = _youtubeController!.value.isFullScreen;

      if (isCurrentlyFullScreen != _isFullScreen) {
        setState(() {
          _isFullScreen = isCurrentlyFullScreen;
        });

        if (!isCurrentlyFullScreen) {
          Future.delayed(const Duration(milliseconds: 100), () {
            SystemUIManager.resetSystemUI(context);
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _youtubeController?.removeListener(_youtubePlayerListener);
    _youtubeController?.dispose();
    // SystemUIManager.resetSystemUI(context);
    super.dispose();
  }

  void _toggleLibrary() {
    final libraryCubit = sl<LibraryCubit>();

    if (_isInLibrary) {
      LibraryDialogs.showRemoveConfirmationDialog(
        context: context,
        lecture: widget.lecture,
        onRemove: () {
          setState(() {
            _isInLibrary = false;
          });
        },
      );
    } else {
      libraryCubit.addLecture(widget.lecture);
      setState(() {
        _isInLibrary = true;
      });
      LibraryDialogs.showSuccessSnackbar(
        context: context,
        message: S.of(context).addedToLibrary,
        isAdd: true,
      );
    }
  }

  void _showLectureInfo() {
    LectureInfoDialog.show(context: context, lecture: widget.lecture);
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller:
            _youtubeController ?? YoutubePlayerController(initialVideoId: ''),
      ),
      builder: (context, player) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: _isFullScreen
              ? null
              : LectureAppBar(
                  lecture: widget.lecture,
                  isInLibrary: _isInLibrary,
                  onBookmarkPressed: _toggleLibrary,
                  onInfoPressed: _showLectureInfo,
                ),
          body: SafeArea(
            child: _isFullScreen
                ? player
                : SingleChildScrollView(
                    padding: EdgeInsets.all(4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LectureHeaderWidget(lecture: widget.lecture),
                        SizedBox(height: 6.h),
                        LectureContentWidget(
                          lecture: widget.lecture,
                          youtubeController: _youtubeController,
                          onRetry: _initializeYoutubePlayer,
                        ),
                        if (widget.lecture.contentType.toLowerCase() ==
                                'video' &&
                            widget.lecture.fileUrl != null) ...[
                          SizedBox(height: 6.h),
                          OnlinePdfViewerWidget(
                            pdfUrl: widget.lecture.fileUrl!,
                            lectureName: widget.lecture.name,
                          ),
                        ],
                        SizedBox(height: 6.h),
                        ExamSectionWidget(lecture: widget.lecture),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}
