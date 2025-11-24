part of 'settings_cubit.dart';

enum SettingsStatus {
  initial,
  changLanguageLoading,
  changBrightnessLoading,
  changeLanguageSuccess,
  changeBrightnessSuccess,
}

extension StatusEx on SettingsState {
  bool get isInitial => status == SettingsStatus.initial;

  bool get isLoading => status == SettingsStatus.changLanguageLoading;

  bool get isChangeLanguageSuccess =>
      status == SettingsStatus.changeLanguageSuccess;

  bool get isChangeBrightnessSuccess =>
      status == SettingsStatus.changeBrightnessSuccess;

  bool get isChangeBrightnessLoading =>
      status == SettingsStatus.changBrightnessLoading;
}

class SettingsState extends Equatable {
  final SettingsStatus status;
  final String languageCode;
  final bool isDark;

  const SettingsState({
    required this.isDark,
    required this.languageCode,
    this.status = SettingsStatus.initial,
  });

  SettingsState copyWith({
    SettingsStatus? status,
    String? languageCode,
    bool? isDark,
  }) {
    return SettingsState(
      status: status ?? this.status,
      isDark: isDark ?? this.isDark,
      languageCode: languageCode ?? this.languageCode,
    );
  }

  @override
  List<Object?> get props => [isDark, languageCode, status];
}
