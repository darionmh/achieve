import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AbstractAuthService {
  Future<SignInStatus> signInWithEmail(String email, String password);

  Future<RegisterStatus> registerWithEmail(
      String email, String password, String displayName);

  User getUser();

  Future<void> signOut();

  Future<String> updateProfile(String displayName, String email);

  Future<String> changePassword(String newPassword);

  Future<void> sendPasswordResetEmail(String email);
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

      await _userDoc().set({'displayName': displayName, 'email': email});

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

  @override
  Future<String> updateProfile(String displayName, String email) async {
    if (displayName != auth.currentUser.displayName) {
      await auth.currentUser.updateProfile(displayName: displayName);
    }

    if (email != auth.currentUser.email) {
      try {
        await auth.currentUser.updateEmail(email);
      } catch (e) {
        return (e as FirebaseAuthException).code;
      }
    }

    await auth.currentUser.reload();

    await _userDoc().set({'displayName': displayName, 'email': email});

    return '';
  }

  @override
  Future<String> changePassword(String newPassword) async {
    try {
      await auth.currentUser.updatePassword(newPassword);
    } catch (e) {
      return (e as FirebaseAuthException).code;
    }

    return '';
  }

  DocumentReference _userDoc() {
    return FirebaseFirestore.instance
        .collection('user')
        .doc(getUser().uid);
  }

  @override
  Future<void> sendPasswordResetEmail(String email) {
    auth.sendPasswordResetEmail(email: email);
  }
}

enum SignInStatus { success, user_not_found, wrong_password, failed }
enum RegisterStatus { success, weak_password, email_already_in_use, failed }
