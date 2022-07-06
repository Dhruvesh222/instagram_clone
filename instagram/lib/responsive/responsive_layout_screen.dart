import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/responsive/mobile_layout.dart';
import 'package:instagram/responsive/web_layout.dart';
import 'package:instagram/utils/global_var.dart';
import 'package:provider/provider.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget mobileWidget;
  final Widget webWidget;
  const ResponsiveLayout({Key? key, required this.mobileWidget, required this.webWidget}) : super(key: key);

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {

  @override
  void initState() {
    super.initState();
    adduser();
  }

  void adduser()async{
    // FirebaseAuth.instance.signOut();
    UserProvider _userProvider = Provider.of(context,listen: false);
    await _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    // Provider.of<UserProvider>(context).refreshUser();
    return LayoutBuilder(
      builder: (context, constraints) {
        if(constraints.maxWidth < websize){
          return MobileLayout();
        }
        return WebLayout();
      }
    );
  }
}