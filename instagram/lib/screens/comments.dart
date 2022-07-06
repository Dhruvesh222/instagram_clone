import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram/models/user.dart' as model;
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/screens/commentcard.dart';
import 'package:instagram/screens/loading.dart';
import 'package:instagram/services/database.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/utils.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  final snap;
  const CommentScreen({Key? key,required this.snap}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {

  final databaseServices _database = databaseServices();
  final TextEditingController _commentcontroller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _commentcontroller.dispose();
  }

  void addcomment(
    String uid,
    String username,
    String postID,
    String ProfileURL,
  ) async{
    try{
      String result = await _database.postComment(uid: uid, username: username, postID: postID, commentText: _commentcontroller.text,ProfileURL: ProfileURL);
      setState(() {
        _commentcontroller.text = '';
      });
      if(result=="success"){
        snackbar('comment posted !', context);
      }else{
        snackbar(result, context);
      }

    }catch(err){
      snackbar(err.toString(), context);
    }
  }



  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        title: Text("Comments"),
        centerTitle: false,
        backgroundColor: mobileBackgroundColor,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("posts").doc(widget.snap['postID']).collection("comments")
        .orderBy('DatePublished',descending: true).snapshots(),
        builder: (context,AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting){
            return Loading();
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context,index){
              return CommentCard(snap: snapshot.data!.docs[index].data());
            }
          );
        }
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          // color: Colors.yellow,
          height: kToolbarHeight,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          padding: EdgeInsets.only(left: 16,right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.downloadURL),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left:16.0,right: 8.0),
                  child: TextField(
                    controller: _commentcontroller,
                    decoration: InputDecoration(
                      hintText: 'write as ${user.username} ....',
                      border: InputBorder.none,
                    ),
                    maxLines: 1,
                  ),
                ),

              ),
              InkWell(
                onTap: ()=>addcomment(user.uid,user.username,widget.snap['postID'],user.downloadURL),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
                  child: Text("post",style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 16,
                  ),),
                ),
              )
            ]
          ),
        )
      
      ),
    );
  }
}