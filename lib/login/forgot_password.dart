import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class forgotPassword extends StatefulWidget {
  const forgotPassword({super.key});

  @override
  State<forgotPassword> createState() => _forgotPasswordState();
}

class _forgotPasswordState extends State<forgotPassword> {
  final emailController = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Forgot Password"),
        backgroundColor: Colors.red,),

      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: "Enter Email",
                border: OutlineInputBorder()
              ),

            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.red)
                  ),
                  onPressed: (){
                  auth.sendPasswordResetEmail(email: emailController.text.toString()).then((onValue){
                    Fluttertoast.showToast(msg: "Email sent successfully");
                  }).catchError((error){
                    Fluttertoast.showToast(msg: error.toString());
                  });
              }, child: Text("Send Verification Link")),
            )
          ],
        ),
      ),
    );

  }
}
