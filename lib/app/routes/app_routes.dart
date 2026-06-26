/// Centraliza todas as strings de rotas da aplicação.
abstract class Routes {
  Routes._(); // Construtor privado para evitar instanciação

  static const LOGIN = '/login';
  static const HOME = '/home';
  static const ASSETS_FORM = '/assets/form';

  // --- Seções renderizadas DENTRO do shell da Home (Navigator aninhado) ---
  static const ASSETS = '/assets';
  static const DASHBOARD = '/dashboard';
  static const DEVICES = '/devices';
  static const INSTALLATIONS = '/installations';
  static const SETTINGS = '/settings';
}