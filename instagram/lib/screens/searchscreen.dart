import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram/screens/loading.dart';
import 'package:instagram/screens/profilescreen.dart';
import 'package:instagram/utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchcontroller = TextEditingController();
  bool search_complete = false;

  @override
  void dispose() {
    super.dispose();
    _searchcontroller.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: TextField(
            controller: _searchcontroller,
            decoration: InputDecoration(
              labelText: 'search user....',
            ),
            onEditingComplete: (){
              setState(() {
                search_complete = true;
                FocusScope.of(context).unfocus();
              });
            },
          ),
        ),
        body: search_complete ? 
        GestureDetector(
          onTap: (){
            setState(() {
              _searchcontroller.text = '';
              search_complete = false;
            });
          },
          child: FutureBuilder(
            future: FirebaseFirestore.instance.collection("users").where('username',isGreaterThanOrEqualTo: _searchcontroller.text).get(),
            builder: (context,AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot){
              if(snapshot.connectionState==ConnectionState.waiting){
                return Loading();
              }
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context,index){
                  return InkWell(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ProfileScreen(uid: snapshot.data!.docs[index].data()['uid']))),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(snapshot.data!.docs[index].data()['downloadURL']),
                      ),
                      title: Text(snapshot.data!.docs[index].data()['username']),
                    ),
                  );
                }
              ); 
            } 
          ),
        )
        //  : Container()
         : FutureBuilder(
          future: FirebaseFirestore.instance.collection("posts").get(),
          builder: (context,AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return Loading();
            }
            return GridView.custom(
              gridDelegate: SliverQuiltedGridDelegate(
                crossAxisCount: 4,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
                repeatPattern: QuiltedGridRepeatPattern.inverted,
                pattern: [
                  QuiltedGridTile(2, 2),
                  QuiltedGridTile(1, 1),
                  QuiltedGridTile(1, 1),
                  QuiltedGridTile(1, 2),
                ],
              ),
              semanticChildCount: 1,
              childrenDelegate: SliverChildBuilderDelegate(
                (context, index){
                  return Image(image: NetworkImage(snapshot.data!.docs[index].data()['postURL']));
                },
                childCount: snapshot.data!.docs.length,
              ),
            );
          }
        )
      ),
    );
  }
}