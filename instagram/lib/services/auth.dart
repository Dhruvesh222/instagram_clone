import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/models/user.dart' as model;
import 'package:instagram/services/database.dart';
import 'package:instagram/services/storage.dart';

class Authservices{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final StorageServices _storage = StorageServices();

  Future<model.User> getuserdetails() async{
    DocumentSnapshot snap = await FirebaseFirestore.instance
    .collection('users')
    .doc(_auth.currentUser!.uid).get();
    return model.User.fromsnap(snap);
  }

  // register using email and password
  Future<String> Signupwithemailandpassword({
    required String username,
    required String email,
    required String password,
    required String bio,
    required Uint8List file, 
    }) async{
      String ret = 'some error occured';
      if(username.isEmpty || password.isEmpty || bio.isEmpty || file==null || email.isEmpty){
        ret = 'some fields are empty' ;
        return ret;
      }
      try{
        UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        User? user = cred.user;
        String downloadURL = await _storage.uploadimagetoStorage('profilePics', file, false);
        await databaseServices(uid: user!.uid).createuser(username: username, email: email, bio: bio,downloadURL:downloadURL);
        ret = "success";
      }
      //  on FirebaseAuthException catch(err){
      //   if(err.code=='invalid-email'){
      //     ret = 'invalid email id';
      //   }
      // }
      catch(e){
        ret = e.toString();
      }
      return ret;
  }



  Future<String> Signinemailandpassword({
    required String email,
    required String password}) async{
    String ret = 'some error occured ';
    try{
      if(email.isEmpty || password.isEmpty){
        ret = "Some fields are empty. Fill all the fields";
      }
      final UserCredential cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
      ret = "success";
    }catch(err){
      ret = err.toString();
    }
    return ret;
  }


  // signout
  Future SignOut() async{
    await _auth.signOut();
  }

}