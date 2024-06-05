from ..modules.helper import *
from django.views.decorators.csrf import csrf_exempt
from ..models import *

# Import Application Components
from ..Components.UserComponent import *
from ..Components.ChatSystem import *

# Initiate a Chat Between Buyer and Seller
@csrf_exempt
def InitiateChat(request):
    
    # Log The Terminal
    print(f"=> Chat Initiation Request | IP: {request.META.get('REMOTE_ADDR')}")

    try:
        
        # Get the other data files
        Email = request.POST['Email']
        PrivateKey = request.POST['PrivateKey']
        SellerEmail = request.POST["SellerEmail"]

        try:

            # Create User Component for Buyer and Seller
            buyerUserComponent = UserComponent()
            sellerUserComponent = UserComponent()

            # Authenticate the Buyer
            buyerUserComponent.authenticateEmailPrivateKey(Email, PrivateKey)

            # Find the Seller Account
            sellerUserComponent.findUser(SellerEmail)

            # Create Chat Component and Initiate Chat
            chatSystem = ChatSystem()
            chatRoom = chatSystem.initiateChat(buyerUserComponent.getUserModel(), sellerUserComponent.getUserModel())

            # Generate a Response Message
            responseMessage = {
                "fullName":chatRoom.Seller.full_name,
                "profilePicture": chatRoom.Seller.profile_pic,
                "email":chatRoom.Seller.email_address,
                "lastMessage":chatRoom.LastMessage,
                "time": chatRoom.modified.strftime("%H:%M %p"),
                "chatID": chatRoom.id,
                "count": 0
            }

            # Send Response Message Back
            return httpSuccessJsonResponse(responseMessage)

        except Exception as e:
            return httpErrorJsonResponse(str(e))
            
    except Exception as e:
        print(f"-> Exception | {str(e)}")
        return JsonResponse({"status":"error", "message":"Invalid Request"})


# Buyer and Seller Send Message to Each other
@csrf_exempt
def sendMessage(request):

    # Log The Terminal
    print(f"=> Message Send Request | IP: {request.META.get('REMOTE_ADDR')}")

    try:
        # Get Data From POST Request
        Email = request.POST['Email']
        PrivateKey = request.POST['PrivateKey']
        ChatID = request.POST['ChatID']
        Message = request.POST['Message']

        try:

            # Create User Component for Sender
            senderUserComponent = UserComponent()

            # Authenticate the Sender
            senderUserComponent.authenticateEmailPrivateKey(Email, PrivateKey)

            # Create Chat Component and Get Chat Room
            chatSystem = ChatSystem()
            chatSystem.findChatRoom(ChatID)

            # Send Message Into Chat Room
            chatSystem.sendMessage(
                sender=senderUserComponent.getUserModel(),
                message=Message)

            return httpSuccessJsonResponse("Message Send")

        except Exception as e:
            print(str(e))
            return httpErrorJsonResponse(str(e))

    except Exception as e:
        print(f"-> Exception | {str(e)}")
        return JsonResponse({"status":"error", "message":"Invalid Request"})

# Store and Send File to Other User
@csrf_exempt
def StoreSendFile(request):

    # Log The Terminal
    print(f"=> Send File Message Request | IP: {request.META.get('REMOTE_ADDR')}")

    try:

        # Get Data From POST Request
        Email = request.POST['Email']
        PrivateKey = request.POST['PrivateKey']
        sendFile = request.FILES['SendFile']
        ChatID = request.POST['ChatID']

        try:
            # Create User Component for Sender
            senderUserComponent = UserComponent()

            # Authenticate the Sender
            senderUserComponent.authenticateEmailPrivateKey(Email, PrivateKey)

            # Create Chat Component and Get Chat Room
            chatSystem = ChatSystem()
            chatSystem.findChatRoom(ChatID)

            # Send the File Message of the User
            message = chatSystem.sendFileMessage(senderUserComponent.getUserModel(), sendFile)

            return httpSuccessJsonResponse(message.Message)

        except Exception as e:
            return httpErrorJsonResponse(str(e))

    except Exception as e:
        print(f"-> Exception | {str(e)}")
        return JsonResponse({"status":"error", "message":"Invalid Request"})

# Get the Chat for the User
@csrf_exempt
def get_all_user_chat(request):

    # Log The Terminal
    print(f"=> User Chats Information Request | IP: {request.META.get('REMOTE_ADDR')}")

    try:

        # Get Data From POST Request
        Email = request.POST['Email']
        PrivateKey = request.POST['PrivateKey']

        try:
            # Create User Component for User
            userComponent = UserComponent()

            # Authenticate the Sender
            userComponent.authenticateEmailPrivateKey(Email, PrivateKey)

            # Create Chat Component and Get Chat Room
            chatSystem = ChatSystem()

            # Get All the Chats
            chats = chatSystem.chats(userComponent.getUserModel())

            # Response Message Deliver to Client
            responseMessage = []

            # Loop Through Each Chat and Gather Information
            for chat in chats:

                # Get the Other Person For the Chat
                otherPerson = chat.otherPerson(userComponent.getUserModel())
                
                # Add to Response Message
                responseMessage.append({
        
                    "fullName": otherPerson.full_name,
                    "profilePicture": otherPerson.profile_pic,
                    "email": otherPerson.email_address,
                    "lastMessage":chat.LastMessage,
                    "time": chat.modified.strftime("%H:%M %p"),
                    "chatID": chat.id,
                    "count": chat.unViewCount(userComponent.getUserModel())
        
                })
            
            # Display Message to the User
            return httpSuccessJsonResponse(responseMessage)

        except Exception as e:
            print(str(e))
            return httpErrorJsonResponse(str(e))
            
    except Exception as e:
        print(f"-> Exception | {str(e)}")
        return JsonResponse({"status":"error", "message":"Invalid Request"})


# Get the Chat Messages for a corresponding chat
@csrf_exempt
def get_all_chat_messages(request):

    # Log The Terminal
    print(f"=> Chat Messages Query Request | IP: {request.META.get('REMOTE_ADDR')}")

    try:

        # Get Data From POST Request
        Email = request.POST['Email']
        PrivateKey = request.POST['PrivateKey']
        ChatID = request.POST['ChatID']

        try:
            # Create User Component for Sender
            userComponent = UserComponent()

            # Authenticate the Sender
            userComponent.authenticateEmailPrivateKey(Email, PrivateKey)

            # Create Chat Component and Get Chat Room
            chatSystem = ChatSystem()
            chatSystem.findChatRoom(ChatID)

            # Get All the Messages of the Chat
            messages = chatSystem.chatMessages(userComponent.getUserModel())

            # Send Back All Messages to Client
            MessagesData = []
            for message in messages:
                data = {
                        "Status": message.Status,
                        "Message": message.Message,
                        "MessageType": message.Type,
                        "Time": message.timestamp.strftime("%H:%M %p")
                }
                if message.Sender.email_address == userComponent.getUserModel().email_address:
                    data['Type'] = "Send"
                else:
                    data['Type'] = "Reply"
                    message.Status = "Viewed"
                    message.save()
                MessagesData.append(data)

            return httpSuccessJsonResponse(MessagesData)

        except Exception as e:
            return httpErrorJsonResponse(str(e))

    except Exception as e:
        print(f"-> Exception | {str(e)}")
        return JsonResponse({"status":"error", "message":"Invalid Request"})


# Get the unviewed messages
@csrf_exempt
def get_all_unview_messages(request):

    # Log The Terminal
    print(f"=> Unview Messages Request | IP: {request.META.get('REMOTE_ADDR')}")

    try:

        # Get Data From POST Request
        Email = request.POST['Email']
        PrivateKey = request.POST['PrivateKey']
        ChatID = request.POST['ChatID']

        try:
            # Create User Component for Sender
            userComponent = UserComponent()

            # Authenticate the Sender
            userComponent.authenticateEmailPrivateKey(Email, PrivateKey)

            # Create Chat Component and Get Chat Room
            chatSystem = ChatSystem()
            chatSystem.findChatRoom(ChatID)

            # Get All the Messages of the Chat
            messages = chatSystem.chatMessages(userComponent.getUserModel())

            # Now we Make the JSON Data
            MessagesData = []
            for message in messages:
                if message.Sender.id != userComponent.getUserModel().id and message.Status == "Send":
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

            # Display Message to the User
            return httpSuccessJsonResponse(MessagesData)

        except Exception as e:
            return httpErrorJsonResponse(str(e))

    except Exception as e:
        print(f"-> Exception | {str(e)}")
        return JsonResponse({"status":"error", "message":"Invalid Request"})


@csrf_exempt
def deleteUserChat(request):

    # Log The Terminal
    print(f"=> Complete Chat Deletion Request | IP: {request.META.get('REMOTE_ADDR')}")

    try:
        # Get Data From POST Request
        Email = request.POST['Email']
        PrivateKey = request.POST['PrivateKey']
        ChatID = request.POST['ChatID']

        try:

            # Create User Component for Sender
            userComponent = UserComponent()

            # Authenticate the Sender
            userComponent.authenticateEmailPrivateKey(Email, PrivateKey)

            # Create Chat Component and Get Chat Room
            chatSystem = ChatSystem()
            chatSystem.findChatRoom(ChatID)

            # Delete the Chat Data
            chatSystem.deleteChat(userComponent.getUserModel())

            return httpSuccessJsonResponse("Chat Deleted")
        
        except Exception as e:
            return httpErrorJsonResponse(str(e))

    except Exception as e:
        print(f"-> Exception | {str(e)}")
        return JsonResponse({"status":"error", "message":"Invalid Request"})




