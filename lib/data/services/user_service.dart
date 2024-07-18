import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserService {
  final _userCollection = FirebaseFirestore.instance.collection('users');
  final _userImageStorage = FirebaseStorage.instance;

  Stream<QuerySnapshot> getUser() {
    return _userCollection.snapshots();
  }

  Future<void> addUser(String fullName, String email, File image) async {
    try {
      final imageReference = _userImageStorage
          .ref()
          .child('users')
          .child('images')
          .child('$fullName.jpg');

      final uploadTask = imageReference.putFile(image);
      await uploadTask.whenComplete(() async {
        final imageUrl = await imageReference.getDownloadURL();

        await _userCollection.add({
          'fullName': fullName,
          'email': email,
          'image': imageUrl,
        });
      });
    } catch (e) {
      print('Error adding user: $e');
      throw e;
    }
  }
}
