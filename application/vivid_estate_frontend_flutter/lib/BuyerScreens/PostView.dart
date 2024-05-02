import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class PostView extends StatefulWidget {
  const PostView({super.key});

  @override
  State<PostView> createState() => _PostView();
}

/// Display The Preview of the Property
class _PostView extends State<PostView> {
  var Rs = ["7800000"];
  var bid = ["Place Bid"];
  var address = ["Wapda Town Lahore"];
  var Likes = ["12K"];
  var View = ["12K"];

  var images = ["assets/house.jpg", 'assets/house2.jpg'];

  // The Index of the Image Display In Top Carousal
  var imageCarousalController = CarouselController();
  var totalImages = 1;
  var imageIndex = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Set our data variables
    setState(() {
      totalImages = images.length;
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
                      child:
                          // Display the Images of the Properties in Carousel Slider
                          CarouselSlider.builder(
                              carouselController: imageCarousalController,
                              itemCount: totalImages,
                              itemBuilder: (context, index, pageviewIndex) {
                                return Image.asset(
                                  images[index],
                                  fit: BoxFit.cover,
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
                              )),
                    ),
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
                                "${imageIndex.toString()}/${totalImages.toString()}",
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
                                imageIndex = totalImages;
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
                            if (imageIndex + 1 > totalImages) {
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
                              Text(
                                "Rs ${Rs[0]}",
                                style: const TextStyle(
                                    color: Color(0XFF5F5F5F),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 28),
                              ),
                              InkWell(
                                child: Text(bid[0],
                                    style: const TextStyle(
                                        color: Color(0XFF00627C),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                                onTap: () {
                                  print("Place bid");
                                },
                              ),
                            ],
                          )),
                      Container(
                        margin: const EdgeInsets.only(right: 15),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0XFF00627C),
                                side: const BorderSide(width: 3),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0))),
                            onPressed: () {
                              print("likes");
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
                                  Likes[0],
                                  style: const TextStyle(color: Colors.white),
                                )
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 15),
                      child: Text(
                        address[0],
                        style: const TextStyle(
                            color: Color(0XFF8D8D8D),
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                    Container(
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
                                View[0],
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
                            child: const CircleAvatar(
                              backgroundImage:
                                  AssetImage("assets/images/sheroz.jpg"),
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
                                    child: const Text("Ahmen Khan",
                                        style: TextStyle(
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
                                        onPressed: () {},
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
                          print("View Profile");
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/images/Image 14@1x.png",
                              height: 25,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              "5 Bed Rooms",
                              style: TextStyle(
                                  color: Color(0XFF8D8D8D),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/images/Image 15@1x.png",
                              height: 25,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              "10 Kanal",
                              style: TextStyle(
                                  color: Color(0XFF8D8D8D),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/images/Image 15@1x (2).png",
                              height: 25,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              "2 Floors",
                              style: TextStyle(
                                  color: Color(0XFF8D8D8D),
                                  fontSize: 14,
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
                  margin: const EdgeInsets.only(left: 20),
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
                  child: const Text(
                    "Real estate is real "
                    "include buildings, fixtures, roads, structures, and utility systems. Property rights give a title of ownership to the land, "
                    "improvements,",
                    style: TextStyle(color: Color(0XFF8D8D8D), fontSize: 16),
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
