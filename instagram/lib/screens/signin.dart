import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/responsive/mobile_layout.dart';
import 'package:instagram/responsive/responsive_layout_screen.dart';
import 'package:instagram/responsive/web_layout.dart';
import 'package:instagram/screens/signup.dart';
import 'package:instagram/services/auth.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/global_var.dart';
import 'package:instagram/utils/utils.dart';
import 'package:instagram/widgets/inputtextfield.dart';
class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);
  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final Authservices _auth = Authservices();

  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
  }

  void loginUser() async{
    setState((){
      _isLoading = true;
    });
    String result = await _auth.Signinemailandpassword(email: _emailcontroller.text, password: _passwordcontroller.text);

    if(result == "success"){
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ResponsiveLayout(mobileWidget: MobileLayout(), webWidget: WebLayout())));
    }else{
      snackbar(result, context);
    }

    setState((){
        _isLoading = false;
    });
  }

  void navigateToSignup(){
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context)=>SignUp())
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            padding: width>websize ? EdgeInsets.symmetric(horizontal: width*0.3) : EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(child: Container(),flex: 2,),
                // svg image
                SvgPicture.asset(
                  'assets/ic_instagram.svg',
                  color: primaryColor,
                  height: 64,
                ),
                SizedBox(height: 64),
                TextFieldInput(texteditingcontroller: _emailcontroller, hinttext: 'enter yout email', textInputType: TextInputType.emailAddress),
                SizedBox(height: 24),
                TextFieldInput(texteditingcontroller: _passwordcontroller, hinttext: 'enter your password',ispass: true, textInputType: TextInputType.text),
                SizedBox(height: 24),
                InkWell(
                  onTap: loginUser,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: _isLoading ? Center(child: CircularProgressIndicator(color: primaryColor),) : Text("login"),
                    alignment: Alignment.center,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      color: blueColor
                    ),
                  ),
                ),
                SizedBox(height: 12,),
                Flexible(child: Container(),flex: 2,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text("don't you have an account ?"),
                    ),
                    GestureDetector(
                      onTap: navigateToSignup,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text("sign up",style: TextStyle(
                          fontWeight: FontWeight.bold,
                          // color: blueColor,
                        ),),
                      ),
                    ),
                ],),
              ],
            ),
          ),
        )
      ),
    );
  }
}