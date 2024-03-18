from django.shortcuts import render
from django.http import HttpResponse, JsonResponse
from django.views.decorators.csrf import csrf_exempt
from ..models import *


#Initiate Chat Between Buyer and Seller
@csrf_exempt
def InitiateChat(request):

    print("NEW CHAT INITATE REQUEST")

    try:
        # Make Sure it is POST Request
        if request.method == "POST":

            # Get the other data files
            Email = request.POST['Email']
            PrivateKey = request.POST['PrivateKey']
            SellerEmail = request.POST["SellerEmail"]

            # Check If Seller Email is not equal to Buyer Email
            if Email == SellerEmail:
                return JsonResponse({"status":"error", "message": "Buyer and Seller email can't be same."})

            # Get the User
            try:
                # Find the User with Email Address
                user = ApplicationUser.objects.get(email_address=Email)

                # Check the User Password
                if user.private_key != PrivateKey:
                    return JsonResponse({"status":"error", "message": "User is not Authenticated"})

                # Now we find the Seller using Seller email address
                seller = ApplicationUser.objects.get(email_address=SellerEmail)

                # Now we Create a new Chat Room between Seller and Buyer
                chat_room = Chat(Buyer=user, Seller = seller, LastMessage = "Hey! " + seller.full_name)
                chat_room.unviewCount = 1
                chat_room.unviewPerson = user
                chat_room.save()

                # Create a new Message
                message = ChatMessage(ChatRoom=chat_room, Sender=user, Message= "Hey! " + seller.full_name, Status="Send")

                # Display Message to the User
                return JsonResponse({"status":"success", "message":"Chat is initiated successfully!"})
            
            # If User not found        
            except ApplicationUser.DoesNotExist as e:
                return JsonResponse({"status":"error", "message": "User not found"})

    except Exception as e:
        return JsonResponse({"status":"error", "message": "User not found"})

    return JsonResponse({"status":"error", "message":"Invalid Request"})

# Buyer and Seller Send Message to Each other
@csrf_exempt
def sendMessage(request):
    print("NEW MESSAGE SEND REQUEST")

    try:
        # Make Sure it is POST Request
        if request.method == "POST":

            # Get the other data files
            Email = request.POST['Email']
            PrivateKey = request.POST['PrivateKey']
            ChatID = request.POST['ChatID']
            UserMessage = request.POST['Message']

            # Get the User
            try:
                # Find the User with Email Address
                user = ApplicationUser.objects.get(email_address=Email)

                # Check the User Password
                if user.private_key != PrivateKey:
                    return JsonResponse({"status":"error", "message": "User is not Authenticated"})

                # Get the Chat
                try:
                    chat = Chat.objects.get(id=ChatID)
                except Chat.DoesNotExist as e:
                    return JsonResponse({"status":"error", "message":"Chat does not exist"})

                # Check if User is in the Chat or not
                if chat.Buyer.email_address != user.email_address and chat.Seller.email_address != user.email_address:
                    return JsonResponse({"status":"error", "message":"User does not allowed in this chat"})

                # Save the Last Mesasge
                chat.unviewPerson = user
                chat.unviewCount = chat.unviewCount + 1
                chat.LastMessage = UserMessage
                chat.save()
                
                # Now we Store the Message in the Chat
                chat_message = ChatMessage(ChatRoom=chat, Sender=user, Status="Send", Message=UserMessage)
                chat_message.save()


                # Display Message to the User
                return JsonResponse({"status":"success", "message":"Message is Send Successfully!"})
            
            # If User not found        
            except ApplicationUser.DoesNotExist as e:
                return JsonResponse({"status":"error", "message": "User not found"})

    except Exception as e:
        return JsonResponse({"status":"error", "message": "User not found"})

    return JsonResponse({"status":"error", "message":"Invalid Request"})

# Get the Chat for the User
@csrf_exempt
def get_all_user_chat(request):
    print("NEW CHAT DATA REQUEST")

    try:
        # Make Sure it is POST Request
        if request.method == "POST":

            # Get the other data files
            Email = request.POST['Email']
            PrivateKey = request.POST['PrivateKey']

            # Get the User
            try:
                # Find the User with Email Address
                user = ApplicationUser.objects.get(email_address=Email)

                # Check the User Private Key
                if user.private_key != PrivateKey:
                    return JsonResponse({"status":"error", "message": "User is not Authenticated"})

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
                return JsonResponse({"status":"success", "message": responseData})
            
            # If User not found        
            except ApplicationUser.DoesNotExist as e:
                return JsonResponse({"status":"error", "message": "User not found"})

    except Exception as e:
        return JsonResponse({"status":"error", "message": "User not found" + str(e)})

    return JsonResponse({"status":"error", "message":"Invalid Request"})




# Get the Chat Messages for a corresponding chat
@csrf_exempt
def get_all_chat_messages(request):
    print("NEW CHAT MESSAGES REQUEST")

    try:
        # Make Sure it is POST Request
        if request.method == "POST":

            # Get the other data files
            Email = request.POST['Email']
            PrivateKey = request.POST['PrivateKey']
            ChatID = request.POST['ChatID']

            # Get the User
            try:
                # Find the User with Email Address
                user = ApplicationUser.objects.get(email_address=Email)

                # Check the User Private Key
                if user.private_key != PrivateKey:
                    return JsonResponse({"status":"error", "message": "User is not Authenticated"})

                # Now Get the Chat Room User is in
                try:
                    chatRoom = Chat.objects.get(id=int(ChatID))
                except Chat.DoesNotExist as e:
                    return JsonResponse({"status":"error", "message": "Chat room not found"})

                # Check if User is in the Chat or not
                if chatRoom.Buyer.email_address != user.email_address and chatRoom.Seller.email_address != user.email_address:
                    return JsonResponse({"status":"error", "message":"User does not allowed in this chat"})
                
                # Now we Get All the Messages in the Chat box
                messages = ChatMessage.objects.filter(ChatRoom=chatRoom)

                # Now we Make the JSON Data
                MessagesData = []
                for message in messages:
                    data = {
                            "Status": message.Status,
                            "Message": message.Message,
                            "Time": message.timestamp.strftime("%H:%M %p")
                    }
                    if message.Sender.email_address == Email:
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
                return JsonResponse({"status":"success", "message": MessagesData})
            
            # If User not found        
            except ApplicationUser.DoesNotExist as e:
                return JsonResponse({"status":"error", "message": "User not found"})

    except Exception as e:
        return JsonResponse({"status":"error", "message": "User not found"})

    return JsonResponse({"status":"error", "message":"Invalid Request"})



# Get the unviewed messages
@csrf_exempt
def get_all_unview_messages(request):
    print("NEW UNVIEWD MESSAGES REQUEST")

    try:
        # Make Sure it is POST Request
        if request.method == "POST":

            # Get the other data files
            Email = request.POST['Email']
            PrivateKey = request.POST['PrivateKey']
            ChatID = request.POST['ChatID']

            # Get the User
            try:
                # Find the User with Email Address
                user = ApplicationUser.objects.get(email_address=Email)

                # Check the User Private Key
                if user.private_key != PrivateKey:
                    return JsonResponse({"status":"error", "message": "User is not Authenticated"})

                # Now Get the Chat Room User is in
                try:
                    chatRoom = Chat.objects.get(id=int(ChatID))
                except Chat.DoesNotExist as e:
                    return JsonResponse({"status":"error", "message": "Chat room not found"})

                # Check if User is in the Chat or not
                if chatRoom.Buyer.email_address != user.email_address and chatRoom.Seller.email_address != user.email_address:
                    return JsonResponse({"status":"error", "message":"User does not allowed in this chat"})
                
                # Now we Get All the Messages in the Chat box
                messages = ChatMessage.objects.filter(ChatRoom=chatRoom)

                # Now we Make the JSON Data
                MessagesData = []
                for message in messages:
                    if message.Sender.email_address != Email and message.Status == "Send":
                        data = {
                                "Status": message.Status,
                                "Message": message.Message,
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
                return JsonResponse({"status":"success", "message": MessagesData})
            
            # If User not found        
            except ApplicationUser.DoesNotExist as e:
                return JsonResponse({"status":"error", "message": "User not found"})

    except Exception as e:
        return JsonResponse({"status":"error", "message": "User not found"})

    return JsonResponse({"status":"error", "message":"Invalid Request"})