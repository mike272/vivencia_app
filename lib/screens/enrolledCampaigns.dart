import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInUser;
List<String> args = [];
dynamic data;

class EnrolledScreen extends StatefulWidget {
  @override
  _EnrolledScreenState createState() => _EnrolledScreenState();
}

class _EnrolledScreenState extends State<EnrolledScreen> {
  final db = _firestore.collection("smeData");
  String messageText;
  final _auth = FirebaseAuth.instance;
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

  void getData(CollectionReference db) async {
    try {
      final d = await db.get();
      var a = d.docs.reversed;
      // for (var i in a) print(i.data());
      // print(data.docs);
      data = a;
      //return data.docs.map(doc => doc.data());
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getCurrentUser();
    getData(db);
    for (var i in data) print(i.data());
    //print(data.docs);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('Enrolled Campaigns'),
        backgroundColor: kColorPurple,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            CampaignStream(),
            //MessagesStream(),
          ],
        ),
      ),
    );
  }
}

class CampaignBubble extends StatefulWidget {
  final location;
  final name;
  final type;
  final String imageLink;
  final String email; //SME's ID
  CampaignBubble(
    this.name,
    this.location,
    this.imageLink,
    this.type,
    this.email,
  );

  @override
  _CampaignBubbleState createState() => _CampaignBubbleState();
}

class _CampaignBubbleState extends State<CampaignBubble> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: FlatButton(
        onPressed: () {
          args.clear();
          args.add(this.widget.imageLink);
          args.add(this.widget.name);
          args.add(this.widget.location);
          args.add(this.widget.type);
          args.add(this.widget.email);
          Navigator.pushNamed(context, 'enrolledDetailsScreen',
              arguments: args);
        },
        child: Material(
          color: Colors.green,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12),
                      topLeft: Radius.circular(12)),
                  image: DecorationImage(
                    fit: BoxFit.fitWidth,
                    image: AssetImage(widget.imageLink),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.type,
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                        Text(
                          widget.location,
                          style: TextStyle(fontSize: 18, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Icon(
                      Icons.favorite_border,
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

class CampaignStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _firestore
          .collection("usersData")
          .doc(loggedInUser.email)
          .snapshots(),
      // ignore: missing_return
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Text(
            "You are currently not enrolled in any campaign!",
            style: TextStyle(fontSize: 40),
          );
        }
        final campaigns = snapshot.data["campaigns"];
        List<CampaignBubble> campaignBubbles = [];
        for (var camp in campaigns) {
          for (var place in data) {
            if (place["ID"] == camp) {
              //this is the campaign that the user is enrolled in
              //TODO:: change it because it is very unoptimal
              final address = place["address"];

              final ID = place["ID"];
              final city = place["city"];
              final name = place["name"];
              //TODO::  photos from web
              var imageLink;
              if (name == "Pizza Hut")
                imageLink = 'images/pizza.png';
              else if (name == "Thai Food")
                imageLink = 'images/tajskie.png';
              else
                imageLink = 'images/pierogi.png';
              final currentParticipants = place["currentParticipants"];
              final maxParticipants = place["maxCampaignParticipants"];
              final campaignBubble = CampaignBubble(
                  name, address + ", " + city, imageLink, "restaurant", ID);
              campaignBubbles.add(campaignBubble);
            }
          }
          //I iterate through campaigns that the user is enrolled in. each camp is a  SME ID

        }
        return Expanded(
            child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          children: campaignBubbles,
        ));
      },
    );
  }
}
