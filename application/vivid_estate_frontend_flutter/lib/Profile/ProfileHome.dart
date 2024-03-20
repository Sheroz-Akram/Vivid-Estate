import 'package:flutter/material.dart';
import 'package:vivid_estate_frontend_flutter/Authentication/ServerInfo.dart';
import 'package:vivid_estate_frontend_flutter/Authentication/ForgotPassword.dart';
import 'package:vivid_estate_frontend_flutter/Helpers/Help.dart';
import 'package:vivid_estate_frontend_flutter/Report/ReportIssue.dart';

class ProfileHome extends StatefulWidget {
  const ProfileHome({super.key});
  @override
  State<ProfileHome> createState() => _ProfileHome();
}

class _ProfileHome extends State<ProfileHome> {
  // Store User Profile Picture
  String profilePicture = "${ServerInfo().host}/static/Default.jpg";
  String userName = "No Name";
  String userID = "No ID";

  @override
  void initState() {
    super.initState();
    getUserProfileData(context);
  }

  // Get the User Profile Image
  void getUserProfileData(myContext) async {
    // Create a New Server
    var server = ServerInfo();

    // Send Request to Our Server
    server.sendPostRequest(
        myContext, "profile_data", await server.getAuthData(), (result) {
      if (result['status'] == "success") {
        var data = result['message'];
        setState(() {
          profilePicture = "${server.host}/static/" + data['profilePic'];
          userName = data['userFullName'];
          userID = data['userName'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          ListTile(
            leading: SizedBox(
                height: 70,
                width: 70,
                child: CircleAvatar(
                    backgroundImage: NetworkImage(profilePicture))),
            title: Text(
              userName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              userID,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
          ),
          Container(
              margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 15),
              width: MediaQuery.of(context).size.width,
              child: const Text(
                "Account & Settings ",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              )),
          Container(
            padding: const EdgeInsets.only(
                top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
            decoration: BoxDecoration(
              color: const Color(0XFFE2E2E2),
              borderRadius: BorderRadius.circular(10.0),
            ),
            margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 15),
            height: 225,
            width: MediaQuery.of(context).size.width,
            child: Expanded(
              child: ListView(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ListTile(
                            onTap: () => {print("Edit Profile")},
                            leading: const Icon(
                              Icons.account_circle,
                              size: 30,
                            ),
                            title: const Text("Edit Profile",
                                style: TextStyle(fontSize: 22)),
                            trailing: const InkWell(
                                child: Icon(Icons.arrow_forward_ios)),
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    child: const Divider(
                      thickness: 0.4,
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ListTile(
                            onTap: () {
                              // Move use to reset use password page
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgotPassword()));
                            },
                            leading: const Icon(
                              Icons.lock_reset_rounded,
                              size: 30,
                            ),
                            title: const Text(
                              "Reset Password",
                              style: TextStyle(fontSize: 22),
                            ),
                            trailing: const InkWell(
                              child: Icon(Icons.arrow_forward_ios),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    child: const Divider(
                      thickness: 0.4,
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ListTile(
                            onTap: () => {
                              // Move to the Report Issue Screen
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ReportIssue()))
                            },
                            leading: const Icon(
                              Icons.flag_outlined,
                              size: 30,
                            ),
                            title: const Text(
                              "Report Problem",
                              style: TextStyle(fontSize: 22),
                            ),
                            trailing: const InkWell(
                              child: Icon(Icons.arrow_forward_ios),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(
                      top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
                  decoration: BoxDecoration(
                    color: const Color(0XFFE2E2E2),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  margin:
                      const EdgeInsets.only(left: 20.0, right: 20.0, top: 30),
                  width: MediaQuery.of(context).size.width,
                  height: 75,
                  child: ListTile(
                    onTap: () => {
                      // Display Dialog Box
                      showLogoutDialog(context)
                    },
                    leading: const Icon(
                      Icons.logout_sharp,
                      size: 30,
                    ),
                    title: const Text(
                      "Logout",
                      style: TextStyle(fontSize: 22),
                    ),
                    trailing: const InkWell(
                      child: Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                ),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(
                      top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
                  decoration: BoxDecoration(
                    color: const Color(0XFFA30000),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  margin:
                      const EdgeInsets.only(left: 20.0, right: 20.0, top: 15),
                  width: MediaQuery.of(context).size.width,
                  height: 75,
                  child: ListTile(
                    onTap: () => {print("Delete Account")},
                    leading: const Icon(Icons.delete_forever,
                        size: 30, color: Colors.white),
                    title: const Text(
                      "Delete Account",
                      style: TextStyle(fontSize: 22, color: Colors.white),
                    ),
                    trailing: const InkWell(
                      child: Icon(Icons.arrow_forward_ios, color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ]),
      ),
    );
  }
}
