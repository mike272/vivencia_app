import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInUser;
List<String> args = [];

class applicationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFa568f4),
              Color(0xFF7ab3f8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        alignment: Alignment.center,
        child: FractionallySizedBox(
          heightFactor: 0.8,
          widthFactor: 0.85,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(80),
                bottomLeft: Radius.circular(80),
              ),
            ),
            child: ListView(
              padding: EdgeInsets.all(20),
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                ),
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
                          //color: Colors.grey[350],
                        ),
                        child: Column(
                          children: [
                            Text(
                              "HERE'S YOUR EVENT AT A GLANCE",
                              //textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Material(
                          //color: Colors.grey[350],
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(40),
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
                        ),
                        child: Text(
                          args[1],
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Date: 08.01.2020",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "Time: 19:00",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "Location: Koszykowa 23",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              //color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "We're in prep for the big day. Watch out this space for more details",
                        style: TextStyle(fontSize: 15),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: 170,
                        height: 60,
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.grey[350],
                        ),
                        child: FlatButton(
                          height: 10,
                          onPressed: () {
                            Navigator.pushNamed(context, 'chatScreen');
                          },
                          child: Text(
                            'CHAT BOX',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Hang tight! The chat will become available 24 hours before the event!",
                        style: TextStyle(
                            fontSize: 12, fontStyle: FontStyle.italic),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
