import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/core/constants/app_routes.dart';
import 'package:clean_architecture/core/constants/app_sizes.dart';
import 'package:clean_architecture/core/constants/app_strings.dart';
import 'package:clean_architecture/core/constants/font_sizes.dart';
import 'package:clean_architecture/core/di/injection_container.dart';
import 'package:clean_architecture/core/storage/local_storage.dart';
import 'package:clean_architecture/core/storage/shared_preferences_storage.dart';
import 'package:clean_architecture/core/utils/responsive_helper.dart';
import 'package:clean_architecture/core/utils/use_case.dart';
import 'package:clean_architecture/core/widgets/common_button.dart';
import 'package:clean_architecture/features/auth/domain/usecases/logout_use_case.dart';
import 'package:clean_architecture/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:clean_architecture/features/auth/presentation/bloc/otp/otp_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(AppStrings.logoutConfirmTitle),
        content: const Text(AppStrings.logoutConfirmMessage),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(context, true),
            child: const Text(AppStrings.confirm),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    // Perform logout
    final logoutUseCase = sl<LogoutUseCase>();
    await logoutUseCase(const NoParams());

    if (!context.mounted) return;

    // Reset BLoCs
    context.read<LoginBloc>().add(const LoginReset());
    context.read<OtpBloc>().add(const OtpReset());

    // Navigate to login, clearing the stack
    context.goNamed(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.profileTab)),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.md),
          child: ResponsiveWrapper(
            child: Column(
              children: [
                const SizedBox(height: AppSizes.xl),
                _buildAvatar(),
                const SizedBox(height: AppSizes.xl),
                _buildProfileCard(context),
                const SizedBox(height: AppSizes.xl),
                _buildInfoSection(context),
                const SizedBox(height: AppSizes.xxl),
                CommonButton(
                  label: AppStrings.logoutButton,
                  onPressed: () => _logout(context),
                  icon: const Icon(Icons.logout_rounded, color: Colors.white),
                ),
                const SizedBox(height: AppSizes.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          width: AppSizes.avatarLg,
          height: AppSizes.avatarLg,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Center(
            child: Text(
              'JD',
              style: TextStyle(
                color: Colors.white,
                fontSize: FontSizes.font28,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(AppSizes.length4),
          decoration: const BoxDecoration(
            color: AppColors.success,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check,
            color: Colors.white,
            size: AppSizes.size14,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return Column(
      children: [
        Text(
          AppStrings.dummyUserName,
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSizes.xs),
        FutureBuilder<String?>(
          future: sl<LocalStorage>().getString(StorageKeys.userMobile),
          builder: (context, snapshot) {
            final mobile = snapshot.data ?? '9876543210';
            return Text(
              '+91 $mobile',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
            );
          },
        ),
      ],
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          children: [
            _buildInfoRow(
              context,
              icon: Icons.person_outline_rounded,
              label: AppStrings.fullName,
              value: AppStrings.dummyUserName,
            ),
            const Divider(height: AppSizes.xl),
            _buildInfoRow(
              context,
              icon: Icons.phone_outlined,
              label: AppStrings.mobile,
              value: AppStrings.tempNumber,
            ),
            const Divider(height: AppSizes.xl),
            _buildInfoRow(
              context,
              icon: Icons.email_outlined,
              label: AppStrings.email,
              value: AppStrings.tempEmail,
            ),
            const Divider(height: AppSizes.xl),
            _buildInfoRow(
              context,
              icon: Icons.verified_outlined,
              label: AppStrings.status,
              value: AppStrings.verified,
              valueColor: AppColors.success,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Container(
          width: AppSizes.size40,
          height: AppSizes.size40,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          ),
          child: Icon(icon, color: AppColors.primary, size: AppSizes.size20),
        ),
        const SizedBox(width: AppSizes.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodySmall),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: valueColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
