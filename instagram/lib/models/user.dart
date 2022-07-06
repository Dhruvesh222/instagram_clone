import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class User{
  final String uid;
  final String username;
  final String email;
  final String downloadURL;
  final List followings;
  final List followers;
  final String bio;

  User({
    required this.email,
    required this.username,
    required this.bio,
    required this.downloadURL,
    required this.uid,
    required this.followers,
    required this.followings
  });

  Map<String,dynamic> toJson() => {
      'uid' : uid,
      'username' : username,
      'email' : email,
      'bio' : bio,
      'followers' : [],
      'followings' : [],
      'downloadURL':downloadURL
  };

  static User fromsnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String,dynamic> ;
    return User(email: snapshot['email'],
    username: snapshot['username'], 
    bio: snapshot['bio'], 
    downloadURL: snapshot['downloadURL'], 
    uid: snapshot['uid'], 
    followers: snapshot['followers'], 
    followings: snapshot['followings']);
  }
}