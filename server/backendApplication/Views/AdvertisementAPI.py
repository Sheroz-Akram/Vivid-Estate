from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from ..modules.helper import *
from ..models import *
import json

# Import our Components
from ..Components.PropertyManager import *
from ..Components.UserComponent import *
from ..Components.FileHandler import *
from ..Components.ReportingSystem import *
from ..Components.SearchingSystem import *
from ..Components.VirtualVisitManager import *
from ..Components.ChatSystem import *
from ..Components.BiddingSystem import *

# Create your views here.

# API to Store the New Property In the Server
@csrf_exempt
def StoreNewAd(request):

     # Log The Terminal
    print(f"=> New Property Creation Request | IP: {request.META.get('REMOTE_ADDR')}")

    try:
        # Get Data From POST Request
        Email = request.POST['Email']
        PrivateKey = request.POST['PrivateKey']
        PropertyData = json.loads(request.POST['PropertyData'])

        try:

            # Create a Seller Component Object and Authenticate
            sellerUserComponent = UserComponent()
            sellerUserComponent.authenticateEmailPrivateKey(Email, PrivateKey)

            # Now Create Property Manager Object and Store Property
            propertyManager = PropertyManager()
            propertyModel = propertyManager.storeNewProperty(PropertyData, sellerUserComponent.getUserModel())

            # Now Store the Images of the Property In Server
            for x in range(1, int(request.POST['PicturesCount']) + 1):

                # Get the Image Data
                imageFile = request.FILES['PropertyImage' + str(x)]

                # Store the Image
                propertyImage = propertyManager.addPropertyImage(imageFile, propertyModel, sellerUserComponent.getUserModel())

            # Loop Through All The Virtual Visits and Store
            virtualVisitManager = VirtualVisitManager()
            for visit in PropertyData['Visits']:

                # Store the Virtual Visit
                virtualVisitManager.StoreNewVirtualVisit(
                    propertyModel,
                    visit['RoomName'],
                    f"{visit['Length']}x{visit['Width']}x{visit['Height']}",
                    visit['FileLocation']
                )
            
            # Loop Through All the Layouts and Store them in database
            for layout in PropertyData['Layouts']:

                # Store the Layout
                layoutModel = PropertyLayout(
                    propertyID=propertyModel,
                    title=layout['FloorName'],
                    fileLocation=layout['FileLocation'],
                    views=0
                )
                layoutModel.save()

            return httpSuccessJsonResponse("New Property Created")
        
        except Exception as e:
            return httpErrorJsonResponse(str(e))

    except Exception as e:
        print(f"-> Exception | {str(e)}")
        return JsonResponse({"status":"error", "message":"Invalid Request"})


# Edit the Property Stored in Server
@csrf_exempt
def EditProperty(request):

     # Log The Terminal
    print(f"=> Edit Property Request | IP: {request.META.get('REMOTE_ADDR')}")

    try:
        # Get Data From POST Request
        Email = request.POST['Email']
        PrivateKey = request.POST['PrivateKey']
        PropertyData = json.loads(request.POST['PropertyData'])
        PropertyID = request.POST['PropertyID']

        try:

            # Handle File
            fileHandler = FileHandler()

            # Create User Component and Authenticate User
            sellerUserComponent = UserComponent()
            sellerUserComponent.authenticateEmailPrivateKey(Email, PrivateKey)

            # Create Object of Property System
            propertyManager = PropertyManager()

            # Find the Property
            propertyModel = propertyManager.findProperty(PropertyID)

            # Edit the Property
            propertyModel = propertyManager.EditProperty(PropertyData, propertyModel, sellerUserComponent.getUserModel())

            # Delete the Existing Images
            serverImages = propertyManager.propertyImages(propertyModel)
            if serverImages.count() > 0:
                for serverImage in serverImages:
                    # Delete the Image
                    fileHandler.deleteFile(serverImage.imageLocation)
                    serverImage.delete()

            # Delete Existing Visits and Store New One
            virtualVisitManager = VirtualVisitManager()
            serverVisits = virtualVisitManager.virtualVisits(propertyModel)
            if serverVisits.count() > 0:
                for serverVisit in serverVisits:
                    serverVisit.delete()

            # Delete Existing 2D Layouts and Store new New
            layouts = PropertyLayout.objects.filter(propertyID=propertyModel)
            if layouts.count() > 0:
                for layout in layouts:
                    layout.delete()

            # Now Store the Images of the Property In Server
            for x in range(1, int(request.POST['PicturesCount']) + 1):

                # Get the Image Data
                imageFile = request.FILES['PropertyImage' + str(x)]

                # Store the Image
                propertyImage = propertyManager.addPropertyImage(imageFile, propertyModel, sellerUserComponent.getUserModel())

            # Loop Through All The Virtual Visits and Store
            for visit in PropertyData['Visits']:

                # Store the Virtual Visit
                virtualVisitManager.StoreNewVirtualVisit(
                    propertyModel,
                    visit['RoomName'],
                    f"{visit['Length']}x{visit['Width']}x{visit['Height']}",
                    visit['FileLocation']
                )
            
            # Loop Through All the Layouts and Store them in database
            for layout in PropertyData['Layouts']:

                # Store the Layout
                layoutModel = PropertyLayout(
                    propertyID=propertyModel,
                    title=layout['FloorName'],
                    fileLocation=layout['FileLocation'],
                    views=0
                )
                layoutModel.save()

            return httpSuccessJsonResponse("Property Edited")
        
        except Exception as e:
            return httpErrorJsonResponse(str(e))

    except Exception as e:
        print(f"-> Exception | {str(e)}")
        return JsonResponse({"status":"error", "message":"Invalid Request"})

# Search the properties based upon the user query
@csrf_exempt
def SearchLocationProperty(request):

    # Log The Terminal
    print(f"=> Simple Property Search Request | IP: {request.META.get('REMOTE_ADDR')}")

    # Perform the Search Operation
    try:

        # Get all the Data
        Query = request.POST['Query']
        Filter = json.loads(request.POST['Filter'])

        # Perform Search Operation For Properties
        searchingSystem = SearchingSystem()
        results = searchingSystem.propertySearch(Query, Filter)

        # Now Combine all the Data Into Json Response
        SearchData = {}

        # Display the data in the specific page
        SearchData['SearchItems'] = []
        unique_predictions = set()  # Set to store unique predictions

        # Go Through each property find the resutls and only display properties in the same area
        for searchProperty in results:
            prediction = searchingSystem.completeWordSearch(Query, searchProperty.location).strip().title().rstrip(',')
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
        print(e)
        return httpErrorJsonResponse("Error: Invalid Request")


# Search the properties based upon the user query
@csrf_exempt
def DetailSearchQuery(request):

    # Log The Terminal
    print(f"=> Detail Property Search Request | IP: {request.META.get('REMOTE_ADDR')}")

    # Perform the Search Operation
    try:

        # Get all the Data
        Query = request.POST['Query']
        Filter = json.loads(request.POST['Filter'])

        # Perform Search Operation For Properties
        searchingSystem = SearchingSystem()
        results = searchingSystem.propertySearch(Query, Filter)

        # Create Object for Property Manager
        propertyManager = PropertyManager()

        # Now Combine all the Data Into Json Response
        SearchData = {}

        # Display the data in the specific page
        SearchData['SearchItems'] = []

        # Loop Through all the Properties find in the search
        for searchProperty in results:

            # Get the First Picture of the Property
            picture = propertyManager.firstImage(searchProperty)
            
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

    # Log The Terminal
    print(f"=> Property Detail Request | IP: {request.META.get('REMOTE_ADDR')}")

    try:

        # Get Data From POST Request
        Email = request.POST['Email']
        PrivateKey = request.POST['PrivateKey']
        PropertyID = request.POST['PropertyID']

        try:

            # Create User Component and Authenticate User
            userComponent = UserComponent()
            userComponent.authenticateEmailPrivateKey(Email, PrivateKey)

            # Create Object of Property System
            propertyManager = PropertyManager()

            # Find the Property
            property = propertyManager.findProperty(PropertyID)

            # Find Images of the Property
            images = propertyManager.propertyImages(PropertyID)

            # Create Message Data
            message = {
                "PropertyID": PropertyID,
                "PropertyType": property.propertyType,
                "Description": property.description,
                "ListingType": property.listingType,
                "Location": property.abstractLocation,
                "Latitude": property.latitude,
                "Longitude": property.longitude,
                "Price": property.price,
                "Size": property.size,
                "Beds": property.beds,
                "Floors": property.floors,
                "Views": property.views + 1,
                "Likes": property.likes,
                "SellerPicture": property.seller.profile_pic,
                "SellerID": property.seller.id,
                "SellerName": property.seller.full_name,
                "SellerEmail": property.seller.email_address,
                "IsFavourite": propertyManager.isFavorite(property,userComponent.getUserModel()),
                "IsLike": propertyManager.isLike(property, userComponent.getUserModel())
            }

            # Add Property Images to our Message Response
            message['Images'] = []
            message['TotalImages'] = images.count()
            for image in images:
                message['Images'].append(image.imageLocation)

            # Get Virtual Visits of Property
            visits = VirtualVisitManager().virtualVisits(property)

            # Add Virtual Visits to our Message
            message['Visits'] = []
            message['TotalVisits'] = visits.count()
            if visits.count() > 0:    
                for visit in visits:
                    message['Visits'].append({
                        "RoomName": visit.title,
                        "Dimensions": visit.dimension,
                        "Length": visit.dimension.split("x")[0],
                        "Width": visit.dimension.split("x")[1],
                        "Height": visit.dimension.split("x")[2],
                        "FileLocation": visit.fileLocation
                    })
            
            # Get All the Layouts of our Property
            layouts = PropertyLayout.objects.filter(propertyID=property)

            # Add Layouts to our Message
            message['Layouts'] = []
            message['TotalLayouts'] = layouts.count()
            if layouts.count() > 0:
                for layout in layouts:
                    message['Layouts'].append({
                        "FloorName": layout.title,
                        "FileLocation": layout.fileLocation
                    })

            # Update the View Count of Property
            property.views = message['Views']
            property.save()

            # Send JSON data back to the client
            return httpSuccessJsonResponse(message)

        except Exception as e:
            return httpErrorJsonResponse(str(e))

    
    except Exception as e:
        print(f"-> Exception | {str(e)}")
        return JsonResponse({"status":"error", "message":"Invalid Request"})


# Get the complete detail of the property
@csrf_exempt
def GetPropertyReviews(request):

    # Log The Terminal
    print(f"=> Review List Request | IP: {request.META.get('REMOTE_ADDR')}")

    try:

        # Get Data From POST Request
        Email = request.POST['Email']
        PrivateKey = request.POST['PrivateKey']
        PropertyID = request.POST['PropertyID']

        try:

            # Create User Component and Authenticate User
            userComponent = UserComponent()
            userComponent.authenticateEmailPrivateKey(Email, PrivateKey)

            # Create Object of Property System
            propertyManager = PropertyManager()

            # Find the Property
            property = propertyManager.findProperty(PropertyID)

            # Get Reviews of the Property
            reviews = propertyManager.reviews(property)

            # Create a message
            message = {
                "PropertyID": PropertyID,
                "Reviews": [],
                "ReviewsCount": 0
            }

            # Add Reviews to our Message
            if reviews.count() > 0:

                # Update the Review Count
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

            return httpSuccessJsonResponse(message)

        except Exception as e:
            return httpErrorJsonResponse(str(e))
    
    except Exception as e:
        print(f"-> Exception | {str(e)}")
        return JsonResponse({"status":"error", "message":"Invalid Request"})

# Store the Review of the Property in server
@csrf_exempt
def StorePropertyReview(request):

    # Log The Terminal
    print(f"=> Give Property Review Request | IP: {request.META.get('REMOTE_ADDR')}")

    try:

        # Get Data From POST Request
        Email = request.POST['Email']
        PrivateKey = request.POST['PrivateKey']
        PropertyID = request.POST['PropertyID']
        ReviewComment = request.POST['ReviewComment']
        ReviewRating = request.POST['ReviewRating']

        try:

            # Create User Component and Authenticate User
            userComponent = UserComponent()
            userComponent.authenticateEmailPrivateKey(Email, PrivateKey)

            # Create Object of Property System
            propertyManager = PropertyManager()

            # Find the Property
            property = propertyManager.findProperty(PropertyID)

            # Give Property Review
            propertyManager.giveReview(
                property=property,
                reviewPerson=userComponent.getUserModel(),
                comment=ReviewComment,
                rating=ReviewRating
            )

            return httpSuccessJsonResponse("Review Saved for Property")

        except Exception as e:
            return httpErrorJsonResponse(str(e))
    
    except Exception as e:
        print(f"-> Exception | {str(e)}")
        return JsonResponse({"status":"error", "message":"Invalid Request"})


# API to Add the Property to Favourite List by Buyer
@csrf_exempt
def AddToFavourite(request):

    # Log The Terminal
    print(f"=> Property Favorite List Add Request | IP: {request.META.get('REMOTE_ADDR')}")

    try:

        # Get Data From POST Request
        Email = request.POST['Email']
        PrivateKey = request.POST['PrivateKey']
        PropertyID = request.POST['PropertyID']

        try:

            # Create User Component and Authenticate User
            userComponent = UserComponent()
            userComponent.authenticateEmailPrivateKey(Email, PrivateKey)

            # Create Object of Property System
            propertyManager = PropertyManager()

            # Find the Property
            property = propertyManager.findProperty(PropertyID)

            # Add Property to Favorite List
            propertyManager.addPropertyToFavorite(property, userComponent.getUserModel())

            return httpSuccessJsonResponse("Property added to favorite list")

        except Exception as e:
            return httpErrorJsonResponse(str(e))

    except Exception as e:
        print(f"-> Exception | {str(e)}")
        return JsonResponse({"status":"error", "message":"Invalid Request"})


# API to Remove the Property from Favourite List
@csrf_exempt
def RemoveFromFavourite(request):

    # Log The Terminal
    print(f"=> Property Favorite List Remove Request | IP: {request.META.get('REMOTE_ADDR')}")

    try:

        # Get Data From POST Request
        Email = request.POST['Email']
        PrivateKey = request.POST['PrivateKey']
        PropertyID = request.POST['PropertyID']

        try:

            # Create User Component and Authenticate User
            userComponent = UserComponent()
            userComponent.authenticateEmailPrivateKey(Email, PrivateKey)

            # Create Object of Property System
            propertyManager = PropertyManager()

            # Find the Property
            property = propertyManager.findProperty(PropertyID)

            # Add Property to Favorite List
            propertyManager.removePropertyFromFavourite(property, userComponent.getUserModel())

            return httpSuccessJsonResponse("Property removed to favorite list")

        except Exception as e:
            return httpErrorJsonResponse(str(e))

    except Exception as e:
        print(f"-> Exception | {str(e)}")
        return JsonResponse({"status":"error", "message":"Invalid Request"})


# Remove Property from Seller Account
@csrf_exempt
def RemoveProperty(request):

    # Log The Terminal
    print(f"=> Property Remove Request | IP: {request.META.get('REMOTE_ADDR')}")

    try:

        # Get Data From POST Request
        Email = request.POST['Email']
        PrivateKey = request.POST['PrivateKey']
        PropertyID = request.POST['PropertyID']

        try:

            # Create User Component and Authenticate User
            userComponent = UserComponent()
            userComponent.authenticateEmailPrivateKey(Email, PrivateKey)

            # Create Object of Property System
            propertyManager = PropertyManager()

            # Find the Property
            property = propertyManager.findProperty(PropertyID)

            # Remove Property
            propertyManager.removeProperty(property, userComponent.getUserModel())

            return httpSuccessJsonResponse("Property Removed")

        except Exception as e:
            return httpErrorJsonResponse(str(e))

    except Exception as e:
        print(f"-> Exception | {str(e)}")
        return JsonResponse({"status":"error", "message":"Invalid Request"})

# Likes the Property by the Buyer
@csrf_exempt
def LikeProperty(request):

    # Log The Terminal
    print(f"=> Like Property Request | IP: {request.META.get('REMOTE_ADDR')}")

    try:

        # Get Data From POST Request
        Email = request.POST['Email']
        PrivateKey = request.POST['PrivateKey']
        PropertyID = request.POST['PropertyID']

        try:

            # Create User Component and Authenticate User
            userComponent = UserComponent()
            userComponent.authenticateEmailPrivateKey(Email, PrivateKey)

            # Create Object of Property System
            propertyManager = PropertyManager()

            # Find the Property
            property = propertyManager.findProperty(PropertyID)

            # Toggle the Property Like Button
            message = propertyManager.toggleLike(property, userComponent.getUserModel())

            return httpSuccessJsonResponse(message)

        except Exception as e:
            return httpErrorJsonResponse(str(e))

    except Exception as e:
        print(f"-> Exception | {str(e)}")
        return JsonResponse({"status":"error", "message":"Invalid Request"})

# API to Remove the Property from Favourite List
@csrf_exempt
def UnLikeProperty(request):

    # Log The Terminal
    print(f"=> Unlike Property Request | IP: {request.META.get('REMOTE_ADDR')}")

    try:

        # Get Data From POST Request
        Email = request.POST['Email']
        PrivateKey = request.POST['PrivateKey']
        PropertyID = request.POST['PropertyID']

        try:

            # Create User Component and Authenticate User
            userComponent = UserComponent()
            userComponent.authenticateEmailPrivateKey(Email, PrivateKey)

            # Create Object of Property System
            propertyManager = PropertyManager()

            # Find the Property
            property = propertyManager.findProperty(PropertyID)

            # Toggle the Property Like Button
            message = propertyManager.toggleLike(property, userComponent.getUserModel())

            return httpSuccessJsonResponse(message)

        except Exception as e:
            return httpErrorJsonResponse(str(e))

    except Exception as e:
        print(f"-> Exception | {str(e)}")
        return JsonResponse({"status":"error", "message":"Invalid Request"})


# Get the list of favourite properties
@csrf_exempt
def GetFavouritePropertiesList(request):

    # Log The Terminal
    print(f"=> Like Property Request | IP: {request.META.get('REMOTE_ADDR')}")

    try:

        # Get Data From POST Request
        Email = request.POST['Email']
        PrivateKey = request.POST['PrivateKey']

        try:

            # Create User Component and Authenticate User
            userComponent = UserComponent()
            userComponent.authenticateEmailPrivateKey(Email, PrivateKey)

            # Create Object of Property System
            propertyManager = PropertyManager()

            # Get List of Properties
            properties = propertyManager.favoriteProperties(userComponent.getUserModel())

            # Prepare our response message
            message = {
                "PropertiesCount": properties.count(),
                "Properties" : []
            }

            # Check Property Count
            if properties.count() > 0:

                # Loop Through Each Property
                for property in properties:

                    # Get the Image of the Property
                    picture = propertyManager.firstImage(property.propertyID)

                    # Store in Our Message
                    message['Properties'].append({
                        "PropertyID": property.propertyID.id,
                        "Image": picture.imageLocation,
                        "Price": picture.propertyID.price,
                        "Location": property.propertyID.abstractLocation,
                        "TimeAgo": property.propertyID.days_ago(),
                        "Views": property.propertyID.views,
                        "Likes": property.propertyID.likes
                    })

            return httpSuccessJsonResponse(message)

        except Exception as e:
            return httpErrorJsonResponse(str(e))

    except Exception as e:
        print(f"-> Exception | {str(e)}")
        return JsonResponse({"status":"error", "message":"Invalid Request"})


# Get the list of seller properties
@csrf_exempt
def SellerProperties(request):

    # Log The Terminal
    print(f"=> Seller Properties Request | IP: {request.META.get('REMOTE_ADDR')}")

    try:

        # Get Data From POST Request
        Email = request.POST['Email']
        PrivateKey = request.POST['PrivateKey']

        try:

            # Create User Component and Authenticate User
            userComponent = UserComponent()
            userComponent.authenticateEmailPrivateKey(Email, PrivateKey)

            # Create Object of Property System
            propertyManager = PropertyManager()

            # Get List of Sellet Properties
            properties = propertyManager.sellerProperties(userComponent.getUserModel())

            # Prepare our response message
            message = {
                "PropertiesCount": properties.count(),
                "Properties" : []
            }

            # Check Property Count
            if properties.count() > 0:

                # Loop Through Each Property
                for property in properties:

                    # Get the Image of the Property
                    picture = propertyManager.firstImage(property)

                    # Get All the Bids of the Property
                    biddingSystem = BiddingSystem()
                    propertyBids = biddingSystem.getBiddingList(property, userComponent.getUserModel())

                    # Bids
                    Bids = []
                    if propertyBids.count() > 0:
                        for bid in propertyBids:
                            Bids.append({
                                "Amount": bid.bid_amount,
                                "Name": bid.bidder.full_name
                            })

                    # Store in Our Message
                    message['Properties'].append({
                        "PropertyID": property.id,
                        "Image": picture.imageLocation,
                        "Price": picture.propertyID.price,
                        "Location": property.abstractLocation,
                        "TimeAgo": property.days_ago(),
                        "Views": property.views,
                        "Likes": property.likes,
                        "BiddingData": Bids
                    })

            return httpSuccessJsonResponse(message)

        except Exception as e:
            print(str(e))
            return httpErrorJsonResponse(str(e))

    except Exception as e:
        print(f"-> Exception | {str(e)}")
        return JsonResponse({"status":"error", "message":"Invalid Request"})


# Store the Report of the User regarding Property
@csrf_exempt
def StorePropertyReport(request):

    # Log The Terminal
    print(f"=> Submit New Property Report Request | IP: {request.META.get('REMOTE_ADDR')}")

    try:

        # Get Data from POST Request
        Email = request.POST['Email']
        PrivateKey = request.POST['PrivateKey']
        PropertyID = request.POST['PropertyID']
        ReportType = request.POST['ReportType']
        ReportDetails = request.POST['ReportDetails']

        try:

            # Create User Component and Authenticate the User
            userComponent = UserComponent()
            userComponent.authenticateEmailPrivateKey(Email, PrivateKey)

            # Create Object of Property System
            propertyManager = PropertyManager()

            # Find the Property
            property = propertyManager.findProperty(PropertyID)

            # Create Reporting System Object
            reportingSystem = ReportingSystem()

            # Report the Property
            reportingSystem.submitPropertyReport(
                property=property,
                user=userComponent.getUserModel(),
                issueType=ReportType,
                reportDetails=ReportDetails
            )

            return httpSuccessJsonResponse("Property Report Submitted")

        except Exception as e:
            return httpErrorJsonResponse(str(e))

    except Exception as e:
        print(f"-> Exception | {str(e)}")
        return JsonResponse({"status":"error", "message":"Invalid Request"})


# Store the Bids on a Property
@csrf_exempt
def PropertyBid(request):

    # Log The Terminal
    print(f"=> Submit New BID Request | IP: {request.META.get('REMOTE_ADDR')}")

    try:

        # Get Data from POST Request
        Email = request.POST['Email']
        PrivateKey = request.POST['PrivateKey']
        PropertyID = request.POST['PropertyID']
        BidAmount = request.POST['BidAmount']

        try:

            # Create User Component and Authenticate the User
            userComponent = UserComponent()
            userComponent.authenticateEmailPrivateKey(Email, PrivateKey)

            # Create Object of Property System
            propertyManager = PropertyManager()

            # Find the Property
            property = propertyManager.findProperty(PropertyID)

            # Places a Bid on Property
            biddingSystem = BiddingSystem()
            message, bid = biddingSystem.bidsOnProperty(property, userComponent.getUserModel(), BidAmount)

            # Now Send Message Update to the User About Bidding
            chatSystem = ChatSystem()
            chatRoom = chatSystem.findChatElseCreate(userComponent.getUserModel(), bid.propertyID.seller)

            # Now Send the Message to Seller About Bidding
            chatSystem.sendBidMessage(userComponent.getUserModel(), bid, message)

            return httpSuccessJsonResponse("Bid Placed on Property")

        except Exception as e:
            return httpErrorJsonResponse(str(e))

    except Exception as e:
        print(f"-> Exception | {str(e)}")
        return JsonResponse({"status":"error", "message":"Invalid Request"})


# Store the 2D Layouts of the Properties
@csrf_exempt
def StoreLayout(request):

    # Log The Terminal
    print(f"=> New 2D Layout Store Request | IP: {request.META.get('REMOTE_ADDR')}")

    try:

        # Get Data from POST Request
        Email = request.POST['Email']
        PrivateKey = request.POST['PrivateKey']
        LayoutFile = request.FILES['LayoutFile']

        try:

            # Create User Component and Authenticate the User
            userComponent = UserComponent()
            userComponent.authenticateEmailPrivateKey(Email, PrivateKey)

            # Create File Handler Object and Save the File to Sever
            fileHandler = FileHandler()
            fileName = fileHandler.storeFile(LayoutFile)

            return httpSuccessJsonResponse(fileName)

        except Exception as e:
            return httpErrorJsonResponse(str(e))

    except Exception as e:
        print(f"-> Exception | {str(e)}")
        return JsonResponse({"status":"error", "message":"Invalid Request"})