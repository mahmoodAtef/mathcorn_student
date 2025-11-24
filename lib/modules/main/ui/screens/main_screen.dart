import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_corn/core/routing/navigation_manager.dart';
import 'package:math_corn/core/services/dep_injection.dart';
import 'package:math_corn/generated/l10n.dart';
import 'package:math_corn/modules/courses/cubit/courses_cubit.dart';
import 'package:math_corn/modules/library/ui/widgets/library_page.dart';
import 'package:math_corn/modules/main/ui/widgets/home_page.dart';
import 'package:math_corn/modules/notifications/ui/screens/notifications_screens.dart';
import 'package:math_corn/modules/payment/ui/widgets/cart_page.dart';
import 'package:math_corn/modules/settings/ui/settings_page.dart';
import 'package:math_corn/modules/student/cubit/student_cubit.dart';
import 'package:math_corn/modules/student/ui/screens/profile_screen.dart';

int _currentIndex = 0; // TODO : handle this later

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late StudentCubit studentCubit;
  late CoursesCubit coursesCubit;

  @override
  void initState() {
    studentCubit = sl<StudentCubit>();
    studentCubit.getProfile();
    coursesCubit = sl<CoursesCubit>();
    super.initState();
  }

  @override
  void dispose() {
    _currentIndex = 0;
    studentCubit.close();
    coursesCubit.close();
    super.dispose();
  }

  final List<Widget> _pages = const [
    HomePage(),
    LibraryPage(),
    CartPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final List<BottomNavigationBarItem> bottomItems = [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: S.of(context).home,
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.book),
        label: S.of(context).library,
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.shopping_cart),
        label: S.of(context).cart,
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        label: S.of(context).settings,
      ),
    ];
    List<String> appBarTitles = [
      S.of(context).home,
      S.of(context).library,
      S.of(context).cart,
      S.of(context).settings,
    ];
    return BlocListener<StudentCubit, StudentState>(
      bloc: studentCubit,
      listenWhen: (previous, current) =>
          current.student != null || previous.student != null,
      listener: (context, state) {
        if (state.student != null) {
          coursesCubit.getCourses(grade: state.student!.gradeId);
        }
      },
      child: BlocProvider(
        lazy: true,
        create: (context) => coursesCubit,
        child: Scaffold(
          appBar: AppBar(
            title: Text(appBarTitles[_currentIndex]),
            leading: IconButton(
              onPressed: () {
                context.push(const ProfileScreen());
              },
              icon: const Icon(Icons.person),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  context.push(const NotificationsScreen());
                },
                icon: const Icon(Icons.notifications),
              ),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: bottomItems,
            currentIndex: _currentIndex,
            onTap: (index) => setState(() {
              _currentIndex = index;
            }),
          ),
          body: IndexedStack(index: _currentIndex, children: _pages),
        ),
      ),
    );
  }
}
