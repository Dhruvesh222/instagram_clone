import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Post{
  final String uid;
  final String username;
  final String profileURL;
  final String postID;
  final String postURL;
  final String description;
  final datePublished;
  final List likes;

  Post({
    required this.uid,
    required this.username,
    required this.profileURL,
    required this.postID,
    required this.postURL,
    required this.description,
    required this.datePublished,
    required this.likes,
  });

  Map<String,dynamic> toJson() => {
      'uid' : uid,
      'username' : username,
      'profileURL' : profileURL,
      'postID' : postID,
      'postURL' : postURL,
      'description' : description,
      'datePublished' : datePublished,
      'likes':likes,
  };

  static Post fromsnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String,dynamic> ;
    return Post(
      uid: snapshot['uid'],
      username: snapshot['username'], 
      profileURL: snapshot['profileURL'], 
      postID: snapshot['postID'], 
      postURL: snapshot['postURL'], 
      description: snapshot['description'], 
      datePublished: snapshot['datePublished'],
      likes: snapshot['likes'],
    );
  }
}