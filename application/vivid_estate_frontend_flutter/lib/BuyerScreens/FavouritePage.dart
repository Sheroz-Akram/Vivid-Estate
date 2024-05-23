import 'package:flutter/material.dart';
import 'package:vivid_estate_frontend_flutter/BuyerScreens/FavouriteProperty.dart';
import 'package:vivid_estate_frontend_flutter/Classes/Buyer.dart';
import 'package:vivid_estate_frontend_flutter/Classes/Property.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => _FavouritePage();
}

class _FavouritePage extends State<FavouritePage> {
  // Our Buyer Object to Get Favourite List
  Buyer buyer = Buyer();

  // List of All Our Properties
  List<dynamic> propertiesList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Get the Favourite List From Server
    getFavouriteList();
  }

  // Send request to Server and Retrive Favourite List
  void getFavouriteList() async {
    // Get the Authentication Data for Server
    await buyer.getAuthData();

    // Now Perform the Request to Get Data
    List<dynamic> responseList = await buyer.getFavouriteList(context);

    // Update the State Of our View
    setState(() {
      propertiesList = responseList;
    });
  }

  void removeFromFavourite(BuildContext context, propertyID) async {
    // Make a Property Object
    Property property = Property(propertyID: propertyID);

    // Send a request to Remove Property
    bool requestStatus = await property.removeFromFavourite(
        context, buyer.emailAddress, buyer.privateKey);

    // Reload the favourite list from Server
    if (requestStatus) {
      getFavouriteList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            "Favourite List",
            style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5F5F5F)),
          ),
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: propertiesList.isEmpty
                ?
                // Display Empty Favourite List Message
                const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "No Properties in favourite list",
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                : // Display Favourite List of the User
                ListView.builder(
                    itemBuilder: (context, index) {
                      return FavouriteProperty(
                        PropertyID: propertiesList[index]['PropertyID'],
                        ImageLocation: propertiesList[index]['Image'],
                        Price: propertiesList[index]['Price'],
                        Location: propertiesList[index]['Location'],
                        TimeAgo: propertiesList[index]['TimeAgo'],
                        Views: propertiesList[index]['Views'],
                        Likes: propertiesList[index]['Likes'],

                        // Whenever The User Press the Cross Buttom
                        onCrossPressed: (propertyID) {
                          // Remove the Property from the Favourite List
                          removeFromFavourite(context, propertyID.toString());
                        },
                      );
                    },
                    itemCount: propertiesList.length,
                  )));
  }
}
