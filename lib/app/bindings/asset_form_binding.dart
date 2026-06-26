import 'package:dio/dio.dart';
import 'package:get/get.dart';

// --- Imports das Camadas de Dados e Domínio ---
import '../../features/assets/data/repositories/asset_repository_impl.dart';
import '../../features/assets/domain/repositories/i_asset_repository.dart';

// --- Import da Controller do Formulário ---
import '../../features/assets/presentation/controllers/asset_form_controller.dart';

class AssetFormBinding extends Bindings {
  @override
  void dependencies() {
    // 1. Garante que o Repositório está disponível para o Formulário
    Get.lazyPut<IAssetRepository>(
          () => AssetRepositoryImpl(Get.find<Dio>()),
    );

    // 2. Injeta a Controller do Formulário, passando o Repositório
    Get.lazyPut<AssetFormController>(
          () => AssetFormController(Get.find<IAssetRepository>()),
    );
  }
}