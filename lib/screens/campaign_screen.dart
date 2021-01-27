import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInUser;
List<String> args = [];

class CampaignScreen extends StatefulWidget {
  @override
  _CampaignScreenState createState() => _CampaignScreenState();
}

class _CampaignScreenState extends State<CampaignScreen> {
  //final messageTextController = TextEditingController();
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

  @override
  void initState() {
    // TODO: implement initState
    getCurrentUser();
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
                //Implement logout functionality
              }),
          //TODO:log out
          // IconButton(
          //     icon: Icon(Icons.close),
          //     onPressed: () {
          //       _auth.signOut();
          //       Navigator.pop(context);
          //       //Implement logout functionality
          //     }),
        ],
        title: Text('Active Campaigns'),
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
          Navigator.pushNamed(context, 'campaignDetailsScreen',
              arguments: args);
        },
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
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection("smeData").orderBy("city").snapshots(),
      // ignore: missing_return
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text(
            "No campaigns available at the moment, please come back later",
            style: TextStyle(fontSize: 40),
          );
        }
        final campaigns = snapshot.data.docs.reversed;
        List<CampaignBubble> campaignBubbles = [];
        for (var camp in campaigns) {
          final address = camp.data()["address"];
          final ID = camp.data()["ID"];
          final city = camp.data()["city"];
          final name = camp.data()["name"];
          //TODO::  photos from web
          var imageLink;
          if (name == "Pizza Hut")
            imageLink = 'images/pizza.png';
          else if (name == "Thai Food")
            imageLink = 'images/tajskie.png';
          else
            imageLink = 'images/pierogi.png';
          final currentParticipants = camp.data()["currentParticipants"];
          final maxParticipants = camp.data()["maxCampaignParticipants"];
          final campaignBubble = CampaignBubble(
              name, address + ", " + city, imageLink, "restaurant", ID);
          campaignBubbles.add(campaignBubble);
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
