import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:project/Screens/update.dart';
import 'package:project/Classes/firestore.dart';

class ProfilePage extends StatefulWidget {
  static const String routeName = "Profile";

  final String email;
  const ProfilePage({super.key, required this.email});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Uint8List? _selectedImage;
  DocumentSnapshot? _userDocument;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final firestoreProvider = Provider.of<FirestoreProvider>(context, listen: false);
    try {
      DocumentSnapshot? userDoc = await firestoreProvider.getUserByEmail(widget.email);
      setState(() {
        _userDocument = userDoc;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching user data: $e")),
      );
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final returnedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (returnedImage == null) return;
      var webImage = await returnedImage.readAsBytes();
      setState(() {
        _selectedImage = webImage;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error picking image from gallery: $e")),
      );
    }
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final returnedImage = await ImagePicker().pickImage(source: ImageSource.camera);
      if (returnedImage == null) return;
      var webImage = await returnedImage.readAsBytes();
      setState(() {
        _selectedImage = webImage;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error picking image from camera: $e")),
      );
    }
  }

  Future<void> _navigateToUpdateProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateProfileScreen(
          userId: _userDocument!.id,
          name: _userDocument!['name'],
          age: _userDocument!['age'],
          email: _userDocument!['email'],
        ),
      ),
    );

    if (result == true) {
      // Refetch user data if the profile was updated
      _fetchUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_userDocument == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    var userData = _userDocument!.data() as Map<String, dynamic>;
    final screenWidth = MediaQuery.of(context).size.width;
    final inputWidth = screenWidth * 0.8;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _navigateToUpdateProfile,
          ),
        ],
      ),
      body: Center(
        child: SizedBox(
          width: inputWidth,
          child: Column(
            children: [
              Text('Name: ${userData['name']}'),
              Text('Age: ${userData['age']}'),
              Text('Email: ${userData['email']}'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _pickImageFromCamera,
                    child: const Text('Camera'),
                  ),
                  const SizedBox(width: 30),
                  ElevatedButton(
                    onPressed: _pickImageFromGallery,
                    child: const Text('Gallery'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _selectedImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(120),
                      child: Image.memory(
                        _selectedImage!,
                        width: 240,
                        height: 240,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Text("Please select an image!"),
            ],
          ),
        ),
      ),
    );
  }
}
