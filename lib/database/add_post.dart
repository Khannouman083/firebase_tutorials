import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class addPost extends StatefulWidget {
  const addPost({super.key});

  @override
  State<addPost> createState() => _addPostState();
}

class _addPostState extends State<addPost> {
  final dataBaseRef = FirebaseDatabase.instance.ref("Post");
  final postController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Post"),
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
                    String id= DateTime.now().millisecondsSinceEpoch.toString();
                    dataBaseRef.child(id).set(
                        {
                          'title' : postController.text.toString(),
                          'id': id

                        }).then((value){
                          Fluttertoast.showToast(msg: "Post added",
                          gravity: ToastGravity.CENTER);
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
