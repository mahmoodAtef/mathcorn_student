import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_corn/core/extentions/string_direction_extention.dart';
import 'package:math_corn/core/routing/navigation_manager.dart';
import 'package:math_corn/core/services/dep_injection.dart';
import 'package:math_corn/core/utils/constants_manager.dart';
import 'package:math_corn/core/utils/theme_manager.dart';
import 'package:math_corn/core/widgets/core_widgets.dart';
import 'package:math_corn/generated/l10n.dart';
import 'package:math_corn/modules/auth/cubit/auth_cubit.dart';
import 'package:math_corn/modules/auth/ui/screens/login_screen.dart';
import 'package:math_corn/modules/settings/cubit/settings_cubit.dart';
import 'package:math_corn/modules/student/ui/screens/profile_screen.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  // Methods for launching external apps
  Future<void> _launchWhatsApp() async {
    final Uri whatsappUri = Uri.parse(ConstantsManager.whatsAppUrl);
    await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
  }

  Future<void> _launchEmail() async {
    final Uri emailUri = Uri.parse(ConstantsManager.emailUrl);
    await launchUrl(emailUri);
  }

  Future<void> _launchPhone() async {
    final Uri phoneUri = Uri.parse(ConstantsManager.phoneNumber);
    await launchUrl(phoneUri);
  }

  Future<void> _launchPrivacyPolicy() async {
    final Uri privacyUri = Uri.parse(ConstantsManager.privacyPolicyUrl);
    await launchUrl(privacyUri, mode: LaunchMode.inAppWebView);
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'اختر اللغة / Choose Language',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('العربية'),
                onTap: () {
                  context.read<SettingsCubit>().changeLanguage('ar');
                  context.pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('English'),
                onTap: () {
                  context.read<SettingsCubit>().changeLanguage('en');
                  context.pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            S.of(context).logout,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: Text(S.of(context).logoutConfirmation),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: Text(S.of(context).cancel),
            ),
            BlocProvider<AuthCubit>(
              create: (context) => sl(),
              child: BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state.status == AuthStatus.authenticated) {
                    context.pop();
                    context.pushAndRemove(LoginScreen());
                  }
                },
                builder: (context, state) {
                  if (state.status == AuthStatus.loading) {
                    return CustomLoadingWidget();
                  }
                  return ElevatedButton(
                    onPressed: () {
                      context.read<AuthCubit>().logout();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.errorColor,
                    ),
                    child: Text(S.of(context).logout),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // Contact Section
              _buildSectionTitle(context, S.of(context).contact),
              SizedBox(height: 2.h),
              _buildContactSection(context),

              SizedBox(height: 4.h),

              // App Settings Section
              _buildSectionTitle(context, S.of(context).appSettings),
              SizedBox(height: 2.h),
              _buildAppSettingsSection(context, state),

              SizedBox(height: 4.h),

              // Account Section
              _buildSectionTitle(context, S.of(context).account),
              SizedBox(height: 2.h),
              _buildAccountSection(context),

              SizedBox(height: 4.h),

              // Legal Section
              _buildSectionTitle(context, S.of(context).legal),
              SizedBox(height: 2.h),
              _buildLegalSection(context),

              SizedBox(height: 6.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      textDirection: title.getDirection,
      textAlign: TextAlign.start,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: AppTheme.primaryGreen,
      ),
    );
  }

  Widget _buildContactSection(BuildContext context) {
    return Card(
      child: Column(
        children: [
          _buildSettingsItem(
            context,
            icon: Icons.phone,
            title: S.of(context).phone,
            subtitle: ConstantsManager.phoneNumber,
            onTap: _launchPhone,
          ),
          const Divider(height: 1),
          _buildSettingsItem(
            context,
            icon: Icons.email,
            title: S.of(context).email,
            subtitle: ConstantsManager.email,
            onTap: _launchEmail,
          ),
          const Divider(height: 1),
          _buildSettingsItem(
            context,
            icon: Icons.chat,
            title: S.of(context).whatsapp,
            subtitle: S.of(context).whatsappDescription,
            onTap: _launchWhatsApp,
            iconColor: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildAppSettingsSection(BuildContext context, SettingsState state) {
    return Card(
      child: Column(
        children: [
          _buildSettingsItem(
            context,
            icon: Icons.language,

            title: S.of(context).language,
            subtitle: state.languageCode == 'ar' ? 'العربية' : 'English',
            onTap: () => _showLanguageDialog(context),
            trailing: state.isLoading
                ? SizedBox(
                    width: 4.w,
                    height: 4.w,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.arrow_forward_ios),
          ),
          const Divider(height: 1),
          _buildSettingsItem(
            context,
            icon: state.isDark ? Icons.light_mode : Icons.dark_mode,
            title: S.of(context).theme,
            subtitle: state.isDark ? S.of(context).dark : S.of(context).light,
            trailing: state.isChangeBrightnessLoading
                ? SizedBox(
                    width: 4.w,
                    height: 4.w,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  )
                : Switch(
                    value: state.isDark,
                    onChanged: (value) {
                      context.read<SettingsCubit>().changeTheme(value);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    return Card(
      child: Column(
        children: [
          _buildSettingsItem(
            context,
            icon: Icons.person,
            title: S.of(context).profile,
            subtitle: S.of(context).profileDescription,
            onTap: () {
              context.push(ProfileScreen());
            },
          ),
          const Divider(height: 1),
          _buildSettingsItem(
            context,
            icon: Icons.logout,
            title: S.of(context).logout,
            subtitle: S.of(context).logoutDescription,
            onTap: () => _showLogoutDialog(context),
            iconColor: AppTheme.errorColor,
            titleColor: AppTheme.errorColor,
          ),
        ],
      ),
    );
  }

  Widget _buildLegalSection(BuildContext context) {
    return Card(
      child: Column(
        children: [
          _buildSettingsItem(
            context,
            icon: Icons.privacy_tip,
            title: S.of(context).privacyPolicy,
            subtitle: S.of(context).privacyPolicyDescription,
            onTap: _launchPrivacyPolicy,
          ),
          const Divider(height: 1),
          _buildSettingsItem(
            context,
            icon: Icons.info,
            title: S.of(context).about,
            subtitle:
                '${ConstantsManager.appName} ${ConstantsManager.packageInfo?.version}',
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: ConstantsManager.appName,
                applicationVersion: ConstantsManager.packageInfo?.version,
                applicationIcon: Icon(
                  Icons.calculate,
                  size: 8.w,
                  color: AppTheme.primaryGreen,
                ),
                children: [
                  Text(
                    S.of(context).aboutDescription,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    Widget? trailing,
    Color? iconColor,
    Color? titleColor,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      leading: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: (iconColor ?? AppTheme.primaryGreen).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor ?? AppTheme.primaryGreen, size: 6.w),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: titleColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}
