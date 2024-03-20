import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class SellerDashboard extends StatefulWidget {
  const SellerDashboard({super.key});

  @override
  State<SellerDashboard> createState() => _SellerDashboardState();
}

class _SellerDashboardState extends State<SellerDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20.0),
            width: MediaQuery.of(context).size.width,
            child: const Text(
              "Dashboard",
              style: TextStyle(
                  color: Color(0XFF006E86),
                  fontSize: 36,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ListTile(
              leading: const CircleAvatar(
                backgroundImage: AssetImage("assets/images/sheroz.jpg"),
              ),
              title: Container(
                  child: const Text(
                "Sheroz Akram",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0XFF7D7D7D)),
              )),
              subtitle: Container(
                  child: const Text("Lahore,Pakistan",
                      style: TextStyle(
                          color: Color(0XFF9D9D9D),
                          fontSize: 18,
                          fontWeight: FontWeight.bold))),
              trailing: Container(
                child: Image.asset(
                  "assets/UI/seller-dashboard.png",
                  height: 1000,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
                top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
            decoration: BoxDecoration(
              color: const Color(0XFFBBE4EC),
              borderRadius: BorderRadius.circular(10.0),
            ),
            margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 15),
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(top: 5, bottom: 25),
                  child: const Text(
                    "This Month",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Image.asset("assets/UI/impressions.png"),
                        const Text(
                          "Impression",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            const Text(
                              "20K",
                              style: TextStyle(
                                  fontSize: 36, fontWeight: FontWeight.bold),
                            ),
                            Image.asset("assets/UI/up.png"),
                          ],
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Image.asset("assets/UI/likes.png"),
                        const Text(
                          "View",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            const Text(
                              "5K",
                              style: TextStyle(
                                  fontSize: 36, fontWeight: FontWeight.bold),
                            ),
                            Image.asset("assets/UI/down.png"),
                          ],
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Image.asset("assets/UI/views.png"),
                        const Text(
                          "Likes",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            const Text(
                              "510K",
                              style: TextStyle(
                                  fontSize: 36, fontWeight: FontWeight.bold),
                            ),
                            Image.asset("assets/UI/up.png"),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 15.0, left: 25.0, right: 25.0),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Active Ads : 2",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Totals Chats : 5",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
                top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
            decoration: BoxDecoration(
              color: const Color(0XFFBBE4EC),
              borderRadius: BorderRadius.circular(10.0),
            ),
            margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 15),
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ListTile(
                      leading: const Icon(
                        Icons.add_circle_outline,
                        size: 30,
                      ),
                      title: const Text("Create New ad",
                          style: TextStyle(fontSize: 16)),
                      trailing: InkWell(
                          onTap: () {
                            print("Create ad");
                          },
                          child: const Icon(Icons.arrow_forward_ios)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
