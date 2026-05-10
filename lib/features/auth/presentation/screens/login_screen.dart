import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/core/constants/app_routes.dart';
import 'package:clean_architecture/core/constants/app_sizes.dart';
import 'package:clean_architecture/core/constants/app_strings.dart';
import 'package:clean_architecture/core/utils/responsive_helper.dart';
import 'package:clean_architecture/core/widgets/common_button.dart';
import 'package:clean_architecture/core/widgets/common_loader.dart';
import 'package:clean_architecture/core/widgets/common_snackbar.dart';
import 'package:clean_architecture/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();

  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      context
          .read<LoginBloc>()
          .add(LoginSubmitted(_mobileController.text.trim()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          // Navigate to OTP screen, passing mobile as query param
          context.goNamed(
            AppRoutes.otp,
            queryParameters: {AppRoutes.mobileParam: state.sentToMobile},
          );
        } else if (state is LoginFailure) {
          CommonSnackbar.showError(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: AppColors.background,
              body: SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSizes.md),
                    child: ResponsiveWrapper(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: AppSizes.xxl),
                            _buildHeader(),
                            const SizedBox(height: AppSizes.xxxl),
                            _buildMobileField(state),
                            const SizedBox(height: AppSizes.xl),
                            _buildLoginButton(state),
                            const SizedBox(height: AppSizes.xl),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (state is LoginLoading) const CommonLoader(),
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
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
          child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 32),
        ),
        const SizedBox(height: AppSizes.lg),
        Text(
          AppStrings.loginTitle,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSizes.sm),
        Text(
          AppStrings.loginSubtitle,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildMobileField(LoginState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.mobileNumberLabel,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: AppSizes.sm),
        TextFormField(
          controller: _mobileController,
          keyboardType: TextInputType.phone,
          maxLength: 10,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (value) {
            context.read<LoginBloc>().add(LoginMobileChanged(value));
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppStrings.mobileRequired;
            }
            if (!RegExp(r'^\d+$').hasMatch(value)) {
              return AppStrings.mobileDigitsOnly;
            }
            if (value.length != 10) {
              return AppStrings.mobileTenDigits;
            }
            return null;
          },
          buildCounter: (context,
              {required currentLength,
                required isFocused,
                maxLength}) =>
          null,
          decoration: InputDecoration(
            hintText: AppStrings.mobileNumberHint,
            prefixIcon: const Icon(Icons.phone_outlined),
            prefixText: '+91  ',
            prefixStyle: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(LoginState state) {
    final isValid = state.isValid;
    return CommonButton(
      label: AppStrings.loginButton,
      isEnabled: isValid,
      isLoading: state is LoginLoading,
      onPressed: _onLoginPressed,
      icon: isValid
          ? const Icon(Icons.arrow_forward_rounded, color: Colors.white)
          : null,
    );
  }
}