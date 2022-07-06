import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({Key? key,required this.snap}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.amber,
      padding: EdgeInsets.only(left: 16,top: 8,bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.snap['ProfileURL']),
            radius: 18,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 8,),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: 
                    TextSpan(
                      children: [
                        TextSpan(
                          text: widget.snap['username'],
                          style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: "  ${widget.snap['commentText']} ",
                          style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),
                        )
                      ]
                    )
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 4),
                    child: Text('${DateFormat.yMMMd().format(widget.snap['DatePublished'].toDate())}')
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: (){

            }, 
            icon: Icon(Icons.favorite, color: Colors.white,),
          )
        ],

      ),
    );
  }
}