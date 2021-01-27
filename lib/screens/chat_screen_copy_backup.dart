// import 'package:flutter/material.dart';
// import 'package:flash_chat/constants.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// final _firestore = FirebaseFirestore.instance;
// User loggedInUser;
//
// class ChatScreen extends StatefulWidget {
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   final messageTextController = TextEditingController();
//   String messageText;
//   final _auth = FirebaseAuth.instance;
//
//   void getCurrentUser() async {
//     try {
//       final user = await _auth.currentUser;
//       if (user != null) {
//         loggedInUser = user;
//       }
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     getCurrentUser();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: null,
//         actions: <Widget>[
//           IconButton(
//               icon: Icon(Icons.close),
//               onPressed: () {
//                 _auth.signOut();
//                 Navigator.pop(context);
//                 //Implement logout functionality
//               }),
//         ],
//         title: Text('Version 0.1'),
//         backgroundColor: Colors.lightBlueAccent,
//       ),
//       body: SafeArea(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             MessagesStream(),
//             Container(
//               decoration: kMessageContainerDecoration,
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   Expanded(
//                     child: TextField(
//                       controller: messageTextController,
//                       onChanged: (value) {
//                         messageText = value;
//                         //Do something with the user input.
//                       },
//                       decoration: kMessageTextFieldDecoration,
//                     ),
//                   ),
//                   FlatButton(
//                     onPressed: () {
//                       messageTextController.clear();
//                       _firestore.collection('messages').add({
//                         'text': messageText,
//                         'sender': loggedInUser.email,
//                         'timestamp': FieldValue.serverTimestamp(),
//                       });
//                       //Implement send functionality.
//                     },
//                     child: Text(
//                       'Send',
//                       style: kSendButtonTextStyle,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class MessageBubble extends StatelessWidget {
//   final text;
//   final sender;
//   final bool isMe;
//   MessageBubble(this.sender, this.text, this.isMe);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.all(10),
//       child: Column(
//         crossAxisAlignment:
//         isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//         children: [
//           Text(
//             sender,
//             style: TextStyle(fontSize: 12, color: Colors.black54),
//           ),
//           Material(
//             borderRadius: isMe
//                 ? BorderRadius.only(
//                 topLeft: Radius.circular(30),
//                 bottomLeft: Radius.circular(30),
//                 topRight: Radius.circular(30))
//                 : BorderRadius.only(
//                 topLeft: Radius.circular(30),
//                 bottomRight: Radius.circular(30),
//                 topRight: Radius.circular(30)),
//             elevation: 5,
//             child: Padding(
//               padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//               child: Text(
//                 text,
//                 style: TextStyle(
//                     color: isMe ? Colors.white : Colors.black54, fontSize: 18),
//               ),
//             ),
//             color: isMe ? Colors.lightBlueAccent : Colors.white,
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class MessagesStream extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: _firestore
//           .collection('messages')
//           .orderBy('timestamp', descending: false)
//           .snapshots(),
//       // ignore: missing_return
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return CircularProgressIndicator(
//             backgroundColor: Colors.lightBlueAccent,
//           );
//         }
//         final messages = snapshot.data.docs.reversed;
//         List<MessageBubble> messageBubbles = [];
//         for (var message in messages) {
//           final messageText = message.data()['text'];
//           final messageSender = message.data()['sender'];
//           final currentUser = loggedInUser.email;
//           final messageBubble = MessageBubble(
//               messageSender, messageText, currentUser == messageSender);
//           messageBubbles.add(messageBubble);
//         }
//         return Expanded(
//           child: ListView(
//             reverse: true,
//             padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
//             children: messageBubbles,
//           ),
//         );
//       },
//     );
//   }
// }
