import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/utils/assets_manager.dart';

class AuthHeaderWidget extends StatelessWidget {
  const AuthHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35.h,
      width: 100.w,
      child: Image.asset(
        AssetsManager.authHeader,
        fit: BoxFit.cover,
        width: 100.w,
        height: 35.h,
      ),
    );
  }
}
