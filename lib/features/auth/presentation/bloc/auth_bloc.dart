import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<SendOtpEvent>(_onSendOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<CheckUserEvent>(_onCheckUser);
    on<RegisterUserEvent>(_onRegisterUser);
  }

  Future<void> _onSendOtp(SendOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await authRepository.sendOtp(event.phone);
    result.fold(
          (error) => emit(AuthFailure(error)),
          (_) => emit(OtpSent()),
    );
  }

  Future<void> _onVerifyOtp(VerifyOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await authRepository.verifyOtp(event.phone, event.otp);
    result.fold(
          (error) => emit(AuthFailure(error)),
          (isVerified) {
        if (isVerified) {
          emit(OtpVerified());
        } else {
          emit(AuthFailure("Invalid OTP"));
        }
      },
    );
  }

  Future<void> _onCheckUser(CheckUserEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await authRepository.checkUserExists(event.phone);

    result.fold(
          (error) => emit(AuthFailure(error)),
          (user) async {
        if (user != null) {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('user_token', user.id);
          await prefs.setBool('is_approved', user.isApproved);

          if (user.isApproved) {
            emit(UserExists(user));
          } else {
            emit(UserPendingApproval()); // FIXED: Now this state exists
          }
        } else {
          emit(UserNotFound());
        }
      },
    );
  }

  Future<void> _onRegisterUser(RegisterUserEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await authRepository.registerUser(event.phone, event.name, event.photoUrl);
    result.fold(
          (error) => emit(AuthFailure(error)),
          (_) => emit(UserRegistered()),
    );
  }
}
