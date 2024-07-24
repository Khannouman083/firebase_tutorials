import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tutorials/login/login_phone.dart';
import 'package:firebase_tutorials/login/login_screen.dart';
import 'package:firebase_tutorials/database/post_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

class signUpScreenn extends StatefulWidget {
  const signUpScreenn({super.key});

  @override
  State<signUpScreenn> createState() => _signUpScreennState();
}

class _signUpScreennState extends State<signUpScreenn> {
  @override
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formkey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  String password = '';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Sign Up Screen"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Form(
        key: _formkey,
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                key: const Key("User Name"),
                decoration: const InputDecoration(
                  labelText: "User Name",
                ),
                validator: (value) {
                  if (value.toString().length < 3) {
                    return "Username is so small";
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  name = value!;
                },
              ),
              const SizedBox(
                height: 10,
              ),
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
                      signUp(email, password);

                      setState(() {
                        name = '';
                        email = '';
                        password = '';
                      });
                    }
                    }, child: const Text("Sign Up")),
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const logInScreen()));
                  },
                  child: const Text("Already have an account? Log in")),
              // SizedBox(
              //   height: 20,
              // ),
              TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const phoneLogin()));
                  },
                  child: const Text("Log in with phone number")),
              // SizedBox(
              //   height: 20,
              // ),
            ],
          ),
        ),
      ),
    );
  }

}

void signUp (String email, String password) async{
  try {
    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    Navigator.push(BuildContext as BuildContext, MaterialPageRoute(builder: (context)=>const postScreen()));
    print("Account Created Successfully");
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      Fluttertoast.showToast(
          msg: "Password is weak",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    } else if (e.code == 'email-already-in-use') {
      Fluttertoast.showToast(
          msg: "Email registered with another account",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  } catch (e) {
    Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}

