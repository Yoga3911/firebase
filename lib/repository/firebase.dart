import 'package:cloud_firestore/cloud_firestore.dart';

class Repository {
  static CollectionReference users = FirebaseFirestore.instance.collection("users");
}