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

class campaignDetailsScreen extends StatefulWidget {
  @override
  _campaignDetailsScreenState createState() => _campaignDetailsScreenState();
}

class _campaignDetailsScreenState extends State<campaignDetailsScreen> {
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
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: appliedBool ? Colors.green : Colors.grey[600],
                      ),
                      child: FlatButton(
                        onPressed: () async {
                          print(appliedBool);
                          Map<String, dynamic> data;
                          final db =
                              _firestore.collection('smeData').doc(args[4]);

                          if (appliedBool == false) {
                            var d = await db.get();
                            data = d.data();

                            if (int.parse(data['maxCampaignParticipants']) >
                                int.parse(data['currentParticipants'])) {
                              print("entering false statement");

                              //there is still place for another person
                              //TODO::registering person for campaign
                              //increasing peoples count for this campaign
                              // try {
                              Map<String, dynamic> x = {
                                "currentParticipants":
                                    (1 + int.parse(data['currentParticipants']))
                              };
                              db.update(x);
                              _firestore
                                  .collection('usersData')
                                  .doc(loggedInUser.email)
                                  .update({
                                "campaigns": FieldValue.arrayUnion([args[4]]),
                              });
                              appliedBool = true;
                              // } catch (e) {
                              //   print(e);
                              // }
                            } else {
                              //there is no space
                              //TODO:: notification for user that there is no space and disable button
                            }
                            setState(() {});
                          } else {
                            //already applied
                            setState(() {});
                          }
                        },
                        child: appliedBool
                            ? Text(
                                'APPLIED!',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              )
                            : Text(
                                'APPLY',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
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
