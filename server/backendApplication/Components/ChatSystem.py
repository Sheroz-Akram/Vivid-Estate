from ..models import *
from .FileHandler import *
import json

# System Component to Perform Chat Functionality
class ChatSystem:

    def __init__(self):

        # Helper Component
        self.fileHandler = FileHandler()

    # Find the Chat Room from Its ID
    def findChatRoom(self, ChatID):

        try:
            chatRoom = Chat.objects.get(id=int(ChatID))
        except Chat.DoesNotExist as e:
            raise Exception("Chat Room not Found")

        # Store the Chat Room
        self.chatRoom = chatRoom

        return chatRoom

    # Initiate a Chat between Buyer and Seller
    def initiateChat(self, buyer: ApplicationUser, seller: ApplicationUser):

        # Perform Chat Initiate Checks
        self.__chatInitiationChecks(buyer, seller)

        # Now Create a new Chat Room
        try:
            chatRoom = Chat(
                Buyer=buyer, 
                Seller = seller, 
                LastMessage = "Hey! " + seller.full_name,
                unviewCount = 1,
                unviewPerson = seller
            )
            chatRoom.save()
        except:
            raise Exception("Unable to create new chat room")

        # Store The Chat Room
        self.chatRoom = chatRoom

        return chatRoom
    
    # Perform Checks on Chat Room Creation
    def __chatInitiationChecks(self, buyer: ApplicationUser, seller: ApplicationUser):

        # Check If Have Same Account or Not
        if buyer.email_address == seller.email_address:
            raise Exception("Both same Account found")

        # Check if the User is Buyer or Not
        if buyer.user_type != "Buyer":
            raise Exception("Chat initiator is not Buyer")

        # Check the Other Person is Seller or not
        if seller.user_type != "Seller":
            raise Exception("Other Person must have to be Seller")

        # Check If Already Chat Initiated or not
        if (Chat.objects.filter(Buyer=buyer, Seller=seller)).exists():
            raise Exception("Chat is Already Initiated")

    # Get All the Messages from a Chat
    def chatMessages(self, user: ApplicationUser):

        # Check Is User is Allowed in this Chat Room or not
        self.__checkUserChatRoomAccess(self.chatRoom, user)

        try:    
            # Perform Database Query
            messages = ChatMessage.objects.filter(ChatRoom=self.chatRoom)
        except:
            raise Exception("Error in chat messages database")

        # Update our Chat Model
        try:
            if self.chatRoom.unviewPerson.id == user.id:
                self.chatRoom.unviewCount = 0
                self.chatRoom.save()
        except:
            raise Exception("Unable to Update Chat Room")
        
        return messages

    # Send a new Message into Chat Room
    def sendMessage(self, sender: ApplicationUser, message: str):

        # Check Is User is Allowed in this Chat Room or not
        self.__checkUserChatRoomAccess(self.chatRoom, sender)

        # Update the Chat Room
        try:
            # Store the Unview Person
            if sender.user_type == "Buyer":
                unviewPerson = self.chatRoom.Seller
            else:
                unviewPerson = self.chatRoom.Buyer

            # Update Chat Room
            self.chatRoom.unviewPerson = unviewPerson
            self.chatRoom.unviewCount = self.chatRoom.unviewCount + 1
            self.chatRoom.LastMessage = message
            self.chatRoom.save()

        except:
            raise Exception("Unable to update Chat Room")

        # Create a New Message
        try:
            chatMessage = ChatMessage(
                ChatRoom=self.chatRoom,
                Sender=sender,
                Status="Send",
                Type="text",
                Message=message
            )
            chatMessage.save()
        except:
            raise Exception("Not Able to Send Message")
        
        return chatMessage

    
    # Send a Message File To Other User in Chat Room
    def sendFileMessage(self, sender: ApplicationUser, fileData: str):

        # Check Is User is Allowed in this Chat Room or not
        self.__checkUserChatRoomAccess(self.chatRoom, sender)

        # Store the File in Server
        try:
            fileName = self.fileHandler.storeFile(fileData)
        except:
            raise Exception("Unable to Store File Message")

        # Create a File Message
        userFileMessage = json.dumps(
        {
            "fileLocation": fileName,
            "fileName": fileData.name
        })

        # Update the Chat Room
        try:
            # Store the Unview Person
            if sender.user_type == "Buyer":
                unviewPerson = self.chatRoom.Seller
            else:
                unviewPerson = self.chatRoom.Buyer

            # Update Chat Room
            self.chatRoom.unviewPerson = unviewPerson
            self.chatRoom.unviewCount = self.chatRoom.unviewCount + 1
            self.chatRoom.LastMessage = f"File Transfered! {fileData.name}"
            self.chatRoom.save()

        except:
            raise Exception("Unable to update Chat Room")

        # Create a New Message
        try:
            chatMessage = ChatMessage(
                ChatRoom=self.chatRoom,
                Sender=sender,
                Status="Send",
                Type="file",
                Message=userFileMessage
            )
            chatMessage.save()
        except:
            raise Exception("Not Able to Send Message")
        
        return chatMessage

    # Delete a Chat Room
    def deleteChat(self, user: ApplicationUser):

        # Check if User has Permission
        self.__checkUserChatRoomAccess(self.chatRoom, user)

        # Delete All Files in Chat
        try:

            # Perform Database Query
            messages = ChatMessage.objects.filter(ChatRoom=self.chatRoom,Type="file")

            # Loop Through All Files Messages
            for message in messages:

                # Get the Location of File
                fileLocation = json.loads(message.Message)['fileLocation']

                # Delete File
                self.fileHandler.deleteFile(fileLocation)

        except:
            raise Exception("Unable to delete chat files")

        # Delete the Chat Room
        try:
            self.chatRoom.delete()
        except:
            raise Exception("Unable to delete chat room")


    # Check If user has Access to Chat Room or Not
    def __checkUserChatRoomAccess(self, chatRoom: Chat, user: ApplicationUser):

        # Check If the user is Buyer
        if chatRoom.Buyer.email_address != user.email_address and chatRoom.Seller.email_address != user.email_address:
            raise Exception("User not allowed on chat")

    # Getters
    def getChatRoom(self):
        return self.chatRoom