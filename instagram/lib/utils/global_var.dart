import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/screens/add_post.dart';
import 'package:instagram/screens/home.dart';
import 'package:instagram/screens/profilescreen.dart';
import 'package:instagram/screens/searchscreen.dart';

const websize = 600;

final HomeScreen = [
  Home(),
  SearchScreen(),
  Post(),
  Center(child: Text("like"),),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
];