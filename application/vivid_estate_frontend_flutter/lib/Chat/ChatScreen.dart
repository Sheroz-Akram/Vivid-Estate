import 'dart:async';
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
  // Store all the Messages
  var messages = [];
  final _send_controller = TextEditingController();
  final _scoll_controller = ScrollController();

  @override
  void initState() {
    super.initState();
    getAllMessages(context);

    scrollToBottom();

    // Get New Messages
    Timer.periodic(const Duration(seconds: 2), (timer) {
      getUnviewMessages(context);
    });
  }

  void scrollToBottom() {
    Timer(const Duration(seconds: 1), () {
      _scoll_controller.animateTo(
        _scoll_controller.position.maxScrollExtent,
        duration:
            const Duration(milliseconds: 500), // Adjust animation duration
        curve: Curves.easeOut, // Adjust animation curve
      );
    });
  }

  // Get all the Chat Messsages
  void getAllMessages(myContext) async {
    // Get the User Data
    var prefs = await SharedPreferences.getInstance();
    var userEmail = prefs.getString("userEmail");
    var userPrivateKey = prefs.getString("privateKey");
    // URL to Send Request
    var host = ServerInfo().host;
    var url = Uri.parse("$host/get_all_messages");
    try {
      // Our Request
      var response = await http.post(url, body: {
        'Email': userEmail,
        'PrivateKey': userPrivateKey,
        'ChatID': (widget.ChatID).toString()
      });

      // Get a Response from the Server
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);

        // Valid Request
        if (result['status'] == "success") {
          var data = result['message'];
          for (var i = 0; i < data.length; i++) {
            setState(() {
              messages = data;
              _send_controller.text = "";
            });
          }
          scrollToBottom();
        }
      } else {}
    }

    // Error Connecting to Server
    catch (e) {
      print(e);
    }
  }

  // Send Message to the Other User
  void getUnviewMessages(myContext) async {
    // Get the User Data
    var prefs = await SharedPreferences.getInstance();
    var userEmail = prefs.getString("userEmail");
    var userPrivateKey = prefs.getString("privateKey");
    // URL to Send Request
    var host = ServerInfo().host;
    var url = Uri.parse("$host/get_all_unview_messages");

    try {
      // Our Request
      var response = await http.post(url, body: {
        'Email': userEmail,
        'PrivateKey': userPrivateKey,
        'ChatID': (widget.ChatID).toString(),
      });

      // Get a Response from the Server
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);

        // Valid Request
        if (result['status'] == "success") {
          var data = result['message'];
          if (data.length > 0) {
            var i = messages.length - 1;
            while (messages[i]['Status'] == "Send") {
              messages[i]['Status'] = "Viewed";
              i--;
            }
          }
          for (var i = 0; i < data.length; i++) {
            setState(() {
              messages.add({
                "Status": data[i]['Status'],
                "Message": data[i]['Message'],
                "Time": data[i]['Time'],
                "Type": data[i]['Type']
              });
            });
          }
          scrollToBottom();
        }
      } else {}
    }

    // Error Connecting to Server
    catch (e) {
      print(e);
    }
  }

  // Send Message to the Other User
  void sendMessage(myContext) async {
    // Get the User Data
    var prefs = await SharedPreferences.getInstance();
    var userEmail = prefs.getString("userEmail");
    var userPrivateKey = prefs.getString("privateKey");
    // URL to Send Request
    var host = ServerInfo().host;
    var url = Uri.parse("$host/send_message");

    // Check if Message not empty
    if (_send_controller.text == "") {
      ScaffoldMessenger.of(myContext).showSnackBar(
          const SnackBar(content: Text("Please Type as Message")));
      return;
    }

    try {
      // Our Request
      var response = await http.post(url, body: {
        'Email': userEmail,
        'PrivateKey': userPrivateKey,
        'ChatID': (widget.ChatID).toString(),
        'Message': _send_controller.text
      });

      // Get a Response from the Server
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);

        // Valid Request
        if (result['status'] == "success") {
          setState(() {
            messages.add({
              "Status": "Send",
              "Message": _send_controller.text,
              "Time": "now",
              "Type": "Send"
            });
            _send_controller.text = "";
          });
          scrollToBottom();
        }
      } else {}
    }

    // Error Connecting to Server
    catch (e) {
      print(e);
    }
  }

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
        leadingWidth: MediaQuery.of(context).size.width * 0.90,
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
              height: 40,
              width: 40,
              child: CircleAvatar(
                backgroundImage: NetworkImage(widget.ProfilePicture),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Last seen ${widget.lastScene}",
                  textAlign: TextAlign.left,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
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
                child: ListView.builder(
                  controller: _scoll_controller,
                  itemBuilder: (context, index) =>
                      messages[index]['Type'] == "Reply"
                          ? Reply(
                              message: messages[index]['Message'],
                              time: messages[index]['Time'])
                          : Send(
                              message: messages[index]['Message'],
                              time: messages[index]['Time'],
                              status: messages[index]['Status']),
                  itemCount: messages.length,
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
                        controller: _send_controller,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: const Icon(
                                Icons.send_sharp,
                                color: Colors.blue,
                              ),
                              onPressed: () {
                                // Send a message to the User
                                sendMessage(context);
                              },
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
