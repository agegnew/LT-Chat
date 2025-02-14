import 'package:dartz/dartz.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  /// Sends OTP to a phone number
  Future<Either<String, void>> sendOtp(String phone);

  /// Verifies OTP and returns success status
  Future<Either<String, bool>> verifyOtp(String phone, String otp);

  /// Checks if user exists
  Future<Either<String, UserEntity?>> checkUserExists(String phone);

  /// Registers a new user
  Future<Either<String, void>> registerUser(String phone, String name, String photoUrl);
}
