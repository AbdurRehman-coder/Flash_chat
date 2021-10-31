import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  User? loggedInUser;
  String? messageText;
  final messageController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }
  void getCurrentUser() async{
   try{
    final currentUser = _auth.currentUser;
    if(currentUser != null){
    loggedInUser = currentUser;
    print(loggedInUser!.email);
    print(loggedInUser!.uid);
    }
   }catch (e){
     print(e);
   }
  }
  void getMessages() async{
    final messages = await _firestore.collection('messages').get();
     for(var message in messages.docs){
       print(message.data());
     }
  }
  //add data to auto generated document in 'messages' collection
  Future<void> addUser(){
    return _firestore.collection('messages').add({
      'sender' : loggedInUser!.email,
      'text'   : messageText,
    }).then((value) => print('added successfully:  $value')).catchError((error){
      print('error occurred $error');
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(

        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
                // _auth.signOut();
                // Navigator.pop(context);
                getMessages();
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Expanded(
          child: Column(
           // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.stretc,
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                   stream: _firestore.collection('messages').snapshots(),
                   builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                     // if(snapshot.hasData){
                     //   final data = snapshot.data!.docs;
                     //   List<Text> messageWidget = [];
                     //   for(var messages in data){
                     //     final message = Text('${messages['text']} from ${messages['sender']}');
                     //     messageWidget.add(message);
                     //   }
                     //   return Column(
                     //     children: messageWidget,
                     //   );
                     // }else {
                     //   return Center(
                     //     child: Text('loading'),
                     //   );
                     // }



                     if (snapshot.hasError) {
                       return Text('Something went wrong');
                     }

                     if (snapshot.connectionState == ConnectionState.waiting) {
                       return Text("Loading");
                     }
                      final data = snapshot.data!.docs.reversed;
                     return ListView(
                       reverse: true,
                       children: data.map((DocumentSnapshot document) {
                         Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                         return MessageBubbles(
                           text: data['text'],
                           sender: data['sender'],
                           isMe: loggedInUser!.email == data['sender'],
                         );
                       }).toList(),
                     );
                   },
                 ),
              ),
              Column(
                children: [
                  Container(
                    decoration: kMessageContainerDecoration.copyWith(
                      color: Colors.white
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: messageController,
                            onChanged: (value) {
                              messageText = value;
                            },
                            decoration: InputDecoration(
                              hintText: 'enter your message..',
                            ),
                            cursorColor: Colors.black,


                          ),
                        ),
                        TextButton(

                          onPressed: () {
                            addUser();
                            messageController.clear();
                          },
                          child: Text(
                            'Send',
                            style: kSendButtonTextStyle.copyWith(backgroundColor: Colors.white,
                            letterSpacing: 1.5),
                          ),
                        ),
                      ],
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

class MessageBubbles extends StatelessWidget {
  MessageBubbles({this.text, this.sender, this.isMe});
  String? text;
  String? sender;
  bool? isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
         crossAxisAlignment: isMe! ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(sender!, style: TextStyle(
            color: Colors.black54,
            fontSize: 14,
          ),),
          Material(

              color: isMe! ? Colors.lightBlueAccent : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(text!, style: TextStyle(
                  color: isMe! ? Colors.white : Colors.black,
                ),),
              )),
        ],
      ),
    );
  }
}