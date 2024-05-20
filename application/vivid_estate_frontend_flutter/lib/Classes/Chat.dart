import 'package:flutter/material.dart';
import 'package:vivid_estate_frontend_flutter/Authentication/ServerInfo.dart';
import 'package:vivid_estate_frontend_flutter/Classes/DisplayHelper.dart';

class Chat {
  // Chat Information
  var chatID;
  var personName;
  var personImage;
  var lastMessage;
  var lastTime;
  var unviewMessagesCount;

  // Store Messages of the User
  List<Message> messageList = [];

  var server = ServerInfo(); // Helper Class to Communicate with server
  var displayHelper =
      DisplayHelper(); // Helps to Display Messages on the screen

  // Constructor
  Chat(this.chatID, this.personName, this.personImage, this.lastMessage,
      this.lastTime, this.unviewMessagesCount);

  // Get Length of All Messages
  int getTotalMessages() {
    return messageList.length;
  }

  // Set the Message List
  void setMessages(List<Message> list) {
    messageList = list;
  }

  // Get a Specific Message from its Index
  Message getMessage(int index) {
    return messageList[index];
  }

  // Get All the Messages
  Future<List<Message>> getMessages(BuildContext context) async {
    // Get Our Auth Data
    var authData = await server.getAuthData();
    authData['ChatID'] = (chatID).toString();

    // Completely Clear Our Chat List
    messageList.clear();

    // Send Data to Our Server
    await server.sendPostRequest(context, "get_all_messages", authData,
        (result) {
      // Valid Request
      if (result['status'] == "success") {
        var data = result['message'];
        for (var i = 0; i < data.length; i++) {
          // Add a new Messages to Our List
          messageList.add(Message(
              Status: data[i]['Status'],
              MessageContent: data[i]['Message'],
              MessageType: data[i]['MessageType'],
              Time: data[i]['Time'],
              Type: data[i]['Type']));
        }
      }
    });

    return messageList;
  }

  // Retrive all teh Unview Messages of the Chat And Also Store them
  Future<List<Message>> getNewMessages(BuildContext context) async {
    // Get Our Auth Data
    var authData = await server.getAuthData();
    authData['ChatID'] = (chatID).toString();

    // Send Data to Our Server
    await server.sendPostRequest(context, "get_all_unview_messages", authData,
        (result) {
      // Valid Request
      if (result['status'] == "success") {
        var data = result['message'];

        // Update the Status Of Previous Messages
        if (data.length > 0) {
          var i = getTotalMessages() - 1;
          while (getMessage(i).Status == "Send") {
            getMessage(i).Status = "Viewed";
            i--;
          }
        }

        // Add New Messages
        for (var i = 0; i < data.length; i++) {
          // Add New Unview Messages to our List
          messageList.add(Message(
              Status: data[i]['Status'],
              MessageContent: data[i]['Message'],
              MessageType: data[i]['MessageType'],
              Time: data[i]['Time'],
              Type: data[i]['Type']));
        }
      }
    });

    return messageList;
  }

  // Send a messages to Other User
  Future<List<Message>> sendMessage(
      BuildContext context, String messageContent, String messageType) async {
    // Check if Message not empty
    if (messageContent.isEmpty) {
      displayHelper.displaySnackBar(
          "Please Type Message to Send", false, context);
      return messageList;
    }

    // Get Our Auth Data
    var authData = await server.getAuthData();
    authData['ChatID'] = (chatID).toString();
    authData['Message'] = messageContent;

    // Send Data to Our Server
    await server.sendPostRequest(context, "send_message", authData, (result) {
      // Valid Request
      if (result['status'] == "success") {
        // Add the New Send Message to our list
        messageList.add(Message(
            Status: "Send",
            MessageContent: messageContent,
            MessageType: messageType,
            Time: "now",
            Type: "Send"));
      }
    });

    return messageList;
  }
}

class Message {
  // Attributes to Store Message Data
  var Status;
  var MessageContent;
  var MessageType;
  var Time;
  var Type;

  // Contructor for our Messages
  Message(
      {required this.Status,
      required this.MessageContent,
      required this.MessageType,
      required this.Time,
      required this.Type});
}
