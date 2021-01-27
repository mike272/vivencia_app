import 'package:flash_chat/components/square_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/rendering.dart';
import 'package:flash_chat/components/input_field.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flash_chat/components/notifications_pop_ups.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  data password = new data();
  data email = new data();
  bool showSpinner = false;
  int _currentIndex = 0;
  AnimationController controller;
  @override
  void initState() {
    Firebase.initializeApp();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage('images/forest_clouds.png'),
        fit: BoxFit.cover,
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Center(
            child: FractionallySizedBox(
              heightFactor: 0.85,
              widthFactor: 0.8,
              child: ListView(children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                            color: kColorPurple,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: <Widget>[
                                  // Hero(
                                  //   tag: 'logoMe',
                                  //   child: Container(
                                  //     child: Image.asset('images/logoMe.png'),
                                  //     height: 60.0,
                                  //   ),
                                  // ),

                                  TypewriterAnimatedTextKit(
                                    text: ['Vivencia'],
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 45.0,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Log in or register',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            color: Colors.white,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 30.0,
                                ),
                                inputField(
                                  hint: 'EMAIL',
                                  dataFromField: email,
                                ),
                                inputField(
                                  hint: 'PASSWORD',
                                  hideInfo: true,
                                  dataFromField: password,
                                ),
                                SquareButtonSimple(
                                  function: () async {
                                    if (email.Data.length < 3 ||
                                        password.Data.length < 8) {
                                      //missing information
                                      ErrorNotification(
                                        context: context,
                                        title: 'Incorrect Email or Password',
                                        text:
                                            'please provide correct email and password',
                                        answer: 'Back',
                                      );
                                    } else {
                                      print(email.Data);
                                      print(password.Data);
                                      try {
                                        setState(() {
                                          showSpinner = true;
                                        });

                                        final user = await _auth
                                            .signInWithEmailAndPassword(
                                                email: email.Data,
                                                password: password.Data);
                                        if (user != null) {
                                          Navigator.pushNamed(
                                              context, 'bottomBar');
                                        }
                                        setState(() {
                                          showSpinner = false;
                                        });
                                      } catch (e) {
                                        print(e);
                                      }
                                    }
                                  },
                                  buttonText: 'Log In',
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  child: Text('Don\'t have an account yet?'),
                                ),
                                SquareButtonSimple(
                                  function: () {
                                    Navigator.pushNamed(
                                        context, 'registrationScreen');
                                  },
                                  buttonText: 'Register',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ]),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
