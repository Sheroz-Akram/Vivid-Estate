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
            fs = FileSystemStorage(location=settings.PROFILE_PIC_ROOT)
            
            # Save the file directly
            fileNewName = str(uuid.uuid4()) + imageFile.name
            filename = fs.save(fileNewName, imageFile)
            file_path = os.path.join(settings.PROFILE_PIC_ROOT, filename)

            # Store the Property Image Location in the Server
            propertyImagesLocation = PropertyImage(
                imageLocation = file_path,
                propertyID = propertyNew
            )

            propertyImagesLocation.save()

        return httpSuccessJsonResponse("New Ad is created successfully!")

    # Something wrong just happen the process
    except Exception as e:
        print(e)
        return httpErrorJsonResponse("Error in the server or an invalid request")


# Search the properties based upon the user query
@csrf_exempt
def SearchLocationProperty(request):

    # Perform the Search Operation
    try:

        # Get all the Data
        Query = request.POST['Query']

        print(request.POST['Filter'])

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
        return httpErrorJsonResponse("Error in the server or an invalid request" + str(e))


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
        return httpErrorJsonResponse("Error in the server or an invalid request" + str(e))

    
# Get the complete detail of the property
@csrf_exempt
def GetPropertyDetail(request):

    # Perform the Search Operation
    try:

        # Get all the Data
        PropertyID = request.POST['PropertyID']

        try:
            # Search The Property using its ID
            result = Property.objects.get(pk=PropertyID)
        except Exception as e:
            return httpErrorJsonResponse("Error: Property not found." + str(e))

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

        # Now Add Other Data to our Response
        message['PropertyType'] = result.propertyType
        message['ListingType'] = result.listingType

        print(message)
        

        # Send JSON data back to the client
        return httpSuccessJsonResponse(message)
    
    # Something wrong just happen the process
    except Exception as e:
        return httpErrorJsonResponse("Error: Invalid Request")
