import "package:firebase_core/firebase_core.dart";
import "package:firebase_tutorials/login/splash_screen.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCdQGOIrcZXgg2HZ-LX1jUXbBVn3FYXHtI",
        authDomain: "fir-tutorials-b7416.firebaseapp.com",
        databaseURL: "https://fir-tutorials-b7416-default-rtdb.firebaseio.com",
        projectId: "fir-tutorials-b7416",
        storageBucket: "fir-tutorials-b7416.appspot.com",
        messagingSenderId: "423723179960",
        appId: "1:423723179960:web:1a6b0ad66935415fef394d",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.red
      ),
      home: const SplashScreen(),
    );
  }
}
