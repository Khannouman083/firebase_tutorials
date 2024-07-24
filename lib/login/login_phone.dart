import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tutorials/login/code_verification.dart';
import 'package:firebase_tutorials/database/post_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class phoneLogin extends StatefulWidget {
  const phoneLogin({super.key});

  @override
  State<phoneLogin> createState() => _phoneLoginState();
}

class _phoneLoginState extends State<phoneLogin> {
  String phone = '';
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Phone Login"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                key: const Key("Phone"),
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                ),
                validator: (value) {
                  if (value.toString().length < 11) {
                    return "Phone number must be 11 digits";
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  phone = value!;
                },
              ),
              const SizedBox(height: 20,),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.red)
                    ),
                    onPressed: () {
                      if(_formKey.currentState!.validate()){
                        _formKey.currentState!.save();
                        sendCode(phone, context);
                      }
                    },
                    child: const Text("Send Code")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void sendCode (String phone, BuildContext context) async{
  await FirebaseAuth.instance.verifyPhoneNumber(
    phoneNumber: phone,
    verificationCompleted: (PhoneAuthCredential credential) async {
      // This callback will be triggered if the phone number is verified automatically.
      await FirebaseAuth.instance.signInWithCredential(credential);
      Fluttertoast.showToast(
        msg: "Phone number automatically verified and signed in!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Navigator.push(context, MaterialPageRoute(builder: (context) => const postScreen()));
    },
    verificationFailed: (FirebaseAuthException e) {
      // This callback is triggered in case of an error during phone number verification.
      String message;
      if (e.code == 'invalid-phone-number') {
        message = "The provided phone number is not valid.";
      } else {
        message = "Phone number verification failed. Please try again.";
      }
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    },
    codeSent: (String verificationId, int? resendToken) {
      // This callback is triggered when the verification code has been successfully sent to the user.
      Fluttertoast.showToast(
        msg: "Verification code sent to your phone.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      // Navigate to the screen where the user can enter the verification code.
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => codeVerify(verificationid: verificationId,),
        ),
      );
    },
      codeAutoRetrievalTimeout: (String verificationId) {
        // This callback is triggered when the auto retrieval time expires.
        Fluttertoast.showToast(
          msg: "Code auto retrieval timeout. Please request a new code.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.orange,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      },
  );
}
