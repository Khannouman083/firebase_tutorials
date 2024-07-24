import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tutorials/firestore/firestore_posts.dart';
import 'package:firebase_tutorials/login/login_screen.dart';
import 'package:firebase_tutorials/database/post_screen.dart';
import 'package:firebase_tutorials/login/signup_screen.dart';
import 'package:firebase_tutorials/storage/store_image.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user!= null){
      Timer(const Duration(seconds: 3), (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const logInScreen()));
      });
    }
    else{
      Timer(const Duration(seconds: 3), (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const signUpScreenn()));
      });
    }

  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Firebase Tutorials", style: TextStyle(fontSize: 30),),
            Text("Nouman Khan", style: TextStyle(fontSize: 30),),
          ],
        ),
      ),
    );
  }
}
