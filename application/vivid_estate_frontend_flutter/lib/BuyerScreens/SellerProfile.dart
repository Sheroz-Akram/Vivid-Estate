import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:vivid_estate_frontend_flutter/Authentication/ServerInfo.dart';
import 'package:vivid_estate_frontend_flutter/Chat/ChatScreen.dart';
import 'package:vivid_estate_frontend_flutter/Classes/Buyer.dart';
import 'package:vivid_estate_frontend_flutter/Classes/Chat.dart';
import 'package:vivid_estate_frontend_flutter/Classes/Seller.dart';
import 'package:vivid_estate_frontend_flutter/Helpers/Help.dart';

class SellerProfile extends StatefulWidget {
  SellerProfile({super.key, required this.sellerID});

  dynamic sellerID;

  @override
  State<SellerProfile> createState() => _SellerProfile();
}

class _SellerProfile extends State<SellerProfile> {
  // Buyer Class To Communicate With Server
  Buyer buyer = Buyer();

  // Seller Class
  Seller seller = Seller();

  // Server Helper
  var serverHelper = ServerInfo();

  // Seller Json Data Object
  dynamic sellerData = {
    "SellerName": "No Name",
    "TotalAdsPublish": 0,
    "SellerEmail": "no email",
    "ProfilePicture": "",
    "Ads": []
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Load the Profile Of Seller
    getSellerProfileData(context, widget.sellerID);
  }

  // Get the Profile Data of Seller
  void getSellerProfileData(BuildContext context, int sellerID) async {
    // Get the Authentication Data For the Server
    await buyer.getAuthData();

    // Now Make Request to Server And Get All The Data
    var responseData = await seller.getSellerProfileData(
        context, sellerID, buyer.emailAddress, buyer.privateKey);

    // Now Update The State Of Our Response
    setState(() {
      sellerData = responseData;
    });

    print(sellerData);
  }

  // Initiate A Chat With Seller and Move To Chat Screen
  void chatWithSeller(BuildContext context, String sellerEmailAddress) async {
    // Request to Perform Chat Initiation with Seller
    Chat userChat =
        await buyer.initiateChatWithSeller(context, sellerEmailAddress);

    // Move To Chat Screen If Status Okays
    if (userChat.personName.toString().isNotEmpty) {
      Navigator.push(
          context,

          // Open The Chat For the User
          MaterialPageRoute(
              builder: (context) => ChatScreen(
                    title: userChat.personName,
                    ChatID: userChat.chatID,
                    ProfilePicture: userChat.personImage,
                    lastScene: userChat.lastTime,
                    chatInfo: userChat,
                  )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const CloseButton(
            color: Color(0XFF00627C),
          ),
        ),
        body: Container(
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10.0),
                    height: 60,
                    width: 60,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            sellerData["ProfilePicture"].toString()),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text(
                        sellerData['SellerName'].toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      subtitle: Text(
                        "${sellerData['TotalAdsPublish']} Ads Published",
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0XFF00627C)),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 10,
                ),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color(0XFF00627C), width: 1.5),
                  ),
                  // Initiate a Chat With Seller
                  child: InkWell(
                    onTap: () => {
                      chatWithSeller(
                          context, sellerData['SellerEmail'].toString())
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Icon(
                            Icons.chat,
                            color: Color(0XFF00627C),
                            size: 25,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Chat with the seller",
                          style:
                              TextStyle(fontSize: 16, color: Color(0XFF00627C)),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Divider(
                  color: Colors.grey,
                  height: 30,
                  thickness: 1.5,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Showing All Ads",
                    style: TextStyle(fontSize: 16, color: Color(0XFF00627C)),
                  ),
                ),
              ),

              /**
               * 
               * Show All the Seller Properties in Grid View
               * 
               */
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Number of columns
                        crossAxisSpacing: 10.0, // Space between columns
                        mainAxisSpacing: 10.0, // Space between rows
                      ),
                      itemBuilder: (context, index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.00)),
                          color: Colors.white,
                          elevation: 15,
                          margin: const EdgeInsets.only(left: 15, right: 15),
                          shadowColor: Colors.black,

                          /**
                           * 
                           * Card to Display Information of the Property in Seller Profile
                           * 
                           */
                          child: Container(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  // Dispplay Image of the Property
                                  Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30.00)),
                                      child: Image(
                                        image: NetworkImage(
                                            "${serverHelper.host}/static/${sellerData['Ads'][index]['PropertyImage']}"),
                                        fit: BoxFit.fitWidth,
                                      )),

                                  // Display Price of the Property
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10.0, top: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Rs ${formatNumber(sellerData['Ads'][index]['Price'])}",
                                          style: const TextStyle(
                                              color: Color(
                                                0XFF00627C,
                                              ),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Display Property Location
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.location_on_rounded),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5, right: 10),
                                            child: Text(
                                              "${sellerData['Ads'][index]['Location']}",
                                              style: const TextStyle(
                                                  color: Color(0XFF00627C),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Display Property Post Time Ago in Days
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: Text(
                                        "${sellerData['Ads'][index]['TimeAgo']} days ago",
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ),

                                  /***
                                   * Display Property Likes and Views
                                   */
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 10, top: 10),
                                    child: Row(
                                      children: [
                                        // Display Views
                                        Row(children: [
                                          const Icon(Icons.remove_red_eye),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                              sellerData['Ads'][index]['Views']
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF5F5F5F)))
                                        ]),

                                        const SizedBox(
                                          width: 20,
                                        ),

                                        // Display Hearts
                                        Row(
                                          children: [
                                            const Icon(Icons.favorite),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                                sellerData['Ads'][index]
                                                        ['Likes']
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFF5F5F5F)))
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: sellerData['TotalAdsPublish'] as int,
                    )),
              )
            ],
          ),
        ));
  }
}
