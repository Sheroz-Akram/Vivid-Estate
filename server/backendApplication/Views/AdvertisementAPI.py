from django.shortcuts import render
from django.http import HttpResponse, JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.conf import settings
from ..modules.ocr import getCnicDetails
from ..modules.mail import send_email
from ..modules.helper import *
import uuid
import os
from django.core.files.storage import FileSystemStorage
from ..models import *
import random
import string
from geopy.geocoders import Nominatim
import json
from django.db.models import Q


# Create your views here.

# API to Store the New Property In the Server
@csrf_exempt
def StoreNewAd(request):
    # Check the User Authentications
    authResult = checkUserLogin(request=request)
    if authResult[0] == False:
        return httpErrorJsonResponse(authResult[1])

    # Now we Get the User
    user = authResult[1]

    # Now We Store the new property ad in the server
    try:

        # Get All the Data
        propertyData = json.loads(request.POST['PropertyData'])
        PropertyType = propertyData['PropertyType']
        ListingType = propertyData['ListingType']
        LocationLatitude = propertyData['Location']['Latitude']
        LocationLongitude = propertyData['Location']['Longitude']
        Price = propertyData['Price']
        Size = propertyData['Size']
        Beds = propertyData['Beds']
        Floors = propertyData['Floors']
        Description = propertyData['Description']

        # Locate the location of the property
        geolocator = Nominatim(user_agent="VividEstate")
        location = geolocator.reverse((LocationLatitude, LocationLongitude),language="en")
        address = location.raw['address']
        littleLocation = address['suburb'] + ", " + address['district'] + ", " + address['state']

        # Create a new Property Add
        propertyNew = Property(
            seller = user,
            description = Description,
            propertyType = PropertyType,
            listingType = ListingType,
            location = location,
            latitude = LocationLatitude,
            longitude = LocationLongitude,
            abstractLocation = littleLocation,
            price = Price,
            size = Size,
            beds = Beds,
            floors = Floors,
            views =0,
            likes = 0
        )

        propertyNew.save()

        # Store the Pictures in the Server
        for x in range(1, int(request.POST['PicturesCount']) + 1):

            # Get the Image Data
            imageFile = request.FILES['PropertyImage' + str(x)]

            # Create or get an instance of FileSystemStorage to handle saving
            fs = FileSystemStorage(location=settings.FILESTORAGE)
            
            # Save the file directly
            fileNewName = "file_" + str(uuid.uuid4()) + imageFile.name
            filename = fs.save(fileNewName, imageFile)

            # Store the Property Image Location in the Server
            propertyImagesLocation = PropertyImage(
                imageLocation = fileNewName,
                propertyID = propertyNew
            )

            propertyImagesLocation.save()

        return httpSuccessJsonResponse("Success: New Add Created")

    # Something wrong just happen the process
    except Exception as e:
        
        return httpErrorJsonResponse("Error: Invalid Request")


# Search the properties based upon the user query
@csrf_exempt
def SearchLocationProperty(request):

    # Perform the Search Operation
    try:

        # Get all the Data
        Query = request.POST['Query']

        # Search
        results = Property.objects.filter(Q(location__icontains=Query))

        # Now Combine all the Data Into Json Response
        SearchData = {}

        # Locate the location of the property
        geolocator = Nominatim(user_agent="VividEstate")

        # Display the data in the specific page
        SearchData['SearchItems'] = []
        unique_predictions = set()  # Set to store unique predictions

        # Go Through each property find the resutls and only display properties in the same area
        for searchProperty in results:
            prediction = completeWordSearch(Query, searchProperty.location).strip().title().rstrip(',')
            if prediction not in unique_predictions:  # Check if prediction is not already added
                SearchData['SearchItems'].append(prediction)
                unique_predictions.add(prediction)

        # Store the count of search items
        SearchData['SearchCount'] = SearchData['SearchItems'].__len__()
        SearchData['TotalCount'] = results.count()

        # Send JSON data back to the client
        return httpSuccessJsonResponse(SearchData)
    
    # Something wrong just happen the process
    except Exception as e:
        return httpErrorJsonResponse("Error: Invalid Request")


# Search the properties based upon the user query
@csrf_exempt
def DetailSearchQuery(request):

    # Perform the Search Operation
    try:

        # Get all the Data
        Query = request.POST['Query']
        Filter = request.POST['Filter']

        # Search
        results = Property.objects.filter(Q(location__icontains=Query))

        # Now Combine all the Data Into Json Response
        SearchData = {}

        # Display the data in the specific page
        SearchData['SearchItems'] = []

        # Loop Through all the Properties find in the search
        for searchProperty in results:

            # Get the First Picture of the Property
            picture = PropertyImage.objects.filter(propertyID=searchProperty).first()
            
            # Add Property Details to our result
            SearchData['SearchItems'].append({
                "PropertyID": searchProperty.id,
                "Price": searchProperty.price,
                "Location": searchProperty.abstractLocation,
                "Picture": picture.imageLocation,
                "Type": searchProperty.propertyType
            })
            

        # Store the count of search items
        SearchData['SearchCount'] = SearchData['SearchItems'].__len__()

        # Send JSON data back to the client
        return httpSuccessJsonResponse(SearchData)
    
    # Something wrong just happen the process
    except Exception as e:
        return httpErrorJsonResponse("Error: Invalid Request" + str(e))

    
# Get the complete detail of the property
@csrf_exempt
def GetPropertyDetail(request):

    # Check the User Authentications
    authResult = checkUserLogin(request=request)
    if authResult[0] == False:
        return httpErrorJsonResponse(authResult[1])

    # Now we Get the User
    user = authResult[1]

    # Perform the Search Operation
    try:

        # Get all the Data
        PropertyID = request.POST['PropertyID']

        try:
            # Search The Property using its ID
            result = Property.objects.get(pk=PropertyID)
        except Exception as e:
            return httpErrorJsonResponse("Error: Invalid Request")

        # Now Send the Details of the Property Back to Client
        message = {
            "PropertyID": PropertyID,
        }

        # Now we get all the Images of the property
        pictures = PropertyImage.objects.filter(propertyID=result)

        # Add Images to Our Response
        message['Images'] = []
        message['TotalImages'] = pictures.count()
        for picture in pictures:
            message['Images'].append(picture.imageLocation)

        # Get the Seller of the Property
        seller = result.seller

        # Check if the Property is Added to Favourite or Not
        existing_favorite = Favourite.objects.filter(propertyID=result, user=user).first()
        isFavourite = False
        if existing_favorite:
            isFavourite = True

        # Check if the Property is Added to Favourite or Not
        existing_like = Like.objects.filter(propertyID=result, user=user).first()
        isLike = False
        if existing_like:
            isLike = True

        # Update the View Count
        result.views = result.views + 1
        result.save()

        # Now Add Other Data to our Response
        message['PropertyType'] = result.propertyType
        message['Description'] = result.description
        message['ListingType'] = result.listingType
        message['Location'] = result.abstractLocation
        message['Price'] = result.price
        message['Size'] = result.size
        message['Beds'] = result.beds
        message['Floors'] = result.floors
        message['Views'] = result.views
        message['Likes'] = result.likes
        message['SellerPicture'] = seller.profile_pic
        message['SellerName'] = seller.full_name
        message['SellerEmail'] = seller.email_address
        message['IsFavourite'] = isFavourite
        message['IsLike'] = isLike


        # Send JSON data back to the client
        return httpSuccessJsonResponse(message)
    
    # Something wrong just happen the process
    except Exception as e:
        return httpErrorJsonResponse("Error: Invalid Request")


# Get the complete detail of the property
@csrf_exempt
def GetPropertyReviews(request):

    # Check the User Authentications
    authResult = checkUserLogin(request=request)
    if authResult[0] == False:
        return httpErrorJsonResponse(authResult[1])

    # Now We Perform Our Operation
    try:

        # Get all the Data
        PropertyID = request.POST['PropertyID']

        try:
            # Search The Property using its ID
            result = Property.objects.get(pk=PropertyID)
        except Exception as e:
            return httpErrorJsonResponse("Error: Invalid Request. Property Not Found.")

        # Now Send the Details of the Property Back to Client
        message = {
            "PropertyID": PropertyID,
        }

        # Now We Get All The Reviews of the Property
        reviews = PropertyReviews.objects.filter(propertyID=result).order_by('-timestamp')
        message['Reviews'] = []
        message['ReviewsCount'] = 0

        # Store The Reviews In Message
        if reviews.count() > 0:
            message['ReviewsCount'] = reviews.count()
            
            # Loop Through All The Reviews and Store them One by One
            for review in reviews:
                message['Reviews'].append({
                    "ReviewID": review.id,
                    "PersonName": review.reviewPerson.full_name,
                    "PersonImage": review.reviewPerson.profile_pic,
                    "ReviewTime": review.timestamp.strftime("%m/%d/%Y"),
                    "ReviewRating": review.rating,
                    "ReviewComment": review.comment
                })

        # Send JSON data back to the client
        return httpSuccessJsonResponse(message)
    
    # Something wrong just happen the process
    except Exception as e:
        return httpErrorJsonResponse("Error: Invalid Request")

# Store the Review of the Property in server
@csrf_exempt
def StorePropertyReview(request):

    # Check the User Authentications
    authResult = checkUserLogin(request=request)
    if authResult[0] == False:
        return httpErrorJsonResponse(authResult[1])
    
    # Now we Get the User
    user = authResult[1]

    # Now We Perform Our Operation
    try:

        # Get all the Data
        PropertyID = request.POST['PropertyID']
        ReviewComment = request.POST['ReviewComment']
        ReviewRating = request.POST['ReviewRating']

        try:
            # Search The Property using its ID
            result = Property.objects.get(pk=PropertyID)
        except Exception as e:
            return httpErrorJsonResponse("Error: Invalid Request. Property Not Found.")

        # Now We Create another Review. As Property and User Verified
        review = PropertyReviews(
            propertyID=result, 
            reviewPerson=user,
            comment= ReviewComment,
            rating= ReviewRating
        )

        # Save the Review To Database
        review.save()

        # Send JSON data back to the client
        return httpSuccessJsonResponse("Review for the property is saved.")
    
    # Something wrong just happen the process
    except Exception as e:
        return httpErrorJsonResponse("Error: Invalid Request")

# API to Add the Property to Favourite List by Buyer
@csrf_exempt
def AddToFavourite(request):

    # Check the User Authentications
    authResult = checkUserLogin(request=request)
    if authResult[0] == False:
        return httpErrorJsonResponse(authResult[1])

    # Now we Get the User
    user = authResult[1]

    # Now We Add the Property to our List
    try:

        # Get the POST Data from user
        PropertyID = request.POST['PropertyID']

        # Now We get the property through its id
        try:
            # Search The Property using its ID
            result = Property.objects.get(pk=PropertyID)
        except Exception as e:
            return httpErrorJsonResponse("Property Not Found")

        # Check if the user has already favorited the property
        existing_favorite = Favourite.objects.filter(propertyID=result, user=user).first()

        if existing_favorite:
            # If the user has already favorited the property, return a response indicating it
            return httpSuccessJsonResponse('Property already added')
        else:
            # Add new favorite to the list
            favouriteProperty = Favourite(propertyID=result, user=user)
            favouriteProperty.save()
            return httpSuccessJsonResponse('Property added to favorites')

    # Something wrong just happen the process
    except Exception as e:
        return httpErrorJsonResponse("Invalid Request")


# Likes the Property by the Buyer
@csrf_exempt
def LikeProperty(request):

    # Check the User Authentications
    authResult = checkUserLogin(request=request)
    if authResult[0] == False:
        return httpErrorJsonResponse(authResult[1])

    # Now we Get the User
    user = authResult[1]

    # Now We Add the Property to our List
    try:
        # Get the POST Data from user
        PropertyID = request.POST['PropertyID']

        # Now We get the property through its id
        try:
            # Search The Property using its ID
            result = Property.objects.get(pk=PropertyID)
        except Exception as e:
            return httpErrorJsonResponse("Property Not Found")

        # Check if the user has already likes the property
        existing_favorite = Like.objects.filter(propertyID=result, user=user).first()

        if existing_favorite:
            # If the user has already favorited the property, return a response indicating it
            return httpSuccessJsonResponse('Property already liked')
        else:
            # Decrease the Like Counter of our Property
            result.likes = result.likes + 1
            result.save()
            # Add new favorite to the list
            favouriteProperty = Like(propertyID=result, user=user)
            favouriteProperty.save()
            return httpSuccessJsonResponse('Property is Liked')

    # Something wrong just happen the process
    except Exception as e:
        return httpErrorJsonResponse("Invalid Request")

# API to Remove the Property from Favourite List
@csrf_exempt
def RemoveFromFavourite(request):

    # Check the User Authentications
    authResult = checkUserLogin(request=request)
    if authResult[0] == False:
        return httpErrorJsonResponse(authResult[1])

    # Now we Get the User
    user = authResult[1]

    # Now We Add the Property to our List
    try:

        # Get the POST Data from user
        PropertyID = request.POST['PropertyID']

        # Now We get the property through its id
        try:
            # Search The Property using its ID
            result = Property.objects.get(pk=PropertyID)
        except Exception as e:
            return httpErrorJsonResponse("Property Not Found")

        # Check if the user has already favorited the property
        existing_favorite = Favourite.objects.filter(propertyID=result, user=user).first()

        # Is the Property is List Exists
        if existing_favorite:
            existing_favorite.delete()
            return httpSuccessJsonResponse('Property Remove from Favourite List')
        else:
            return httpErrorJsonResponse('Property is not in Favourite List')

    # Something wrong just happen the process
    except Exception as e:
        
        return httpErrorJsonResponse("Invalid Request")


# API to Remove the Property from Favourite List
@csrf_exempt
def UnLikeProperty(request):

    # Check the User Authentications
    authResult = checkUserLogin(request=request)
    if authResult[0] == False:
        return httpErrorJsonResponse(authResult[1])

    # Now we Get the User
    user = authResult[1]

    # Now We Add the Property to our List
    try:

        # Get the POST Data from user
        PropertyID = request.POST['PropertyID']

        # Now We get the property through its id
        try:
            # Search The Property using its ID
            result = Property.objects.get(pk=PropertyID)
        except Exception as e:
            return httpErrorJsonResponse("Property Not Found")

        # Check if the user has already likes the property
        existing_like = Like.objects.filter(propertyID=result, user=user).first()

        

        # If the Property is Already Liked
        if existing_like:
            # Decrease the Like Counter of our Property
            result.likes = result.likes - 1
            result.save()
            # Remove the likes data
            existing_like.delete()
            return httpSuccessJsonResponse('Property is unliked.')
        else:
            return httpErrorJsonResponse('Property is not Liked Previously.')

    # Something wrong just happen the process
    except Exception as e:
        
        return httpErrorJsonResponse("Invalid Request")


# Get the list of favourite properties
@csrf_exempt
def GetFavouritePropertiesList(request):

    # Check the User Authentications
    authResult = checkUserLogin(request=request)
    if authResult[0] == False:
        return httpErrorJsonResponse(authResult[1])

    # Now we Get the User
    user = authResult[1]

    # Now We Find the List and Send Data Back To Client
    try:

        # Find all the Favourite Properties

        # Check if the user has already favorited the property
        favourite_properties = Favourite.objects.filter(user=user)

        # Now We Prase Each Favourite Property and Get Usefull Information
        message = {
            "PropertiesCount": favourite_properties.count(),
            "Properties" : []
        }
        if favourite_properties.count() > 0:
            # Loop Through Each Property
            for favourite in favourite_properties:

                # Get the Image of the Property
                picture = PropertyImage.objects.filter(propertyID=favourite.propertyID).first()

                # Store in Our Message
                message['Properties'].append({
                    "PropertyID": favourite.propertyID.id,
                    "Image": picture.imageLocation,
                    "Price": picture.propertyID.price,
                    "Location": favourite.propertyID.abstractLocation,
                    "TimeAgo": favourite.propertyID.days_ago(),
                    "Views": favourite.propertyID.views,
                    "Likes": favourite.propertyID.likes
                })

        return httpSuccessJsonResponse(message)

    # Something wrong just happen the process
    except Exception as e:
        
        return httpErrorJsonResponse("Error: Invalid Request" + str(e))


# Store the Report of the User regarding Property
@csrf_exempt
def StorePropertyReport(request):

    # Check the User Authentications
    authResult = checkUserLogin(request=request)
    if authResult[0] == False:
        return httpErrorJsonResponse(authResult[1])

    # Now we Get the User
    user = authResult[1]

    # We Begin our process to Store Report
    try:

        # Get the POST Data from user
        PropertyID = request.POST['PropertyID']
        ReportType = request.POST['ReportType']
        ReportDetails = request.POST['ReportDetails']

        # Now We get the property through its id
        try:
            # Search The Property using its ID
            result = Property.objects.get(pk=PropertyID)
        except Exception as e:
            return httpErrorJsonResponse("Error: Property Not Found")

        # Store the Report of the User
        propertyReport = PropertyReport(
            propertyID=result,
            reportingUser=user,
            issueType=ReportType,
            reportDetails=ReportDetails,
        )
        propertyReport.save()

        return httpSuccessJsonResponse("Success: Report is stored and will be viewed be Admin")

    # Something wrong just happen the process
    except Exception as e:
        print(e)
        return httpErrorJsonResponse("Error: Invalid Request")
