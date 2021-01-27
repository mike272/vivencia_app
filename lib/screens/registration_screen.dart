import 'package:flash_chat/components/input_field.dart';
import 'package:flash_chat/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/RoundedButton.dart';
import 'package:flash_chat/components/square_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flash_chat/components/notifications_pop_ups.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  data email = new data();
  data name = new data();
  data password = new data();
  data passwordAgain = new data();
  bool showSpinner = false;
  List<String> args = [];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => inputField(),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/forest_clouds.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: ModalProgressHUD(
            inAsyncCall: showSpinner,
            child: Center(
              child: FractionallySizedBox(
                heightFactor: 0.85,
                widthFactor: 0.8,
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.white,
                  child: ListView(children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        //Flexible(
                        // child: Hero(
                        //   tag: 'logoMe',
                        //   child: Container(
                        //     height: 200.0,
                        //     child: Image.asset('images/logoMe.png'),
                        //   ),
                        // ),
                        //),
                        Container(
                          color: kColorPurple,
                          height: 120.0,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hello,',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        inputField(
                          hint: 'NAME',
                          dataFromField: name,
                        ),
                        // TextField(
                        //     textAlign: TextAlign.center,
                        //     keyboardType: TextInputType.emailAddress,
                        //     onChanged: (value) {
                        //       name = value;
                        //     },
                        //     decoration: kTextFieldDecoration.copyWith(
                        //         hintText: 'Enter your name')),

                        inputField(
                          hint: 'EMAIL',
                          dataFromField: email,
                        ),

                        inputField(
                          hint: 'PASSWORD',
                          hideInfo: true,
                          dataFromField: password,
                        ),

                        inputField(
                          hint: 'REPEAT PASSWORD',
                          hideInfo: true,
                          dataFromField: passwordAgain,
                        ),
                        SizedBox(
                          height: 100,
                        ),
                        SquareButton(
                          function: () async {
                            print(email.Data);
                            try {
                              setState(() {
                                showSpinner = true;
                              });
                              if (password.Data == passwordAgain.Data &&
                                  password.Data.length > 7) {
                                final newUser =
                                    await _auth.createUserWithEmailAndPassword(
                                        email: email.Data,
                                        password: password.Data);
                                _firestore
                                    .collection('usersData')
                                    .doc(email.Data)
                                    .set({
                                  'name': name.Data,
                                  'email': email.Data,
                                  'account creation date':
                                      FieldValue.serverTimestamp(),
                                });

                                if (newUser != null) {
                                  args.add(name.Data);
                                  args.add(email.Data);
                                  Navigator.pushNamed(
                                      context, 'registrationScreenTwo',
                                      arguments: args);
                                }
                              } else if (password.Data != passwordAgain.Data) {
                                //notification about wrong password
                                ErrorNotification(
                                    context: context,
                                    title: 'Passwords do not match!',
                                    text: 'Please type your password again',
                                    answer: 'Back');
                              } else {
                                ErrorNotification(
                                    context: context,
                                    title: 'Passwords are too short',
                                    text: 'Please choose another password',
                                    answer: 'Back');
                              }

                              setState(() {
                                showSpinner = false;
                              });
                            } catch (e) {
                              print(e);
                            }
                          },
                          buttonText: 'NEXT STEP',
                          smallText: '1/2',
                        )
                      ],
                    ),
                  ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
