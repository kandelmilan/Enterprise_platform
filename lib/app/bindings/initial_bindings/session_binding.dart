import 'package:enterprise_platform/core/core.dart';
import 'package:get/get.dart';

class SessionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InactivityService>(
      () => InactivityService(
        Get.find<AuthStorageService>(),
        // timeout: const Duration(seconds: 15),
      ),
    );

    Get.put<AutoLogoutHandler>(
      AutoLogoutHandler(Get.find<AuthStorageService>()),
      permanent: true,
    );
  }
}
