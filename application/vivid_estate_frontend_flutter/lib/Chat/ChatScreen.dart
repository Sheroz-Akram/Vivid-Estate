import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vivid_estate_frontend_flutter/Authentication/ServerInfo.dart';
import 'package:vivid_estate_frontend_flutter/Chat/Reply.dart';
import 'package:vivid_estate_frontend_flutter/Chat/Send.dart';
import 'package:vivid_estate_frontend_flutter/Chat/SendFileMessage.dart';
import 'package:vivid_estate_frontend_flutter/Classes/User.dart';
import 'package:vivid_estate_frontend_flutter/Helpers/Help.dart';
import 'package:file_picker/file_picker.dart';

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
  var server = ServerInfo();

  // Our User Object
  var user = User();

  @override
  void initState() {
    super.initState();

    getAllMessages(context);

    PageLoad();

    // Scoll to the Bottom
    scrollToBottom(_scoll_controller);

    // Get New Messages
    Timer.periodic(const Duration(seconds: 2), (timer) {
      getUnviewMessages(context);
    });
  }

  // Load All the Data of the Page
  void PageLoad() async {
    await user.getAuthData();
  }

  // Get all the Chat Messsages
  void getAllMessages(myContext) async {
    // Get Our Auth Data
    var authData = await server.getAuthData();
    authData['ChatID'] = (widget.ChatID).toString();

    // Send Data to Our Server
    server.sendPostRequest(myContext, "get_all_messages", authData, (result) {
      // Valid Request
      if (result['status'] == "success") {
        var data = result['message'];
        for (var i = 0; i < data.length; i++) {
          setState(() {
            messages = data;
            _send_controller.text = "";
          });
        }
        // Scoll to the Bottom
        scrollToBottom(_scoll_controller);
      }
    });
  }

  // Send Message to the Other User
  void getUnviewMessages(myContext) async {
    // Get Our Auth Data
    var authData = await server.getAuthData();
    authData['ChatID'] = (widget.ChatID).toString();

    // Send Data to Our Server
    server.sendPostRequest(myContext, "get_all_unview_messages", authData,
        (result) {
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
              "MessageType": data[i]['MessageType'],
              "Time": data[i]['Time'],
              "Type": data[i]['Type']
            });
          });
        }
        // Scoll to the Bottom
        scrollToBottom(_scoll_controller);
      }
    });
  }

  // Send Message to the Other User
  void sendMessage(myContext) async {
    // Check if Message not empty
    if (_send_controller.text == "") {
      ScaffoldMessenger.of(myContext).showSnackBar(
          const SnackBar(content: Text("Please Type as Message")));
      return;
    }

    // Get Our Auth Data
    var authData = await server.getAuthData();
    authData['ChatID'] = (widget.ChatID).toString();
    authData['Message'] = _send_controller.text;

    // Send Data to Our Server
    server.sendPostRequest(myContext, "send_message", authData, (result) {
      // Valid Request
      if (result['status'] == "success") {
        setState(() {
          messages.add({
            "Status": "Send",
            "Message": _send_controller.text,
            "MessageType": "text",
            "Time": "now",
            "Type": "Send"
          });
          _send_controller.text = "";
        });
        // Scoll to the Bottom
        scrollToBottom(_scoll_controller);
      }
    });
  }

  // Delete User Chat Function
  void deleteChat(myContext) async {
    // Get Our Auth Data
    var authData = await server.getAuthData();
    authData['ChatID'] = (widget.ChatID).toString();

    // Send Data to Our Server
    server.sendPostRequest(myContext, "delete_chat", authData, (result) {
      // Valid Request
      if (result['status'] == "success") {
        ScaffoldMessenger.of(myContext).showSnackBar(
            const SnackBar(content: Text("Chat deleted successfully")));

        Navigator.pop(myContext);
        Navigator.pop(myContext);
      }
    });
  }

  // Pick a file from the Menu
  dynamic pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      PlatformFile file = result!.files.first;
      return file;
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
                    deleteChat(context);
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
                      messages[index]['MessageType'] == "text"
                          // Display Text Messages
                          ? messages[index]['Type'] == "Reply"
                              ? Reply(
                                  message: messages[index]['Message'],
                                  time: messages[index]['Time'])
                              : Send(
                                  message: messages[index]['Message'],
                                  time: messages[index]['Time'],
                                  status: messages[index]['Status'])
                          // Display File Messages
                          : SendFileMessage(
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

                        // Add New Message to Our Status
                        setState(() {
                          messages.add({
                            "Status": "Send",
                            "Message": responseMessage,
                            "MessageType": "file",
                            "Time": "now",
                            "Type": "Send"
                          });
                          _send_controller.text = "";
                        });

                        // Scoll to the Bottom
                        scrollToBottom(_scoll_controller);
                      },
                      icon: const Icon(Icons.attach_file_sharp),
                      iconSize: MediaQuery.of(context).size.width * 0.10,
                      color: const Color(0xFF006E86),
                    ),

                    /**
                     * 
                     * Send Message BOX
                     * 
                     */
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.80,
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
                                sendMessage(context);
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
