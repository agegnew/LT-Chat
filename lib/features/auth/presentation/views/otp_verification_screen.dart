import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import 'profile_setup_screen.dart';

class OtpVerificationScreen extends StatelessWidget {
  final String phone;
  final TextEditingController otpController = TextEditingController();

  OtpVerificationScreen({required this.phone});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Enter OTP")),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is OtpVerified) {
            BlocProvider.of<AuthBloc>(context).add(CheckUserEvent(phone));
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is UserExists) {
            // User already registered, navigate to home or chat screen
            Navigator.pushReplacementNamed(context, "/");
          } else if (state is UserNotFound) {
            // New user, navigate to profile setup
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileSetupScreen(phone: phone),
              ),
            );
          }
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Enter OTP"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  BlocProvider.of<AuthBloc>(context).add(VerifyOtpEvent(phone, otpController.text));
                },
                child: Text("Verify OTP"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
