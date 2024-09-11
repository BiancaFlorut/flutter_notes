import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes/view/login_view.dart';
import 'package:notes/view/register_view.dart';
import 'package:notes/view/verify_email.dart';
import 'dart:developer' as devtools show log;

import 'firebase_options.dart';

void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: const HomePage(),
    routes: {
      '/login/': (context) => const LoginView(),
      '/register/': (context) => const RegisterView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
            final currentUser = FirebaseAuth.instance.currentUser;
            if (currentUser != null) {
              if (currentUser.emailVerified) {
                print('Email verified');
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
            return const NotesView();
            default: return const CircularProgressIndicator();
          }

        }
    );
  }
}

enum MenuAction { logout }

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Main UI"),
        actions: [
          PopupMenuButton<MenuAction>(onSelected: (value)  async {
            switch (value) {
              case MenuAction.logout:
                final shouldLogout = await shouwLogoutDialog(context);
                if (shouldLogout) {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushNamedAndRemoveUntil('/login/', (_) => false);
                }
                break;
            }
          }, itemBuilder: (context) {
            return const [
              PopupMenuItem<MenuAction>(
                value: MenuAction.logout,
                child: Text("Log out"),
              )
            ];
          })
        ],
      ),
      body: const Center(
        child: Text("Notes"),
      ),
    );
  }
}

Future<bool> shouwLogoutDialog(BuildContext context) {
  return showDialog(context: context,
      builder: (context) {
    return AlertDialog(
    title: const Text("Sign out"),
    content: const Text("Are you sure you want to sign out?"),
    actions: [
      TextButton(onPressed: () {
        Navigator.of(context).pop(false);
      }, child: const Text("Cancel")),
      TextButton(onPressed: () {
        Navigator.of(context).pop(true);
      }, child: const Text("Log out"))
    ],
  );
  }).then((value) => value ?? false);
}







