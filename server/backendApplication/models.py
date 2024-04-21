from django.db import models
from django.contrib import admin

# User model that store the data of both Buyer and Seller
class ApplicationUser(models.Model):
    private_key = models.CharField(max_length=60)
    profile_pic = models.CharField(max_length=255)
    full_name = models.CharField(max_length=150)
    email_address = models.EmailField(unique=True)
    user_name = models.CharField(unique=True, max_length=100)
    password = models.CharField(max_length=150)
    otp_code = models.CharField(max_length=4)
    langitude = models.FloatField()
    longitude = models.FloatField()
    location = models.CharField(max_length=255)
    verification_status = models.CharField(max_length=10)
    user_type = models.CharField(max_length=10)
    cnic_file = models.CharField(max_length=255)
    cnic_name = models.CharField(max_length=150)
    cnic_number = models.CharField(max_length=50)
    cnic_father_name = models.CharField(max_length=150)
    cnic_dob = models.CharField(max_length=50)
    feedback = models.FloatField()

    def __str__(self):
        return "ID: " + str(self.id) + ">>\t\tUser: " + self.full_name + "\t|\tEmail: " + self.email_address + "\t|\tType: " + self.user_type

class ApplicationUserAdmin(admin.ModelAdmin):
    search_fields = ['user_name__icontains', 'cnic_name__icontains', 'email_address__icontains']

# Chat Room with Buyer and Seller
class Chat(models.Model):
    Buyer = models.ForeignKey(ApplicationUser, on_delete=models.CASCADE, related_name="chat_as_buyer")
    Seller = models.ForeignKey(ApplicationUser, on_delete=models.CASCADE, related_name="chat_as_seller")
    LastMessage = models.CharField(max_length=255)
    modified = models.DateTimeField(auto_now=True)
    unviewCount = models.IntegerField()
    unviewPerson = models.ForeignKey(ApplicationUser, on_delete=models.CASCADE)

    def __str__(self):
        return "ID: " + str(self.id) + ">>\t\tBuyer: " + self.Buyer.full_name + "\t<---->\tSeller: " +self.Seller.full_name

# Messages within Chat Room
class ChatMessage(models.Model):
    ChatRoom = models.ForeignKey(Chat, on_delete=models.CASCADE)
    Sender = models.ForeignKey(ApplicationUser, on_delete=models.CASCADE)
    Message = models.CharField(max_length=255)
    Status = models.CharField(max_length=20)
    timestamp = models.DateTimeField(auto_now_add=True) 

    def __str__(self):
        return "ID: " + str(self.id) + ">>\t\tSender: " + self.Sender.full_name

# Choices given to the admin for the issue status
IssueChoices = (
    ("Unseen", "Unseen"),
    ("Pending", "Pending"),
    ("Resolved", "Resolved")
)

# Issues which are reported by the user
class Issue(models.Model):
    IssueType = models.CharField(max_length=50)
    IssueDate = models.CharField(max_length=50)
    IssueDetails = models.TextField()
    SubmitBy = models.ForeignKey(ApplicationUser, on_delete=models.CASCADE)
    ResolveStatus = models.CharField(max_length=20, choices=IssueChoices, default="Unseen")
    timestamp = models.DateTimeField(auto_now_add=True) 

    def __str__(self):
        return "ID: " + str(self.id) + ">>\t\tUser: " + self.SubmitBy.full_name + "\t|\tStatus: " + self.ResolveStatus 




# Listing Types
listingTypes = (
    ("Rent", "Rent"),
    ("Buy", "Buy"),
    ("N/A", "N/A")
)

# Property Types
propertyTypes = {
    ("House", "Hosue"),
    ("Appartment", "Appartment"),
    ("Hostel", "Hostel"),
    ("Room", "Room"),
    ("N/A", "N/A")
}

# Data of the property
class Property(models.Model):
    seller = models.ForeignKey(ApplicationUser, on_delete=models.CASCADE)
    description = models.TextField()
    propertyType = models.CharField(max_length=20, choices=propertyTypes, default="N/A")
    listingType = models.CharField(max_length=20, choices=listingTypes, default="N/A")
    location = models.CharField(max_length=255)
    latitude = models.FloatField()
    longitude = models.FloatField()
    price = models.IntegerField()
    size = models.IntegerField()
    beds = models.IntegerField()
    floors = models.IntegerField()
    views = models.IntegerField()
    likes = models.IntegerField()

    def __str__(self):
        return "ID: " + str(self.id) + ">>\t\tDescription: " + ' '.join(self.description.split()[:5]) + "..." + "\t|\tType: " + self.propertyType + "\t|\tPrice: " + str(self.price)

# Store the images of the location
class PropertyImage(models.Model):
    imageLocation = models.CharField(max_length=255)
    propertyID = models.ForeignKey(Property, on_delete=models.CASCADE)
