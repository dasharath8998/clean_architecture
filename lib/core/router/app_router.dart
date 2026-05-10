import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_routes.dart';
import '../di/injection_container.dart';
import '../storage/local_storage.dart';
import '../storage/shared_preferences_storage.dart';

import 'package:clean_architecture/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:clean_architecture/features/auth/presentation/bloc/otp/otp_bloc.dart';
import 'package:clean_architecture/features/home/presentation/bloc/home_bloc.dart';

import 'package:clean_architecture/features/splash/presentation/screens/splash_screen.dart';
import 'package:clean_architecture/features/auth/presentation/screens/login_screen.dart';
import 'package:clean_architecture/features/auth/presentation/screens/otp_screen.dart';
import 'package:clean_architecture/features/home/presentation/screens/home_screen.dart';








class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splashPath,
    debugLogDiagnostics: true,
    redirect: _routeGuard,
    routes: [
      // ── Splash ──────────────────────────────────────────────────────────
      GoRoute(
        name: AppRoutes.splash,
        path: AppRoutes.splashPath,
        builder: (context, state) => const SplashScreen(),
      ),

      // ── Login ────────────────────────────────────────────────────────────
      GoRoute(
        name: AppRoutes.login,
        path: AppRoutes.loginPath,
        builder: (context, state) => BlocProvider(
          create: (_) => sl<LoginBloc>(),
          child: const LoginScreen(),
        ),
      ),

      // ── OTP ─────────────────────────────────────────────────────────────
      // Query param: ?mobile=9876543210
      GoRoute(
        name: AppRoutes.otp,
        path: AppRoutes.otpPath,
        builder: (context, state) {
          // Read mobile number from query parameters
          final mobile =
              state.uri.queryParameters[AppRoutes.mobileParam] ?? '';
          return BlocProvider(
            create: (_) => sl<OtpBloc>(),
            child: OtpScreen(mobile: mobile),
          );
        },
      ),

      // ── Home (with nested bottom tabs) ───────────────────────────────────
      GoRoute(
        name: AppRoutes.home,
        path: AppRoutes.homePath,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<HomeBloc>()),
            // LoginBloc and OtpBloc kept alive for logout reset
            BlocProvider(create: (_) => sl<LoginBloc>()),
            BlocProvider(create: (_) => sl<OtpBloc>()),
          ],
          child: const HomeScreen(),
        ),
      ),
    ],

    // 404 error page
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              state.uri.toString(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.goNamed(AppRoutes.login),
              child: const Text('Go to Login'),
            ),
          ],
        ),
      ),
    ),
  );

  
  static Future<String?> _routeGuard(
      BuildContext context,
      GoRouterState state,
      ) async {
    // Public routes that do not require authentication
    final publicRoutes = {
      AppRoutes.splashPath,
      AppRoutes.loginPath,
      AppRoutes.otpPath,
    };

    final currentPath = state.uri.path;
    final isPublic = publicRoutes.contains(currentPath);

    // Check persisted login state
    final storage = sl<LocalStorage>();
    final isLoggedIn = (await storage.getBool(StorageKeys.isLoggedIn)) ?? false;

    // If navigating to a protected route without being logged in → login
    if (!isPublic && !isLoggedIn) {
      return AppRoutes.loginPath;
    }

    // If already logged in and trying to access auth screens → home
    if (isLoggedIn &&
        (currentPath == AppRoutes.loginPath ||
            currentPath == AppRoutes.otpPath)) {
      return AppRoutes.homePath;
    }

    // No redirect needed
    return null;
  }
}