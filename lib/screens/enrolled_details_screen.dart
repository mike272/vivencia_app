import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInUser;
int x = 0;
List<String> args = [];

class enrolledCampaignDetailsScreen extends StatefulWidget {
  @override
  _enrolledCampaignDetailsScreenState createState() =>
      _enrolledCampaignDetailsScreenState();
}

class _enrolledCampaignDetailsScreenState
    extends State<enrolledCampaignDetailsScreen> {
  final _auth = FirebaseAuth.instance;
  bool appliedBool = false;
  Map<String, dynamic> applied;
  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  void checkIfApplied() async {
    final appliedSnapchot =
        await _firestore.collection('usersData').doc(loggedInUser.email).get();
    applied = appliedSnapchot.data();
    print(args);
    for (int i = 0; i < applied["campaigns"].length; i++) {
      print("B");
      if (applied["campaigns"][i] == args[4]) {
        print("A");
        appliedBool = true;
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context).settings.arguments;
    checkIfApplied();
    print(appliedBool ? "i ahve applied" : "I have not applied");
    return Scaffold(
      appBar: AppBar(
        leading: null,
        title: Text(
          args[1] + ' Campaign',
        ),
        backgroundColor: kColorPurple,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Container(
            //color: kColorPurple,
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.grey[350],
                  ),
                  child: Column(
                    children: [
                      Text(
                        args[3],
                        //textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        /* applied["address"]*/ args[2],
                        //textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Material(
                    color: Colors.grey[350],
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(12),
                            ),
                            image: DecorationImage(
                              fit: BoxFit.fitWidth,
                              image: AssetImage(args[0]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.grey[350],
                  ),
                  child: Text(
                    'One of the most popular places for Italian cuisine lovers, it serves amazing pizza and pasta',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      // width: 100,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.green,
                      ),
                      child: Text(
                        'YOU HAVE BEEN SELECTED!',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'chatScreen',
                            arguments: args);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 100,
                        height: 75,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.lightBlue,
                        ),
                        child: Text(
                          "CHAT",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey[600],
                      ),
                      child: FlatButton(
                        onPressed: () {},
                        child: Text(
                          'PREVIOUS CAMPAIGN INFO',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Material(
                    color: Colors.grey[350],
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(12),
                            ),
                            image: DecorationImage(
                              fit: BoxFit.fitWidth,
                              image: AssetImage('images/mapScreenShot.png'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
