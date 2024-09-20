import 'package:flutter/material.dart';
import 'package:notes/constants/routs.dart';
import 'package:notes/services/auth/auth_exceptions.dart';
import 'package:notes/services/auth/auth_service.dart';
import '../utilities/dialog/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

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
                await AuthService.firebase().logIn(
                  email: email,
                  password: password,
                );
                final user = AuthService.firebase().currentUser;
                if (context.mounted) {
                  if (user?.isEmailVerified ?? false) {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(notesRoute, (route) => false);
                  } else {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        verifyEmailRoute, (route) => false);
                  }
                }
              } on InvalidCredentialsException {
                await showErrorDialog(
                  context,
                  'Invalid credentials. Please try again.',
                );
              } on GenericAuthException {
                await showErrorDialog(
                  context,
                  'Error occurred while logging in.',
                );
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
