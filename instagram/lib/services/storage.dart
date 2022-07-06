import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:instagram/services/auth.dart';
import 'package:uuid/uuid.dart';

class StorageServices{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadimagetoStorage(String childname,Uint8List file ,bool ispost) async{
    Reference ref = _storage.ref().child(childname).child(_auth.currentUser!.uid);
    String photoID = Uuid().v1();
    if(ispost){
      ref = ref.child(photoID);
    }
    UploadTask _uploadTask = ref.putData(file);
    TaskSnapshot _snapshot = await _uploadTask;
    String _downloadURL = await _snapshot.ref.getDownloadURL();
    return _downloadURL;
  }


}