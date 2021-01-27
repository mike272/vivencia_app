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
import 'dart:io' show Platform;

class RegistrationScreenTwo extends StatefulWidget {
  @override
  _RegistrationScreenTwoState createState() => _RegistrationScreenTwoState();
}

class _RegistrationScreenTwoState extends State<RegistrationScreenTwo> {
  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    dropdownItems.add(DropdownMenuItem(
      child: Text('MALE'),
      value: 'MALE',
    ));
    dropdownItems.add(DropdownMenuItem(
      child: Text('FEMALE'),
      value: 'FEMALE',
    ));

    return DropdownButton<String>(
      value: 'MALE',
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          gender.Data = value;
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    pickerItems.add(Text('MALE'));
    pickerItems.add(Text('FEMALE'));

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          gender.Data = pickerItems[selectedIndex].toString();
        });
      },
      children: pickerItems,
    );
  }

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  data age = new data();
  data name = new data();
  data gender = new data();
  data city = new data();
  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    List<String> args = ModalRoute.of(context).settings.arguments;
    name.Data = args[0];
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
                          height: 150.0,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Almost there,',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  'We\'d like to know you better!',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'NAME',
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 13),
                              ),
                              TextFormField(
                                obscureText: false,
                                initialValue: args[0],
                                textAlign: TextAlign.start,
                                onChanged: (newValue) {
                                  name.Data = newValue;
                                  //notifyListeners();
                                },
                              ),
                            ],
                          ),
                        ),
                        // TextField(
                        //     textAlign: TextAlign.center,
                        //     keyboardType: TextInputType.emailAddress,
                        //     onChanged: (value) {
                        //       name = value;
                        //     },
                        //     decoration: kTextFieldDecoration.copyWith(
                        //         hintText: 'Enter your name')),
                        Container(
                          padding: EdgeInsets.only(left: 13.0),
                          child: Text(
                            'GENDER',
                            style:
                                TextStyle(color: Colors.black54, fontSize: 13),
                          ),
                        ),
                        Container(
                          height: 60.0,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 13.0),
                          color: Colors.white,
                          child:
                              Platform.isIOS ? iOSPicker() : androidDropdown(),
                        ),

                        inputField(
                          hint: 'AGE',
                          dataFromField: age,
                        ),

                        inputField(
                          hint: 'CITY',
                          dataFromField: city,
                        ),
                        SizedBox(
                          height: 100,
                        ),
                        SquareButton(
                          function: () async {
                            print(age.Data);
                            try {
                              setState(() {
                                showSpinner = true;
                              });
                              if (age.Data == null ||
                                  gender.Data == null ||
                                  city.Data == null ||
                                  name.Data == null) {
                                ErrorNotification(
                                    context: context,
                                    title: 'Not enough information',
                                    text:
                                        'Please provide the necessary information',
                                    answer: 'Back');
                              } else {
                                _firestore
                                    .collection('usersData')
                                    .doc(args[1])
                                    .update({
                                  'name': name.Data,
                                  'age': age.Data,
                                  'gender': gender.Data,
                                  'city': city.Data,
                                });

                                Navigator.pushNamed(context, 'CampaignScreen');
                              }

                              setState(() {
                                showSpinner = false;
                              });
                            } catch (e) {
                              print(e);
                            }
                          },
                          buttonText: 'REGISTER',
                          smallText: '2/2',
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
