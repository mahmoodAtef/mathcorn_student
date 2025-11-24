import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:math_corn/core/utils/assets_manager.dart';
import 'package:math_corn/generated/l10n.dart';
import 'package:sizer/sizer.dart';

class LibraryHeader extends StatelessWidget {
  const LibraryHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 35.h,
      collapsedHeight: 0,
      toolbarHeight: 0,
      pinned: false,
      floating: true,
      snap: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: _buildHeaderWithNotification(context),
        collapseMode: CollapseMode.parallax,
      ),
    );
  }

  Widget _buildHeaderWithNotification(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 35.h,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(AssetsManager.library, fit: BoxFit.fill),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Center(
              child: Text(
                S.of(context).library,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 20.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
