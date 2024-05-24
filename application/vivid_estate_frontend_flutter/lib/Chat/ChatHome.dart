import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vivid_estate_frontend_flutter/Authentication/ServerInfo.dart';
import 'package:vivid_estate_frontend_flutter/Chat/ChatScreen.dart';
import 'package:vivid_estate_frontend_flutter/Classes/Chat.dart';
import 'package:vivid_estate_frontend_flutter/Classes/ChatManager.dart';
import 'package:vivid_estate_frontend_flutter/Classes/DisplayHelper.dart';

class ChatHome extends StatefulWidget {
  const ChatHome({super.key});

  @override
  State<ChatHome> createState() => _ChatHome();
}

class _ChatHome extends State<ChatHome> {
  // Chats Data to Display
  var server = ServerInfo();

  // All the Chat Availible
  ChatManager chatManager = ChatManager();
  var displayHelper = DisplayHelper();
  var isFirst = true;

  @override
  void initState() {
    super.initState();

    // Display Initial Loading Bar
    displayHelper.displayLoadingbar();
    getAllChats(context);

    // Periodic Chats Load After 2 Seconds Each
    Timer.periodic(const Duration(seconds: 2), (timer) {
      getAllChats(context);
    });
  }

  // Get All the Chats of the User from server
  void getAllChats(BuildContext context) async {
    // Get All the Chats from Server
    List<Chat> list = await chatManager.loadChats(context, chatManager, server);

    // Chat All Chat from Server
    setState(() {
      chatManager.setChatList(list);
    });

    // Stop the Loading Bar
    if (isFirst) {
      isFirst = false;
      displayHelper.stopLoadingBar(chatManager.getChatsLength() > 0);
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
      body: chatManager.getChatsLength() == 0
          // Display Message for Not Chat Availible
          ? const Align(
              alignment: Alignment.center,
              child: Text(
                "No Chat Found",
                style: TextStyle(fontSize: 20),
              ),
            )
          // Display All the Chats Availible
          : ListView.builder(
              itemBuilder: (context, index) {
                return SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    // Tap to Open Chat
                    child: InkWell(
                      onTap: () => {
                        // Navigate to Chat Screen
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                      title: chatManager
                                          .getChatData(index)
                                          .personName,
                                      ChatID:
                                          chatManager.getChatData(index).chatID,
                                      ProfilePicture: chatManager
                                          .getChatData(index)
                                          .personImage,
                                      lastScene: chatManager
                                          .getChatData(index)
                                          .lastTime,
                                      chatInfo: chatManager.getChatData(index),
                                    )))
                      },
                      // Chat Informtaion Display
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              chatManager.getChatData(index).personImage),
                          child: Column(
                            children: [
                              Container(
                                  margin:
                                      const EdgeInsets.only(top: 27, left: 26),
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
                          chatManager.getChatData(index).personName,
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          chatManager.getChatData(index).lastMessage,
                          style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                        trailing: Column(
                          children: [
                            Text(
                              chatManager.getChatData(index).lastTime,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            chatManager
                                        .getChatData(index)
                                        .unviewMessagesCount !=
                                    0
                                ? CircleAvatar(
                                    radius: 8,
                                    backgroundColor: Colors.green,
                                    child: Text(
                                      (chatManager
                                              .getChatData(index)
                                              .unviewMessagesCount)
                                          .toString(),
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
              itemCount: chatManager.getChatsLength(),
            ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
