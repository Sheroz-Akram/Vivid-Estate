import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:vivid_estate_frontend_flutter/Classes/User.dart';

// ignore: must_be_immutable
class EditProfile extends StatefulWidget {
  EditProfile({super.key, required this.user});
  User user;
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  // Controllers to read the data from the user input text fields
  final _display_name = TextEditingController();
  final _cnic_number = TextEditingController();
  final _cnic_dob = TextEditingController();

  // Store Our Profile Picture
  File? profileImage;

  // Select a image from the prefered source whether camera or gallery
  Future pickImage(ImageSource imageSource, BuildContext myContext) async {
    final image = await ImagePicker().pickImage(source: imageSource);

    // If Image not Selected
    if (image == null) {
      ScaffoldMessenger.of(myContext).showSnackBar(
          const SnackBar(content: Text("Please select or take a image!!")));
    } else {
      // Save our Image in Temporary Files
      File? croppedImage = await ImageCropper().cropImage(
        sourcePath: image.path,
        compressFormat: ImageCompressFormat.png,
        compressQuality: 100,
        androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Crop CNIC',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: false),
        iosUiSettings: const IOSUiSettings(
          title: 'Crop CNIC',
        ),
      );

      // Check if User Cropped the Image or Not
      if (croppedImage == null) {
        ScaffoldMessenger.of(myContext).showSnackBar(
            const SnackBar(content: Text("Please select or take a image!!")));
      }
      // Display the new Image
      else {
        setState(() {
          profileImage = croppedImage;
        });

        // Update the profile picture in the server
        widget.user.updateUserProfilePicture(profileImage, myContext);
      }
    }
  }

  // Now we have to get the user edited data and submit it the server
  void submitDataToServer(BuildContext userContext) {
    // Get all the required data
    widget.user.updateProfileData(
      userContext,
      _display_name.text.isNotEmpty ? _display_name.text : widget.user.fullName,
      _cnic_number.text.isNotEmpty ? _cnic_number.text : widget.user.cnicNumber,
      _cnic_dob.text.isNotEmpty ? _cnic_dob.text : widget.user.dob,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(
          color: Color(0XFF00627C),
        ),
        centerTitle: true,
        title: const Text(
          "Edit Profile",
          style: TextStyle(
              color: Color(0XFF5F5F5F),
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Stack(children: [
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: InkWell(
                      onTap: () {
                        // take picture from gallery
                        pickImage(ImageSource.gallery, context);
                      },

                      // Display the User Profile Picture
                      child: CircleAvatar(
                        backgroundImage: profileImage == null

                            // Profile Picture store on the Internet
                            ? NetworkImage(widget.user.profilePictureLocation)

                            // Profile Picture selected to change from local device
                            : FileImage(profileImage!) as ImageProvider,
                      ),
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(left: 75, top: 75),
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        weight: 50,
                        color: Color(0XFF00627C),
                      ))
                ]),
              ),
              Container(
                margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 1, left: 15),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Enter Display Name",
                          style: TextStyle(
                              color: Color(0XFF00627C),
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Card(
                        elevation: 8,
                        shadowColor: Colors.black26,
                        child: TextField(
                          controller: _display_name,
                          decoration: InputDecoration(
                            hintText: widget.user.fullName,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  const BorderSide(color: Colors.white38),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 1, left: 15),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Enter Location",
                          style: TextStyle(
                              color: Color(0XFF00627C),
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Card(
                        elevation: 8,
                        shadowColor: Colors.black26,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Lahore, Pakistan",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  const BorderSide(color: Colors.white38),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 1, left: 15),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Update CNIC",
                          style: TextStyle(
                              color: Color(0XFF00627C),
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Card(
                        elevation: 8,
                        shadowColor: Colors.black26,
                        child: TextField(
                          controller: _cnic_number,
                          decoration: InputDecoration(
                            hintText: widget.user.cnicNumber,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  const BorderSide(color: Colors.white38),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 1, left: 15),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Date of Birth",
                          style: TextStyle(
                              color: Color(0XFF00627C),
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Card(
                        elevation: 8,
                        shadowColor: Colors.black26,
                        child: TextField(
                          onTap: () async {
                            // Get the Date from the User
                            var selectedDate = await showDatePicker(
                                context: context,
                                firstDate: DateTime(1990),
                                lastDate: DateTime.now());

                            // Format Our Date
                            var formatter = DateFormat('dd.MM.yy');

                            // Now we Set the Date
                            setState(() {
                              _cnic_dob.text = formatter.format(selectedDate!);
                            });
                          },
                          controller: _cnic_dob,
                          decoration: InputDecoration(
                            hintText: widget.user.dob,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  const BorderSide(color: Colors.white38),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                  child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 20),
                width: 200,
                height: 40,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0XFF00627C),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: const BorderSide(width: 3)),
                      elevation: 30,
                      shadowColor: Colors.black26,
                    ),
                    onPressed: () {
                      // Submit the Edited data to the Server
                      submitDataToServer(context);
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
