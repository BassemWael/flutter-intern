import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/Classes/firestore.dart';
import 'package:project/Classes/theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UpdateProfileScreen extends StatefulWidget {
  final String userId;
  final String name;
  final int age;
  final String email;

  const UpdateProfileScreen({
    super.key,
    required this.userId,
    required this.name,
    required this.age,
    required this.email,
  });

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name;
    _ageController.text = widget.age.toString();
    _emailController.text = widget.email;
  }

  Future<void> _updateProfile() async {
    final firestoreProvider =
        Provider.of<FirestoreProvider>(context, listen: false);
    final auth = FirebaseAuth.instance.currentUser;

    if (auth == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not logged in")),
      );
      return;
    }

    try {
      // Update Firestore
      await firestoreProvider.updateUser(
        widget.userId,
        _nameController.text,
        int.parse(_ageController.text),
        _emailController.text,
      );

      // Update Firebase Authentication
      await auth.updateProfile(displayName: _nameController.text);
      if (_emailController.text != widget.email) {
        await auth.verifyBeforeUpdateEmail(_emailController.text);
      }

      Navigator.pop(context, true); // Return true to indicate successful update
    } catch (e) {
      print("Failed to update profile: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          appBar: AppBar(title:  Text("${AppLocalizations.of(context)!.update} ${AppLocalizations.of(context)!.profile}")),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.name),
                ),
                TextField(
                  controller: _ageController,
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.age),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.email),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _updateProfile,
                  child:  Text(AppLocalizations.of(context)!.update),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
