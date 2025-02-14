import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<void> sendOtp(String phone);
  Future<bool> verifyOtp(String phone, String otp);
  Future<UserModel?> checkUserExists(String phone);
  Future<void> registerUser(String phone, String name, String photoUrl);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<void> sendOtp(String phone) async {
    final baseUrl = dotenv.env['BASE_URL'];
    if (baseUrl == null) throw Exception('BASE_URL not found in .env');

    await dio.post('$baseUrl/auth/send-otp', data: {'phone': phone});
  }

  @override
  Future<bool> verifyOtp(String phone, String otp) async {
    final baseUrl = dotenv.env['BASE_URL'];
    if (baseUrl == null) throw Exception('BASE_URL not found in .env');

    final response = await dio.post('$baseUrl/auth/verify-otp', data: {'phone': phone, 'otp': otp});
    return response.statusCode == 200;
  }

  @override
  Future<UserModel?> checkUserExists(String phone) async {
    final baseUrl = dotenv.env['BASE_URL'];
    if (baseUrl == null) throw Exception('BASE_URL not found in .env');

    final response = await dio.get('$baseUrl/auth/check-user?phone=$phone');
    return response.statusCode == 200 ? UserModel.fromJson(response.data) : null;
  }

  @override
  Future<void> registerUser(String phone, String name, String photoUrl) async {
    final baseUrl = dotenv.env['BASE_URL'];
    if (baseUrl == null) throw Exception('BASE_URL not found in .env');

    await dio.post('$baseUrl/auth/register', data: {'phone': phone, 'name': name, 'photo': photoUrl});
  }
}
