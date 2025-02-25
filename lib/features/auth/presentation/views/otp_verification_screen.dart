import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/auth_bloc.dart';
import 'profile_setup_screen.dart';
import '../../../chat/presentation/pages/chat_page.dart';
import 'waiting_approval_screen.dart';
import '../../../chat/presentation/views/chat_header_logo.dart'; // Import the animated logo

class OtpVerificationScreen extends StatelessWidget {
  final String phone;
  final TextEditingController otpController = TextEditingController();

  OtpVerificationScreen({required this.phone});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.5),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          "OTP Verification",
          style: GoogleFonts.pressStart2p(
            fontSize: 16,
            color: Colors.cyanAccent,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is OtpVerified) {
            BlocProvider.of<AuthBloc>(context).add(CheckUserEvent(phone));
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is UserExists) {
            Navigator.pushReplacementNamed(context, '/chat');
          } else if (state is UserNotFound) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileSetupScreen(phone: phone),
              ),
            );
          } else if (state is UserPendingApproval) {
            Navigator.pushReplacementNamed(context, '/waiting-approval');
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Circular Logo
              const ChatHeaderLogo(),

              const SizedBox(height: 30),

              // Instruction Text
              Text(
                "Enter the OTP sent to\n$phone",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.cyanAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              // OTP Text Field
              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white10,
                  labelText: "OTP",
                  labelStyle: const TextStyle(color: Colors.cyanAccent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Verify OTP Button
              ElevatedButton(
                onPressed: () {
                  if (otpController.text.isNotEmpty) {
                    BlocProvider.of<AuthBloc>(context).add(
                      VerifyOtpEvent(phone, otpController.text),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please enter the OTP")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyanAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Verify OTP",
                  style: GoogleFonts.pressStart2p(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
