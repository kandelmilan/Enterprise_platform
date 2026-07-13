
import 'package:enterprise_platform/app/app.dart';
import 'package:enterprise_platform/features/auth/auth.dart';
import 'package:enterprise_platform/features/dashboard/dashboard.dart';
import 'package:enterprise_platform/features/home/home_view.dart';
import 'package:enterprise_platform/features/onboarding/onboarding.dart';
import 'package:enterprise_platform/features/splash/splash.dart';
import 'package:get/get.dart';

class AppPages {
  AppPages._();

  static final pages = <GetPage>[
    GetPage(name: AppRoutes.login, page: () => LoginView()),
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(name: AppRoutes.home, page: () => const HomeView()),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(name: AppRoutes.forgotPassword, page: () => ForgotPasswordView()),

    GetPage(name: AppRoutes.profile, page: () => ProfilePage()),

    GetPage(
      name: AppRoutes.mainNav,
      page: () => MainNavView(),
      binding: MainNavBinding(),
    ),
  ];
}
