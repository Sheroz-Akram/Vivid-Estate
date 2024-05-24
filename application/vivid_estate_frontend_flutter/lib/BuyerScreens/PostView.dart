import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:vivid_estate_frontend_flutter/Authentication/ServerInfo.dart';
import 'package:vivid_estate_frontend_flutter/BuyerScreens/ReviewPanel.dart';
import 'package:vivid_estate_frontend_flutter/Chat/ChatScreen.dart';
import 'package:vivid_estate_frontend_flutter/Classes/Buyer.dart';
import 'package:vivid_estate_frontend_flutter/Classes/Chat.dart';
import 'package:vivid_estate_frontend_flutter/Classes/Property.dart';
import 'package:vivid_estate_frontend_flutter/Helpers/Help.dart';

// ignore: must_be_immutable
class PostView extends StatefulWidget {
  PostView({super.key, required this.PropertyID});

  // The Property ID of our Property
  dynamic PropertyID;

  @override
  State<PostView> createState() => _PostView();
}

/// Display The Preview of the Property
class _PostView extends State<PostView> {
  // The Index of the Image Display In Top Carousal
  var imageCarousalController = CarouselController();
  var images = [];
  var totalImages = 1;
  var imageIndex = 1;

  // Report Issue Information
  var selectedReportType = 'Issue';
  final reportDetailsController = TextEditingController();

  // Our Server Object used to perform post request
  ServerInfo server = ServerInfo();
  var buyer = Buyer();

  // Property Object To Store Property Details
  Property property =
      Property(propertyID: 0); // Varaible To Store Property Data

  @override
  void initState() {
    super.initState();

    // Load the Data Of Page
    loadPageData(context);
  }

  // Load the Details of the Property
  void loadPageData(BuildContext context) async {
    // First Get Our Auth Data
    await buyer.getAuthData();

    // Get the Property Details From Server
    Property responseProperty =
        await buyer.getPropertyDetail(context, widget.PropertyID);

    // Now We Update Our State
    setState(() {
      property = responseProperty;
    });
  }

  // Add the property to the favourite list
  void addToFavourite(BuildContext context) async {
    // Send A Reques to Add Property to Favourite
    var requestStatus = await property.addToFavourite(
        context, buyer.emailAddress, buyer.privateKey);

    // Make the Buttom Glow If Status is Success
    if (requestStatus == true) {
      setState(() {
        property.isFavourite = true;
      });
    }
  }

  // Remove the Property from the Favourite List
  void removeFromFavourite(BuildContext context) async {
    // Send A Reques to Add Property to Favourite
    var requestStatus = await property.removeFromFavourite(
        context, buyer.emailAddress, buyer.privateKey);

    // Make the Buttom Glow If Status is Success
    if (requestStatus == true) {
      setState(() {
        property.isFavourite = false;
      });
    }
  }

  // Likes This Property by the Buyer
  void likeProperty(BuildContext context) async {
    // Send A Request to Like the Property
    var requestStatus = await property.likeProperty(
        context, buyer.emailAddress, buyer.privateKey);

    // Make the Buttom Glow If Status is Success
    if (requestStatus == true) {
      setState(() {
        property.isLike = true;
        property.likes++;
      });
    }
  }

  // Un Likes This Property by the Buyer
  void unLikeProperty(BuildContext context) async {
    // Send A Request to Like the Property
    var requestStatus = await property.unlikesProperty(
        context, buyer.emailAddress, buyer.privateKey);

    // Make the Buttom Glow If Status is Success
    if (requestStatus == true) {
      setState(() {
        property.isLike = false;
        property.likes--;
      });
    }
  }

  // Report the Property to the Admin
  void reportProperty(BuildContext context, String propertyID,
      String ReportType, String ReportDetails) async {
    // Send our request to the server
    await buyer.submitReport(context, propertyID, ReportType, ReportDetails);
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
            actions: <Widget>[
              const SizedBox(
                width: 10,
              ),
              const Spacer(),

              /**
               * 
               * Add To Favourite Button
               * 
               */
              InkWell(
                  onTap: () {
                    // When User Click the Favourite Button
                    if (property.isFavourite == false) {
                      // Send Request to Add to Favourite
                      addToFavourite(context);
                    } else {
                      // Send Request to Remove from the Favourite List
                      removeFromFavourite(context);
                    }
                  },
                  child: Icon(
                    property.isFavourite
                        ? Icons.star
                        : Icons.star_border_outlined,
                    size: 30,
                    color: property.isFavourite
                        ? Colors.amber
                        : const Color(0XFF00627C),
                  )),
              const SizedBox(
                width: 10,
              ),

              /**
               * 
               * Button to report the ad to the Admin
               * 
               */
              InkWell(
                  onTap: () {
                    // Display Dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Submit Report'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                'Select Report Type:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              DropdownButton<String>(
                                isExpanded: true,
                                value: selectedReportType,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedReportType = newValue!;
                                  });
                                },
                                items: <String>[
                                  'Issue',
                                  'Feedback',
                                  'Other'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 16.0),
                              const Text(
                                'Report Details:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextField(
                                controller: reportDetailsController,
                                maxLines: 5,
                                decoration: const InputDecoration(
                                  hintText: 'Enter report details...',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                // Handle submitting report here
                                String reportType = selectedReportType;
                                String reportDetails =
                                    reportDetailsController.text;

                                if (reportDetails.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Please write your report in detail.")));
                                } else {
                                  // Submit the Report to the Server
                                  reportProperty(context, widget.PropertyID,
                                      reportType, reportDetails);

                                  // Close the dialog
                                  Navigator.of(context).pop();
                                }
                              },
                              child: const Text('Submit'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Icon(
                    Icons.report_gmailerrorred_rounded,
                    size: 30,
                    color: Color(0XFF00627C),
                  )),
              const SizedBox(
                width: 10,
              ),
              InkWell(
                  onTap: () {
                    print(" share ");
                  },
                  child: const Icon(
                    Icons.share,
                    size: 30,
                    color: Color(0XFF00627C),
                  )),
              const SizedBox(
                width: 10,
              ),
            ],
            leadingWidth: 150,
            leading: Row(
              children: [
                // Back Button
                IconButton(
                    onPressed: () {},
                    icon: InkWell(
                        onTap: () {
                          // Move to the Prevous Page
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back_ios_outlined,
                          color: Color(0XFF00627C),
                        ))),
                const Text(
                  "Back",
                  style: TextStyle(
                      color: Color(0XFF00627C),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ],
            )),
        body: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15.0),
                            topRight: Radius.circular(15.0)),
                        child: property.imagesCount != 0
                            ? // Display the Images of the Properties in Carousel Slider
                            CarouselSlider.builder(
                                carouselController: imageCarousalController,
                                itemCount: property.imagesCount,
                                itemBuilder: (context, index, pageviewIndex) {
                                  return Image.network(
                                    "${server.host}/static/${property.images[index]}",
                                    fit: BoxFit.fill,
                                    height: 300,
                                    width: MediaQuery.of(context).size.width,
                                  );
                                },
                                options: CarouselOptions(
                                  height: 300,
                                  autoPlay: false,
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  enableInfiniteScroll: true,
                                  autoPlayAnimationDuration:
                                      const Duration(milliseconds: 800),
                                  viewportFraction: 1,
                                ))
                            :
                            // If No Image is Found
                            Image.asset(
                                "assets/BuyerImages/loadingImage.jpg",
                                fit: BoxFit.fill,
                                height: 300,
                                width: MediaQuery.of(context).size.width,
                              )),
                    Row(
                      children: [
                        const Spacer(),
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.black,
                            ),
                            width: 100,
                            height: 30,
                            margin: const EdgeInsets.only(top: 260, right: 15),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "${imageIndex.toString()}/${property.imagesCount.toString()}",
                                    style: const TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                            )),
                      ],
                    ),

                    // Left Arrow Buttom to Move to Next Image
                    SizedBox(
                      height: 300,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                          onTap: () {
                            // Display Previous Picture
                            imageCarousalController.previousPage(
                                duration: Durations.long1);
                            if (imageIndex - 1 == 0) {
                              setState(() {
                                imageIndex = property.imagesCount;
                              });
                            } else {
                              setState(() {
                                imageIndex--;
                              });
                            }
                          },
                          child: const Icon(
                            Icons.arrow_back_ios_rounded,
                            color: Colors.white,
                            size: 60,
                          ),
                        ),
                      ),
                    ),

                    // Right Arrow Buttom to Move to Previous Image
                    SizedBox(
                      height: 300,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () {
                            // Display Next Picture
                            imageCarousalController.nextPage(
                                duration: Durations.long1);
                            if (imageIndex + 1 > property.imagesCount) {
                              setState(() {
                                imageIndex = 1;
                              });
                            } else {
                              setState(() {
                                imageIndex++;
                              });
                            }
                          },
                          child: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                            size: 60,
                          ),
                        ),
                      ),
                    )
                  ],
                ),

                /**
                 * 
                 * Display Price and Place Bid Option
                 * 
                 */
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          margin: const EdgeInsets.only(left: 15),
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Price of the Property
                              Text(
                                "RS ${formatNumber(property.price)}",
                                style: const TextStyle(
                                    color: Color(0XFF5F5F5F),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 28),
                              ),
                              // Option to place bid
                              InkWell(
                                child: const Text("Place Bid",
                                    style: TextStyle(
                                        color: Color(0XFF00627C),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                                onTap: () {
                                  // Option to Place Bid on the Property
                                  print("Place BID");
                                },
                              ),
                            ],
                          )),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0XFF00627C),
                                side: const BorderSide(width: 3),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0))),
                            onPressed: () {
                              // Likes the Property Button
                              if (property.isLike == false) {
                                // Likes The Property
                                likeProperty(context);
                              } else {
                                // UnLikes the Property
                                unLikeProperty(context);
                              }
                            },
                            child: Row(
                              children: [
                                // Display The Property Like Icon
                                Icon(
                                  property.isLike == true
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  formatNumber(property.likes),
                                  style: const TextStyle(color: Colors.white),
                                )
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
                // Display Information Regarding Property
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: const EdgeInsets.only(left: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Display Location
                            Text(
                              property.location,
                              style: const TextStyle(
                                  color: Color(0XFF8D8D8D),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            // Display Property Type
                            Row(
                              children: [
                                const Text(
                                  "Property Type: ",
                                  style: TextStyle(
                                      color: Color(0XFF5F5F5F),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Text(
                                  property.propertyType,
                                  style: const TextStyle(
                                      color: Color(0XFF8D8D8D),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                            // Display Listing Type
                            Row(
                              children: [
                                const Text(
                                  "Listing Type: ",
                                  style: TextStyle(
                                      color: Color(0XFF5F5F5F),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Text(
                                  property.listingType,
                                  style: const TextStyle(
                                      color: Color(0XFF8D8D8D),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ],
                            )
                          ],
                        )),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0XFF00627C),
                              side: const BorderSide(width: 3),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0))),
                          onPressed: () {},
                          child: Row(
                            children: [
                              const Icon(
                                Icons.remove_red_eye_rounded,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                formatNumber(property.views),
                                style: const TextStyle(color: Colors.white),
                              )
                            ],
                          )),
                    ),
                  ],
                ),

                // Display Information Of Seller
                Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Column(
                    children: [
                      const Divider(
                        thickness: 3,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 15),
                                height: 70,
                                width: 70,
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      "${server.host}/static/${property.sellerPicture}"),
                                ),
                              ),
                              SizedBox(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 15),
                                        child: Text(property.sellerName,
                                            style: const TextStyle(
                                                color: Color(0XFF5F5F5F),
                                                fontSize: 28,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 15),
                                        width: 150,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color(0XFF00627C),
                                                side:
                                                    const BorderSide(width: 3),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0))),
                                            onPressed: () {
                                              // Initiate Chat with Seller
                                              chatWithSeller(context,
                                                  property.sellerEmail);
                                            },
                                            child: const Text("Start chat",
                                                style: TextStyle(
                                                    color: Colors.white))),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            child: Container(
                              margin: const EdgeInsets.only(right: 30),
                              child: const Column(
                                children: [
                                  Text(
                                    " View",
                                    style: TextStyle(
                                        color: Color(0XFF006E86),
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    " Profile",
                                    style: TextStyle(
                                        color: Color(0XFF006E86),
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                            onTap: () {
                              // Open the Profile of Seller
                              print("View Profile");
                            },
                          ),
                        ],
                      ),
                      const Divider(
                        thickness: 3,
                      ),
                    ],
                  ),
                ),

                /**
                 * Display the Data of Property with Icons as welll
                 */
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/UI/beds.png",
                              height: MediaQuery.of(context).size.width * 0.15,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "${property.beds} Beds",
                              style: const TextStyle(
                                  color: Color(0XFF8D8D8D),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/UI/size.png",
                              height: MediaQuery.of(context).size.width * 0.15,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "${property.size} m",
                              style: const TextStyle(
                                  color: Color(0XFF8D8D8D),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/UI/floors.png",
                              height: MediaQuery.of(context).size.width * 0.15,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "${property.floors} Floors",
                              style: const TextStyle(
                                  color: Color(0XFF8D8D8D),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 20, top: 20),
                  child: const Text(
                    "Description",
                    style: TextStyle(
                        color: Color(0XFF5F5F5F),
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    property.description,
                    style:
                        const TextStyle(color: Color(0XFF8D8D8D), fontSize: 16),
                    maxLines: 10,
                  ),
                ),

                /**
                 * 
                 * Display Reviews Of Our Property
                 * 
                 */
                ReviewPanel(
                  propertyID: widget.PropertyID,
                ),
              ],
            ),
          ),
        ));
  }
}
