from ..models import *
from django.db.models import Q

class SearchingSystem:

        # Apply Filters to Query and Returns the Updated Query
    def ApplyFilter(self, query:Q, filterData:dict):

        # Apply The Listing Filter
        if filterData['ListingType'] != "":
            query &= Q(listingType=filterData['ListingType'])

        # Apply The Property Type Filter
        if filterData['PropertyType'] != "None":
            query &= Q(propertyType=filterData['PropertyType'])

        # Apply the Price Filter for Lower Price Range
        if filterData['Price']['Lower']:
            try:
                lower_price = int(filterData['Price']['Lower'])
                query &= Q(price__gte=lower_price)
            except ValueError:
                pass

        # Apply the Price Filter for Upper Price Range
        if filterData['Price']['Upper']:
            try:
                upper_price = int(filterData['Price']['Upper'])
                query &= Q(price__lte=upper_price)
            except ValueError:
                pass

        # Check and add size filters
        if filterData['Size']['Lower']:
            try:
                lower_size = int(filterData['Size']['Lower'])
                query &= Q(size__gte=lower_size)
            except ValueError:
                pass 

        if filterData['Size']['Upper']:
            try:
                upper_size = int(filterData['Size']['Upper'])
                query &= Q(size__lte=upper_size)
            except ValueError:
                pass

        # Check and add bed and floor filters
        if filterData['NoBeds']:
            try:
                no_beds = int(filterData['NoBeds'])
                query &= Q(beds=no_beds)
            except ValueError:
                pass  # Handle the case where conversion fails if needed

        if filterData['NoFloors']:
            try:
                no_floors = int(filterData['NoFloors'])
                query &= Q(floors=no_floors)
            except ValueError:
                pass  # Handle the case where conversion fails if needed

        # Return the Updated Query
        return query

    
    # Find the search word and complete the remaining results only
    def completeWordSearch(self, Search , Text):
        isFound = False
        Text = Text.lower()
        Search = Search.lower()
        Result = ""
        for x in Text.split(','):
            if Search in x:
                isFound = True
            if isFound == True:
                Result += x + ","

        return Result
            

    # Perform Search On Query and Filter Data
    def propertySearch(self, searchQuery: str, filterData):

        # Start with the initial query based on location
        query = Q(location__icontains=searchQuery)

        # Apply Filters to our query
        query = self.ApplyFilter(query, filterData)

        # Perform Search Based Upon Query and Filter Data
        results = Property.objects.filter(query)

        # Search query
        print(f"-> Query: {query}")

        print(results)

        return results