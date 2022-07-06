import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/responsive/mobile_layout.dart';
import 'package:instagram/responsive/responsive_layout_screen.dart';
import 'package:instagram/responsive/web_layout.dart';
import 'package:instagram/screens/loading.dart';
import 'package:instagram/screens/signin.dart';
import 'package:instagram/services/auth.dart';
import 'package:instagram/utils/colors.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(options: FirebaseOptions(apiKey: 'AIzaSyB5HN2to2VI3CeU02mNrx0BlwXUL8mOS3k', appId: '1:289007820772:web:4d1b80e1068a4f51c231f1', messagingSenderId: '289007820772', projectId: 'instagram-c968b',storageBucket: 'instagram-c968b.appspot.com'));
  }else{
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider(),)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Instagram clone',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor : mobileBackgroundColor,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if(snapshot.connectionState==ConnectionState.active){
              if(snapshot.hasData){
                return ResponsiveLayout(mobileWidget: MobileLayout(), webWidget: WebLayout());
              }else if(snapshot.hasError){
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }else if(snapshot.connectionState == ConnectionState.waiting){
              return Loading();
            }
            return SignIn();
          },
        ),
      ),
    );
  }
}
