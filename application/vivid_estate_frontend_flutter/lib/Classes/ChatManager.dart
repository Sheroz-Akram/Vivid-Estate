// Manages All the Chat in the Application
import 'package:flutter/cupertino.dart';
import 'package:vivid_estate_frontend_flutter/Authentication/ServerInfo.dart';
import 'package:vivid_estate_frontend_flutter/Classes/Chat.dart';

class ChatManager {
  // Our Class Attributes
  late List<Chat> chatList = []; // Store all the Chats

  // Add a new Chat to our Chat List
  void addNewChat(Chat newChat) {
    // Store the new Chat
    chatList.add(newChat);
  }

  // Return the List of Chats
  int getChatsLength() {
    return chatList.length;
  }

  // Update the Chat in the Index
  void updateChat(int index, Chat updatedChat) {
    // Store the Updated Chat in the Existing Index
    chatList[index] = updatedChat;
  }

  // Remove All the Chat in list
  void clearChats() {
    chatList.clear();
  }

  // Get the Data of Chat at Index
  Chat getChatData(int index) {
    return chatList[index];
  }

  // Load All Chats
  Future<List<Chat>> loadChats(BuildContext context, ChatManager chatManager,
      ServerInfo serverHelper) async {
    var authData = await ServerInfo().getAuthData();

    // Send Data to Our Server
    await serverHelper.sendPostRequest(context, "get_all_chats", authData,
        (result) {
      // Valid Request
      if (result['status'] == "success") {
        var data = result['message'];

        // Total Chat Availible
        var chatLength = chatManager.getChatsLength();

        // Store New Chats In Our List
        if (data.length > chatLength) {
          for (var i = chatLength; i < data.length; i++) {
            // Add Data to our Chat List
            chatManager.addNewChat(Chat(
                data[i]['chatID'],
                data[i]['fullName'],
                "${serverHelper.host}/static/" + data[i]['profilePicture'],
                data[i]['lastMessage'],
                data[i]['time'],
                data[i]['count']));
          }
        }
        // Clear All the Chats In the List
        else if (data.length < chatLength) {
          // Clear our Chat List
          chatManager.clearChats();
        }

        // Nor New Chat Add our Remove but check for changes in the Chat
        else {
          // Update All the Chats
          for (var i = 0; i < chatLength; i++) {
            // Update Chat at the Index
            chatManager.updateChat(
                i,
                Chat(
                    data[i]['chatID'],
                    data[i]['fullName'],
                    "${serverHelper.host}/static/" + data[i]['profilePicture'],
                    data[i]['lastMessage'],
                    data[i]['time'],
                    data[i]['count']));
          }
        }
      }
    });

    return chatList;
  }

  // Set the Chat List to Manager
  void setChatList(List<Chat> list) {
    chatList = list;
  }
}
