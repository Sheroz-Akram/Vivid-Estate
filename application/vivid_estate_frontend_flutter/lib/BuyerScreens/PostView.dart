import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:vivid_estate_frontend_flutter/Authentication/ServerInfo.dart';
import 'package:vivid_estate_frontend_flutter/Classes/Buyer.dart';
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
  var Rs = ["7800000"];

  // The Index of the Image Display In Top Carousal
  var imageCarousalController = CarouselController();
  var images = [];
  var totalImages = 1;
  var imageIndex = 1;

  // Our Server Object used to perform post request
  ServerInfo server = ServerInfo();
  var buyer = Buyer();
  dynamic PropertyData = {
    "Images": [],
    "ImagesCount": 0,
    "PropertyType": "",
    "ListingType": "",
    "Description": "",
    "Location": "",
    "Price": 0,
    "Size": 0,
    "Beds": 0,
    "Floors": 0,
    "Views": 0,
    "Likes": 0,
    "SellerPicture": "Default.jpg",
    "SellerName": "",
    "SellerEmail": ""
  };

  @override
  void initState() {
    super.initState();

    // Load the Data Of Page
    loadPageData(context);
  }

  // Load the Details of the Property
  void loadPageData(BuildContext userContext) async {
    // Now Get the Property Data
    var responseData =
        await buyer.getPropertyDetail(context, widget.PropertyID);

    // Update the State of our Property Data
    setState(() {
      PropertyData = responseData;
    });
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
              InkWell(
                  onTap: () {
                    print(" star ");
                  },
                  child: const Icon(
                    Icons.star_border_outlined,
                    size: 30,
                    color: Color(0XFF00627C),
                  )),
              const SizedBox(
                width: 10,
              ),
              InkWell(
                  onTap: () {
                    print(" edit");
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
                        child: PropertyData['ImagesCount'] != 0
                            ? // Display the Images of the Properties in Carousel Slider
                            CarouselSlider.builder(
                                carouselController: imageCarousalController,
                                itemCount: PropertyData['ImagesCount'],
                                itemBuilder: (context, index, pageviewIndex) {
                                  return Image.network(
                                    "${server.host}/static/${PropertyData['Images'][index]}",
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
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.black,
                        ),
                        width: 100,
                        height: 30,
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.7,
                            top: 260,
                            right: 15),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
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
                                "${imageIndex.toString()}/${PropertyData['ImagesCount'].toString()}",
                                style: const TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        )),

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
                                imageIndex = PropertyData['ImagesCount'];
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
                            if (imageIndex + 1 > PropertyData['ImagesCount']) {
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
                                "RS ${formatNumber(PropertyData['Price'])}",
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
                        width: 100,
                        margin: const EdgeInsets.only(right: 15),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0XFF00627C),
                                side: const BorderSide(width: 3),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0))),
                            onPressed: () {
                              // Likes the Property
                              print("Likes Property");
                            },
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.favorite,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  formatNumber(PropertyData['Likes']),
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
                              PropertyData['Location'],
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
                                  PropertyData['PropertyType'],
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
                                  PropertyData['ListingType'],
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
                      width: 100,
                      margin: const EdgeInsets.only(right: 15),
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
                                formatNumber(PropertyData['Views']),
                                style: const TextStyle(color: Colors.white),
                              )
                            ],
                          )),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 15, bottom: 15),
                  child: Row(
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
                                  "${server.host}/static/${PropertyData['SellerPicture']}"),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 15),
                                    child: Text(PropertyData['SellerName'],
                                        style: const TextStyle(
                                            color: Color(0XFF5F5F5F),
                                            fontSize: 28)),
                                  ),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 15),
                                    width: 110,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0XFF00627C),
                                            side: const BorderSide(width: 3),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0))),
                                        onPressed: () {
                                          // Initiate Chat with Seller
                                          print("Iniate Chat with Seller");
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
                              "${PropertyData['Beds']} Beds",
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
                              "${PropertyData['Size']} m",
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
                              "${PropertyData['Floors']} Floors",
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
                    PropertyData['Description'],
                    style:
                        const TextStyle(color: Color(0XFF8D8D8D), fontSize: 16),
                    maxLines: 10,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 20, bottom: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0XFF00627C),
                                side: const BorderSide(width: 3),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0))),
                            onPressed: () {},
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/images/Image 17@1x (2).png",
                                  width: 20,
                                  height: 40,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Text(
                                  "2D Layout",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                )
                              ],
                            )),
                      ),
                      Container(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0XFF00627C),
                                side: const BorderSide(width: 3),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0))),
                            onPressed: () {},
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/images/Image 17@1x (6).png",
                                  width: 20,
                                  height: 40,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Text(
                                  "Map",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                )
                              ],
                            )),
                      ),
                      Container(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0XFF00627C),
                                side: const BorderSide(width: 3),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0))),
                            onPressed: () {},
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/images/Image 17@1x (3).png",
                                  width: 20,
                                  height: 40,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Text(
                                  "360*",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                )
                              ],
                            )),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
