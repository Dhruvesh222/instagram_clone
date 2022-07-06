import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/models/user.dart' as model;
import 'package:instagram/services/auth.dart';

class UserProvider extends ChangeNotifier{
  model.User?  _user ;
  
  model.User get getUser => _user!;

  final Authservices _auth = Authservices();

  Future<void> refreshUser() async{
    model.User user = await _auth.getuserdetails();
    _user = user;
    notifyListeners();
  }
}