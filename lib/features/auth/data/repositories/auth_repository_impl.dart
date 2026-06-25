import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../mappers/auth_mapper.dart';
import '../models/auth_dto.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final Dio _dio;

  AuthRepositoryImpl(this._dio);

  @override
  Future<AuthEntity> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/JWT/Login',
        data: {
          "email": email,
          "password": password,
        },
      );

      // Converte JSON para DTO
      final dto = AuthResponseDTO.fromJson(response.data);
      
      // Converte DTO para Entity e devolve
      return AuthMapper.toEntity(dto);
      
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw AuthException('E-mail ou palavra-passe incorretos.');
      }
      throw AuthException('Erro ao comunicar com o servidor. Tente novamente.');
    } catch (e) {
      throw AuthException('Erro inesperado: ${e.toString()}');
    }
  }
}