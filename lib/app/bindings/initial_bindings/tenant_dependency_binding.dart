import 'package:enterprise_platform/features/tenant/presentation/controllers/tenant_controller.dart';
import 'package:get/get.dart';

import '../../../features/tenant/data/datasources/tenant_remote_data_source.dart';
import '../../../features/tenant/data/repositories/tenant_repository_impl.dart';

import '../../../features/tenant/domain/repositories/tenant_repository.dart';
import '../../../features/tenant/domain/usecases/get_tenants_usecase.dart';

class TenantDependencyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TenantRemoteDataSource>(
      () => TenantRemoteDataSourceImpl(Get.find()),
      fenix: true,
    );

    Get.lazyPut<TenantRepository>(
      () => TenantRepositoryImpl(Get.find()),
      fenix: true,
    );

    Get.lazyPut<GetTenantsUseCase>(
      () => GetTenantsUseCase(Get.find()),
      fenix: true,
    );
    Get.lazyPut<TenantController>(
      () => TenantController(Get.find()),
      fenix: true,
    );
  }
}
