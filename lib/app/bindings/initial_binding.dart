import 'package:enterprise_platform/core/api/api_config.dart';
import 'package:enterprise_platform/core/storage/secure_storage_service.dart';
import 'package:get/get.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ApiConfig>(ApiConfig(), permanent: true);

    Get.put<SecureStorageService>(SecureStorageService(), permanent: true);
  }
}
