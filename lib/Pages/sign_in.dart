import 'package:messenger/Screens/contact_screen.dart';
import 'package:messenger/database/fire_auth.dart';
import 'package:messenger/database/local_storage.dart';
import 'package:messenger/database/storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '/Pages/sign_up.dart';
import '/Widgets/widgets.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Authenticate authenticate = Authenticate();
  dataBase db = dataBase();
  bool progress_bar = false;
  QuerySnapshot? snapshotUserName;

  signInButton() {
    if (_formKey.currentState!.validate()) {
      storeEmail(emailController.text);

      setState(() {
        progress_bar = true;
      });
      db.getUserFromEmail(emailController.text).then((value) {
        snapshotUserName = value;
        storeUserName(snapshotUserName?.docs[0]['name']);
      });
      authenticate
          .signInWithEmailAndPassword(
              emailController.text, passwordController.text)
          .then(
        (value) {
          if (value != null) {
            storeLoginStatus(true);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => ContactScreen()));
          }
        },
      ).catchError((e){
        SnackBar(content: Text("Email doesn't exists"),);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Messenger',
          style: TextStyle(color: Colors.white70),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: (MediaQuery.of(context).size.height) * 0.8,
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (val) {
                          return val == null ||
                                  RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val)
                              ? null
                              : 'Please enter a a valid email';
                        },
                        controller: emailController,
                        style: textStyleFunc(),
                        decoration: textFieldFiller('Email'),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      TextFormField(
                        validator: (val) {
                          return val == null || val.length < 6
                              ? 'Password should be atleast 6 characters long'
                              : null;
                        },
                        controller: passwordController,
                        style: textStyleFunc(),
                        decoration: textFieldFiller('Password'),
                      ),
                    ],
                  )),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 12),
                alignment: Alignment.centerRight,
                child: Text(
                  'Forget Password',
                  style: textStyleFunc(),
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              Container(
                width: (MediaQuery.of(context).size.width) * 0.5,
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    textStyle: const TextStyle(fontSize: 20),
                    backgroundColor: Colors.blueAccent,
                  ),
                  onPressed: () {
                    signInButton();
                  },
                  child: Text(
                    'Sign In',
                    style: textStyleBlackFunc(),
                  ),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Container(
                width: (MediaQuery.of(context).size.width) * 0.5,
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    textStyle: const TextStyle(fontSize: 20),
                    backgroundColor: Colors.blueAccent,
                  ),
                  onPressed: () {},
                  child: Text(
                    'Sign In with Google',
                    style: textStyleBlackFunc(),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: textStyleFunc(),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => SignUp()));
                    },
                    child: Text(
                      'Create an Account',
                      style: bottomText(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
