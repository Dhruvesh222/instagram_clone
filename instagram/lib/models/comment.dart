import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Comment{
  final String uid;
  final String username;
  final String ProfileURL;
  final String commentID;
  final String commentText;
  final List likes;
  final DatePublished;

  Comment({
    required this.uid,
    required this.username,
    required this.ProfileURL,
    required this.commentID,
    required this.commentText,
    required this.likes,
    required this.DatePublished
  });

  Map<String,dynamic> toJson() => {
      'uid' : uid,
      'username' : username,
      'ProfileURL' : ProfileURL,
      'commentID' : commentID,
      'commentText' : commentText,
      'likes' : [],
      'DatePublished':DatePublished
  };

  static Comment fromsnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String,dynamic> ;
    return Comment(uid: snapshot['email'],
    username: snapshot['username'], 
    ProfileURL: snapshot['ProfileURL'], 
    commentID: snapshot['commentID'], 
    commentText: snapshot['commentText'], 
    likes: snapshot['likes'], 
    DatePublished: snapshot['DatePublished']);
  }
}