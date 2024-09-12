import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:notes/constants/routs.dart';

import '../utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Column(children: [
        TextField(
          controller: _email,
          enableSuggestions: false,
          autocorrect: false,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(8.0),
              hintStyle: TextStyle(color: Colors.grey),
              hintText: "Enter your email here"),
        ),
        TextField(
          controller: _password,
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
          decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(8.0),
              hintStyle: TextStyle(color: Colors.grey),
              hintText: "Enter your password here"),
        ),
        TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: email, password: password);
                final user = FirebaseAuth.instance.currentUser;
                if (context.mounted) {
                  if (user?.emailVerified ?? false) {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(notesRoute, (route) => false);
                  } else {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        verifyEmailRoute, (route) => false);
                  }
                }
              } on FirebaseAuthException catch (e) {
                if (e.code == 'invalid-credential') {
                  if (context.mounted) {
                    await showErrorDialog(
                      context,
                      'Invalid credentials. Please try again.',
                    );
                  }
                } else {
                  if (context.mounted) {
                    await showErrorDialog(
                      context,
                      'Error occurred while logging in. ${e.message}',
                    );
                  }
                }
              } catch (e) {
                if (context.mounted) {
                  await showErrorDialog(
                    context,
                    'Error occurred while logging in. ${e.toString()}',
                  );
                }
              }
            },
            child: const Text("Login")),
        TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerRoute, (route) => false);
            },
            child: const Text("Not Registered? Register Here!"))
      ]),
    );
  }
}
