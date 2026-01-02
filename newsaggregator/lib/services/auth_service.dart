import '../models/user_model.dart';

class AuthService {
  // Dummy authentication for development
  static Future<UserModel?> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call

    // For demo purposes, accept any non-empty credentials
    if (email.isNotEmpty && password.isNotEmpty) {
      return UserModel(
        id: 'demo_user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: email.split('@').first,
        location: 'Addis Ababa',
      );
    }
    return null;
  }

  static Future<UserModel?> register(
    String name,
    String email,
    String password,
    String location,
  ) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call

    // For demo purposes, accept any valid registration
    if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {
      return UserModel(
        id: 'demo_user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: name,
        location: location,
      );
    }
    return null;
  }

  static Future<void> logout() async {
    // Clear local storage
  }
}
