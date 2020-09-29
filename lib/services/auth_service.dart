import 'package:firebase_auth/firebase_auth.dart';

abstract class AbstractAuthService {
  Future<SignInStatus> signInWithEmail(String email, String password);
  Future<RegisterStatus> registerWithEmail(
      String email, String password, String displayName);
  User getUser();
  Future<void> signOut();
}

class AuthService implements AbstractAuthService {
  FirebaseAuth auth;

  AuthService() {
    auth = FirebaseAuth.instance;
  }

  @override
  Future<SignInStatus> signInWithEmail(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return SignInStatus.success;
    } on FirebaseAuthException catch (e) {
      print(e);
      if (e.code == 'user-not-found') {
        return SignInStatus.user_not_found;
      } else if (e.code == 'wrong-password') {
        return SignInStatus.wrong_password;
      } else {
        return SignInStatus.failed;
      }
    }
  }

  @override
  Future<RegisterStatus> registerWithEmail(
      String email, String password, String displayName) async {
    try {
      UserCredential user = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      await user.user.updateProfile(displayName: displayName);
      await auth.currentUser.reload();

      return RegisterStatus.success;
    } on FirebaseAuthException catch (e) {
      print(e);
      if (e.code == 'weak-password') {
        return RegisterStatus.weak_password;
      } else if (e.code == 'email-already-in-use') {
        return RegisterStatus.email_already_in_use;
      }
    }

    return RegisterStatus.failed;
  }

  @override
  User getUser() {
    return auth.currentUser;
  }

  @override
  Future<void> signOut() {
    return auth.signOut();
  }
}

enum SignInStatus { success, user_not_found, wrong_password, failed }
enum RegisterStatus { success, weak_password, email_already_in_use, failed }
