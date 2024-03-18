import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class ProfileHome extends StatefulWidget {
  const ProfileHome({super.key, required this.title});

  final String title;

  @override
  State<ProfileHome> createState() => _ProfileHomeState();
}

class _ProfileHomeState extends State<ProfileHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            leadingWidth: 80,
            leading: const SizedBox(
              height: 70,
              width: 70,
              child: CircleAvatar(
                backgroundImage: AssetImage("assets/images/sheroz.jpg"),
              ),
            ),
            title: const Column(children: [
              Text(
                "Sheroz Akram",
                style: TextStyle(
                    fontSize: 30,
                    fontFamily: "font1",
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "@Sheroz01",
                style: TextStyle(
                    fontSize: 18, fontFamily: "font1", color: Colors.grey),
              )
            ])),
        body: Padding(
          padding: const EdgeInsets.only(top: 50.0, left: 50.0, right: 50.0),
          child: Column(
            children: [
              const Text(
                "Accounts & Settings",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: "font2",
                    fontSize: 25),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey,
                ),
                child: const Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.only(top: 20.0, left: 30.0, right: 30),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.account_circle_rounded,
                              size: 50,
                            ),
                            SizedBox(
                              width: 60,
                            ),
                            Text(
                              "Edit Profile",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 60,
                            ),
                            Icon(Icons.arrow_forward_ios),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 2.0, left: 30.0, right: 30),
                      child: Divider(
                        thickness: 1,
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(top: 20.0, left: 30.0, right: 30),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.lock_reset_rounded,
                              size: 50,
                            ),
                            SizedBox(
                              width: 40,
                            ),
                            Text(
                              "Reset Password",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 40,
                            ),
                            Icon(Icons.arrow_forward_ios),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 2.0, left: 30.0, right: 30),
                      child: Divider(
                        thickness: 1,
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(top: 20.0, left: 30.0, right: 30),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.flag_circle,
                              size: 50,
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Text(
                              "Report A Problem",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Icon(Icons.arrow_forward_ios),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.grey,
                  ),
                  child: const SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(top: 0, left: 30.0, right: 30),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(
                                    Icons.logout_sharp,
                                    size: 50,
                                  ),
                                  SizedBox(
                                    width: 80,
                                  ),
                                  Text(
                                    "Logout",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 80,
                                  ),
                                  Icon(Icons.arrow_forward_ios),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.red,
                  ),
                  child: const SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 30.0, right: 30),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.delete_forever,
                                  size: 50,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 40,
                                ),
                                Text(
                                  "Delete Account",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                SizedBox(
                                  width: 40,
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
