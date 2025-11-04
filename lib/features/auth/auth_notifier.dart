import 'package:flutter_hyotalk_app/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// AuthNotifier: 인증 상태를 관리하는 Notifier
///
/// - Notifier을 써서 상태(User?)를 관리한다. : Riverpod 3.0에서는 StateNotifier가 deprecated되어 Notifier를 사용해야 한다.
/// - authProvider를 제공한다.
/// - login
/// - logout
/// - signup
class AuthNotifier extends Notifier<User?> {
  @override
  User? build() {
    return null;
  }

  Future<void> login(String email, String password) async {
    state = User(id: '1', name: 'John Doe');
  }

  Future<void> logout() async {
    state = null;
  }
}

final authProvider = NotifierProvider<AuthNotifier, User?>(() {
  return AuthNotifier();
});
