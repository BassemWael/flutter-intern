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
        'image':
            'https://static.vecteezy.com/system/resources/previews/001/840/618/original/picture-profile-icon-male-icon-human-or-people-sign-and-symbol-free-vector.jpg',
      });
    } catch (e) {
      print("Failed to add user: $e");
      throw e;
    }
  }

  Future<DocumentSnapshot?> getUserByEmail(String email) async {
    QuerySnapshot query = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    if (query.docs.isNotEmpty) {
      return query.docs.first;
    }
    return null;
  }

  Future<void> updateImage(String userId, String image) async {
    await _firestore.collection('users').doc(userId).update({'image': image});
  }
  Future<void> updateUser(
      String userId, String name, int age, String email) async {
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
