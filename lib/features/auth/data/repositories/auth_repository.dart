// import 'package:dartz/dartz.dart';
// import 'package:dio/dio.dart';
// import '../sources/auth_remote_data_source.dart';
// import '../models/user_model.dart';
//
// abstract class AuthRepository {
//   /// Sends OTP to a phone number
//   Future<Either<String, void>> sendOtp(String phone);
//
//   /// Verifies OTP and returns success status
//   Future<Either<String, bool>> verifyOtp(String phone, String otp);
//
//   /// Checks if user exists
//   Future<Either<String, UserModel?>> checkUserExists(String phone);
//
//   /// Registers a new user
//   Future<Either<String, void>> registerUser(String phone, String name, String photoUrl);
// }
//
// class AuthRepositoryImpl implements AuthRepository {
//   final AuthRemoteDataSource remoteDataSource;
//
//   AuthRepositoryImpl({required this.remoteDataSource});
//
//   @override
//   Future<Either<String, void>> sendOtp(String phone) async {
//     try {
//       await remoteDataSource.sendOtp(phone);
//       return const Right(null);
//     } catch (e) {
//       return Left(e.toString());
//     }
//   }
//
//   @override
//   Future<Either<String, bool>> verifyOtp(String phone, String otp) async {
//     try {
//       final isVerified = await remoteDataSource.verifyOtp(phone, otp);
//       return Right(isVerified);
//     } catch (e) {
//       return Left(e.toString());
//     }
//   }
//
//   @override
//   Future<Either<String, UserModel?>> checkUserExists(String phone) async {
//     try {
//       final user = await remoteDataSource.checkUserExists(phone);
//       return Right(user);
//     } catch (e) {
//       return Left(e.toString());
//     }
//   }
//
//   @override
//   Future<Either<String, void>> registerUser(String phone, String name, String photoUrl) async {
//     try {
//       await remoteDataSource.registerUser(phone, name, photoUrl);
//       return const Right(null);
//     } catch (e) {
//       return Left(e.toString());
//     }
//   }
// }
