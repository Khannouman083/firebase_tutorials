import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tutorials/database/post_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class codeVerify extends StatefulWidget {
  String verificationid;
  codeVerify({super.key, required this.verificationid});

  @override
  State<codeVerify> createState() => _codeVerifyState();
}

class _codeVerifyState extends State<codeVerify> {
  String code = '';
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("COde Verification"),
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
                key: const Key("Code"),
                decoration: const InputDecoration(
                  labelText: "Enter Code",
                ),
                validator: (value) {
                  if (value.toString().length < 2) {
                    return "Code must be 6 digits";
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  code = value!;
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
                        verifyCode(widget.verificationid, code, context);
                      }
                    },
                    child: const Text("Verify Code")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void verifyCode(String verificationId, String smsCode, BuildContext context) async {
  try {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
    await FirebaseAuth.instance.signInWithCredential(credential);
    Fluttertoast.showToast(
      msg: "Phone number verified and signed in!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    Navigator.push(context, MaterialPageRoute(builder: (context) => const postScreen()));
  } on FirebaseAuthException catch (e) {
    Fluttertoast.showToast(
      msg: "Failed to sign in: ${e.toString()}",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
