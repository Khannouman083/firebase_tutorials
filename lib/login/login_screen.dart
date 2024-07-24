import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tutorials/firestore/firestore_posts.dart';
import 'package:firebase_tutorials/database/post_screen.dart';
import 'package:firebase_tutorials/login/forgot_password.dart';
import 'package:firebase_tutorials/login/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class logInScreen extends StatefulWidget {
  const logInScreen({super.key});

  @override
  State<logInScreen> createState() => _logInScreenState();
}

class _logInScreenState extends State<logInScreen> {
  @override
  final _formkey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Log in Screen"),
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: false,
      ),
      body: Form(
        key: _formkey,
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                key: const Key("Email"),
                decoration: const InputDecoration(
                  labelText: "Email",
                ),
                validator: (value) {
                  if (!(value.toString().contains('@'))) {
                    return "Email is invalid";
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  email = value!;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                obscureText: true,
                key: const Key("Password"),
                decoration: const InputDecoration(
                  labelText: "Password",
                ),
                validator: (value) {
                  if (value.toString().length < 6) {
                    return "Password is small";
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  password = value!;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.red)
                    ),
                    onPressed: () {
                      if(_formkey.currentState!.validate()){
                        _formkey.currentState!.save();
                        signIn(email, password, context);
                        setState(() {
                          email = '';
                          password = '';
                        });


                      }
                    }, child: const Text("Log in")),
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const forgotPassword()));
                    },
                    child: const Text("Forgot Password?")),
              ),

              TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const signUpScreenn()));
                  },
                  child: const Text("Don't have an account? Sign Up")),
            ],
          ),
        ),
      ),
    );
  }
}

void signIn (String email, String password, BuildContext context) async {
  try {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
    );
    Navigator.push(context, MaterialPageRoute(builder: (context)=>const fireStorepostScreen()));
    print("Sign in Sucessfully");
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      Fluttertoast.showToast(
          msg: "No user found for these cridentials",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    } else if (e.code == 'wrong-password') {
      Fluttertoast.showToast(
          msg: "You have entered wrong password",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }

  }
  catch (e) {
    Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}
