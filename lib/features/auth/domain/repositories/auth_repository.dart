import 'package:flutter_saas_starter/features/auth/domain/models/app_user.dart';

abstract class AuthRepository {
  Stream<AppUser?> get authStateChanges;
  AppUser? get currentUser;
  
  Future<AppUser> signInWithEmail(String email, String password);
  Future<AppUser> signUpWithEmail(String email, String password);
  Future<AppUser> signInWithGoogle();
  Future<AppUser> signInWithApple();
  Future<void> signOut();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> deleteAccount();
  Future<void> updateProfile({String? displayName, String? photoUrl});
}

