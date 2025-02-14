part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SendOtpEvent extends AuthEvent {
  final String phone;
  SendOtpEvent(this.phone);

  @override
  List<Object> get props => [phone];
}

class VerifyOtpEvent extends AuthEvent {
  final String phone;
  final String otp;
  VerifyOtpEvent(this.phone, this.otp);

  @override
  List<Object> get props => [phone, otp];
}

class CheckUserEvent extends AuthEvent {
  final String phone;
  CheckUserEvent(this.phone);

  @override
  List<Object> get props => [phone];
}

class RegisterUserEvent extends AuthEvent {
  final String phone;
  final String name;
  final String photoUrl;
  RegisterUserEvent(this.phone, this.name, this.photoUrl);

  @override
  List<Object> get props => [phone, name, photoUrl];
}
