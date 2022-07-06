import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/responsive/mobile_layout.dart';
import 'package:instagram/responsive/responsive_layout_screen.dart';
import 'package:instagram/responsive/web_layout.dart';
import 'package:instagram/screens/loading.dart';
import 'package:instagram/screens/signin.dart';
import 'package:instagram/services/auth.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/global_var.dart';
import 'package:instagram/utils/utils.dart';
import 'package:instagram/widgets/inputtextfield.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final Authservices _auth = Authservices();

  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _usernamecontroller = TextEditingController();
  final TextEditingController _biocontroller = TextEditingController();

  Uint8List? _image;

  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    _usernamecontroller.dispose();
    _biocontroller.dispose();
  }

  void selectImage() async{
    Uint8List im = await pickImage(ImageSource.gallery);
    setState((){
      _image = im;
    });
  }

  void signupuser() async{
    setState(() {
      _isLoading = true;
    });
    String result = await _auth.Signupwithemailandpassword(username: _usernamecontroller.text, email: _emailcontroller.text, password: _passwordcontroller.text, bio: _biocontroller.text,file :_image!);
    setState(() {
        _isLoading = false;
    });

    if(result!='success'){
      snackbar(result, context);
    }else{
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context)=>ResponsiveLayout(mobileWidget: MobileLayout(), webWidget: WebLayout()))
      );
    }

  }

  void navigateToSignin(){
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context)=>SignIn())
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    var deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            reverse: true,
            child: Container(
              padding: width>websize ? EdgeInsets.symmetric(horizontal: width*0.3) :  EdgeInsets.symmetric(horizontal: 32),
              height: deviceHeight-40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(child: Container(),flex: 2),
                  // svg image
                  SvgPicture.asset(
                    'assets/ic_instagram.svg',
                    color: primaryColor,
                    height: 64,
                  ),
                  SizedBox(height: 24),
                  Stack(
                    children: [
                      _image!=null? 
                      CircleAvatar(
                        backgroundImage: MemoryImage(_image!),
                        radius: 64,
                      ):
                      const CircleAvatar(
                        backgroundImage: NetworkImage('https://th.bing.com/th/id/OIP.GC1ZnWTHwOWMgcL9NYwUGAHaHI?pid=ImgDet&w=195&h=187&c=7&dpr=1.25'),
                        radius: 64,
                      ),
                      Positioned(
                        left: 80,
                        bottom: -10,
                        child: IconButton(
                          icon: Icon(Icons.add_a_photo),
                          onPressed: (){
                            selectImage();
                          },
                        ),
                      ),
                    ],
                  ),
          
                  SizedBox(height: 24),
                  TextFieldInput(texteditingcontroller: _usernamecontroller, hinttext: 'enter yout username', textInputType: TextInputType.text),
          
                  SizedBox(height: 24),
                  TextFieldInput(texteditingcontroller: _emailcontroller, hinttext: 'enter yout email', textInputType: TextInputType.emailAddress),
          
                  SizedBox(height: 24),
                  TextFieldInput(texteditingcontroller: _passwordcontroller, hinttext: 'enter your password',ispass: true, textInputType: TextInputType.text),
          
                  SizedBox(height: 24),
                  TextFieldInput(texteditingcontroller: _biocontroller, hinttext: 'enter yout bio', textInputType: TextInputType.text),
          
                  SizedBox(height: 24), 
                  InkWell(
                    onTap: signupuser,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: _isLoading ? Center(child: CircularProgressIndicator(color: primaryColor),) : Text("Register"),
                      alignment: Alignment.center,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        color: blueColor
                      ),
                    ),
                  ),
          
                  SizedBox(height: 24),
                  Flexible(child: Container(),flex: 2,),
          
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text("Already have an account ?"),
                      ),
                      GestureDetector(
                        onTap: navigateToSignin,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text("sign in",style: TextStyle(
                            fontWeight: FontWeight.bold,
                            // color: blueColor,
                          ),),
                        ),
                      ),
                  ],),
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}