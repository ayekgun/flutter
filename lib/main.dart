// This sample shows adding an action to an [AppBar] that opens a shopping cart.
import 'package:flutter/foundation.dart'
  show debugDefaultTargetPlatformOverride;
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'MyTask.dart';

void main() {
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Code Sample for material.AppBar.actions',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(),
    );
  }
}
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String nama = "";
  String gbr = "";
  FirebaseAuth fire = FirebaseAuth.instance;
  GoogleSignIn gsi = new GoogleSignIn();

  Future<FirebaseUser> _signIn() async{
    GoogleSignInAccount gsa = await gsi.signIn();
    GoogleSignInAuthentication gsauth = await gsa.authentication;

    final AuthCredential authCredential = GoogleAuthProvider.getCredential(
        idToken: gsauth.idToken,
        accessToken: gsauth.accessToken
    );
    final FirebaseUser user = await fire.signInWithCredential(authCredential);

    Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>MyTask(user: user, gsi: gsi,)));
    
    return user;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("img/bg.jpg"),fit: BoxFit.cover
          )
        ),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Image.asset("img/task.jpg"),
            GoogleSignInButton(onPressed: () {_signIn();}, darkMode: true,),
          ],
        ),
      ),
    );
  }
}
