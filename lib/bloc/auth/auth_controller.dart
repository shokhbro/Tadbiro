import 'package:tadbiro/data/services/firebase_auth_service.dart';

class FirebaseAuthController {
  final authController = FirebaseAuthServices();

  Future<void> register({
    required String email,
    required String password,
  }) async {
    await authController.register(email, password);
  }

  Future<void> login({required String email, required String password}) async {
    await authController.login(email, password);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await authController.sendPasswordResetEmail(email);
  }

  Future<void> logout() async {
    await authController.logout();
  }
}
