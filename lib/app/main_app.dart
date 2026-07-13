import 'package:enterprise_platform/core/core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'bindings/initial_binding.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with WidgetsBindingObserver {
  late final InactivityService _inactivityService;
  late final AutoLogoutHandler _logoutHandler;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _inactivityService = Get.find<InactivityService>();
    _logoutHandler = Get.find<AutoLogoutHandler>();

    // Register timeout callback.
    // The timer will be started after a successful login.
    _inactivityService.onTimeout = _logoutHandler.handleTimeout;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _inactivityService.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _inactivityService.resumeTimer();
        break;

      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        _inactivityService.pauseTimer();
        break;

      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        break;
    }
  }

  void _onUserInteraction() {
    _inactivityService.resetTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _onUserInteraction(),
      onPointerMove: (_) => _onUserInteraction(),
      onPointerUp: (_) => _onUserInteraction(),
      child: GetMaterialApp(
        title: 'Enterprise Platform',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        initialBinding: InitialBinding(),
        initialRoute: AppRoutes.splash,
        getPages: AppPages.pages,
      ),
    );
  }
}





// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import 'bindings/initial_binding.dart';
// import 'routes/app_pages.dart';
// import 'routes/app_routes.dart';
// import 'theme/app_theme.dart';F
// class MainApp extends StatelessWidget {
//   const MainApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       title: 'Enterprise Platform',
//       debugShowCheckedModeBanner: false,

//       theme: AppTheme.light,

//       initialBinding: InitialBinding(),
//       initialRoute: AppRoutes.splash,
//       getPages: AppPages.pages,
//     );
//   }
// }