import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_corn/core/widgets/connectivity_widget.dart';
import 'package:math_corn/generated/l10n.dart';
import 'package:math_corn/modules/courses/cubit/courses_cubit.dart';
import 'package:math_corn/modules/courses/ui/widgets/couse_card.dart';
import 'package:math_corn/modules/student/cubit/student_cubit.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/widgets/core_widgets.dart';

enum CourseFilter { all, enrolled }

class CoursesList extends StatefulWidget {
  const CoursesList({super.key});

  @override
  State<CoursesList> createState() => _CoursesListState();
}

class _CoursesListState extends State<CoursesList> {
  CourseFilter _currentFilter = CourseFilter.all;

  @override
  Widget build(BuildContext context) {
    final coursesCubit = context.read<CoursesCubit>();
    return ConnectionWidget(
      onRetry: () {
        if (context.read<StudentCubit>().state.student == null) {
          context.read<StudentCubit>().getProfile();
        } else {
          String grade = context.read<StudentCubit>().state.student!.grade!.id;
          context.read<CoursesCubit>().getCourses(grade: grade);
        }
      },
      child: Column(
        children: [
          _buildFilterChips(),
          SizedBox(height: 1.h),
          Expanded(
            child: BlocBuilder<CoursesCubit, CoursesState>(
              bloc: coursesCubit,
              builder: (context, state) {
                if (state.isLoading || state.isInitial) {
                  return _buildLoading();
                } else if (state.isFailure) {
                  return _buildError(state.exception!);
                } else if (state.isSuccess && state.courses!.isNotEmpty) {
                  return _buildCoursesList(state);
                } else {
                  return _buildNoCoursesFound();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            width: 1,
          ),
          color: Colors.grey.withOpacity(0.1),
        ),
        padding: EdgeInsets.all(4),
        child: Row(
          children: [
            _buildFilterOption(
              label: S.of(context).allCourses,
              filter: CourseFilter.all,
              icon: Icons.library_books,
            ),
            _buildFilterOption(
              label: S.of(context).onGoing,
              filter: CourseFilter.enrolled,
              icon: Icons.school,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption({
    required String label,
    required CourseFilter filter,
    required IconData icon,
  }) {
    final isSelected = _currentFilter == filter;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentFilter = filter;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 2.w),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                child: Icon(
                  icon,
                  key: ValueKey(isSelected),
                  size: 18,
                  color: isSelected ? Colors.white : Colors.grey,
                ),
              ),
              SizedBox(width: 1.w),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 150),
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 14,
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoursesList(CoursesState state) {
    final filteredCourses = _getFilteredCourses(state.courses!);

    if (filteredCourses.isEmpty && _currentFilter == CourseFilter.enrolled) {
      return _buildNoEnrolledCoursesFound();
    }

    return BlocBuilder<StudentCubit, StudentState>(
      builder: (context, studentState) {
        return ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: filteredCourses.length,
          itemBuilder: (context, index) {
            final course = filteredCourses[index];
            return CourseCard(
              course: course,
              student: studentState.student,
              onAddToCartPressed: () => _handleCartAction(context, course),
            );
          },
        );
      },
    );
  }

  void _handleCartAction(BuildContext context, dynamic course) {
    final student = context.read<StudentCubit>().state.student;
    if (student == null) return;

    final isInCart = student.cart?.contains(course.id) ?? false;

    if (isInCart) {
      // حذف من السلة
      context.read<StudentCubit>().removeCourseFromCart(course.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).courseRemovedFromCart),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } else {
      // إضافة للسلة
      context.read<StudentCubit>().addCourseToCart(course.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).courseAddedToCart),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
    }
  }

  List<dynamic> _getFilteredCourses(List<dynamic> courses) {
    if (_currentFilter == CourseFilter.all) {
      return courses;
    }

    final studentState = context.read<StudentCubit>().state;
    if (studentState.student == null) {
      return [];
    }

    return courses.where((course) {
      return studentState.student?.isEnrolled(course.id) ?? false;
    }).toList();
  }

  Widget _buildNoEnrolledCoursesFound() {
    return Center(
      child: SizedBox(
        height: 30.h,
        width: 80.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school_outlined, size: 64, color: Colors.grey[400]),
            SizedBox(height: 2.h),
            Text(
              S.of(context).noEnrolledCoursesDescription,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              S.of(context).browseCourses,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _currentFilter = CourseFilter.all;
                });
              },
              icon: const Icon(Icons.explore),
              label: Text(S.of(context).allCourses),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoCoursesFound() {
    return Center(
      child: SizedBox(height: 20.h, width: 80.w, child: NoDataWidget()),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: SizedBox(height: 20.h, width: 80.w, child: CustomLoadingWidget()),
    );
  }

  Widget _buildError(Exception exception) {
    return Center(
      child: SizedBox(
        height: 20.h,
        width: 80.w,
        child: CustomErrorWidget(exception: exception),
      ),
    );
  }
}
