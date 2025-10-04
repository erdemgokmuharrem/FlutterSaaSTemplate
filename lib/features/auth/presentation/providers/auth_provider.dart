import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_saas_starter/features/auth/data/repositories/firebase_auth_repository.dart';
import 'package:flutter_saas_starter/features/auth/domain/models/app_user.dart';
import 'package:flutter_saas_starter/features/auth/domain/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FirebaseAuthRepository();
});

final authStateProvider = StreamProvider<AppUser?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges;
});

final currentUserProvider = Provider<AppUser?>((ref) {
  return ref.watch(authStateProvider).valueOrNull;
});

final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController(ref.watch(authRepositoryProvider));
});

class AuthController {
  final AuthRepository _authRepository;
  
  AuthController(this._authRepository);
  
  Future<void> signInWithEmail(String email, String password) async {
    await _authRepository.signInWithEmail(email, password);
  }
  
  Future<void> signUpWithEmail(String email, String password) async {
    await _authRepository.signUpWithEmail(email, password);
  }
  
  Future<void> signInWithGoogle() async {
    await _authRepository.signInWithGoogle();
  }
  
  Future<void> signInWithApple() async {
    await _authRepository.signInWithApple();
  }
  
  Future<void> signOut() async {
    await _authRepository.signOut();
  }
  
  Future<void> sendPasswordResetEmail(String email) async {
    await _authRepository.sendPasswordResetEmail(email);
  }
  
  Future<void> deleteAccount() async {
    await _authRepository.deleteAccount();
  }
  
  Future<void> updateProfile({String? displayName, String? photoUrl}) async {
    await _authRepository.updateProfile(
      displayName: displayName,
      photoUrl: photoUrl,
    );
  }
}

