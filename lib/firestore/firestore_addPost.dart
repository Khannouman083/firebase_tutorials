import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class addFirestorePost extends StatefulWidget {
  const addFirestorePost({super.key});

  @override
  State<addFirestorePost> createState() => _addFirestorePostState();
}

class _addFirestorePostState extends State<addFirestorePost> {
  final postController = TextEditingController();
  final firestoreN = FirebaseFirestore.instance.collection("Users");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Firestore Add Post"),
          backgroundColor: Colors.red,
        ),
        body: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: postController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: "Add post",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.red)
                    ),

                    onPressed: () {
                      String id = DateTime.now().millisecondsSinceEpoch.toString();
                      firestoreN.doc(id).set({
                        'title' : postController.text.toString(),
                        'id' : id
                      }).then((onValue){
                         Fluttertoast.showToast(msg: "Post Added");
                      }).catchError((error){
                        Fluttertoast.showToast(msg: error.toString());
                      });
                    },
                    child: const Text("Add post")
                ),
              ),
            ],
          ),
        )
    );
  }
}
