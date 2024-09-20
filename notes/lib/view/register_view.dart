import 'package:flutter/material.dart';
import 'package:notes/constants/routs.dart';
import 'package:notes/services/auth/auth_service.dart';
import '../services/auth/auth_exceptions.dart';
import '../utilities/dialog/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        title: const Text("Register"),
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
                await AuthService.firebase()
                    .createUser(email: email, password: password);
                AuthService.firebase().sendEmailVerification();
                if (context.mounted) {
                  Navigator.of(context).pushNamed(verifyEmailRoute);
                }
              } on WeakPasswordException {
                if (context.mounted) {
                  await showErrorDialog(
                      context, 'The password provided is too weak.');
                }
              } on EmailAlreadyInUseException {
                if (context.mounted) {
                  await showErrorDialog(
                      context, 'he account already exists for that email.');
                }
              } on InvalidEmailException {
                if (context.mounted) {
                  await showErrorDialog(
                      context, 'The email provided is not valid.');
                }
              } on GenericAuthException {
                if (context.mounted) {
                  await showErrorDialog(context, 'Failed to register.');
                }
              }
            },
            child: const Text("Register")),
        TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (route) => false);
            },
            child: const Text("Already registered? Login here")),
      ]),
    );
  }
}
