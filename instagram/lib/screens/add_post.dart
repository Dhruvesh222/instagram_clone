
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/models/user.dart' as model;
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/screens/loading.dart';
import 'package:instagram/services/database.dart';
import 'package:instagram/services/storage.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/utils.dart';
import 'package:provider/provider.dart';

class Post extends StatefulWidget {
  const Post({Key? key}) : super(key: key);

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  TextEditingController _captionController = TextEditingController();
  Uint8List? _file;
  bool _isLoading = false; 

  // StorageServices _storage = StorageServices();
  final databaseServices _database = databaseServices();

  _selectImage(BuildContext context) async{
    return showDialog(
      context: context, 
      builder: (context){
        return SimpleDialog(
          title: Text('create a post'),
          children: [
            SimpleDialogOption(
              padding: EdgeInsets.all(20),
              child: Text("choose from Gallery"),
              onPressed: () async{
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.gallery);
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: EdgeInsets.all(20),
              child: Text("Take photo"),
              onPressed: () async{
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.camera);
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: EdgeInsets.all(20),
              child: Text("Cancel"),
              onPressed: () async{
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    );
  }

  void uploadPost(
    String uid,
    String username,
    String profileURL,
  ) async{
    setState(() {
      _isLoading = true;
    });
    try{
        String result = await _database.uploadPost(uid, username, profileURL, _file!, _captionController.text);
        setState(() {
          _isLoading = false;
        });
        if(result=="success"){
          clearImage();
          snackbar("posted !", context);
        }else{
          snackbar(result, context);
        }
    }catch(err){
      snackbar(err.toString(), context);
    }
  }

  void clearImage(){
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _captionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;
    
    return _file==null ? Center(
      child: GestureDetector(
        child: Icon(Icons.upload, size: 100, color: primaryColor),
        onTap: (){
          return _selectImage(context);
          // Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext)=>Loading()));
        },
      ),
    ) 
    :
    GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          leading: IconButton(
            onPressed: clearImage, 
            icon: Icon(Icons.arrow_back),
          ),
          title: Text("Add Post"),
          actions: [
            TextButton(
              onPressed: (){
                return uploadPost(user.uid,user.username,user.downloadURL);
              }, 
              child: Text("Post",style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: 1
               ),
              )
            )
          ],
        ),
        body: Column(
          children: [
            SizedBox(height: 10,),
            _isLoading ? LinearProgressIndicator() : Container(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(user.downloadURL),
                  // radius: 30
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.5,
                  child: TextField(
                    controller: _captionController,
                    decoration: InputDecoration(
                      hintText: 'write a caption...',
                      border: InputBorder.none,
                    ),
                    maxLines: 8,
                  ),
                ),
                SizedBox(
                  width: 45,
                  height: 45,
                  child: AspectRatio(
                    aspectRatio: 487/513,
                    child: Container(
                      alignment: FractionalOffset.topCenter,
                      decoration: BoxDecoration(
                        image: DecorationImage(image: MemoryImage(_file!)),
                      )
                    ),
                  )
                ),
              ],
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            )

          ],
        )
        
      ),
    );

  }
}