import 'package:flutter/material.dart';
import 'package:vivid_estate_frontend_flutter/Classes/Seller.dart';
import 'package:vivid_estate_frontend_flutter/SellerScreens/EditProperty.dart';
import 'package:vivid_estate_frontend_flutter/SellerScreens/SellerAdPreview.dart';

class AdList extends StatefulWidget {
  const AdList({super.key});

  @override
  State<AdList> createState() => _AdList();
}

class _AdList extends State<AdList> {
  // Our Seller Object to Get Add List
  Seller seller = Seller();

  // List of All Our Properties
  List<dynamic> propertiesList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Get the AdList List From Server
    getAdList();
  }

  // Send request to Server and Retrive Ad List
  void getAdList() async {
    // Get the Authentication Data for Server
    await seller.getAuthData();

    // Now Perform the Request to Get Data
    List<dynamic> responseList = await seller.geAdList(context);

    // Update the State Of our View
    setState(() {
      propertiesList = responseList;
    });
  }

  // Remove From Seller Account
  void removeFromAccount(BuildContext context, propertyID) async {
    // Send a request to Remove Property
    bool requestStatus =
        await seller.removePropertyFromAccount(context, propertyID);

    // Reload the favourite list from Server
    if (requestStatus) {
      getAdList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            "My Ads",
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
                      "No Properties Found",
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                : // Display Favourite List of the User
                ListView.builder(
                    itemBuilder: (context, index) {
                      return SellerAdPreview(
                        PropertyID: propertiesList[index]['PropertyID'],
                        ImageLocation: propertiesList[index]['Image'],
                        Price: propertiesList[index]['Price'],
                        Location: propertiesList[index]['Location'],
                        TimeAgo: propertiesList[index]['TimeAgo'],
                        Views: propertiesList[index]['Views'],
                        Likes: propertiesList[index]['Likes'],

                        // Whenever The User Press the Cross Buttom
                        onCrossPressed: (propertyID) {
                          // Remove Property From Seller Account
                          print(propertyID);
                          removeFromAccount(context, propertyID.toString());
                        },

                        // When User Press the Edit Property Button
                        onEditPressed: (propertyID) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProperty(
                                        propertyID: propertyID.toString(),
                                      )));
                        },
                      );
                    },
                    itemCount: propertiesList.length,
                  )));
  }
}
