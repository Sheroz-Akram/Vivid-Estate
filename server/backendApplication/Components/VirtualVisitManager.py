
from ..models import *
import os
from django.conf import settings

class VirtualVisitManager:

    # Store Virtual Visit To Database
    def StoreNewVirtualVisit(self, property: Property, title:str, dimension:str , fileLocation: str):

        # Check if Virtual Visit File Exists or not
        if not os.path.exists(settings.FILESTORAGE + f"/{fileLocation}"):
            raise Exception("Virtual Visit File Not Exists")

        # Store the Virtual Visit
        try:
            virtualVisit = PropertyVirtualVisit(
                propertyID=property,
                title=title,
                dimension=dimension,
                fileLocation=fileLocation,
                views=0
            )
            virtualVisit.save()
        except:
            raise Exception("Unable to Save Virtual Visit")

        return virtualVisit

    # Get All the Virtual Visits of the Property
    def virtualVisits(self, property: Property):
        # Query the Database
        try:
            visits = PropertyVirtualVisit.objects.filter(propertyID=property)
        except:
            raise Exception("Unable to get virtual visits")
        
        return visits