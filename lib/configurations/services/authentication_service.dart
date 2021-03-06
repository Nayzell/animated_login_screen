import '../exceptions/exceptions.dart';
import '../models/models.dart';
import 'package:audioplayers/audio_cache.dart';
abstract class AuthenticationService {
  Future<User> getCurrentUser();
  Future<User> signInWithEmailAndPassword(String email, String password);
  Future<void> signOut();
}

class FakeAuthenticationService extends AuthenticationService {
  @override

  Future<User> getCurrentUser() async {
    return null;
  }

  @override
  final player = AudioCache();
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    await Future.delayed(Duration(seconds: 1));

    if (email.toLowerCase() != 'cictapps@wvsu.edu.ph' || password != '1234') {
      throw AuthenticationException(message: 'Wrong username or password');
    }
    return User(name: 'Test User', email: email);
  }

  @override
  Future<void> signOut() {
    return null;
  }
}
