import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_tutorials/firestore/firestore_addPost.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class fireStorepostScreen extends StatefulWidget {
  const fireStorepostScreen({super.key});

  @override
  State<fireStorepostScreen> createState() => _fireStorepostScreenState();
}

class _fireStorepostScreenState extends State<fireStorepostScreen> {
  final editController = TextEditingController();
  final firestoreRef = FirebaseFirestore.instance.collection("Users").snapshots();
  CollectionReference refer = FirebaseFirestore.instance.collection("Users");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firestore Posts"),
        backgroundColor: Colors.red,
      ),
      body:
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: firestoreRef,
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index){
                        return Card(
                          child: ListTile(
                            title: Text(snapshot.data!.docs[index]['title'].toString()),
                            subtitle: Text(snapshot.data!.docs[index]['id'].toString()),
                            trailing: PopupMenuButton(
                                itemBuilder: (context)=>[
                                  PopupMenuItem(
                                      child: ListTile(
                                        onTap: (){
                                          Navigator.pop(context);
                                          showmyDialog1(snapshot.data!.docs[index]['title'].toString(), snapshot.data!.docs[index]['id'].toString());
                                        },
                                        leading: Icon(Icons.edit),
                                        title: Text("Edit"),
                                      )),
                                  PopupMenuItem(
                                      child: ListTile(
                                        leading: Icon(Icons.delete),
                                        title: Text("Delete"),
                                        onTap: (){
                                          Navigator.pop(context);
                                          refer.doc(snapshot.data!.docs[index]['id'].toString()).delete().then((onValue){
                                            Fluttertoast.showToast(msg: "Deleted Successfully");
                                          }).catchError((error){
                                            Fluttertoast.showToast(msg: error.toString());
                                          });
                                        },
                                      )),
                                ]),
                          ),
                        );
                      });
                }),
          ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>addFirestorePost()));
          },
          child: Icon(Icons.add),),
    );
  }
  Future<void> showmyDialog1 (String title, String id){
    editController.text= title;
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Update Value"),
            content: TextField(
              controller: editController,
            ),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text('Cancel')),
              TextButton(onPressed: (){
                Navigator.pop(context);
                refer.doc(id).update({
                  'title' : editController.text
                }
                ).then((onValue){
                  Fluttertoast.showToast(msg: "Updated Successfully");
                }).catchError((error){
                  Fluttertoast.showToast(msg: error.toString());
                });
              }, child: Text('Update')),
            ],
          );
        });
  }
}

