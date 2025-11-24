import 'package:flutter/material.dart';
import 'package:math_corn/core/routing/navigation_manager.dart';
import 'package:math_corn/modules/courses/data/models/lecture.dart';
import 'package:math_corn/modules/library/ui/widgets/library_bookmark.dart';

class LectureAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Lecture lecture;
  final bool isInLibrary;
  final VoidCallback onBookmarkPressed;
  final VoidCallback onInfoPressed;

  const LectureAppBar({
    super.key,
    required this.lecture,
    required this.isInLibrary,
    required this.onBookmarkPressed,
    required this.onInfoPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        lecture.name,
        style: Theme.of(context).appBarTheme.titleTextStyle,
      ),
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
      elevation: Theme.of(context).appBarTheme.elevation,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () => context.pop(),
      ),
      actions: [
        LibraryBookmarkButton(
          isInLibrary: isInLibrary,
          onPressed: onBookmarkPressed,
        ),
        IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: onInfoPressed,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
