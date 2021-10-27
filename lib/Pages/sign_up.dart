import '/Pages/sign_in.dart';
import '/Screens/contact_screen.dart';
import '/Widgets/widgets.dart';
import '/database/fire_auth.dart';
import '/database/storage.dart';
import 'package:flutter/material.dart';
import '/database/local_storage.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  dataBase db = dataBase();

  final _formKey = GlobalKey<FormState>();
  bool progress_bar = false;
  Authenticate authenticate = Authenticate();

  signUpButton() {
    if (_formKey.currentState!.validate()) {
      storeUserName(userNameController.text);
      storeEmail(emailController.text);

      setState(() {
        progress_bar = true;
      });

      authenticate
          .createUserWithEmailAndPassword(
              emailController.text, passwordController.text)
          .then((value) {
        db.addUser(emailController.text, userNameController.text);
        storeLoginStatus(true);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const ContactScreen()));
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
      body: progress_bar
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
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
                                return val == null || val.length < 3
                                    ? "atleast enter 4 characters"
                                    : null;
                              },
                              controller: userNameController,
                              style: textStyleFunc(),
                              decoration: textFieldFiller('Username'),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
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
                              obscureText: true,
                              controller: passwordController,
                              style: textStyleFunc(),
                              decoration: textFieldFiller('Password'),
                            ),
                          ],
                        )),
                    const SizedBox(
                      height: 18,
                    ),
                    Container(
                      width: (MediaQuery.of(context).size.width) * 0.5,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding:
                              EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                          textStyle: const TextStyle(fontSize: 20),
                          backgroundColor: Colors.blueAccent,
                        ),
                        onPressed: () {
                          signUpButton();
                        },
                        child: Text(
                          'Sign Up',
                          style: textStyleBlackFunc(),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    // Container(
                    //   width: (MediaQuery.of(context).size.width) * 0.5,
                    //   child: TextButton(
                    //     style: TextButton.styleFrom(
                    //       padding:
                    //           EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    //       textStyle: const TextStyle(fontSize: 20),
                    //       backgroundColor: Colors.blueAccent,
                    //     ),
                    //     onPressed: () {},
                    //     child: Text(
                    //       'Sign Up with Google',
                    //       style: textStyleBlackFunc(),
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: textStyleFunc(),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignIn()));
                          },
                          child: Text(
                            'Sign In',
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
