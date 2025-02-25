import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/auth_bloc.dart';
import '../../../chat/presentation/views/chat_header_logo.dart'; // Import the glowing animated logo
import '../../../chat/presentation/pages/chat_page.dart';

class WaitingApprovalScreen extends StatefulWidget {
  @override
  _WaitingApprovalScreenState createState() => _WaitingApprovalScreenState();
}

class _WaitingApprovalScreenState extends State<WaitingApprovalScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.5),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          "Pending Approval",
          style: GoogleFonts.pressStart2p(
            fontSize: 16,
            color: Colors.cyanAccent,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is UserExists && state.user.isApproved) {
            // Navigate to chat if the admin approves the user
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ChatPage(),
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Glowing Logo
              const ChatHeaderLogo(),

              const SizedBox(height: 20),

              // Approval Message
              Text(
                "Your account is waiting for approval.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.cyanAccent,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Please wait while the admin approves your account. You'll be notified once approved.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 30),

              // Check Approval Status Button
              ElevatedButton(
                onPressed: () {
                  // Trigger checking user status
                  BlocProvider.of<AuthBloc>(context).add(CheckUserEvent(''));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyanAccent,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 32.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Check Status",
                  style: GoogleFonts.pressStart2p(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Note for users
              Text(
                "This may take a few minutes.",
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
