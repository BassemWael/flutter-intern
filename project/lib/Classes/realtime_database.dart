import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class RealtimeDB extends ChangeNotifier {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

}
