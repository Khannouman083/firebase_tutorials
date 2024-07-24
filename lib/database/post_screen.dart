import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_tutorials/database/add_post.dart';
import 'package:firebase_tutorials/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class postScreen extends StatefulWidget {
  const postScreen({super.key});

  @override
  State<postScreen> createState() => _postScreenState();
}

class _postScreenState extends State<postScreen> {
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref("Post");
  final searchController = TextEditingController();
  final editController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Post Screen"),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const logInScreen()));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: TextFormField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: "Search",
                border: OutlineInputBorder(),
              ),
              onChanged: (value){
                setState(() {

                });
              },
            ),
          ),
          // Expanded(child: StreamBuilder(
          //     stream: ref.onValue,
          //     builder: (context, AsyncSnapshot<DatabaseEvent> snapshot){
          //       if (snapshot.hasData){
          //         Map<dynamic, dynamic> map = snapshot.data!.snapshot.value as dynamic;
          //         List<dynamic> list=[];
          //         list.clear();
          //         list= map.values.toList();
          //         return ListView.builder(
          //             itemCount: snapshot.data!.snapshot.children.length,
          //             itemBuilder: (context, index){
          //               return ListTile(
          //                 title: Text(list[index]['title']),
          //                 subtitle: Text(list[index]['id']),
          //               );
          //             }
          //         );
          //       }
          //       else {
          //         return Center(child: CircularProgressIndicator(),);
          //       }
          //
          //     })
          // ),
          Expanded(
            child: FirebaseAnimatedList(
                query: ref,
                itemBuilder: (context, snapshot, animation, index){
                  final title = snapshot.child('title').value.toString();
                  if(searchController.text.isEmpty){
                    return ListTile(
                      title: Text(snapshot.child('title').value.toString()),
                      subtitle: Text(snapshot.child('id').value.toString()),
                      trailing: PopupMenuButton(
                          icon: const Icon(Icons.more_vert),
                          itemBuilder: (context)=>[
                            PopupMenuItem(child: ListTile(
                              title: const Text("Update"),
                              leading: const Icon(Icons.edit),
                              onTap: (){
                                Navigator.pop(context);
                                showMyDialog(title,snapshot.child('id').value.toString());

                              },
                            )),
                            PopupMenuItem(child: ListTile(
                              title: const Text("Delete"),
                              leading: const Icon(Icons.delete),
                              onTap: (){
                                Navigator.pop(context);
                                ref.child(snapshot.child('id').value.toString()).remove();
                              },
                            )),
                          ]),
                    );
                  }
                  else if(title.toLowerCase().contains(searchController.text.toLowerCase())){
                    return ListTile(
                      title: Text(snapshot.child('title').value.toString()),
                      subtitle: Text(snapshot.child('id').value.toString()),
                      trailing: PopupMenuButton(
                          icon: const Icon(Icons.more_vert),
                          itemBuilder: (context)=>[
                            PopupMenuItem(child: ListTile(
                              title: const Text("Update"),
                              leading: const Icon(Icons.edit),
                              onTap: (){
                                showMyDialog(title,snapshot.child('id').value.toString());
                                Navigator.pop(context);
                              },
                            )),
                            const PopupMenuItem(child: ListTile(
                              title: Text("Delete"),
                              leading: Icon(Icons.delete),
                            )),
                          ]),
                    );
                  }
                  else {
                    return Container();
                  }

                }),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(

        backgroundColor: Colors.red,
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> const addPost()));
          },
      child: const Icon(Icons.add),),
    );
  }
  Future<void> showMyDialog (String title, id) async{
    editController.text = title;
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: const Text("Update"),
            content: Container(
              child: TextField(
                controller: editController,
              ),
            ),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: const Text("Cancel")),
              TextButton(onPressed: (){
                Navigator.pop(context);
                ref.child(id).update({
                  'title' : editController.text
                }).then((value){
                  Fluttertoast.showToast(msg: "Post Updated");
                }).catchError((error){
                  Fluttertoast.showToast(msg: error.toString());
                });
              }, child: const Text("Update"))
            ],
          );
        });
  }
}
