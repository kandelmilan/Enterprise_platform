import 'package:enterprise_platform/features/dashboard/presentation/controllers/main_nav_controller.dart';
import 'package:get/get.dart';

class MainNavBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainNavController>(() => MainNavController());
  }
}
