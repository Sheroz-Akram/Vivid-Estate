from geopy.geocoders import Nominatim

class LocationSystem:

    def __init__(self):

        # Create New Location Service Object
        geoLocator = Nominatim(user_agent="VividEstate")

        # Store the Object
        self.geolocator = geoLocator

    # Get the Address from Latitude and Longitude
    def queryAddress(self, latitude, longitude):

        # Access our Geo Locator Object
        geoLocator = self.geolocator

        # Reverse our Latitude and Longitude
        location = geoLocator.reverse((latitude, longitude),language="en", timeout=10)

        # Get Address from Location
        address = location.raw['address']

        print(address)

        return address

    # Get the Complete Detail Location of User from Latitude and Longitude
    def detailLocation(self, latitude, longitude) -> str:

        # Get the Address 
        address = self.queryAddress(latitude, longitude)

        # Now Convert Address to String
        return ', '.join(address.values())

    # Get the simple location from Latitude and Longitude
    def simpleLocation(self, latitude, longitude) -> str:

        # Get the Address 
        address = self.queryAddress(latitude, longitude)

        return (list(address.values()))[0] + ", " + (list(address.values()))[1] 

