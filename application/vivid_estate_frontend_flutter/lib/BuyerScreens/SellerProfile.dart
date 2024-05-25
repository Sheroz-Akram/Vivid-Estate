import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:vivid_estate_frontend_flutter/Chat/ChatScreen.dart';
import 'package:vivid_estate_frontend_flutter/Classes/Buyer.dart';
import 'package:vivid_estate_frontend_flutter/Classes/Chat.dart';
import 'package:vivid_estate_frontend_flutter/Classes/Seller.dart';

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

  // Seller Json Data Object
  var sellerData = {
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

              // Display All Seller Properties
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
                          child: Container(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30.00)),
                                      child: const Image(
                                        image: AssetImage("assets/house.jpg"),
                                        fit: BoxFit.fitWidth,
                                      )),
                                  const Padding(
                                    padding: EdgeInsets.only(
                                        left: 10, right: 10.0, top: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Rs 10000",
                                          style: TextStyle(
                                              color: Color(
                                                0XFF00627C,
                                              ),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: Text(
                                        "Brand New 5 marla house",
                                        style: TextStyle(
                                            color: Color(0XFF00627C),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  const Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: Text(
                                        "NIshtar Colony ",
                                        style: TextStyle(
                                            color: Color(0XFF00627C),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                    ),
                                  ),
                                  const Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: Text(
                                        "5 hour ago",
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ),
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
