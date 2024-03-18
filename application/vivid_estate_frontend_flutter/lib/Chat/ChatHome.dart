import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivid_estate_frontend_flutter/Authentication/ServerInfo.dart';
import 'package:vivid_estate_frontend_flutter/Chat/ChatScreen.dart';

class ChatHome extends StatefulWidget {
  const ChatHome({super.key});

  @override
  State<ChatHome> createState() => _ChatHome();
}

class _ChatHome extends State<ChatHome> {
  // Chats Data to Display
  var names = [];
  var messages = [];
  var img = [];
  var times = [];
  var chatID = [];
  var countMessages = [];

  @override
  void initState() {
    super.initState();
    getAllChats(context);

    // Get New Messages
    Timer.periodic(const Duration(seconds: 2), (timer) {
      getAllChats(context);
    });
  }

  void getAllChats(myContext) async {
    // Get the User Data
    var prefs = await SharedPreferences.getInstance();
    var userEmail = prefs.getString("userEmail");
    var userPrivateKey = prefs.getString("privateKey");

    // URL to Send Request
    var host = ServerInfo().host;
    var url = Uri.parse("$host/get_all_chats");
    try {
      // Our Request
      var response = await http
          .post(url, body: {'Email': userEmail, 'PrivateKey': userPrivateKey});

      // Get a Response from the Server
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);

        // Valid Request
        if (result['status'] == "success") {
          var data = result['message'];
          if (data.length > names.length) {
            for (var i = names.length; i < data.length; i++) {
              setState(() {
                names.add(data[i]['fullName']);
                messages.add(data[i]['lastMessage']);
                img.add(
                    "${ServerInfo().host}/static/" + data[i]['profilePicture']);
                times.add(data[i]['time']);
                chatID.add(data[i]['chatID']);
                countMessages.add(data[i]['count']);
              });
            }
          } else {
            for (var i = 0; i < data.length; i++) {
              setState(() {
                names[i] = data[i]['fullName'];
                messages[i] = data[i]['lastMessage'];
                times[i] = data[i]['time'];
                chatID[i] = data[i]['chatID'];
                countMessages[i] = data[i]['count'];
              });
            }
          }
        }
      } else {}
    }

    // Error Connecting to Server
    catch (e) {
      // Do Nothing
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Colors.white,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text(
          "Inbox",
          style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Color(0xFF5F5F5F)),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.notifications_rounded,
                size: 40, color: Color(0xFF006E86)),
            onPressed: () {
              print("notification");
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () => {
                  // Move to the Chat Screen
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatScreen(
                              title: names[index],
                              ChatID: chatID[index],
                              ProfilePicture: img[index],
                              lastScene: times[index])))
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(img[index]),
                    child: Column(
                      children: [
                        Container(
                            margin: const EdgeInsets.only(top: 27, left: 26),
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.green,
                            )),
                      ],
                    ),
                  ),
                  title: Text(
                    names[index],
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    messages[index],
                    style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                  ),
                  trailing: Column(
                    children: [
                      Text(
                        times[index],
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      countMessages[index] != 0
                          ? CircleAvatar(
                              radius: 8,
                              backgroundColor: Colors.green,
                              child: Text(
                                (countMessages[index]).toString(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          : const Text("")
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        itemCount: names.length,
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
