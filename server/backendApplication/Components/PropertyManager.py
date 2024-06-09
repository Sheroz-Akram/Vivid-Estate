from ..models import *
from django.db.models import Q

# Components of the System
from .LocationSystem import *
from .Mail import *
from .FileHandler import *
from .VirtualVisitManager import *

class PropertyManager:

    def __init__(self):

        # Load Other Components
        self.geoInfomation = LocationSystem() # Helps in Location Service
        self.fileHandler = FileHandler() # Handles Files Storage
        self.virtualVisitManager = VirtualVisitManager() # Handles Virtual Visits of Property

    # Find the Property from Database
    def findProperty(self, propertyID):
        try:
            # Search Property
            property = Property.objects.get(pk=propertyID)

            return property
        except:
            raise Exception("Property Not Found")

    # Store New Property in to the database system
    def storeNewProperty(self, propertyData, seller: ApplicationUser):

        # Get Fields from Property Data
        try:
            PropertyType = propertyData['PropertyType']
            ListingType = propertyData['ListingType']
            LocationLatitude = propertyData['Location']['Latitude']
            LocationLongitude = propertyData['Location']['Longitude']
            Price = propertyData['Price']
            Size = propertyData['Size']
            Beds = propertyData['Beds']
            Floors = propertyData['Floors']
            Description = propertyData['Description']
        except:
            raise Exception("Error in POST Request")

        # Get the Address of the Property
        try:
            simpleLocation = self.geoInfomation.simpleLocation(LocationLatitude, LocationLongitude)
            detailLocation = self.geoInfomation.detailLocation(LocationLatitude, LocationLongitude)
        except:
            raise Exception("Unable to Get Property Address")

        # Create a new Property in Database
        try:
            newProperty = Property(
                seller = seller,
                description = Description,
                propertyType = PropertyType,
                listingType = ListingType,
                location = detailLocation,
                latitude = LocationLatitude,
                longitude = LocationLongitude,
                abstractLocation = simpleLocation,
                price = Price,
                size = Size,
                beds = Beds,
                floors = Floors,
                views =0,
                likes = 0
            )
            newProperty.save()
        except:
            raise Exception("Unable to save new property")

        # Send Mail to Seller about Property Added
        try:
            mail = Mail("Vivid Estate - Property Added")
            mail.addRecipients(seller.email_address)
            mail.setBody(
                f"""Dear {seller.full_name}! A new property is added by your account in Vivid Estate Application. Here are the detail:
                \nProperty Type: {newProperty.propertyType}
                \nListing Type: {newProperty.listingType}
                \nLocation: {simpleLocation}
                \nPrice: {newProperty.price}
                \nSize: {newProperty.size}, Beds: {newProperty.beds}, Floors: {newProperty.floors}
                \nIf you don't add this property please contact customer service. Thank You!
                \nbest regards,
                \nVivid Estate Team
                """
            )
            mail.sendMail()
        except:
            raise Exception("Unable to Send Mail")
        
        return newProperty

    # Edit The Stored Property in the System
    def EditProperty(self, propertyData, property: Property, seller: ApplicationUser):

        # Check If Seller has Access to Property
        if property.seller.id != seller.id:
            raise Exception("Permission Denied to Edit")

        # Get Fields from Property Data
        try:
            property.propertyType = propertyData['PropertyType']
            property.listingType = propertyData['ListingType']
            property.latitude = propertyData['Location']['Latitude']
            property.longitude = propertyData['Location']['Longitude']
            property.price = propertyData['Price']
            property.size = propertyData['Size']
            property.beds = propertyData['Beds']
            property.floors = propertyData['Floors']
            property.description = propertyData['Description']
        except:
            raise Exception("Error in POST Request")

        # Get the Address of the Property
        try:
            property.abstractLocation = self.geoInfomation.simpleLocation(propertyData['Location']['Latitude'], propertyData['Location']['Longitude'])
            property.location = self.geoInfomation.detailLocation(propertyData['Location']['Latitude'], propertyData['Location']['Longitude'])
        except:
            raise Exception("Unable to Get Property Address")

        # Now Save the Property
        try:
            property.save()
        except:
            raise Exception("Unable to Save Property")

        return property


    # Get the First Image of the Property
    def firstImage(self, property: Property):

        try:
            picture = PropertyImage.objects.filter(propertyID=property).first()
        except:
            raise Exception("Unable to get property image")
        
        return picture

    # Store New Image of the Property
    def addPropertyImage(self, imageFile, property: Property, seller: ApplicationUser):

        # Check If Seller has permission to add image
        if not self.checkSellerEditPermission(seller, property):
            raise Exception("Seller has no permission to add images")
        
        # Try to Save the File in Storage
        try:
            fileName = self.fileHandler.storeFile(imageFile)
        except:
            raise Exception("Unable to store property image")

        # Now Store the Property Location
        try:
            propertyImage = PropertyImage(
                imageLocation = fileName,
                propertyID = property
            )
            propertyImage.save()
        except:
            raise Exception("Unable to store property image location in database")

        return propertyImage

    # Get All the Images of the Property
    def propertyImages(self, property: Property):

        try:
            # Query the database
            images = PropertyImage.objects.filter(propertyID=property)

            # Check Property Count
            if images.count() == 0:
                raise Exception("No property images found")
            
            return images
        except Exception as e:
            print(str(e))
            raise Exception("Unable to get property images")


    # Toggle Property Like
    def toggleLike(self, property: Property, user: ApplicationUser):

        # Check if the Property is Already Liked or not
        if self.isLike(property, user):

            # Decrease the Like Counter
            property.likes = property.likes - 1
            property.save()

            # Unlike the Property
            Like.objects.filter(propertyID=property, user=user).first().delete()

            return "Property Unliked"

        else:

            # Increase the like counter
            property.likes = property.likes + 1
            property.save()

            # Like the Property
            like = Like(propertyID=property, user=user)
            like.save()

            return "Property Liked"

    # Get the list of favorite propertiesby user
    def favoriteProperties(self, user: ApplicationUser):

        # Query the Database
        try:
            properties = Favourite.objects.filter(user=user)
        except:
            raise Exception("Unable to get favorite property list")
        
        return properties

    # Get the List of Seller Properties
    def sellerProperties(self, seller: ApplicationUser):

        # Query The Database
        try:
            properties = Property.objects.filter(seller=seller)
        except:
            raise Exception("Unable to get favorite property list")
        
        return properties

    # Remove a Property from Seller Account and Database
    def removeProperty(self, property: Property, seller: ApplicationUser):

        # Check if user is the seller or not
        if property.seller.id != seller.id:
            raise Exception("Permission Denied to Delete Property")

        # Remove Images of the Property
        try:
            images = self.propertyImages(property)

            # Loop Through Each Image and Delete it
            if images.count() > 0:
                for image in images:
                    self.fileHandler.deleteFile(image.imageLocation)
        except:
            raise Exception("Unable to delete property images")
        
        # Remove the Virtual Visits
        try:
            visits = self.virtualVisitManager.virtualVisits(property)

            # Loop Through each and delete their files
            if visits.count() > 0:
                for visit in visits:
                    self.fileHandler.deleteFile(visit.fileLocation)
        except:
            raise Exception("Unable to delete virtual visits")
        
        # Now At Last Remove the Property from Database
        property.delete()

    # Add a Property to User Favorite List
    def addPropertyToFavorite(self, property: Property, user: ApplicationUser):

        # Check if Property is Already Favourite
        if self.isFavorite(property, user):
            raise Exception("Property already favourite")
        
        # Now Add to Favorite List
        favorite = Favourite(propertyID=property, user=user)
        favorite.save()

        return favorite

    # Add a Property to User Favorite List
    def removePropertyFromFavourite(self, property: Property, user: ApplicationUser):

        # Check if Property is Already Favourite
        if not self.isFavorite(property, user):
            raise Exception("Property not in favorite list")
        
        # Delete Favourite From Database
        Favourite.objects.filter(propertyID=property, user=user).first().delete()

    # Check If the Property is Liked or not by User
    def isLike(self, property: Property, user: ApplicationUser):

        try:
            # Query Database
            existing_like = Like.objects.filter(propertyID=property, user=user).first()

            # Return Result
            if existing_like:
                return True
            return False
        except:
            raise Exception("Not able to check if property is liked or not")

    # Check if the Property is Added to Favourite or Not
    def isFavorite(self, property: Property, user: ApplicationUser):
        
        try:
            # Query Database
            existing_favorite = Favourite.objects.filter(propertyID=property, user=user).first()

            # Return Result
            if existing_favorite:
                return True
            return False
        except:
            raise Exception("Not Able to Check if Property is Favorite or not")

    # Add a new review for Property
    def giveReview(self, property: Property, reviewPerson: ApplicationUser, comment, rating):

        # Store the new review
        try:
            review = PropertyReviews(
                propertyID=property, 
                reviewPerson=reviewPerson,
                comment=comment,
                rating=rating
            )
            review.save()
        except:
            raise Exception("unable to store review in database")
        
        return review
        
    # Get All Reviews of the Property
    def reviews(self, property: Property):
        
        # Query Database
        try:
            reviews = PropertyReviews.objects.filter(propertyID=property).order_by('-timestamp')
        except:
            raise Exception("Unable to retrive reviews from database")

        return reviews

    # Check If Seller Has Permission to Edit Property
    def checkSellerEditPermission(self, seller: ApplicationUser, property: Property):
        # Perform Check
        if seller.id == property.seller.id:
            return True
        return False


