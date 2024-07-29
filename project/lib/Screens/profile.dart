import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/Classes/realtime_database.dart';
import 'package:project/Screens/login.dart';
import 'package:provider/provider.dart';
import 'package:project/Screens/update.dart';
import 'package:project/Classes/firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  String? _name;
  final ImagePicker _picker = ImagePicker();
  DatabaseReference ref = FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL:
              'https://flutter-intern-97dad-default-rtdb.europe-west1.firebasedatabase.app')
      .ref("users/123");
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
      print("Error updating name: $e");
    }
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
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
        title: Text(AppLocalizations.of(context)!.profile),
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
              Text(
                  '${AppLocalizations.of(context)!.name}: ${userData['name']}'),
              Text('${AppLocalizations.of(context)!.age}: ${userData['age']}'),
              Text(
                  '${AppLocalizations.of(context)!.email}: ${FirebaseAuth.instance.currentUser?.email}'),
              FutureBuilder<String?>(
                future:
                    _fetchUsername(), // The async function that returns a Future
                builder:
                    (BuildContext context, AsyncSnapshot<String?> snapshot) {
                  // Check the state of the Future
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // Display a loading indicator while waiting
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}'); // Handle errors
                  } else if (snapshot.hasData) {
                    return Text(
                        'realtimeName: ${snapshot.data}'); // Display the data
                  } else {
                    return Text(
                        'No data'); // Handle the case where no data is available
                  }
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  String? newName = await _showNameDialog(context, _name ?? '');
                  print("33333333");
                  if (newName != null && newName.isNotEmpty) {
                    DatabaseReference ref = FirebaseDatabase.instanceFor(
                            app: Firebase.app(),
                            databaseURL:
                                'https://flutter-intern-97dad-default-rtdb.europe-west1.firebasedatabase.app')
                        .ref("users/123");

                    await ref.set(newName);
                    setState(() {
                      print(newName);
                      _name = newName;
                    });
                  }
                },
                child: Text('editRealtimeName'),
              ),
              ElevatedButton(
                onPressed: _updateImage,
                child: Text(AppLocalizations.of(context)!.camera),
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

  Future<String?> _showNameDialog(BuildContext context, String currentName) {
    TextEditingController controller = TextEditingController(text: currentName);
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("editRealtimeName"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: "enterName",
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(controller.text);
              },
              child: Text("save"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateImage() async {
    if (!kIsWeb) {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        File file = File(pickedFile.path);

        try {
          String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
          Reference storageRef =
              FirebaseStorage.instance.ref().child('images/$fileName');

          UploadTask uploadTask = storageRef.putFile(file);

          TaskSnapshot taskSnapshot = await uploadTask;
          String downloadURL = await taskSnapshot.ref.getDownloadURL();

          setState(() {
            _selectedImage = downloadURL;
          });

          final firestoreProvider =
              Provider.of<FirestoreProvider>(context, listen: false);
          await firestoreProvider.updateImage(_userDocument!.id, downloadURL);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Image uploaded successfully")),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error uploading image: $e")),
          );
        }
      }
    } else {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.image);

      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;

        try {
          String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
          Reference storageRef =
              FirebaseStorage.instance.ref().child('images/$fileName');

          Uint8List? fileBytes = file.bytes;
          if (fileBytes != null) {
            UploadTask uploadTask = storageRef.putData(fileBytes);

            TaskSnapshot taskSnapshot = await uploadTask;
            String downloadURL = await taskSnapshot.ref.getDownloadURL();

            setState(() {
              _selectedImage = downloadURL;
            });

            final firestoreProvider =
                Provider.of<FirestoreProvider>(context, listen: false);
            await firestoreProvider.updateImage(_userDocument!.id, downloadURL);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Image uploaded successfully")),
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

  Future<String?> _fetchUsername() async {
    String? data;
    DatabaseReference ref = FirebaseDatabase.instanceFor(
            app: Firebase.app(),
            databaseURL:
                'https://flutter-intern-97dad-default-rtdb.europe-west1.firebasedatabase.app')
        .ref("users/123");

    DatabaseEvent event = await ref.once();
    data = event.snapshot.value as String?;
    return data;
  }
}
