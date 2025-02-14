part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);

  @override
  List<Object> get props => [message];
}

class OtpSent extends AuthState {}

class OtpVerified extends AuthState {}

class UserExists extends AuthState {
  final UserEntity user;
  UserExists(this.user);

  @override
  List<Object> get props => [user];
}

class UserNotFound extends AuthState {}

class UserRegistered extends AuthState {}


class UserPendingApproval extends AuthState {} // FIXED: Added this state
