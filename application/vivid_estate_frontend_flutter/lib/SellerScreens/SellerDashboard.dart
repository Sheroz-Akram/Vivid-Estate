import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:vivid_estate_frontend_flutter/Authentication/ServerInfo.dart';
import 'package:vivid_estate_frontend_flutter/Classes/Seller.dart';
import 'package:vivid_estate_frontend_flutter/Helpers/Help.dart';
import 'package:vivid_estate_frontend_flutter/SellerScreens/CreateNewAd/NewPropertyAdd.dart';

class SellerDashboard extends StatefulWidget {
  const SellerDashboard({super.key});

  @override
  State<SellerDashboard> createState() => _SellerDashboardState();
}

class _SellerDashboardState extends State<SellerDashboard> {
  // Create a Seller Object
  Seller seller = Seller();
  var server = ServerInfo();
  // Seler Dashboard Data Structure
  dynamic SellerDashboardData = {
    "profilePic": "logo.png",
    "userFullName": "Seller Name",
    "location": "Seller Location",
    "propertyCount": 0,
    "chatCount": 0,
    "View": 0,
    "Likes": 0,
    "Reviews": 0,
    "AverageRating": 5.0
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadSellerDashboard(context);
  }

  // Load the Dashboard of Seller
  void loadSellerDashboard(BuildContext context) async {
    // Load Our Data from User
    await seller.getAuthData();

    // Get the Data of Seller from Server
    var responseData = await seller.getSellerDashboardData(context);

    print(responseData);

    // Update our State
    setState(() {
      SellerDashboardData = responseData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20.0, top: 20),
            width: MediaQuery.of(context).size.width,
            child: const Text(
              "Dashboard",
              style: TextStyle(
                  color: Color(0XFF5F5F5F),
                  fontSize: 36,
                  fontWeight: FontWeight.w900),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                    "${server.host}/static/${SellerDashboardData['profilePic']}"),
              ),
              title: Text(
                SellerDashboardData['userFullName'],
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0XFF7D7D7D)),
              ),
              subtitle: Text(SellerDashboardData['location'],
                  style: const TextStyle(
                      color: Color(0XFF9D9D9D),
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
              trailing: Image.asset(
                "assets/UI/seller-dashboard.png",
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
                top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
            decoration: BoxDecoration(
                color: const Color(0xFFECECEC),
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: getBoxShadow()),
            margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10),
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(top: 5, bottom: 10),
                    child: const Text(
                      "Metrics Report",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Image.asset(
                            "assets/UI/impressions.png",
                            width: 50,
                          ),
                          const Text(
                            "Reviews",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                SellerDashboardData['Reviews'].toString(),
                                style: const TextStyle(fontSize: 15),
                              ),
                            ],
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Image.asset("assets/UI/likes.png", width: 50),
                          const Text(
                            "Views",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                SellerDashboardData['View'].toString(),
                                style: const TextStyle(fontSize: 15),
                              )
                            ],
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Image.asset("assets/UI/views.png", width: 50),
                          const Text(
                            "Likes",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                SellerDashboardData['Likes'].toString(),
                                style: const TextStyle(fontSize: 15),
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(top: 15),
                    child: const Text(
                      "Average Rating",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  RatingBar.builder(
                    initialRating: SellerDashboardData['AverageRating'],
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Color(0xFF006E86),
                    ),
                    onRatingUpdate: (rating) {
                      // This callback will not be called because gestures are ignored
                    },
                    ignoreGestures: true, // Disable interactions
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 15.0, left: 25.0, right: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Active Ads : ${SellerDashboardData['propertyCount']}",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Totals Chats : ${SellerDashboardData['chatCount'].toString()}",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              // Go to the Create new Add Page
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NewPropertyAd()));
            },
            child: Container(
              padding: const EdgeInsets.only(
                  top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
              decoration: BoxDecoration(
                  color: const Color(0xFFECECEC),
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: getBoxShadow()),
              margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 15),
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: const ListTile(
                        leading: Icon(
                          Icons.add_circle_outline,
                          size: 30,
                        ),
                        title: Text("Create New ad",
                            style: TextStyle(fontSize: 16)),
                        trailing: InkWell(child: Icon(Icons.arrow_forward_ios)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
