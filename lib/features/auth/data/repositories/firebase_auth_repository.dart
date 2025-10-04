import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_saas_starter/features/auth/domain/models/app_user.dart';
import 'package:flutter_saas_starter/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_saas_starter/core/constants/app_constants.dart';
import 'package:flutter_saas_starter/core/utils/logger.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;
  
  FirebaseAuthRepository({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();
  
  @override
  Stream<AppUser?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      return _getOrCreateUser(user);
    });
  }
  
  @override
  AppUser? get currentUser {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;
    
    // Note: This returns a simplified user without Firestore data
    // For full data, use authStateChanges stream
    return AppUser(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoUrl: user.photoURL,
      emailVerified: user.emailVerified,
      isPremium: false,
    );
  }
  
  @override
  Future<AppUser> signInWithEmail(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user == null) {
        throw Exception('Sign in failed');
      }
      
      return await _getOrCreateUser(credential.user!);
    } catch (e, stackTrace) {
      Logger.error('Sign in with email failed', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
  
  @override
  Future<AppUser> signUpWithEmail(String email, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user == null) {
        throw Exception('Sign up failed');
      }
      
      return await _getOrCreateUser(credential.user!);
    } catch (e, stackTrace) {
      Logger.error('Sign up with email failed', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
  
  @override
  Future<AppUser> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google sign in cancelled');
      }
      
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      
      if (userCredential.user == null) {
        throw Exception('Google sign in failed');
      }
      
      return await _getOrCreateUser(userCredential.user!);
    } catch (e, stackTrace) {
      Logger.error('Sign in with Google failed', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
  
  @override
  Future<AppUser> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      
      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      
      final userCredential = await _firebaseAuth.signInWithCredential(oauthCredential);
      
      if (userCredential.user == null) {
        throw Exception('Apple sign in failed');
      }
      
      return await _getOrCreateUser(userCredential.user!);
    } catch (e, stackTrace) {
      Logger.error('Sign in with Apple failed', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
  
  @override
  Future<void> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e, stackTrace) {
      Logger.error('Sign out failed', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
  
  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e, stackTrace) {
      Logger.error('Send password reset email failed', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
  
  @override
  Future<void> deleteAccount() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        // Delete user data from Firestore
        await _firestore.collection(AppConstants.collectionUsers).doc(user.uid).delete();
        
        // Delete Firebase Auth user
        await user.delete();
      }
    } catch (e, stackTrace) {
      Logger.error('Delete account failed', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
  
  @override
  Future<void> updateProfile({String? displayName, String? photoUrl}) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) throw Exception('No user logged in');
      
      await user.updateDisplayName(displayName);
      await user.updatePhotoURL(photoUrl);
      
      // Update Firestore
      await _firestore.collection(AppConstants.collectionUsers).doc(user.uid).update({
        if (displayName != null) 'displayName': displayName,
        if (photoUrl != null) 'photoUrl': photoUrl,
      });
    } catch (e, stackTrace) {
      Logger.error('Update profile failed', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
  
  Future<AppUser> _getOrCreateUser(User firebaseUser) async {
    final userDoc = _firestore.collection(AppConstants.collectionUsers).doc(firebaseUser.uid);
    final snapshot = await userDoc.get();
    
    if (snapshot.exists) {
      // Update last login
      await userDoc.update({'lastLoginAt': FieldValue.serverTimestamp()});
      
      final data = snapshot.data()!;
      return AppUser.fromJson({
        ...data,
        'id': firebaseUser.uid,
        'createdAt': (data['createdAt'] as Timestamp?)?.toDate().toIso8601String(),
        'lastLoginAt': DateTime.now().toIso8601String(),
        'premiumExpiresAt': (data['premiumExpiresAt'] as Timestamp?)?.toDate().toIso8601String(),
      });
    } else {
      // Create new user
      final now = DateTime.now();
      final newUser = AppUser(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        displayName: firebaseUser.displayName,
        photoUrl: firebaseUser.photoURL,
        emailVerified: firebaseUser.emailVerified,
        isPremium: false,
        createdAt: now,
        lastLoginAt: now,
      );
      
      await userDoc.set({
        'email': newUser.email,
        'displayName': newUser.displayName,
        'photoUrl': newUser.photoUrl,
        'emailVerified': newUser.emailVerified,
        'isPremium': newUser.isPremium,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLoginAt': FieldValue.serverTimestamp(),
      });
      
      return newUser;
    }
  }
}

