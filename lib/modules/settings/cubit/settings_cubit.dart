import "package:equatable/equatable.dart";
import "package:hydrated_bloc/hydrated_bloc.dart";
import "package:math_corn/core/error/exception_manager.dart";
import "package:math_corn/core/services/localization_manager.dart";
import "package:math_corn/core/utils/theme_manager.dart";

part "settings_state.dart";

class SettingsCubit extends HydratedCubit<SettingsState> {
  SettingsCubit()
    : super(
        SettingsState(
          languageCode: LocalizationManager.getCurrentLocale().languageCode,
          isDark: AppTheme.isDark,
          status: SettingsStatus.initial,
        ),
      );

  Future<void> changeLanguage(String languageCode) async {
    try {
      await LocalizationManager.changeLanguage(languageCode);
      emit(
        state.copyWith(
          languageCode: languageCode,
          status: SettingsStatus.changeLanguageSuccess,
        ),
      );
    } on Exception catch (e) {
      ExceptionManager.showMessage(e);
    }
  }

  Future<void> changeTheme(bool isDark) async {
    try {
      AppTheme.changeTheme(isDark);
      emit(
        state.copyWith(
          isDark: isDark,
          status: SettingsStatus.changeBrightnessSuccess,
        ),
      );
    } on Exception catch (e) {
      ExceptionManager.showMessage(e);
    }
  }

  void resetStatus() {
    emit(state.copyWith(status: SettingsStatus.initial));
  }

  @override
  SettingsState? fromJson(Map<String, dynamic> json) {
    try {
      String languageCode = json['languageCode'] ?? 'ar';
      bool isDark = json['theme'].toString() == "dark";

      AppTheme.changeTheme(isDark);

      return SettingsState(
        languageCode: languageCode,
        isDark: isDark,
        status: SettingsStatus.initial,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(SettingsState state) {
    return {
      "languageCode": state.languageCode,
      "theme": state.isDark ? "dark" : "light",
    };
  }
}
