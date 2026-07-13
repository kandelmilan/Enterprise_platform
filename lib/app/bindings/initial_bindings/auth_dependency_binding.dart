import 'package:enterprise_platform/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:enterprise_platform/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:enterprise_platform/features/auth/domain/repositories/auth_repository.dart';
import 'package:enterprise_platform/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:enterprise_platform/features/auth/domain/usecases/get_me_usecase.dart';
import 'package:enterprise_platform/features/auth/domain/usecases/login_user_usecase.dart';
import 'package:enterprise_platform/features/auth/domain/usecases/refresh_token_usecase.dart';
import 'package:enterprise_platform/features/auth/presentation/controllers/auth_controller.dart';
import 'package:get/get.dart';

class AuthDependencyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(Get.find()),
      fenix: true,
    );

    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(Get.find()),
      fenix: true,
    );

    Get.lazyPut<LoginUserUsecase>(
      () => LoginUserUsecase(Get.find()),
      fenix: true,
    );

    Get.lazyPut<RefreshTokenUseCase>(
      () => RefreshTokenUseCase(Get.find()),
      fenix: true,
    );

    Get.lazyPut<GetMeUseCase>(() => GetMeUseCase(Get.find()), fenix: true);

    Get.lazyPut<ForgotPasswordUseCase>(
      () => ForgotPasswordUseCase(Get.find()),
      fenix: true,
    );

    Get.put<AuthController>(
      AuthController(Get.find(), Get.find(), Get.find(), Get.find()),
      permanent: true,
    );
  }
}
