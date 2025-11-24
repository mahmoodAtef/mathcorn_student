import 'package:flutter/material.dart';
import 'package:math_corn/core/widgets/custom_button.dart';
import 'package:math_corn/modules/courses/data/models/lecture.dart';
import 'package:sizer/sizer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerWidget extends StatefulWidget {
  final YoutubePlayerController? controller;
  final Lecture lecture;
  final VoidCallback onRetry;

  const VideoPlayerWidget({
    super.key,
    required this.controller,
    required this.lecture,
    required this.onRetry,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _checkForErrors();
  }

  void _checkForErrors() {
    if (widget.lecture.url.isEmpty) {
      setState(() {
        _hasError = true;
        _errorMessage = 'رابط الفيديو غير موجود';
      });
    } else if (widget.controller == null) {
      String? videoId = YoutubePlayer.convertUrlToId(widget.lecture.url);
      if (videoId == null) {
        setState(() {
          _hasError = true;
          _errorMessage = 'رابط YouTube غير صحيح';
        });
      }
    }
  }

  Widget _buildVideoPlayer() {
    if (_hasError) {
      return _buildErrorWidget(_errorMessage);
    }

    if (widget.controller == null) {
      return _buildErrorWidget('خطأ في تحميل الفيديو');
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: YoutubePlayer(
              controller: widget.controller!,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Theme.of(context).colorScheme.primary,
              progressColors: ProgressBarColors(
                playedColor: Theme.of(context).colorScheme.primary,
                handleColor: Theme.of(context).colorScheme.primary,
                backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                bufferedColor: Theme.of(
                  context,
                ).colorScheme.primary.withOpacity(0.3),
              ),
              onReady: () {
                debugPrint('YouTube player is ready');
              },
              onEnded: (metaData) {
                debugPrint('Video ended');
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildControlPanel() {
  //   return Row(
  //     children: [
  //       _buildControlButton(
  //         icon: widget.controller!.value.isPlaying
  //             ? Icons.pause_circle_filled
  //             : Icons.play_circle_filled,
  //         label: widget.controller!.value.isPlaying ? 'إيقاف' : 'تشغيل',
  //         onTap: () {
  //           setState(() {
  //             if (widget.controller!.value.isPlaying) {
  //               widget.controller!.pause();
  //             } else {
  //               widget.controller!.play();
  //             }
  //           });
  //         },
  //       ),
  //       const SizedBox(width: 12),
  //       _buildControlButton(
  //         icon: Icons.speed,
  //         label: 'السرعة',
  //         onTap: () => _showSpeedDialog(),
  //       ),
  //       const SizedBox(width: 12),
  //       _buildControlButton(
  //         icon: Icons.replay_10,
  //         label: 'إعادة 10 ثواني',
  //         onTap: () {
  //           final currentPosition = widget.controller!.value.position;
  //           final newPosition = currentPosition - const Duration(seconds: 10);
  //           widget.controller!.seekTo(
  //             newPosition > Duration.zero ? newPosition : Duration.zero,
  //           );
  //         },
  //       ),
  //       const Spacer(),
  //       _buildControlButton(
  //         icon: Icons.fullscreen,
  //         label: 'ملء الشاشة',
  //         onTap: () => widget.controller!.toggleFullScreenMode(),
  //       ),
  //     ],
  //   );
  // }
  //
  // Widget _buildControlButton({
  //   required IconData icon,
  //   required String label,
  //   required VoidCallback onTap,
  // }) {
  //   return InkWell(
  //     onTap: onTap,
  //     borderRadius: BorderRadius.circular(12),
  //     child: Container(
  //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  //       decoration: BoxDecoration(
  //         color: Theme.of(
  //           context,
  //         ).colorScheme.primaryContainer.withOpacity(0.5),
  //         borderRadius: BorderRadius.circular(12),
  //         border: Border.all(
  //           color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
  //         ),
  //       ),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
  //           const SizedBox(height: 4),
  //           Text(
  //             label,
  //             style: Theme.of(context).textTheme.bodySmall?.copyWith(
  //               color: Theme.of(context).colorScheme.primary,
  //               fontWeight: FontWeight.w500,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  //
  // void _showSpeedDialog() {
  //   final speeds = [
  //     {'label': '0.25x', 'value': 0.25},
  //     {'label': '0.5x', 'value': 0.5},
  //     {'label': '0.75x', 'value': 0.75},
  //     {'label': 'عادي', 'value': 1.0},
  //     {'label': '1.25x', 'value': 1.25},
  //     {'label': '1.5x', 'value': 1.5},
  //     {'label': '1.75x', 'value': 1.75},
  //     {'label': '2x', 'value': 2.0},
  //   ];
  //
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       backgroundColor: Theme.of(context).colorScheme.surface,
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  //       title: Row(
  //         children: [
  //           Icon(Icons.speed, color: Theme.of(context).colorScheme.primary),
  //           const SizedBox(width: 8),
  //           Text(
  //             'سرعة التشغيل',
  //             style: TextStyle(
  //               color: Theme.of(context).colorScheme.onSurface,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //         ],
  //       ),
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: speeds
  //             .map(
  //               (speed) => ListTile(
  //                 leading: Icon(
  //                   Icons.speed,
  //                   color: Theme.of(context).colorScheme.primary,
  //                   size: 20,
  //                 ),
  //                 title: Text(
  //                   speed['label'] as String,
  //                   style: TextStyle(
  //                     color: Theme.of(context).colorScheme.onSurface,
  //                   ),
  //                 ),
  //                 onTap: () {
  //                   Navigator.pop(context);
  //                   widget.controller!.setPlaybackRate(
  //                     speed['value'] as double,
  //                   );
  //                   _showSpeedChangeSnackBar(speed['label'] as String);
  //                 },
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(8),
  //                 ),
  //               ),
  //             )
  //             .toList(),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: Text(
  //             'إغلاق',
  //             style: TextStyle(color: Theme.of(context).colorScheme.primary),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void _showSpeedChangeSnackBar(String speed) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text('تم تغيير السرعة إلى $speed'),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.error.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.error.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'خطأ في تحميل الفيديو',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.onErrorContainer,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onErrorContainer,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'إعادة المحاولة',
                  icon: Icons.refresh,
                  onPressed: () {
                    setState(() {
                      _hasError = false;
                      _errorMessage = '';
                    });
                    widget.onRetry();
                  },
                  type: ButtonType.outlined,
                  height: 4.h,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildVideoPlayer();
  }
}
