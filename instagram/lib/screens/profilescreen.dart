import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/screens/loading.dart';
import 'package:instagram/screens/signin.dart';
import 'package:instagram/services/auth.dart';
import 'package:instagram/services/database.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/functionbutton.dart';
import 'package:instagram/utils/utils.dart';

    Column BuildColumn(int val,String label){
      return Column(
        children: [
          Text(val.toString(),style: TextStyle(fontSize: 22,),),
          Container(
            margin: EdgeInsets.only(top:2),
            child: Text(label,style: TextStyle(
              fontWeight: FontWeight.w400,
            ),),
          )
        ],
      );
    }

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key,required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  var userdata = {};
  bool _isLoading = false;
  int followers = 0;
  int followings = 0;
  int noOfPosts = 0;
  bool _isfollowing = true;

  void getdata() async{
    setState(() {
      _isLoading = true;
    });
    try{
      print(widget.uid);
      dynamic usersnap = await FirebaseFirestore.instance.collection('users').doc(widget.uid).get();
      userdata = usersnap.data();
      followers = userdata['followers'].length;
      followings = userdata['followings'].length;

      QuerySnapshot<Map<String,dynamic>> postsnap = await FirebaseFirestore.instance.collection('posts').where('uid',isEqualTo: userdata['uid']).get();
      noOfPosts = postsnap.docs.length;
      _isfollowing = userdata['followers'].contains(FirebaseAuth.instance.currentUser!.uid);
    }catch(e){
      snackbar(e.toString(), context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading? Loading() : FutureBuilder(
      future: FirebaseFirestore.instance.collection('users').doc(widget.uid).get(),
      builder: (context,AsyncSnapshot<DocumentSnapshot<Map<String,dynamic>>> snapshot){
        if(snapshot.connectionState==ConnectionState.waiting){
          return Loading();
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: mobileBackgroundColor,
            title: Text((snapshot.data!.data() as dynamic)!['username']),
          ),
          body: Container(
            // color: Colors.amber,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage((snapshot.data!.data() as dynamic)!['downloadURL']),
                      radius: 40,
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        // mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              BuildColumn(noOfPosts,"posts"),
                              BuildColumn(followers,"followers"),
                              BuildColumn(followings,"followings"),
                            ],
                          ),
                          userdata['uid'] == FirebaseAuth.instance.currentUser!.uid? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            // mainAxisSize: MainAxisSize.max,
                            children: [
                              FunctionButton(text: "Sign out", backgroundColor: mobileBackgroundColor, textColor: primaryColor, borderColor: Colors.grey,function: ()async{
                                await Authservices().SignOut();
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>SignIn()));
                              },)
                            ],
                          ) : _isfollowing ? FunctionButton(text: "unfollow", backgroundColor: Colors.white, textColor: Colors.black, borderColor: Colors.grey,function: ()async{
                            await databaseServices().followUser(FirebaseAuth.instance.currentUser!.uid,widget.uid);
                            setState(() {
                              _isfollowing = false;
                              followers--;
                            });
                            // Navigator.pushReplacement (context, MaterialPageRoute (builder: (BuildContext context) => super.widget));
                          }) 
                          : FunctionButton(text: "Follow", backgroundColor: Colors.blue, textColor: primaryColor, borderColor: Colors.grey,function: ()async{
                            await databaseServices().followUser(FirebaseAuth.instance.currentUser!.uid,widget.uid);
                            setState(() {
                              _isfollowing = true;
                              followers++;
                            });
                            // Navigator.pushReplacement (context, MaterialPageRoute (builder: (BuildContext context) => super.widget));
                          },)
                        ],
                      )
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 2),
                  child: Text((snapshot.data!.data() as dynamic)!['username'],style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                ),        
                Container(
                  padding: EdgeInsets.symmetric(vertical: 2),
                  child: Text((snapshot.data!.data() as dynamic)!['bio']),
                ),        
                Divider(color: Colors.white,thickness: 1.0,),
                FutureBuilder(
                  future: FirebaseFirestore.instance.collection('posts').where('uid',isEqualTo: widget.uid).get(),
                  builder: (context,AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot){
                    if(snapshot.connectionState==ConnectionState.waiting){
                      return Loading();
                    }
                    return GridView.builder(
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      gridDelegate : SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context,index){
                        return  Container(
                          child: Image(image: NetworkImage(snapshot.data!.docs[index].data()['postURL']),fit: BoxFit.cover,)
                        );
                      }
                    );
                  }
                )
              ],
            ),
          ),
        );
      }
    );
  }
}


