import 'package:enterprise_platform/core/services/storage/auth-storage_service.dart';
import 'package:get/get.dart';

class StorageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthStorageService>(
      AuthStorageService(),
      permanent: true,
    );
  }
}