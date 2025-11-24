import 'package:get_it/get_it.dart';
import 'package:math_corn/modules/auth/data/services/auth_services.dart';
import 'package:math_corn/modules/courses/cubit/courses_cubit.dart';
import 'package:math_corn/modules/courses/data/reposiory/courses_repository.dart';
import 'package:math_corn/modules/courses/data/serives/courses_services.dart';
import 'package:math_corn/modules/exams/cubit/exam_cubit.dart';
import 'package:math_corn/modules/exams/data/repository/exam_repository.dart';
import 'package:math_corn/modules/exams/data/services/exam_services.dart';
import 'package:math_corn/modules/library/cubit/library_cubit.dart';
import 'package:math_corn/modules/notifications/cubit/notifications_cubit.dart';
import 'package:math_corn/modules/notifications/data/repositories/notification_repository.dart';
import 'package:math_corn/modules/notifications/data/services/notification_services.dart';
import 'package:math_corn/modules/payment/cubit/payment_cubit.dart';
import 'package:math_corn/modules/payment/data/repository/payment_repository.dart';
import 'package:math_corn/modules/payment/data/services/payment_services.dart';
import 'package:math_corn/modules/settings/cubit/settings_cubit.dart';
import 'package:math_corn/modules/student/cubit/student_cubit.dart';
import 'package:math_corn/modules/student/data/repository/student_repository.dart';
import 'package:math_corn/modules/student/data/services/student_services.dart';

import '../../modules/auth/cubit/auth_cubit.dart' show AuthCubit;
import '../../modules/auth/data/repositories/auth_repository.dart';

final sl = GetIt.instance;

class ServiceLocator {
  static void init() {
    _initializeRemoteServices();
    _initializeLocalServices();
    _initializeRepositories();
    _initializeBlocs();
  }

  static void _initializeRemoteServices() {
    sl.registerLazySingleton(() => AuthServices());
    sl.registerLazySingleton(() => StudentServices());
    sl.registerLazySingleton(() => CoursesServices());
    sl.registerLazySingleton(() => PaymentServices());
    sl.registerLazySingleton(() => NotificationServices());
    sl.registerLazySingleton(() => ExamServices());
  }

  static void _initializeLocalServices() {}

  static void _initializeRepositories() {
    sl.registerLazySingleton(() => AuthRepository(sl()));
    sl.registerLazySingleton(() => StudentRepository(sl()));
    sl.registerLazySingleton(() => CoursesRepository(sl()));
    sl.registerLazySingleton(() => PaymentRepository(sl()));
    sl.registerLazySingleton(() => NotificationRepository(sl()));
    sl.registerLazySingleton(() => ExamRepository(sl()));
  }

  static void _initializeBlocs() {
    sl.registerCachedFactory(() => AuthCubit(sl()));
    sl.registerCachedFactory(() => StudentCubit(sl()));
    sl.registerCachedFactory(() => CoursesCubit(sl()));
    sl.registerFactory(() => SettingsCubit());
    sl.registerCachedFactory(() => LibraryCubit());
    sl.registerCachedFactory(() => PaymentCubit(repository: sl()));
    sl.registerCachedFactory(() => NotificationsCubit(sl()));
    sl.registerFactory(() => ExamCubit(sl()));
  }
}
