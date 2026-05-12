import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/core/constants/app_routes.dart';
import 'package:clean_architecture/core/constants/app_sizes.dart';
import 'package:clean_architecture/core/constants/app_strings.dart';
import 'package:clean_architecture/core/constants/font_sizes.dart';
import 'package:clean_architecture/core/extensions/string_extensions.dart';
import 'package:clean_architecture/core/utils/responsive_helper.dart';
import 'package:clean_architecture/core/widgets/common_button.dart';
import 'package:clean_architecture/core/widgets/common_loader.dart';
import 'package:clean_architecture/core/widgets/common_snackbar.dart';
import 'package:clean_architecture/features/auth/presentation/bloc/otp/otp_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OtpScreen extends StatefulWidget {
  final String mobile;

  const OtpScreen({super.key, required this.mobile});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _onVerifyPressed() {
    final otp = _otpController.text.trim();
    if (otp.length == AppSizes.length6) {
      context.read<OtpBloc>().add(
        OtpSubmitted(mobile: widget.mobile, otp: otp),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OtpBloc, OtpState>(
      listener: (context, state) {
        if (state is OtpSuccess) {
          CommonSnackbar.showSuccess(context, AppStrings.otpSuccess);
          // Navigate to home, replacing the full auth stack
          context.goNamed(AppRoutes.home);
        } else if (state is OtpFailure) {
          CommonSnackbar.showError(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: AppColors.background,
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () => context.pop(),
                ),
              ),
              body: SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSizes.md),
                    child: ResponsiveWrapper(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: AppSizes.lg),
                          _buildHeader(),
                          const SizedBox(height: AppSizes.xxl),
                          _buildOtpField(state),
                          const SizedBox(height: AppSizes.md),
                          _buildHint(),
                          const SizedBox(height: AppSizes.xl),
                          _buildVerifyButton(state),
                          const SizedBox(height: AppSizes.xl),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (state is OtpLoading) const CommonLoader(),
          ],
        );
      },
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: AppSizes.size58,
          height: AppSizes.size58,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
          child: const Icon(
            Icons.lock_outline_rounded,
            color: AppColors.primary,
            size: AppSizes.size32,
          ),
        ),
        const SizedBox(height: AppSizes.lg),
        Text(
          AppStrings.otpTitle,
          style: Theme.of(
            context,
          ).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: AppSizes.sm),
        RichText(
          text: TextSpan(
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
            children: [
              const TextSpan(text: '${AppStrings.otpSubtitle} '),
              TextSpan(
                // Show masked mobile number
                text: '+91 ${widget.mobile.maskedMobile}',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOtpField(OtpState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.otpLabel,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: AppSizes.sm),
        TextFormField(
          controller: _otpController,
          keyboardType: TextInputType.number,
          maxLength: AppSizes.length6,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (value) {
            context.read<OtpBloc>().add(OtpChanged(value));
          },
          textAlign: TextAlign.center,
          buildCounter:
              (
                context, {
                required currentLength,
                required isFocused,
                maxLength,
              }) => null,
          style: const TextStyle(
            fontSize: FontSizes.font22,
            fontWeight: FontWeight.w700,
            letterSpacing: AppSizes.size8,
          ),
          decoration: const InputDecoration(
            hintText: '••••••',
            hintStyle: TextStyle(
              letterSpacing: AppSizes.size8,
              fontSize: FontSizes.font22,
            ),
            prefixIcon: Icon(Icons.lock_outline_rounded),
          ),
        ),
      ],
    );
  }

  Widget _buildHint() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.info.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.info,
            size: AppSizes.size18,
          ),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Text(
              AppStrings.otpDemoMsg,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.info,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerifyButton(OtpState state) {
    final isEnabled = _otpController.text.length == AppSizes.size18;
    return CommonButton(
      label: AppStrings.verifyButton,
      isEnabled: isEnabled,
      isLoading: state is OtpLoading,
      onPressed: _onVerifyPressed,
    );
  }
}
