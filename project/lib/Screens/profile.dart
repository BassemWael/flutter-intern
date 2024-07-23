import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/Classes/users.dart';
import 'package:project/utils/boxes.dart';

class ProfilePage extends StatefulWidget {
  final String email;
  const ProfilePage({super.key, required this.email});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _selectedImage;
  String user() {
    Users user = boxUsers.get('key_${widget.email}');
    return "Welcome ${user.name}";
  }

  Future _pickImageFromGallary() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    setState(() {
      _selectedImage = File(returnedImage.path);
    });
  }

  Future _pickImageFromCamera() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnedImage == null) return;
    setState(() {
      _selectedImage = File(returnedImage.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final inputWidth = screenWidth * 0.8;
    return Scaffold(
      appBar: AppBar(
        title: Text(user()),
      ),
      body: Center(
        child: SizedBox(
          width: inputWidth,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _pickImageFromCamera();
                    },
                    child: const Text('Camera'),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _pickImageFromGallary();
                    },
                    child: const Text('Gallary'),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              _selectedImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(120),
                      child: Image.file(_selectedImage!))
                  : const Text("Please Select an image!")
            ],
          ),
        ),
      ),
    );
  }
}
