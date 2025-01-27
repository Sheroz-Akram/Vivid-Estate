from django.db import models
from django.contrib import admin
from django.utils import timezone

# Choices given to the admin for the account status
AccountVerificationTypes = (
    ("Verified", "Verified"),
    ("Pending", "Pending"),
    ("Rejected", "Rejected"),
    ("Suspended", "Suspended")
)

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
    account_verification = models.CharField(max_length=20, choices=AccountVerificationTypes, default="Pending")
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
    
    # Total Number of Unview Messages
    def unViewCount(self, user: ApplicationUser):
        if self.unviewPerson.id != user.id:
            return 0
        return self.unviewCount
    
    # Get the Other Person of Chat Room
    def otherPerson(self, user: ApplicationUser):
        if self.Buyer.id == user.id:
            return self.Seller
        return self.Buyer

# Messages within Chat Room
class ChatMessage(models.Model):
    ChatRoom = models.ForeignKey(Chat, on_delete=models.CASCADE)
    Sender = models.ForeignKey(ApplicationUser, on_delete=models.CASCADE)
    Message = models.CharField(max_length=255)
    Type = models.CharField(max_length=255)
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
    ("House", "House"),
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
    abstractLocation = models.CharField(max_length=255)
    price = models.IntegerField()
    size = models.IntegerField()
    beds = models.IntegerField()
    floors = models.IntegerField()
    views = models.IntegerField()
    likes = models.IntegerField()
    timestamp = models.DateTimeField(auto_now_add=True) 

    def __str__(self):
        return "ID: " + str(self.id) + ">>\t\tDescription: " + ' '.join(self.description.split()[:5]) + "..." + "\t|\tType: " + self.propertyType + "\t|\tPrice: " + str(self.price)

    def days_ago(self):
        now = timezone.now()
        difference = now - self.timestamp
        return difference.days

# Store the images of the location
class PropertyImage(models.Model):
    imageLocation = models.CharField(max_length=255)
    propertyID = models.ForeignKey(Property, on_delete=models.CASCADE)

# Store Reviews of our property
class PropertyReviews(models.Model):
    propertyID = models.ForeignKey(Property, on_delete=models.CASCADE)
    reviewPerson = models.ForeignKey(ApplicationUser, on_delete=models.CASCADE)
    comment = models.TextField()
    rating = models.IntegerField()
    timestamp = models.DateTimeField(auto_now_add=True) 

    def __str__(self):
        return "ID: " + str(self.id) + ">>\t\tReview: " + ' '.join(self.comment.split()[:5]) + "..." + "\t|\tRating: " + str(self.rating) + "\t|\tPerson: " + str(self.reviewPerson.full_name)

# Store the Virtual Visit of the Property
class PropertyVirtualVisit(models.Model):
    propertyID = models.ForeignKey(Property, on_delete=models.CASCADE)
    title = models.CharField(max_length=255)
    dimension = models.CharField(max_length=255)
    fileLocation = models.CharField(max_length=255)
    views = models.IntegerField()

    def __str__(self):
        return "ID: " + str(self.id) + ">>\t\tRoom: " + ' '.join(self.title) + "..." + "\t|\tProperty: " + str(self.propertyID.id) + "\t|\tDimensions: " + str(self.dimension)

# Store the 2D Layout of the Property
class PropertyLayout(models.Model):
    propertyID = models.ForeignKey(Property, on_delete=models.CASCADE)
    title = models.CharField(max_length=255)
    fileLocation = models.CharField(max_length=255)
    views = models.IntegerField()

    def __str__(self):
        return "ID: " + str(self.id) + ">>\t\tRoom: " + ' '.join(self.title) + "..." + "\t|\tProperty: " + str(self.propertyID.id) + "\t|\tFile: " + str(self.fileLocation)

# Store the Favourite Properties of the User
class Favourite(models.Model):
    propertyID = models.ForeignKey(Property, on_delete=models.CASCADE)
    user = models.ForeignKey(ApplicationUser, on_delete=models.CASCADE)
    timestamp = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return "ID: " + str(self.id) + ">>\t\tPerson: " + self.user.full_name + "\t<---->\tProperty: " + str(self.propertyID.id)

# Store the Likes of the Property and By Whom
class Like(models.Model):
    propertyID = models.ForeignKey(Property, on_delete=models.CASCADE)
    user = models.ForeignKey(ApplicationUser, on_delete=models.CASCADE)
    timestamp = models.DateTimeField(auto_now_add=True) 

# Store the Report Request of the Buyer to Admin
class PropertyReport(models.Model):
    propertyID = models.ForeignKey(Property, on_delete=models.CASCADE)
    reportingUser = models.ForeignKey(ApplicationUser, on_delete=models.CASCADE)
    issueType = models.CharField(max_length=50)
    reportDetails = models.TextField()

# Store the Bids on Properties
class Bid(models.Model):
    propertyID = models.ForeignKey(Property, on_delete=models.CASCADE)
    bidder = models.ForeignKey(ApplicationUser, on_delete=models.CASCADE)
    bid_amount = models.FloatField()
    timestamp = models.DateTimeField(auto_now_add=True) 

