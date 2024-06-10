import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:vivid_estate_frontend_flutter/Authentication/ServerInfo.dart';
import 'package:vivid_estate_frontend_flutter/Authentication/ForgotPassword.dart';
import 'package:vivid_estate_frontend_flutter/Classes/User.dart';
import 'package:vivid_estate_frontend_flutter/Helpers/Help.dart';
import 'package:vivid_estate_frontend_flutter/Profile/EditProfile.dart';
import 'package:vivid_estate_frontend_flutter/Report/ReportIssue.dart';

class ProfileHome extends StatefulWidget {
  const ProfileHome({super.key});
  @override
  State<ProfileHome> createState() => _ProfileHomeState();
}

class _ProfileHomeState extends State<ProfileHome> {
  // Store User Profile Picture
  String profilePicture = "${ServerInfo().host}/static/Default.jpg";
  String userName = "No Name";
  String userID = "No ID";
  double feedbackRating = 5.0;

  var user = User();

  @override
  void initState() {
    super.initState();

    // Get the User Profile Data and Set It
    loadPageData(context);
  }

  // Load the Data of the Page
  void loadPageData(context) async {
    // Load Our Data from User
    await user.getAuthData();
    await user.getUserProfileData(context);

    print(user.profilePictureLocation);

    // Set Data to the View
    setState(() {
      profilePicture = user.profilePictureLocation;
      userName = user.fullName;
      userID = user.username;
      feedbackRating = user.feedbackRating;
    });
  }

  // Show Delete Account Dialog Box
  Future<String?> showAccountDeleteDialog(BuildContext context) async {
    final passwordController = TextEditingController();
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Account"),
          content: SizedBox(
            height: 150,
            child: Column(
              children: [
                const Text(
                    "To delete your account enter your password and click yes."),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: passwordController,
                  obscureText: true, // Hide password input
                  decoration: const InputDecoration(hintText: "Password"),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("No"),
              onPressed: () {
                Navigator.pop(context); // Close dialog, return null
              },
            ),
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                String password = passwordController.text;
                if (password.isEmpty) {
                  Navigator.pop(context); // Close dialog, return null
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Please Enter your password!")));
                } else {
                  Navigator.pop(context, password);
                  user.deleteAccount(context, password);
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: ListTile(
                leading: SizedBox(
                  height: 50,
                  width: 50,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(profilePicture),
                  ),
                ),
                title: Text(
                  userName,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  userID,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 15),
              width: MediaQuery.of(context).size.width,
              child: const Text(
                "Account & Settings ",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: const Color(0XFFE2E2E2),
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: getBoxShadow(),
              ),
              margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 15),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          onTap: () async {
                            // Move to the Edit Profile Screen
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfile(user: user),
                              ),
                            );

                            // Reload the data of the page to show the updated results
                            loadPageData(context);
                          },
                          leading: const Icon(
                            Icons.account_circle,
                            size: 30,
                          ),
                          title: const Text("Edit Profile",
                              style: TextStyle(fontSize: 22)),
                          trailing: const Icon(Icons.arrow_forward_ios),
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    thickness: 0.4,
                    color: Colors.black,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          onTap: () {
                            // Move user to reset password page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ForgotPassword(),
                              ),
                            );
                          },
                          leading: const Icon(
                            Icons.lock_reset_rounded,
                            size: 30,
                          ),
                          title: const Text(
                            "Reset Password",
                            style: TextStyle(fontSize: 22),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios),
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    thickness: 0.4,
                    color: Colors.black,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          onTap: () {
                            // Move to the Report Issue Screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReportIssue(user: user),
                              ),
                            );
                          },
                          leading: const Icon(
                            Icons.flag_outlined,
                            size: 30,
                          ),
                          title: const Text(
                            "Report Problem",
                            style: TextStyle(fontSize: 22),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: const Color(0XFFE2E2E2),
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: getBoxShadow(),
              ),
              margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 30),
              width: MediaQuery.of(context).size.width,
              child: ListTile(
                onTap: () {
                  // Display Dialog Box
                  showLogoutDialog(context, user);
                },
                leading: const Icon(
                  Icons.logout_sharp,
                  size: 30,
                ),
                title: const Text(
                  "Logout",
                  style: TextStyle(fontSize: 22),
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: const Color(0XFFA30000),
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: getBoxShadow(),
              ),
              margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 15),
              width: MediaQuery.of(context).size.width,
              child: ListTile(
                onTap: () {
                  showAccountDeleteDialog(context);
                },
                leading: const Icon(Icons.delete_forever,
                    size: 30, color: Colors.white),
                title: const Text(
                  "Delete Account",
                  style: TextStyle(fontSize: 22, color: Colors.white),
                ),
                trailing:
                    const Icon(Icons.arrow_forward_ios, color: Colors.white),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 30),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "User Feedback",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: const Color(0XFFE2E2E2),
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: getBoxShadow(),
              ),
              margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 15),
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Column(
                  children: [
                    const Text(
                      "Please share your feedback on the app!",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    RatingBar.builder(
                      initialRating: feedbackRating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Color(0xFF006E86),
                      ),
                      onRatingUpdate: (rating) {
                        // Update the User Feedback rating on the server
                        user.updateFeedback(context, rating);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
