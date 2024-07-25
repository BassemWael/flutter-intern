import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/Screens/login.dart';
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
  DocumentSnapshot? _userDocument;
  String? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final firestoreProvider =
        Provider.of<FirestoreProvider>(context, listen: false);
    try {
      DocumentSnapshot? userDoc =
          await firestoreProvider.getUserByEmail(widget.email);
      setState(() {
        _userDocument = userDoc;
        _selectedImage = _userDocument?['image'];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching user data: $e")),
      );
    }
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                LoginScreen()), // Ensure this points to your login screen
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error logging out: $e")),
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
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
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
              Text('Email: ${FirebaseAuth.instance.currentUser?.email}'),
              ElevatedButton(
                onPressed: _updateImage,
                child: const Text('Camera'),
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(120),
                child: !kIsWeb
                    ? Image.network(
                        _selectedImage as String,
                        width: 240,
                        height: 240,
                        fit: BoxFit.cover,
                      )
                    : ImageNetwork(
                        image: _selectedImage as String,
                        height: 150,
                        width: 150,
                        onLoading: const CircularProgressIndicator(),
                        onError: const Icon(
                          Icons.error,
                          color: Colors.red,
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateImage() async {
    if (!kIsWeb) {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        File file = File(pickedFile.path);

        try {
          // Create a unique file name
          String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
          // Get a reference to the Firebase Storage bucket
          Reference storageRef =
              FirebaseStorage.instance.ref().child('images/$fileName');

          // Upload the file
          UploadTask uploadTask = storageRef.putFile(file);

          // Get the download URL
          TaskSnapshot taskSnapshot = await uploadTask;
          String downloadURL = await taskSnapshot.ref.getDownloadURL();

          setState(() {
            _selectedImage = downloadURL;
          });

          // Update the user document with the new image URL
          final firestoreProvider =
              Provider.of<FirestoreProvider>(context, listen: false);
          await firestoreProvider.updateImage(_userDocument!.id, downloadURL);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Image uploaded successfully")),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error uploading image: $e")),
          );
        }
      }
    } else {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;

        try {
          // Create a unique file name
          String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
          // Get a reference to the Firebase Storage bucket
          Reference storageRef =
              FirebaseStorage.instance.ref().child('images/$fileName');

          // Upload the file
          Uint8List? fileBytes = file.bytes;
          if (fileBytes != null) {
            UploadTask uploadTask = storageRef.putData(fileBytes);

            // Get the download URL
            TaskSnapshot taskSnapshot = await uploadTask;
            String downloadURL = await taskSnapshot.ref.getDownloadURL();

            setState(() {
              _selectedImage = downloadURL;
            });

            // Update the user document with the new image URL
            final firestoreProvider =
                Provider.of<FirestoreProvider>(context, listen: false);
            await firestoreProvider.updateImage(_userDocument!.id, downloadURL);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Image uploaded successfully")),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error uploading image: $e")),
          );
        }
      }
    }
  }
}
