import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../bloc/auth_bloc.dart';
import 'otp_verification_screen.dart';
import '../../../chat/presentation/views/chat_header_logo.dart';

class PhoneInputScreen extends StatefulWidget {
  @override
  _PhoneInputScreenState createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends State<PhoneInputScreen> {
  final TextEditingController phoneController = TextEditingController();
  String completePhoneNumber = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.5),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          "Welcome",
          style: GoogleFonts.pressStart2p(
            fontSize: 16,
            color: Colors.cyanAccent,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is OtpSent) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtpVerificationScreen(phone: completePhoneNumber),
              ),
            );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Circular Logo
              const ChatHeaderLogo(),

              const SizedBox(height: 30),

              // Instruction Label
              Text(
                "Please enter your phone number",
                style: TextStyle(
                  color: Colors.cyanAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Country Code Picker with Flags
              IntlPhoneField(
                controller: phoneController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white10,
                  labelText: "Phone Number",
                  labelStyle: const TextStyle(color: Colors.cyanAccent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                initialCountryCode: 'US',
                dropdownTextStyle: const TextStyle(color: Colors.white),
                dropdownIcon: const Icon(Icons.arrow_drop_down, color: Colors.cyanAccent),
                onChanged: (phone) {
                  setState(() {
                    completePhoneNumber = phone.completeNumber;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Send OTP Button
              ElevatedButton(
                onPressed: () {
                  if (completePhoneNumber.isNotEmpty) {
                    BlocProvider.of<AuthBloc>(context).add(SendOtpEvent(completePhoneNumber));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please enter your phone number")),
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
                  "Send OTP",
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
