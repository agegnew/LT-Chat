import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../bloc/auth_bloc.dart';
import 'waiting_approval_screen.dart';
import '../../../chat/presentation/views/chat_header_logo.dart'; // Importing the animated logo

class ProfileSetupScreen extends StatefulWidget {
  final String phone;
  ProfileSetupScreen({required this.phone});

  @override
  _ProfileSetupScreenState createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController nameController = TextEditingController();
  String? photoUrl;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        photoUrl = pickedFile.path; // Local path for now
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.5),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          "Profile Setup",
          style: GoogleFonts.pressStart2p(
            fontSize: 16,
            color: Colors.cyanAccent,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is UserRegistered) {
            // Navigate to waiting approval screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => WaitingApprovalScreen(),
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
              // Animated Logo
              const ChatHeaderLogo(),

              const SizedBox(height: 20),

              // Title
              Text(
                "Set Up Your Profile",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.cyanAccent,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              // Name Input Field
              TextField(
                controller: nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white10,
                  labelText: "Enter your name",
                  labelStyle: const TextStyle(color: Colors.cyanAccent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Profile Picture Upload
              GestureDetector(
                onTap: pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.cyanAccent.withOpacity(0.2),
                  backgroundImage:
                  photoUrl != null ? FileImage(File(photoUrl!)) : null,
                  child: photoUrl == null
                      ? Icon(
                    Icons.camera_alt,
                    color: Colors.cyanAccent,
                    size: 30,
                  )
                      : null,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Tap to upload a photo",
                style: TextStyle(
                  color: Colors.cyanAccent.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 30),

              // Complete Setup Button
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty) {
                    BlocProvider.of<AuthBloc>(context).add(
                      RegisterUserEvent(
                        widget.phone,
                        nameController.text,
                        photoUrl ?? '',
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please enter your name")),
                    );
                  }
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
                  "Complete Setup",
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
