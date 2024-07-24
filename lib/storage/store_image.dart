import 'dart:io';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';


class pickImage extends StatefulWidget {
  const pickImage({super.key});

  @override
  State<pickImage> createState() => _pickImageState();
}

class _pickImageState extends State<pickImage> {
  FirebaseStorage storage = FirebaseStorage.instance;
  DatabaseReference refer = FirebaseDatabase.instance.ref("Post");
  XFile? file;
  ImagePicker pick = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload image"),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () async{
                XFile? photo = await pick.pickImage(source: ImageSource.gallery);
                setState(() {
                  file = photo;
                });
              },
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black)
                ),
                child: Center(
                  child: file!=null ? Image.file(File(file!.path), fit: BoxFit.contain,): Icon(Icons.add_a_photo),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(30),
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.red)
                ),
                  onPressed: () async{
                   String id = DateTime.now().millisecondsSinceEpoch.toString();
                    Reference ref = FirebaseStorage.instance.ref('/Nouman/'+id);
                    UploadTask uploadTask = ref.putFile(File(file!.path));
                    Future.value(uploadTask).then((onValue) async{
                      Fluttertoast.showToast(msg: "Image Uploaded successfully");
                      var newUrl = await ref.getDownloadURL();

                      refer.child(id).set(
                          {
                            'id' : id,
                            'title' : newUrl.toString()


                          }).then((onValue){
                        Fluttertoast.showToast(msg: "Image Uploaded successfully");
                      }).catchError((error){
                        Fluttertoast.showToast(msg: error.toString());
                      });
                    }).catchError((error){
                      Fluttertoast.showToast(msg: error.toString());
                    });


                  }, child: Text("Upload Image")),
            )
          ],
        ),
      ),
    );
  }
}
