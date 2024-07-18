import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tadbiro/data/services/user_service.dart';

class UserRepository {
  final _userService = UserService();

  Stream<QuerySnapshot> get list {
    return _userService.getUser();
  }

  Future<void> addUser(String fullName, String email, File image) async {
    return _userService.addUser(fullName, email, image);
  }
}
