import 'package:flutter/material.dart';
import 'package:math_corn/generated/l10n.dart';

class LibraryBookmarkButton extends StatelessWidget {
  final bool isInLibrary;
  final VoidCallback onPressed;

  const LibraryBookmarkButton({
    super.key,
    required this.isInLibrary,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 4),
      decoration: BoxDecoration(
        color: isInLibrary
            ? Theme.of(context).colorScheme.primaryContainer
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(
          isInLibrary ? Icons.bookmark : Icons.bookmark_border,
          color: isInLibrary ? Theme.of(context).colorScheme.primary : null,
        ),
        onPressed: onPressed,
        tooltip: isInLibrary
            ? S.of(context).removeFromLibrary
            : S.of(context).addToLibrary,
      ),
    );
  }
}
