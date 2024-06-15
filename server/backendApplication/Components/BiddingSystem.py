from ..models import *

# Components of the System
from .PropertyManager import *

class BiddingSystem:

    # Find the Higest Bidder on Specific Property
    def findHighestBidder(self, property: Property):

        # Query the Database
        try:
            highest_bid = Bid.objects.filter(propertyID=property).order_by('-bid_amount').first()
        except:
            return 0.0
        return highest_bid.bid_amount

    # Get the List of All Bids on the Property
    def getBiddingList(self, property: Property, seller: ApplicationUser):

        # Check if the Seller has Access to Bids data
        if property.seller.id != seller.id:
            raise Exception("Selller Can't Access Bidding Data")
        
        # Query the Database
        try:
            bids = Bid.objects.filter(propertyID=property).order_by('bid_amount')
        except:
            raise Exception("Unable to query database for bids")
        return bids

    # Store the Bid of Buyer on Property
    def bidsOnProperty(self, property: Property, buyer: ApplicationUser, amount: float):

        # Check if the User Already Bids on the Property or not
        try:
            existing_bid = Bid.objects.get(bidder=buyer,propertyID=property)
            old_bid_amount = existing_bid.bid_amount
            existing_bid.bid_amount = amount
            existing_bid.save()

            # Return the User Message
            return f"{buyer.full_name} updates his bid of RS {old_bid_amount} to RS {existing_bid.bid_amount} on the property. The higest Bid on the Property currently is RS {self.findHighestBidder(property)}", existing_bid

        except:
            # Do Nothig Here
            print("Not Find Existing Bids for the User")

        # Store the Bid on Database
        try:
            bid = Bid(
                propertyID=property,
                bidder=buyer,
                bid_amount=amount
            )
            bid.save()

            return f"{buyer.full_name} place a bid of RS {bid.bid_amount} on the property. The higest Bid on the Property currently is RS {self.findHighestBidder(property)}", bid
        
        except Exception as e:
            print(str(e))
            raise Exception("Unable to store Bid Database in Server")