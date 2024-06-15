import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vivid_estate_frontend_flutter/Helpers/Help.dart';

class BiddingList extends StatefulWidget {
  const BiddingList({super.key, required this.BiddingData});

  final BiddingData;

  @override
  State<BiddingList> createState() => _BiddingListState();
}

class _BiddingListState extends State<BiddingList> {
  // Store the List of Biddings by the Buyer
  dynamic BiddingData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      BiddingData = widget.BiddingData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            // Display Top Header
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: Color(0XFF006E86))),
                const Text(
                  "Bidding List",
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 22,
                      color: Color(0XFF006E86)),
                ),
                const Spacer(),
              ],
            ),

            // Display List of All Virtual Visits
            BiddingData.isNotEmpty
                ? Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.only(bottom: 10),
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Amount: ${formatNumber(BiddingData[index]['Amount'].toInt())}",
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                        "Person Name: ${BiddingData[index]['Name']}"),
                                  )
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                      itemCount: BiddingData.length,
                    ),
                  )
                : const Center(
                    child: Text("No Bids Found"),
                  ),
          ],
        ),
      ),
    );
  }
}
