import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/screens/add_post.dart';
import 'package:instagram/screens/home.dart';
import 'package:instagram/screens/profilescreen.dart';
import 'package:instagram/screens/searchscreen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/global_var.dart';

class MobileLayout extends StatefulWidget {
  const MobileLayout({Key? key}) : super(key: key);
  @override
  State<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
 int active_page = 0;
  late PageController _pageController;
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }
  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }
  void navigationTapped(int page){
    _pageController.jumpToPage(page);
  }
  void onPageChanged(page){
    setState(() {
      active_page = page;
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children:  HomeScreen,
        controller: _pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: mobileBackgroundColor,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home , color: active_page==0 ? primaryColor:SecondaryColor,),label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search , color: active_page==1 ? primaryColor:SecondaryColor,),label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle , color: active_page==2 ? primaryColor:SecondaryColor,),label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.favorite , color: active_page==3 ? primaryColor:SecondaryColor,),label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person , color: active_page==4 ? primaryColor:SecondaryColor,),label: ''),
        ],
        onTap: navigationTapped,
      ),
    );
  }
}