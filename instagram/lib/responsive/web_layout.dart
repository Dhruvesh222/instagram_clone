import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/global_var.dart';

class WebLayout extends StatefulWidget {
  const WebLayout({Key? key}) : super(key: key);

  @override
  State<WebLayout> createState() => _WebLayoutState();
}

class _WebLayoutState extends State<WebLayout> {
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
    setState(() {
      active_page = page;
    });
  }

  void onPageChanged(page){
    setState(() {
      active_page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: SvgPicture.asset(
          'assets/ic_instagram.svg',
          color: primaryColor,
          height: 32,
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () => navigationTapped(0), 
            icon: Icon(
              Icons.home,
              color: active_page==0? primaryColor:SecondaryColor,
            ),
          ),
          IconButton(
            onPressed: () => navigationTapped(1), 
            icon: Icon(
              Icons.search,
              color: active_page==1? primaryColor:SecondaryColor,
            ),
          ),
          IconButton(
            onPressed: () => navigationTapped(2),  
            icon: Icon(
              Icons.add_a_photo,
              color: active_page==2? primaryColor:SecondaryColor,
            ),
          ),
          IconButton(
            onPressed: () => navigationTapped(3), 
            icon: Icon(
              Icons.favorite,
              color: active_page==3? primaryColor:SecondaryColor,
            ),
          ),
          IconButton(
            onPressed: () => navigationTapped(4), 
            icon: Icon(
              Icons.person,
              color: active_page==4? primaryColor:SecondaryColor,
            ),
          ),
        ]
      ),
      body: PageView(
        children:  HomeScreen,
        controller: _pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      
    );
  }
}