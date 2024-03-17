from django.db import models

# Create your models here.
class ApplicationUser(models.Model):
    private_key = models.CharField(max_length=60)
    profile_pic = models.CharField(max_length=255)
    full_name = models.CharField(max_length=150)
    email_address = models.EmailField(unique=True)
    user_name = models.CharField(unique=True, max_length=100)
    password = models.CharField(max_length=150)
    otp_code = models.CharField(max_length=4)
    verification_status = models.CharField(max_length=10)
    user_type = models.CharField(max_length=10)
    cnic_file = models.CharField(max_length=255)
    cnic_name = models.CharField(max_length=150)
    cnic_number = models.CharField(max_length=50)
    cnic_father_name = models.CharField(max_length=150)
    cnic_dob = models.CharField(max_length=50)

    def __str__(self):
        return "User: " + self.full_name + "    Email: " +self.email_address

# Chat Room with Buyer and Seller
class Chat(models.Model):
    Buyer = models.ForeignKey(ApplicationUser, on_delete=models.CASCADE, related_name="chat_as_buyer")
    Seller = models.ForeignKey(ApplicationUser, on_delete=models.CASCADE, related_name="chat_as_seller")
    LastMessage = models.CharField(max_length=255)
    modified = models.DateTimeField(auto_now=True)
    unviewCount = models.IntegerField()
    unviewPerson = models.ForeignKey(ApplicationUser, on_delete=models.CASCADE)

    def __str__(self):
        return "Buyer: " + self.Buyer.email_address + "    Seller: " +self.Seller.email_address

# Messages within Chat Room
class ChatMessage(models.Model):
    ChatRoom = models.ForeignKey(Chat, on_delete=models.CASCADE)
    Sender = models.ForeignKey(ApplicationUser, on_delete=models.CASCADE)
    Message = models.CharField(max_length=255)
    Status = models.CharField(max_length=20)
    timestamp = models.DateTimeField(auto_now_add=True) 

    def __str__(self):
        return "Sender: " + self.Sender.email_address + "    Message: " +self.Message
