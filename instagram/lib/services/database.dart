import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/models/comment.dart';
import 'package:instagram/models/post.dart';
import 'package:instagram/models/user.dart' as model;
import 'package:instagram/services/storage.dart';
import 'package:uuid/uuid.dart';

class databaseServices{

  final String? uid;
  databaseServices({this.uid});
  final CollectionReference _userCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference _postCollection = FirebaseFirestore.instance.collection('posts');

  StorageServices _storage = StorageServices();

  Future createuser({
    required String username,
    required String email,
    required String bio, 
    required downloadURL,
  }) async{
    model.User _user = model.User(bio: bio,email: email,username: username,downloadURL: downloadURL,followers: [],followings: [],uid: uid!);
    await _userCollection.doc(uid).set(_user.toJson());
  }

  Future<String> uploadPost(
    String uid,
    String username,
    String profileURL,
    Uint8List file,
    String description,
  ) async{
    String res = "soome error occured";
    try{
      String postID = Uuid().v1();
      String postURL = await _storage.uploadimagetoStorage("post", file, true);

      Post post = Post(uid: uid, username: username, profileURL: profileURL, postID: postID, postURL: postURL, description: description, datePublished: DateTime.now(), likes: []);

      await _postCollection.doc(postID).set(post.toJson());
      res = "success";
    }catch(err){
      res = err.toString();
    }
    return res;
  }

  // Future<List<Post>> getallposts()async {
  //   QuerySnapshot querysnap = await _postCollection.get();
  //   print("getting posts");
  //   List<DocumentSnapshot> documents = querysnap.docs;
  //   return documents.map((DocumentSnapshot snap) => Post.fromsnap(snap)).toList();
  // }

  Future<String> postComment({
    required String uid,
    required String username,
    required String ProfileURL, 
    required String postID,
    required String commentText,

  }) async{
    String res = 'some error occured';
    try{
      String commentID = Uuid().v1();
      Comment comment = Comment(uid: uid, username: username, ProfileURL: ProfileURL, commentID: commentID, commentText: commentText, likes: [], DatePublished: DateTime.now());
      await _postCollection.doc(postID).collection("comments").doc(commentID).set(comment.toJson());
      res = "success";
    }catch(err){
      res = err.toString();
    }
    return res;
  }

  Future<String> followUser(
    String uid,
    String followID,
  ) async{
    String  res = "some error occured";
    try{
      DocumentSnapshot snapshot = await _userCollection.doc(uid).get();
      List followings = snapshot['followings'];
      if(followings.contains(followID)){
        await FirebaseFirestore.instance.collection("users").doc(uid).update({
          'followings' : FieldValue.arrayRemove([followID]),
        });
        await FirebaseFirestore.instance.collection("users").doc(followID).update({
          'followers' : FieldValue.arrayRemove([uid]),
        });
      }else{
        await FirebaseFirestore.instance.collection("users").doc(uid).update({
          'followings' : FieldValue.arrayUnion([followID]),
        });
        await FirebaseFirestore.instance.collection("users").doc(followID).update({
          'followers' : FieldValue.arrayUnion([uid]),
        });
      }
      res = "success";
    }catch(e){
      res = e.toString();
    }
    return res;
  }

}