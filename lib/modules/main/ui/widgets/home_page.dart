import 'package:flutter/material.dart';
import 'package:math_corn/generated/l10n.dart';
import 'package:math_corn/modules/courses/ui/widgets/courses_list.dart';
import 'package:math_corn/modules/main/ui/widgets/home_app_bar.dart';
import 'package:sizer/sizer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const HomeAppBar(),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
            child: Text(
              S.of(context).courses,
              style: Theme.of(
                context,
              ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: true,
          fillOverscroll: true,
          child: const CoursesList(),
        ),
      ],
    );
  }
}
