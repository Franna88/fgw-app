import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_service.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic> _registrationData = {};
  static const String _isLoggedInKey = 'isLoggedIn';

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;
  String? get error => _error;
  Map<String, dynamic> get registrationData => _registrationData;

  UserProvider() {
    // Listen to auth state changes
    FirebaseService.authStateChanges.listen((User? user) {
      _user = user;
      notifyListeners();
    });
    _checkPersistentLogin();
  }

  // Check if user was previously logged in
  Future<void> _checkPersistentLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final wasLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;

    if (wasLoggedIn && _user == null) {
      // Try to get the current user
      _user = FirebaseService.currentUser;
      if (_user != null) {
        notifyListeners();
      }
    }
  }

  // Sign in with email and password
  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await FirebaseService.signInWithEmailAndPassword(email, password);
      // Log analytics event
      await FirebaseService.logLogin();

      // Store login state
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isLoggedInKey, true);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Register with email and password
  Future<bool> registerWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Create the user account
      UserCredential userCredential =
          await FirebaseService.createUserWithEmailAndPassword(email, password);

      // Update display name
      await userCredential.user?.updateDisplayName(name);

      // Create user document in Firestore
      await FirebaseService.firestore
          .collection('users')
          .doc(userCredential.user?.uid)
          .set({
        'email': email,
        'name': name,
        'createdAt': DateTime.now(),
        'role': 'user',
      });

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await FirebaseService.signOut();
      // Clear login state
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isLoggedInKey, false);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Store registration data for multi-step registration
  void storeRegistrationData(Map<String, dynamic> data) {
    // Merge new data with existing data
    _registrationData.addAll(data);
    notifyListeners();
  }

  // Clear registration data
  void clearRegistrationData() {
    _registrationData.clear();
    notifyListeners();
  }

  // Upload document and get URL
  Future<String?> uploadUserDocument(File documentFile, String type) async {
    try {
      if (_user == null) return null;

      _isLoading = true;
      notifyListeners();

      final String downloadUrl =
          await FirebaseService.uploadDocument(documentFile, _user!.uid, type);

      // Store URL in registration data
      _registrationData['${type}DocumentUrl'] = downloadUrl;

      _isLoading = false;
      notifyListeners();

      return downloadUrl;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  // Create user with full registration data
  Future<bool> createUserWithRegistrationData(String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Get email and name from registration data
      final String email = _registrationData['email'] ?? '';
      final String firstName = _registrationData['firstName'] ?? '';
      final String lastName = _registrationData['lastName'] ?? '';
      final String fullName = '$firstName $lastName';

      // Create the user account
      UserCredential userCredential =
          await FirebaseService.createUserWithEmailAndPassword(email, password);

      // Update display name
      await userCredential.user?.updateDisplayName(fullName);

      // Determine user type and save to appropriate collection
      final String userType = _registrationData['userType'] ?? 'user';

      // Create user document in Firestore with all registration data
      await FirebaseService.firestore
          .collection('users')
          .doc(userCredential.user?.uid)
          .set({
        ..._registrationData,
        'uid': userCredential.user?.uid,
        'displayName': fullName,
        'createdAt': DateTime.now(),
      });

      // If it's a farmer, also create a record in the farmers collection
      if (userType == 'farmer') {
        await FirebaseService.createFarmer(
            userCredential.user!.uid, _registrationData);
      }
      // If it's a worker, also create a record in the workers collection
      else if (userType == 'worker') {
        await FirebaseService.createWorker(
            userCredential.user!.uid, _registrationData);
      }

      // Log analytics event
      await FirebaseService.logEvent('sign_up', {'user_type': userType});

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
