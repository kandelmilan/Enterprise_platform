import 'package:enterprise_platform/core/services/api/api_config.dart';
import 'package:enterprise_platform/core/services/api/api_service.dart';
import 'package:get/get.dart';

class ApiBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ApiConfig>(ApiConfig(), permanent: true);
    Get.put<ApiService>(ApiService(Get.find<ApiConfig>().dio), permanent: true);
  }
}
