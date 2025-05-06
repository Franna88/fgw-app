import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class FirebaseService {
  // Firebase instances
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  // Auth getters
  static FirebaseAuth get auth => _auth;
  static User? get currentUser => _auth.currentUser;
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Firestore getter
  static FirebaseFirestore get firestore => _firestore;

  // Storage getter
  static FirebaseStorage get storage => _storage;

  // Analytics getter
  static FirebaseAnalytics get analytics => _analytics;

  // Document upload
  static Future<String> uploadDocument(
      File file, String userId, String documentType) async {
    try {
      // Create a reference to the file location
      final Reference ref = _storage.ref().child(
          'users/$userId/${documentType}_${DateTime.now().millisecondsSinceEpoch}');

      // Upload the file
      final UploadTask uploadTask = ref.putFile(file);

      // Get the download URL
      final TaskSnapshot taskSnapshot = await uploadTask;
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      rethrow;
    }
  }

  // User authentication methods
  static Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<UserCredential> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> signOut() async {
    await _auth.signOut();
  }

  // Firebase Analytics logging methods
  static Future<void> logLogin() async {
    await _analytics.logLogin();
  }

  static Future<void> logScreenView(String screenName) async {
    await _analytics.logScreenView(screenName: screenName);
  }

  static Future<void> logEvent(
      String name, Map<String, dynamic> parameters) async {
    await _analytics.logEvent(name: name, parameters: parameters);
  }

  // Create a farmer in Firestore
  static Future<void> createFarmer(
      String userId, Map<String, dynamic> farmerData) async {
    try {
      await _firestore.collection('farmers').doc(userId).set({
        ...farmerData,
        'createdAt': FieldValue.serverTimestamp(),
        'userId': userId,
      });
    } catch (e) {
      rethrow;
    }
  }

  // Create a worker in Firestore
  static Future<void> createWorker(
      String userId, Map<String, dynamic> workerData) async {
    try {
      await _firestore.collection('workers').doc(userId).set({
        ...workerData,
        'createdAt': FieldValue.serverTimestamp(),
        'userId': userId,
      });
    } catch (e) {
      rethrow;
    }
  }
}
