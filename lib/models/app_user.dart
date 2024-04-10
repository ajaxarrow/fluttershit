import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filmfoliov2/models/mixins/display_mixin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:github_sign_in_plus/github_sign_in_plus.dart';
import 'package:google_sign_in/google_sign_in.dart';

final _firebase = FirebaseAuth.instance;
final CollectionReference users = FirebaseFirestore.instance.collection('users');


class AppUser with DisplayMixin{
  AppUser({
    this.username,
    this.email,
    this.password,
    this.context,
    this.uid,
    this.authid
  });

  final String? uid;
  final String? authid;
  final String? username;
  final String? email;
  final String? password;
  final BuildContext? context;

  factory AppUser.fromMap(Map<String, dynamic> data, id) {
    return AppUser(
      uid: id,
      username: data['username'],
      email: data['email'],
      password: data['password'],
    );
  }


  Future<void> register() async {
    try{
      UserCredential userCredential = await _firebase.createUserWithEmailAndPassword(
          email: email!,
          password: password!
      );

      await users.add({
        'id': userCredential.user!.uid,
        'username': username,
        'email': email,
        'password': password
      });

    } on FirebaseAuthException catch(e){
      showError(
        errorMessage: e.message!,
        errorTitle: 'Authentication Error!'
      );
      return;

    }
  }

  Future<void> login() async {
    try{
      await _firebase.signInWithEmailAndPassword(
        email: email!,
        password: password!
      );
    } on FirebaseAuthException catch(e){
      showError(
          errorMessage: e.message!,
          errorTitle: 'Authentication Error!'
      );
      return;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
        clientId: '698870059918-cis7o6cq3fv4vothqfao5q29flk8ol8a.apps.googleusercontent.com'
      ).signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );



      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      QuerySnapshot querySnapshot = await users.where('id', isEqualTo: userCredential.user?.uid).get();

      if (querySnapshot.docs.isEmpty) {
        await users.add({
          'id': userCredential.user!.uid,
          'username': userCredential.user!.displayName,
          'email': userCredential.user!.email,
          'password': 'defaultpass',
        });
      }

    } on FirebaseException catch(e){
      showError(
          errorMessage: e.message!,
          errorTitle: 'Authentication Error!'
      );
      return;
    }

  }

  Future<void> signInWithGithub() async {
    try{
      final provider = GithubAuthProvider();
      provider.addScope('repo');
      final result = await FirebaseAuth.instance.signInWithPopup(provider);
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(result.credential!);
      QuerySnapshot querySnapshot = await users.where('id', isEqualTo: userCredential.user?.uid).get();

      if (querySnapshot.docs.isEmpty) {
        await users.add({
          'id': userCredential.user!.uid,
          'username': userCredential.user!.displayName,
          'email': userCredential.user!.email,
          'password': 'defaultpass',
        });
      }
    } catch (e){
      print(e);
    }
  }

  Future<void> signInWithYahoo() async {
    try{
      final provider = YahooAuthProvider();
      final result = await FirebaseAuth.instance.signInWithPopup(provider);
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(result.credential!);
      QuerySnapshot querySnapshot = await users.where('id', isEqualTo: userCredential.user?.uid).get();

      if (querySnapshot.docs.isEmpty) {
        await users.add({
          'id': userCredential.user!.uid,
          'username': userCredential.user!.displayName,
          'email': userCredential.user!.email,
          'password': 'defaultpass',
        });
      }
    } catch (e){
      print(e);
    }
  }

  Future<void> signInWithTwitter() async {
    try{
      final provider = TwitterAuthProvider();
      final result = await FirebaseAuth.instance.signInWithPopup(provider);
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(result.credential!);
      QuerySnapshot querySnapshot = await users.where('id', isEqualTo: userCredential.user?.uid).get();

      if (querySnapshot.docs.isEmpty) {
        await users.add({
          'id': userCredential.user!.uid,
          'username': userCredential.user!.displayName,
          'email': userCredential.user!.email,
          'password': 'defaultpass',
        });
      }
    } catch (e){
      print(e);
    }
  }

  Future<void> updateUser() async {
    try{
      await users.doc(uid).update({
        'username': username!,
        'email': email!,
        'password': password!,
      });
    } on FirebaseAuthException catch(e){
      showError(
          errorMessage: e.message!,
          errorTitle: 'Database Error!'
      );
      return;
    }
  }

  Future<void> deleteUser() async {
    try{
      await users.doc(uid).delete();
    } on FirebaseAuthException catch(e){
      showError(
          errorMessage: e.message!,
          errorTitle: 'Database Error!'
      );
      return;
    }
  }

  Future<void> deleteUserAccount() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('id', isEqualTo: _firebase.currentUser?.uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Document found with matching authId
        final userDocumentId = querySnapshot.docs.first.id;
        await users.doc(userDocumentId).delete();
        window.console.log(userDocumentId);

        // Now you can reauthenticate the user and delete the account if needed
        // Reauthentication and account deletion code here...
      } else {
        // No document found with matching authId
        window.console.log('No user document found with matching authId');
      }


      await FirebaseAuth.instance.currentUser!.delete();


    } on FirebaseAuthException catch (e) {

      if (e.code == "requires-recent-login") {
        await _reauthenticateAndDelete();
      } else {
        // Handle other Firebase exceptions
      }
    } catch (e) {

      // Handle general exception
    }
  }

  Future<void> _reauthenticateAndDelete() async {
    try {
      final providerData = _firebase.currentUser?.providerData.first;

      if (GithubAuthProvider().providerId == providerData!.providerId) {
        await _firebase.currentUser!
            .reauthenticateWithProvider(AppleAuthProvider());
      } else if (GoogleAuthProvider().providerId == providerData.providerId) {
        await _firebase.currentUser!
            .reauthenticateWithProvider(GoogleAuthProvider());
      }

      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('id', isEqualTo: _firebase.currentUser?.uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Document found with matching authId
        final userDocumentId = querySnapshot.docs.first.id;
        await users.doc(userDocumentId).delete();
        window.console.log(userDocumentId);

        // Now you can reauthenticate the user and delete the account if needed
        // Reauthentication and account deletion code here...
      } else {
        // No document found with matching authId
        window.console.log('No user document found with matching authId');
      }

      // await _firebase.currentUser?.delete();
    } catch (e) {
      // Handle exceptions
    }
  }

  Future<void> _reauthenticateUser(User user) async{
    AuthCredential credential = EmailAuthProvider.credential(email: email!, password: password!);
    await user.reauthenticateWithCredential(credential);
  }

  Future<List<AppUser>> getUsers() async {
    QuerySnapshot querySnapshot = await users.get();
    final allUsers = querySnapshot.docs.map((doc) => AppUser.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    return allUsers;
  }

}