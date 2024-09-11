import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes/view/login_view.dart';

import 'firebase_options.dart';

void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: const HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title:
            const Text("Home", style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.deepPurple),
        body: FutureBuilder(
            future: Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform,
            ),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  final currentUser = FirebaseAuth.instance.currentUser;
                  if (currentUser!.emailVerified)
                    print("You are a verified user");
                  else
                    print("You are an unverified user");
                  return const Text('Done');
                  default: return const Text("Loading...");
              }

            }
        ));
  }
}




