import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/storage/local_storage.dart';
import '../../../../core/storage/shared_preferences_storage.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../../core/widgets/common_button.dart';
import '../../../auth/presentation/bloc/login/login_bloc.dart';
import '../../../auth/presentation/bloc/otp/otp_bloc.dart';
import '../../../auth/domain/usecases/logout_use_case.dart';
import '../../../../core/utils/use_case.dart';


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
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
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
      appBar: AppBar(
        title: const Text(AppStrings.profileTab),
      ),
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
                  icon: const Icon(
                    Icons.logout_rounded,
                    color: Colors.white,
                  ),
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
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            color: AppColors.success,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 14),
        ),
      ],
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return Column(
      children: [
        Text(
          AppStrings.dummyUserName,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSizes.xs),
        FutureBuilder<String?>(
          future: sl<LocalStorage>().getString(StorageKeys.userMobile),
          builder: (context, snapshot) {
            final mobile = snapshot.data ?? '9876543210';
            return Text(
              '+91 $mobile',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
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
              label: 'Full Name',
              value: AppStrings.dummyUserName,
            ),
            const Divider(height: AppSizes.xl),
            _buildInfoRow(
              context,
              icon: Icons.phone_outlined,
              label: 'Mobile',
              value: '+91 9876543210',
            ),
            const Divider(height: AppSizes.xl),
            _buildInfoRow(
              context,
              icon: Icons.email_outlined,
              label: 'Email',
              value: 'john.doe@example.com',
            ),
            const Divider(height: AppSizes.xl),
            _buildInfoRow(
              context,
              icon: Icons.verified_outlined,
              label: 'Status',
              value: 'Verified',
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
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: AppSizes.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall,
              ),
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