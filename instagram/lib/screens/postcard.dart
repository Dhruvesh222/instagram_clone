import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/models/user.dart' as model;
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/screens/comments.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/global_var.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class postCard extends StatefulWidget {
  final snap;
  const postCard({Key? key,required this.snap}) : super(key: key);

  @override
  State<postCard> createState() => _postCardState();
}

class _postCardState extends State<postCard> {
  int _commentlen = 0;
  @override
  void initState() {
    super.initState();
    getnumberofcomments();
  }

  void getnumberofcomments() async{
    try{
      QuerySnapshot snap = await FirebaseFirestore.instance.collection('posts').doc(widget.snap['postID']).collection('comments').get();

      int commentlen = snap.docs.length;
      setState(() {
        _commentlen = commentlen;
      });
    }catch(e){
      print(e);
    }
    
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    model.User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      // color: mobileBackgroundColor,
      // color: Colors.yellow,
      decoration: BoxDecoration(
        color: mobileBackgroundColor,
        border: Border.all(
          color: width>websize? primaryColor : mobileBackgroundColor,
        ),
        // borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16,vertical: 4)
            .copyWith(right: 0)
            ,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.snap['profileURL']),
                  // radius: 16,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.snap['username'],style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),)
                      ],
                    ),
                  )
                ),
                user.uid == widget.snap['uid'] ? 
                IconButton(
                  onPressed: (){
                    showDialog(context: context, builder: (context){
                      return Dialog(
                        child: ListView(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shrinkWrap: true,
                          children: [
                            'delete',
                            // 'edit'
                          ].map((e) => InkWell(
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12,horizontal: 16),
                              child: Text(e,style: TextStyle(fontSize: 16),),
                            ),
                            onTap: ()async{
                              Navigator.of(context).pop();
                              try{
                                FirebaseFirestore.instance.collection('posts').doc(widget.snap['postID']).delete();
                              }catch(e){
                                print(e.toString());
                              }
                            },
                          )).toList(),
                        ),
                      );
                    });
                  }, 
                  icon: Icon(Icons.more_vert),
                ) : Container()
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height*0.4,
            child: Image(
              image: NetworkImage(widget.snap['postURL']),
              fit: BoxFit.cover,
            ),
          ),
          Container(
            // color: Colors.blue,
            // padding: EdgeInsets.symmetric(vertical: 2,horizontal: 8),
            child: Row(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: (){

                      }, 
                      icon: Icon(Icons.favorite, color: Colors.red,),
                    ),
                    IconButton(
                      onPressed: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context)=> CommentScreen(snap: widget.snap))
                        );
                      }, 
                      icon: Icon(Icons.comment)
                    ),
                    IconButton(
                      onPressed: (){

                      }, 
                      icon: Icon(Icons.share),
                    ),
                  ],
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      onPressed: (){

                      }, 
                      icon: Icon(Icons.bookmark_outline),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            // color: Colors.deepOrange,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(fontWeight: FontWeight.w800),
                  child: Text(
                    "${widget.snap['likes'].length } likes", 
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top:5),
                  // color: Colors.lime,
                  child: RichText(
                      text: TextSpan(
                        style: TextStyle(color: primaryColor),
                        children: [
                          TextSpan(
                            text: widget.snap['username'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: "  ",
                          ),
                          TextSpan(
                            text: widget.snap['description'],
                          ),
                        ]
                      ),
                    ),

                ),
                InkWell(
                  onTap: (){

                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text('view all ${_commentlen} commments',style: TextStyle(
                        fontSize: 16,
                        color: SecondaryColor,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text(DateFormat.yMMMd().format((widget.snap['datePublished']).toDate()),style: TextStyle(
                      fontSize: 16,
                      color: SecondaryColor,
                    ),
                  ),
                ),
              ],
            ),
          )
        ]
        ),
    );
  }
}