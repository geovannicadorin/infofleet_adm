import 'package:dio/dio.dart';
import 'package:get/get.dart';

// --- Imports das Camadas de Dados e Domínio ---
import '../../features/assets/data/repositories/asset_repository_impl.dart';
import '../../features/assets/domain/repositories/i_asset_repository.dart';

// --- Import da Controller da Listagem ---
import '../../features/assets/presentation/controllers/asset_list_controller.dart';

class AssetListBinding extends Bindings {
  @override
  void dependencies() {
    // 1. Injeta o Repositório na memória.
    // Ele usa o Get.find<Dio>() que nós já instanciámos lá no main.dart
    Get.lazyPut<IAssetRepository>(
          () => AssetRepositoryImpl(Get.find<Dio>()),
    );

    // 2. Injeta a Controller da Listagem, passando o Repositório recém-criado acima
    Get.lazyPut<AssetListController>(
          () => AssetListController(Get.find<IAssetRepository>()),
    );
  }
}