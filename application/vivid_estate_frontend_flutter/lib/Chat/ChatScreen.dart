import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vivid_estate_frontend_flutter/Authentication/ServerInfo.dart';
import 'package:vivid_estate_frontend_flutter/Chat/Reply.dart';
import 'package:vivid_estate_frontend_flutter/Chat/ReplyBidMessage.dart';
import 'package:vivid_estate_frontend_flutter/Chat/ReplyFileMessage.dart';
import 'package:vivid_estate_frontend_flutter/Chat/Send.dart';
import 'package:vivid_estate_frontend_flutter/Chat/SendBidMessage.dart';
import 'package:vivid_estate_frontend_flutter/Chat/SendFileMessage.dart';
import 'package:vivid_estate_frontend_flutter/Classes/Chat.dart';
import 'package:vivid_estate_frontend_flutter/Classes/User.dart';
import 'package:vivid_estate_frontend_flutter/Helpers/Help.dart';
import 'package:file_picker/file_picker.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen(
      {super.key,
      required this.title,
      required this.ChatID,
      required this.ProfilePicture,
      required this.lastScene,
      required this.chatInfo});
  final String title;
  final int ChatID;
  final String ProfilePicture;
  final String lastScene;

  // Information About the Chat With Other User
  final Chat chatInfo;

  @override
  State<ChatScreen> createState() => _ChatScreen();
}

class _ChatScreen extends State<ChatScreen> {
  final _send_controller = TextEditingController();
  final _scoll_controller = ScrollController();
  var server = ServerInfo();

  // Our User Object
  var user = User();
  late Chat chat;

  @override
  void initState() {
    super.initState();

    // Store Our Chat Information
    chat = widget.chatInfo;

    // Get the Complete Messages of all the User
    GetCompleteMessages(context, _scoll_controller);

    // Get New Messages from the Server
    Timer.periodic(const Duration(seconds: 2), (timer) {
      // Periodic Update Our Message List
      GetNewMessages(context, _scoll_controller);
    });
  }

  // Get the Complete List of Messages from the Server
  void GetCompleteMessages(
      BuildContext context, ScrollController scrollController) async {
    // Retrive All the Messages
    List<Message> messageList = await chat.getMessages(context);

    // Update Our Views
    setState(() {
      chat.setMessages(messageList);
    });

    // Scoll to the Bottom
    scrollToBottom(scrollController);
  }

  void GetNewMessages(
      BuildContext context, ScrollController scrollController) async {
    // Retrive All the Messages
    List<Message> messageList = await chat.getNewMessages(context);

    // Update Our Views
    setState(() {
      chat.setMessages(messageList);
    });

    // Scoll to the Bottom
    scrollToBottom(scrollController);
  }

  // Send Message to the Other User
  void sendMessage(BuildContext context, String message,
      ScrollController scrollController, String messageType) async {
    // Now We Send Message to Our Server
    List<Message> messageList =
        await chat.sendMessage(context, message, messageType);

    // Now We Update Our State
    setState(() {
      chat.setMessages(messageList);
    });

    // Clear our text area
    _send_controller.text = "";

    // Scoll to the Bottom
    scrollToBottom(scrollController);
  }

  // Delete User Chat Function
  void DeleteChat(BuildContext context) async {
    // Send Our Request to Server
    if (await chat.deleteChat(context) == true) {
      // Display Message To Our User
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Chat deleted successfully")));

      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  // Pick a file from the Menu
  dynamic pickFile() async {
    try {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(withData: true);

      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;
        return file;
      } else {
        return null; // No file selected or result is null
      }
    } catch (e) {
      print('Error picking file: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leadingWidth: MediaQuery.of(context).size.width * 0.90,
        actions: <Widget>[
          PopupMenuButton<String>(itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                value: "1",
                child: InkWell(
                  onTap: () {
                    DeleteChat(context);
                  },
                  child: const Text("Delete Chat"),
                ),
              )
            ];
          })
        ],
        leading: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_sharp,
                  size: 30, color: Color(0xFF006E86)),
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
              /**
               * 
               * Display All the Messages Between User
               * 
               */
              Container(
                margin: const EdgeInsets.only(bottom: 80),
                child: ListView.builder(
                  controller: _scoll_controller,
                  itemBuilder: (context, index) =>

                      // Check Between Text Messages and Files
                      chat.getMessage(index).MessageType == "text"
                          // Display Text Messages
                          ? chat.getMessage(index).Type == "Reply"
                              ? Reply(
                                  message:
                                      chat.getMessage(index).MessageContent,
                                  time: chat.getMessage(index).Time)
                              : Send(
                                  message:
                                      chat.getMessage(index).MessageContent,
                                  time: chat.getMessage(index).Time,
                                  status: chat.getMessage(index).Status)
                          :
                          // Again Perform Chat To Find Wheter it is Bid Message or File Message
                          chat.getMessage(index).MessageType == "file"
                              ?
                              // File Message
                              chat.getMessage(index).Type == "Reply"
                                  ? ReplyFileMessage(
                                      message:
                                          chat.getMessage(index).MessageContent,
                                      time: chat.getMessage(index).Time)
                                  : SendFileMessage(
                                      message:
                                          chat.getMessage(index).MessageContent,
                                      time: chat.getMessage(index).Time,
                                      status: chat.getMessage(index).Status)
                              :
                              // Bid Message

                              chat.getMessage(index).Type == "Reply"
                                  ? ReplyBidMessage(
                                      message:
                                          chat.getMessage(index).MessageContent,
                                      time: chat.getMessage(index).Time)
                                  : SendBidMessage(
                                      message:
                                          chat.getMessage(index).MessageContent,
                                      time: chat.getMessage(index).Time,
                                      status: chat.getMessage(index).Status),
                  itemCount: chat.getTotalMessages(),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    /**
                     * 
                     * Send a file Icon Buttom
                     */
                    IconButton(
                      onPressed: () async {
                        // Pick a File
                        PlatformFile fileData = await pickFile();

                        // Send File to Server
                        var responseMessage = await user.SendPickedFile(
                            fileData.bytes!,
                            fileData.name,
                            (widget.ChatID).toString(),
                            context);

                        // Now we Send a Message to Server
                        chat.AddNewMessage(Message(
                            Status: "Send",
                            MessageContent: responseMessage,
                            MessageType: "file",
                            Time: "now",
                            Type: "Send"));

                        // Now We Update Our State
                        var messageList = chat.messageList;
                        setState(() {
                          chat.setMessages(messageList);
                        });

                        // Scoll to the Bottom
                        scrollToBottom(_scoll_controller);
                      },
                      icon: const Icon(Icons.attach_file_sharp),
                      iconSize: 50,
                      color: const Color(0xFF006E86),
                    ),

                    /**
                     * 
                     * Send Message BOX
                     * 
                     */
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 80,
                      child: TextFormField(
                        controller: _send_controller,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: const Icon(
                                Icons.send_sharp,
                                color: Color(0xFF006E86),
                              ),
                              onPressed: () {
                                // Send a message to the User
                                sendMessage(context, _send_controller.text,
                                    _scoll_controller, "text");
                              },
                            ),
                            hintText: "Type a message",
                            contentPadding: const EdgeInsets.all(5),
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
