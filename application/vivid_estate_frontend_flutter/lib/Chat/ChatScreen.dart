import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivid_estate_frontend_flutter/Authentication/ServerInfo.dart';
import 'package:vivid_estate_frontend_flutter/Chat/Reply.dart';
import 'package:vivid_estate_frontend_flutter/Chat/Send.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen(
      {super.key,
      required this.title,
      required this.ChatID,
      required this.ProfilePicture,
      required this.lastScene});
  final String title;
  final int ChatID;
  final String ProfilePicture;
  final String lastScene;

  @override
  State<ChatScreen> createState() => _ChatScreen();
}

class _ChatScreen extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Colors.white,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        leadingWidth: 120,
        actions: <Widget>[
          PopupMenuButton<String>(itemBuilder: (BuildContext context) {
            return [
              const PopupMenuItem(
                value: "1",
                child: Text("Delete Chat"),
              )
            ];
          })
        ],

        leading: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_sharp,
                  size: 30, color: Colors.blue),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(
              height: 60,
              width: 60,
              child: CircleAvatar(
                backgroundImage: NetworkImage(widget.ProfilePicture),
              ),
            ),
          ],
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Text(
              "Last seen ${widget.lastScene}",
              textAlign: TextAlign.left,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),
      ),
      body: Container(
          padding: const EdgeInsets.only(top: 10),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 80),
                child: ListView(
                  shrinkWrap: true,
                  children: const [
                    Reply(message: "How are you!", time: "12:90"),
                    Send(
                        message: "This is a Message",
                        time: "12:00",
                        status: "Send"),
                    Reply(message: "How are you!", time: "12:90"),
                    Send(
                        message: "This is a Message",
                        time: "12:00",
                        status: "Send"),
                    Reply(message: "How are you!", time: "12:90"),
                    Send(
                        message: "This is a Message",
                        time: "12:00",
                        status: "Send"),
                    Reply(message: "How are you!", time: "12:90"),
                    Send(
                        message: "This is a Message",
                        time: "12:00",
                        status: "Send"),
                    Reply(message: "How are you!", time: "12:90"),
                    Send(
                        message: "This is a Message",
                        time: "12:00",
                        status: "Send"),
                    Reply(message: "How are you!", time: "12:90"),
                    Send(
                        message: "This is a Message",
                        time: "12:00",
                        status: "Send"),
                    Reply(message: "How are you!", time: "12:90"),
                    Send(
                        message: "This is a Message",
                        time: "12:00",
                        status: "Send"),
                    Reply(message: "How are you!", time: "12:90"),
                    Send(
                        message: "This is a Message",
                        time: "12:00",
                        status: "Send"),
                    Reply(message: "How are you!", time: "12:90"),
                    Send(
                        message: "This is a Message",
                        time: "12:00",
                        status: "Send"),
                    Reply(message: "How are you!", time: "12:90"),
                    Send(
                        message: "This is a Message",
                        time: "12:00",
                        status: "Send"),
                    Reply(message: "How are you!", time: "12:90"),
                    Send(
                        message: "This is a Message",
                        time: "12:00",
                        status: "Send"),
                    Reply(message: "How are you!", time: "12:90"),
                    Send(
                        message: "This is a Message",
                        time: "12:00",
                        status: "Send"),
                    Reply(message: "How are you!", time: "12:90"),
                    Send(
                        message: "This is a Message",
                        time: "12:00",
                        status: "Send"),
                    Reply(message: "How are you!", time: "12:90"),
                    Send(
                        message: "This is a Message",
                        time: "12:00",
                        status: "Send"),
                    Reply(message: "How are you!", time: "12:90"),
                    Send(
                        message: "This is a Message",
                        time: "12:00",
                        status: "Send"),
                    Reply(message: "How are you!", time: "12:90"),
                    Send(
                        message: "This is a Message",
                        time: "12:00",
                        status: "Send")
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        print("upload file");
                      },
                      icon: const Icon(Icons.attach_file_sharp),
                      iconSize: MediaQuery.of(context).size.width * 0.10,
                      color: Colors.blue,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.80,
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: const Icon(
                                Icons.send_sharp,
                                color: Colors.blue,
                              ),
                              onPressed: () {},
                            ),
                            hintText: "Type a message",
                            contentPadding: const EdgeInsets.all(5),
                            border: InputBorder.none,
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                            )),
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
