import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SignupScreen();
}

class _SignupScreen extends State<SignupScreen> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController passConfirmController = TextEditingController();
  String loginErrText = '';

  void signup() async {
    String emailAddress = userController.value.text;
    String password = passController.value.text;
    String passwordConfirmation = passConfirmController.value.text;

    if (password != passwordConfirmation) {
      setState(() {
        loginErrText = 'Passwords must match!';
      });
    }

    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setState(() {
          loginErrText = 'Password is too weak.';
        });
      } else if (e.code == 'email-already-in-use') {
        setState(() {
          loginErrText = 'Account already exists.';
        });
      } else {
        setState(() {
          loginErrText = 'An unknown error occurred: ${e.code}';
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    userController.dispose();
    passController.dispose();
    passConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget userField = TextField(
      controller: userController,
      decoration: const InputDecoration(
          border: OutlineInputBorder(), labelText: 'Email'),
    );

    Widget passField = TextField(
      controller: passController,
      obscureText: true,
      decoration: const InputDecoration(
          border: OutlineInputBorder(), labelText: 'Password'),
    );

    Widget passConfirmField = TextField(
      controller: passConfirmController,
      obscureText: true,
      decoration: const InputDecoration(
          border: OutlineInputBorder(), labelText: 'Confirm Password'),
    );

    Widget submitButton =
        FilledButton(onPressed: () => signup(), child: const Text('Sign Up'));

    EdgeInsets pad = const EdgeInsets.all(10);
    return Padding(
      padding: pad,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          userField,
          const SizedBox(height: 10),
          passField,
          const SizedBox(height: 10),
          passConfirmField,
          const SizedBox(height: 10),
          submitButton,
          Text(loginErrText),
          const Spacer()
        ],
      ),
    );
  }
}
