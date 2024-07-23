import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUser(String name, int age, String email) async {
    CollectionReference users = _firestore.collection('users');

    try {
      await users.add({
        'name': name,
        'age': age,
        'email': email,
      });
    } catch (e) {
      print("Failed to add user: $e");
      throw e;
    }
  }

Future<DocumentSnapshot?> getUserByEmail(String email) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first;
      }
    } catch (e) {
      debugPrint('Error getting user by email: $e');
    }
    return null;
  }

  Future<void> updateUser(String userId, String name, int age, String email) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'name': name,
        'age': age,
        'email': email,
      });
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating user: $e');
    }
  }
}
