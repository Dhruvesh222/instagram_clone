import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/models/post.dart';
import 'package:instagram/screens/loading.dart';
import 'package:instagram/screens/postcard.dart';
import 'package:instagram/services/database.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/global_var.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final databaseServices _database = databaseServices();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: width>websize? webBackgroundColor : mobileBackgroundColor,
      appBar: width>websize? null : AppBar(
        backgroundColor: mobileBackgroundColor,
        title: SvgPicture.asset(
          'assets/ic_instagram.svg',
          color: primaryColor,
          height: 32,
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: (){

            }, 
            icon: Icon(Icons.messenger_outline_sharp),
          )
        ]
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').orderBy('datePublished',descending: true).snapshots(),
        builder: (context,AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot){
          if(ConnectionState.waiting== snapshot.connectionState){
            return Loading();
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context,index){
              return Container(
                margin: EdgeInsets.symmetric(
                  horizontal: width>websize? width*0.3 : 0,
                  vertical: width>websize? 15 : 0
                ),
                child: postCard(snap: snapshot.data!.docs[index].data())
              );
            }
            
          );
        },
      
      ),
    );
  }
}