from ..modules.helper import *
from django.views.decorators.csrf import csrf_exempt
from ..models import *
from django.core.files.storage import FileSystemStorage
from django.conf import settings
import uuid
import os
import json


# Initiate a Chat Between Buyer and Seller
@csrf_exempt
def InitiateChat(request):

    # Check the User Authentications
    authResult = checkUserLogin(request=request)
    if authResult[0] == False:
        return httpErrorJsonResponse(authResult[1])

    # Now we Get the User
    user = authResult[1]
    
    # Now we Initiate chat with Seller and Buyer
    try:
        
        # Get the other data files
        Email = user.email_address
        SellerEmail = request.POST["SellerEmail"]

        # Check If Seller Email is not equal to Buyer Email
        if Email == SellerEmail:
            return httpErrorJsonResponse("Buyer and Seller same accounts found!")

        # Now we find the Seller using Seller email address
        seller = ApplicationUser.objects.get(email_address=SellerEmail)

        # Check is Buyer and Seller chat is already initiated or not
        if (Chat.objects.filter(Buyer=user, Seller=seller)).exists():
            # Already existing chat is found
            return httpErrorJsonResponse("Chat is already initiated. Can't create new")

        # Now we Create a new Chat Room between Seller and Buyer
        chat_room = Chat(Buyer=user, Seller = seller, LastMessage = "Hey! " + seller.full_name)
        chat_room.unviewCount = 1
        chat_room.unviewPerson = seller
        chat_room.save()

        responseMessage = {"fullName":chat_room.Seller.full_name, "profilePicture": chat_room.Seller.profile_pic ,"email":chat_room.Seller.email_address,"lastMessage":chat_room.LastMessage, "time": chat_room.modified.strftime("%H:%M %p"), "chatID": chat_room.id, "count": 0}

        # Display Message to the User
        return httpSuccessJsonResponse(responseMessage)
            
    # Something wrong just happen the process
    except Exception as e:
        return httpErrorJsonResponse("Error in the server or an invalid request")


# Buyer and Seller Send Message to Each other
@csrf_exempt
def sendMessage(request):

    # Check the User Authentications
    authResult = checkUserLogin(request=request)
    if authResult[0] == False:
        return httpErrorJsonResponse(authResult[1])

    # Now we Get the User
    user = authResult[1]

    # User is authenticated. Now Proceeds with the request
    try:
        # Get the other data files
        ChatID = request.POST['ChatID']
        UserMessage = request.POST['Message']

        # Check the User Chat Access
        userChatAuth = validUserChatAccess(user=user, chatID=ChatID)
        if userChatAuth[0] == False:
            # User is not Allowed ot Chat does not Exists
            return httpErrorJsonResponse(userChatAuth[1])
        
        # User is Allowed in this Chat
        chatRoom = userChatAuth[1]

        # Save the Last Mesasge
        chatRoom.unviewPerson = user
        chatRoom.unviewCount = chatRoom.unviewCount + 1
        chatRoom.LastMessage = UserMessage
        chatRoom.save()
            
        # Now we Store the Message in the Chat
        chat_message = ChatMessage(ChatRoom=chatRoom, Sender=user, Status="Send", Type="text", Message=UserMessage)
        chat_message.save()

        # Display Message to the User
        return httpSuccessJsonResponse("Message is send successfully")
        
    # Something wrong just happen the process
    except Exception as e:
        return httpErrorJsonResponse("Error in the server or an invalid request")

    

# Get the Chat for the User
@csrf_exempt
def get_all_user_chat(request):

    # Check the User Authentications
    authResult = checkUserLogin(request=request)
    if authResult[0] == False:
        return httpErrorJsonResponse(authResult[1])

    # Now we Get the User
    user = authResult[1]

    # User is Authenticated. Now move to our request
    try:
        # Now Get the Chat Room User is in
        chatsData = []
        responseData = []
        if user.user_type == "Buyer":
            chatsData = Chat.objects.filter(Buyer=user)
            for chatData in chatsData:
                if chatData.unviewPerson.email_address == user.email_address:
                    unviews = 0
                else:
                    unviews = chatData.unviewCount
                responseData.append({"fullName":chatData.Seller.full_name, "profilePicture": chatData.Seller.profile_pic ,"email":chatData.Seller.email_address,"lastMessage":chatData.LastMessage, "time": chatData.modified.strftime("%H:%M %p"), "chatID": chatData.id, "count": unviews})
        else:
            chatsData = Chat.objects.filter(Seller=user)
            for chatData in chatsData:
                if chatData.unviewPerson.email_address == user.email_address:
                    unviews = 0
                else:
                    unviews = chatData.unviewCount
                responseData.append({"fullName":chatData.Buyer.full_name, "profilePicture": chatData.Buyer.profile_pic ,"email":chatData.Buyer.email_address,"lastMessage":chatData.LastMessage , "time": chatData.modified.strftime("%H:%M %p"), "chatID": chatData.id, "count": unviews})

        # Display Message to the User
        return httpSuccessJsonResponse(responseData)
            
    # Something wrong just happen the process
    except Exception as e:
        return httpErrorJsonResponse("Error in the server or an invalid request")




# Get the Chat Messages for a corresponding chat
@csrf_exempt
def get_all_chat_messages(request):

    # Check the User Authentications
    authResult = checkUserLogin(request=request)
    if authResult[0] == False:
        return httpErrorJsonResponse(authResult[1])

    # Now we Get the User
    user = authResult[1]

    # User is authenticated now proceeds with our request
    try:

        # Get Chat ID from Request
        ChatID = request.POST['ChatID']

        # Check the User Chat Access
        userChatAuth = validUserChatAccess(user=user, chatID=ChatID)
        if userChatAuth[0] == False:
            # User is not Allowed ot Chat does not Exists
            return httpErrorJsonResponse(userChatAuth[1])
        
        # User is Allowed in this Chat
        chatRoom = userChatAuth[1]

        # Now we Get All the Messages in the Chat box
        messages = ChatMessage.objects.filter(ChatRoom=chatRoom)

        # Now we Make the JSON Data
        MessagesData = []
        for message in messages:
            data = {
                    "Status": message.Status,
                    "Message": message.Message,
                    "MessageType": message.Type,
                    "Time": message.timestamp.strftime("%H:%M %p")
            }
            if message.Sender.email_address == user.email_address:
                data['Type'] = "Send"
            else:
                data['Type'] = "Reply"
                message.Status = "Viewed"
                message.save()
            
            MessagesData.append(data)
        
        # Make the Unview Counter to 0
        if chatRoom.unviewPerson.email_address != user.email_address:
            chatRoom.unviewCount = 0
            chatRoom.save()


        # Display Message to the User
        return httpSuccessJsonResponse(MessagesData)
            
    # Something wrong just happen the process
    except Exception as e:
        return httpErrorJsonResponse("Error in the server or an invalid request")




# Get the unviewed messages
@csrf_exempt
def get_all_unview_messages(request):

    # Check the User Authentications
    authResult = checkUserLogin(request=request)
    if authResult[0] == False:
        return httpErrorJsonResponse(authResult[1])

    # Now we Get the User
    user = authResult[1]
    
    # User is Authenticated. Now we process our request
    try:

        # Get Chat ID of where user want new messages
        ChatID = request.POST['ChatID']

        # Check the User Chat Access
        userChatAuth = validUserChatAccess(user=user, chatID=ChatID)
        if userChatAuth[0] == False:
            # User is not Allowed ot Chat does not Exists
            return httpErrorJsonResponse(userChatAuth[1])
        
        # User is Allowed in this Chat
        chatRoom = userChatAuth[1]
        
        # Now we Get All the Messages in the Chat box
        messages = ChatMessage.objects.filter(ChatRoom=chatRoom)

        # Now we Make the JSON Data
        MessagesData = []
        for message in messages:
            if message.Sender.email_address != user.email_address and message.Status == "Send":
                data = {
                        "Status": message.Status,
                        "Message": message.Message,
                        "MessageType": message.Type,
                        "Time": message.timestamp.strftime("%H:%M %p")
                }
                data['Type'] = "Reply"
                message.Status = "Viewed"
                message.save()
                
                MessagesData.append(data)

        # Make the Unview Counter to 0
        if chatRoom.unviewPerson.email_address != user.email_address:
            chatRoom.unviewCount = 0
            chatRoom.save()

        # Display Message to the User
        return httpSuccessJsonResponse(MessagesData)
            

    # Something wrong just happen the process
    except Exception as e:
        return httpErrorJsonResponse("Error in the server or an invalid request")


@csrf_exempt
def deleteUserChat(request):

    # Check the User Authentications
    authResult = checkUserLogin(request=request)
    if authResult[0] == False:
        return httpErrorJsonResponse(authResult[1])
    
    # Now we Get the User
    user = authResult[1]

    # Now we get our profile picture
    try:

        # Get Chat ID of where user want new messages
        ChatID = request.POST['ChatID']

        # Check the User Chat Access
        userChatAuth = validUserChatAccess(user=user, chatID=ChatID)
        if userChatAuth[0] == False:
            # User is not Allowed ot Chat does not Exists
            return httpErrorJsonResponse(userChatAuth[1])
        
        # User is Allowed in this Chat
        chatRoom = userChatAuth[1]

        # Now we Delete the Chat
        chatRoom.delete()

        # Display Message to the User
        return httpSuccessJsonResponse("User Chat Deleted Successfully")

    # Something wrong just happen the process
    except Exception as e:
        return httpErrorJsonResponse("Error in the server or an invalid request")


# Store the file of the User Send in Server
@csrf_exempt
def StoreSendFile(request):

    # Check the User Authentications
    authResult = checkUserLogin(request=request)
    if authResult[0] == False:
        return httpErrorJsonResponse(authResult[1])

    # Now we Get the User
    user = authResult[1]

    # Now We Store the File Message in Our Server
    try:

        # Get the File Data
        sendFile = request.FILES['SendFile']
        ChatID = request.POST['ChatID']

        # Create or get an instance of FileSystemStorage to handle saving
        fs = FileSystemStorage(location=settings.FILESTORAGE)
        
        # Save the file directly
        fileNewName = "file_" + str(uuid.uuid4()) + sendFile.name
        filename = fs.save(fileNewName, sendFile)

        # We add the store the file data into json format in message
        UserMessage = json.dumps({"fileLocation": fileNewName, "fileName": sendFile.name})

        # Check the User Chat Access
        userChatAuth = validUserChatAccess(user=user, chatID=ChatID)
        if userChatAuth[0] == False:
            # User is not Allowed ot Chat does not Exists
            return httpErrorJsonResponse(userChatAuth[1])
        
        # User is Allowed in this Chat
        chatRoom = userChatAuth[1]

        # Save the Last Mesasge
        chatRoom.unviewPerson = user
        chatRoom.unviewCount = chatRoom.unviewCount + 1
        chatRoom.LastMessage = "File Transfered! " + sendFile.name
        chatRoom.save()
            
        # Now we Store the Message in the Chat
        chat_message = ChatMessage(ChatRoom=chatRoom, Sender=user, Status="Send", Type="file", Message=UserMessage)
        chat_message.save()

        return httpSuccessJsonResponse(UserMessage)

    # Something wrong just happen the process
    except Exception as e:
        return httpErrorJsonResponse("Error in the server or an invalid request")

