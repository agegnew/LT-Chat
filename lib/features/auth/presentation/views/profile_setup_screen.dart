import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../bloc/auth_bloc.dart';
import 'dart:io';

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
        photoUrl = pickedFile.path; // Replace with backend-uploaded URL
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile Setup")),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is UserRegistered) {
            Navigator.pushReplacementNamed(context, "/home");
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Enter Name"),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: pickImage,
                child: Text("Upload Photo"),
              ),
              SizedBox(height: 10),
              photoUrl != null
                  ? Image.file(
                File(photoUrl!),
                height: 100,
                width: 100,
              )
                  : Container(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  BlocProvider.of<AuthBloc>(context).add(
                    RegisterUserEvent(widget.phone, nameController.text, photoUrl ?? ''),
                  );
                },
                child: Text("Complete Setup"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
