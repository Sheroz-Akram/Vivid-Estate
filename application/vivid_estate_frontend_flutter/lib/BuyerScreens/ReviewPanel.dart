import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:vivid_estate_frontend_flutter/Authentication/ServerInfo.dart';
import 'package:vivid_estate_frontend_flutter/Classes/Buyer.dart';
import 'package:vivid_estate_frontend_flutter/Classes/DisplayHelper.dart';
import 'package:vivid_estate_frontend_flutter/Classes/Review.dart';

class ReviewPanel extends StatefulWidget {
  ReviewPanel({super.key, required this.propertyID});

  dynamic propertyID;

  @override
  State<ReviewPanel> createState() => _ReviewPanelState();
}

class _ReviewPanelState extends State<ReviewPanel> {
  // Our Server Object used to perform post request
  ServerInfo server = ServerInfo();
  var buyer = Buyer();

  // List To Store All The Reviews
  List<Review> reviewList = [];

  // User Review Variables
  TextEditingController reviewCommentController = TextEditingController();
  int userReviewRating = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Call Function to Load Reviews
    loadReviews(context);
  }

  // Function To Load All The Reviews Of the Page
  void loadReviews(BuildContext context) async {
    // Get The Authentication Data for the Sever
    await buyer.getAuthData();

    await buyer.getUserProfileData(context);

    // Now Make A Request to the Server And Get All Reviews
    List<Review> reviewList =
        await buyer.getPropertyReviews(context, widget.propertyID);

    // Update the State Of Our Widget
    setState(() {
      this.reviewList = reviewList;
    });
  }

  // Submit A New Review From The User
  void submitReview(BuildContext context, String comment, int rating) async {
    // Make a Request to the Server and Send Our Review
    bool requestStatus =
        await buyer.submitReview(context, widget.propertyID, comment, rating);

    // Check The Status of Our Request and Update our view
    if (requestStatus) {
      // Clear The Review Panel
      reviewCommentController.clear();
      // Again Reload All The Reviews
      setState(() {
        reviewList = [];
      });
      loadReviews(context);
    } else {
      // Do Nothing
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(left: 20, top: 20, right: 20),
        child: Column(
          children: [
            // Display Review Title
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Provide Review",
                style: TextStyle(
                    color: Color(0XFF5F5F5F),
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              ),
            ),

            // Display Option to Give Review
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  // Display The User Image
                  Row(
                    children: [
                      SizedBox(
                        height: 60,
                        width: 60,
                        child: CircleAvatar(
                          backgroundImage:
                              NetworkImage(buyer.profilePictureLocation),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Display User Name
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  buyer.fullName,
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                )),

                            // Display Rating Bar To Provide Rating to The Application
                            RatingBar.builder(
                                itemCount: 5,
                                itemSize: 30,
                                itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                onRatingUpdate: (rating) {
                                  // Set Our New Rating
                                  userReviewRating = rating.toInt();
                                }),
                          ],
                        ),
                      )
                    ],
                  ),

                  // Text Field To Give Review
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: TextField(
                      controller: reviewCommentController,
                      minLines: 2,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        hintText:
                            "Please Provide Detail Review of the Property...",
                      ),
                    ),
                  ),

                  // Button To Post Review
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0XFF00627C),
                              side: const BorderSide(width: 3),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0))),
                          onPressed: () {
                            // Submit a new Review from the User
                            submitReview(context, reviewCommentController.text,
                                userReviewRating);
                          },
                          child: const Text(
                            "Give Review",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          )),
                    ),
                  ),
                ],
              ),
            ),

            // Display All Review Title
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "All Reviews",
                style: TextStyle(
                    color: Color(0XFF5F5F5F),
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              ),
            ),

            // Display All the reviews from other user
            SizedBox(
              height: 500,
              child: reviewList.isEmpty
                  ? const Text("No Review Were Found!")
                  : ListView.builder(
                      itemBuilder: (context, index) {
                        return Container(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Row(
                                        children: [
                                          // Display User Details
                                          Container(
                                            margin:
                                                const EdgeInsets.only(top: 20),
                                            height: 40,
                                            width: 40,
                                            child: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  "${server.host}/static/${reviewList[index].personImage}"),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                top: 15, left: 15),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // Display The Name of the User
                                                Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      reviewList[index]
                                                          .personName,
                                                      style: const TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                                Row(
                                                  children: [
                                                    // Display The Rating Given By The User
                                                    Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: RatingBar.builder(
                                                          allowHalfRating:
                                                              false,
                                                          initialRating:
                                                              (reviewList[index]
                                                                      .reviewRating)
                                                                  .toDouble(),
                                                          itemSize: 13,
                                                          itemCount: 5,
                                                          itemBuilder:
                                                              (context, _) =>
                                                                  const Icon(
                                                                    Icons.star,
                                                                    color: Colors
                                                                        .amber,
                                                                  ),
                                                          onRatingUpdate: (rating) =>
                                                              debugPrint(rating
                                                                  .toString())),
                                                    ),
                                                    // Display The Date Of the Comment
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10),
                                                      child: Text(
                                                        reviewList[index]
                                                            .reviewTime,
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Display The Comments of the Users
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 5, right: 15),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    reviewList[index].reviewComment,
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      itemCount: reviewList.length,
                    ),
            )
          ],
        ));
  }
}
