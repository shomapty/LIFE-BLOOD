import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } catch (e) {
      print("Some Error Found");
      return null;
    }
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}

class DonorDataUploader {
  static Future<void> uploadDonorData({
    required String? name,
    required String? email,
    required String password,
  }) async {
    try {
      User? firebaseUser = FirebaseAuth.instance.currentUser;

      if (firebaseUser != null) {
        CollectionReference collRef =
        FirebaseFirestore.instance.collection("users");
        // Explicitly set the document ID to be the same as the user's UID
        DocumentReference docRef = collRef.doc(firebaseUser.uid);

        await docRef.set({
          "name": name,
          "email": email,
          "password": password,
          "type": 'donor',
          "uid": firebaseUser.uid,
        });

        print("Data upload successful. Document ID (UID): ${docRef.id}");
      } else {
        print("User is null. Unable to upload data.");
      }
    } catch (e) {
      print("Error uploading user data: $e");
    }
  }
}

class StaffDataUploader {
  static Future<void> uploadStaffData({
    required String hospital,
    required String email,
    required String password,
    required String id,
  }) async {
    try {
      User? firebaseUser = FirebaseAuth.instance.currentUser;

      if (firebaseUser != null) {
        CollectionReference collRef =
        FirebaseFirestore.instance.collection("users");
        DocumentReference docRef = collRef.doc(firebaseUser.uid);

        await docRef.set({
          "email": email,
          "hospital": hospital,
          "password": password,
          "type": 'staff',
          "id": id,
          "uid": firebaseUser.uid,
        });

        print("Data upload successful. Document ID (UID): ${docRef.id}");
      } else {
        print("User is null. Unable to upload data.");
      }
    } catch (e) {
      print("Error uploading user data: $e");
    }
  }
}