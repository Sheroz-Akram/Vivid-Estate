import 'dart:io';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vivid_estate_frontend_flutter/Authentication/ServerInfo.dart';
import 'package:vivid_estate_frontend_flutter/Classes/Buyer.dart';
import 'package:vivid_estate_frontend_flutter/Classes/Property.dart';
import 'package:vivid_estate_frontend_flutter/Classes/Seller.dart';
import 'package:vivid_estate_frontend_flutter/Helpers/Help.dart';
import 'package:vivid_estate_frontend_flutter/SellerScreens/2D%20Layout/LayoutList.dart';
import 'package:vivid_estate_frontend_flutter/SellerScreens/360%20Virtual%20Visit/VirtualVisitList.dart';

class EditProperty extends StatefulWidget {
  const EditProperty({super.key, required this.propertyID});

  final propertyID;

  @override
  State<EditProperty> createState() => _EditPropertyState();
}

class _EditPropertyState extends State<EditProperty> {
  // A Buyer Object to Get Data
  var buyer = Buyer();

  // Store Information regarding the property
  var selectedPropertyType = 'None';
  var listingType = 'Sell';
  var propertyLocationData = {
    "isSet": "no",
    "latitude": 0.0,
    "longitude": 0.0,
    "address": "none"
  };
  var propertyDescription = TextEditingController();
  var propertyPrice = TextEditingController();
  var propertySize = TextEditingController();
  var noBeds = "";
  var noFloors = "";

  // Data of Virtual Visit
  var VirtualVisitData = [];

  // Data of the 2D Layouts
  var LayoutData = [];

  // store the Images from camera
  List<dynamic> propertyImages = [];

  @override
  void initState() {
    super.initState();

    // Load Data of the Property
    loadPageData(context);
  }

  Future<File> _downloadImageToFile(String imageUrl) async {
    // Fetch the image bytes
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      // Get the temporary directory
      final tempDir = await getTemporaryDirectory();
      // Create a unique file path
      final filePath = path.join(tempDir.path,
          'temp_image_${DateTime.now().millisecondsSinceEpoch}.png');
      // Create the file
      final file = File(filePath);
      // Write the image bytes to the file
      await file.writeAsBytes(response.bodyBytes);
      return file;
    } else {
      throw Exception('Failed to download image');
    }
  }

  // Help With Server
  var server = ServerInfo();

  // Load the Details of the Property
  void loadPageData(BuildContext context) async {
    // First Get Our Auth Data
    await buyer.getAuthData();

    // Get the Property Details From Server
    Property responseProperty =
        await buyer.getPropertyDetail(context, widget.propertyID);

    // Download Image Files and Add to the List
    List<dynamic> downloadImages = [];
    for (var image in responseProperty.images) {
      downloadImages
          .add(await _downloadImageToFile("${server.host}/static/$image"));
    }

    // Now We Update Our State
    setState(() {
      selectedPropertyType = responseProperty.propertyType;
      listingType = responseProperty.listingType;
      propertyLocationData = {
        "isSet": "yes",
        "latitude": responseProperty.latitude,
        "longitude": responseProperty.longitude,
        "address": responseProperty.location
      };
      propertyDescription.text = responseProperty.description;
      propertyPrice.text = responseProperty.price.toString();
      propertySize.text = responseProperty.size.toString();
      noFloors = responseProperty.floors.toString();
      noBeds = responseProperty.beds.toString();
      VirtualVisitData = responseProperty.visits;
      LayoutData = responseProperty.layouts;
      propertyImages = downloadImages;
    });
  }

  // Pick the Property Images from the Camera
  // Select a image from the prefered source whether camera or gallery
  Future pickImage(
      ImageSource imageSource, BuildContext myContext, pictureIndex) async {
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
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: false),
        iosUiSettings: const IOSUiSettings(
          title: 'Crop Image',
        ),
      );

      Navigator.pop(myContext);

      // Check if User Cropped the Image or Not
      if (croppedImage == null) {
        ScaffoldMessenger.of(myContext).showSnackBar(
            const SnackBar(content: Text("Please select or take a image!!")));
      }
      // Display the new Image
      else {
        setState(() {
          if (pictureIndex < propertyImages.length) {
            propertyImages[pictureIndex] = croppedImage;
          } else {
            propertyImages.add(croppedImage);
          }
        });
      }
    }
  }

  // Submit the Property Data to the Server
  void submitPropertyDataToServer(BuildContext userContext) async {
    // Check if the input data is valuid or not
    if (selectedPropertyType == 'None') {
      displaySnackBar(userContext, "Please Select the type of the property.");
    } else if (propertyLocationData['isSet'] == "no") {
      displaySnackBar(userContext, "Please select location of the property.");
    } else if (propertyPrice.text.isEmpty) {
      displaySnackBar(userContext, "Please enter the price of the property.");
    } else if (propertySize.text.isEmpty) {
      displaySnackBar(userContext, "Please enter the size of the property.");
    } else if (noBeds == "") {
      displaySnackBar(
          userContext, "Please Select the number of bed in the house.");
    } else if (noFloors == "") {
      displaySnackBar(
          userContext, "Please Select the number of floors in the house.");
    } else if (propertyImages.length < 2) {
      displaySnackBar(userContext, "Select at least 2 images of the property.");
    } else if (propertyDescription.text.isEmpty) {
      displaySnackBar(userContext, "Provide the details the property.");
    }

    // We have pass all our checks
    else {
      var propertyData = {
        "PropertyType": selectedPropertyType,
        "ListingType": listingType,
        "Location": {
          "Latitude": propertyLocationData['latitude'],
          "Longitude": propertyLocationData['longitude']
        },
        "Price": propertyPrice.text,
        "Size": propertySize.text,
        "Beds": noBeds,
        "Floors": noFloors,
        "Description": propertyDescription.text
      };

      // Add Virtual Visit Data To Our List
      propertyData['VirtualVisitCount'] = VirtualVisitData.length.toString();
      propertyData['Visits'] = VirtualVisitData;

      // Add Layout Data To Our List
      propertyData['LayoutCount'] = LayoutData.length.toString();
      propertyData['Layouts'] = LayoutData;

      // As we checked the data. Now we submit it to the server
      var seller = Seller();
      await seller.getAuthData();

      seller.editProperty(
          userContext, propertyImages, propertyData, widget.propertyID);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, top: 10),
                    child: Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: const Text(
                            "Edit Property",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0XFF006E86),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /*
                    
                    Top Right Button to close the new property creation menu

                    */
                  Container(
                    child: CloseButton(
                      color: const Color(0XFF006E86),
                      onPressed: () {
                        // Move to the previous screen
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              ),
              Container(
                  margin: const EdgeInsets.only(left: 15),
                  width: MediaQuery.of(context).size.width,
                  child: const Text(
                    "Fill the information below and edit your property",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  )),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(left: 15, top: 10),
                child: const Text(
                  "Property Type",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0XFF8D8D8D),
                  ),
                ),
              ),

              /*
                
                Select Property type of the advertisement
                
                */
              Container(
                padding: const EdgeInsets.only(
                    left: 15, top: 10, bottom: 15, right: 15),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: ['House', 'Apartment', 'Hostel', 'Room']
                        .map((type) => ChoiceChip(
                            label: Text(type),
                            selected: selectedPropertyType == type,
                            onSelected: (bool selected) {
                              setState(() {
                                selectedPropertyType = type;
                              });
                            },
                            selectedColor: const Color(0xFF006E86),
                            checkmarkColor: Colors.white,
                            labelStyle: TextStyle(
                              color: selectedPropertyType == type
                                  ? Colors.white
                                  : Colors.black, // Adjust 'black' if needed
                            )))
                        .toList(),
                  ),
                ),
              ),
              /**
                 * Option to choose between selling or renting
                 */
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: const Text(
                              "Listing Type",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0XFF8D8D8D),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 14,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: Row(
                            children: [
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.2 - 5,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: listingType == 'Sell'
                                          ? const Color(0xFF006E86)
                                          : Colors.white,
                                    ),
                                    onPressed: () {
                                      // Change the listing type
                                      setState(() {
                                        listingType = 'Sell';
                                      });
                                    },
                                    child: Text(
                                      "Sell",
                                      style: TextStyle(
                                          color: listingType == 'Sell'
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10),
                                    )),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: listingType == 'Rent'
                                          ? const Color(0xFF006E86)
                                          : Colors.white,
                                    ),
                                    onPressed: () {
                                      // Change the listing type
                                      setState(() {
                                        listingType = 'Rent';
                                      });
                                    },
                                    child: Text("Rent",
                                        style: TextStyle(
                                            color: listingType == 'Rent'
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10))),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  /**
                     * Option to select the property location on map
                     */
                  Container(
                      padding: const EdgeInsets.only(right: 15),
                      width: MediaQuery.of(context).size.width * 0.49,
                      child: Column(
                        children: [
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Location",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0XFF8D8D8D),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          OpenStreetMapSearchAndPick(
                                              locationPinText:
                                                  "Property Location",
                                              locationPinTextStyle:
                                                  const TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold),
                                              locationPinIconColor: Colors.red,
                                              locationPinIcon:
                                                  Icons.location_on,
                                              buttonColor:
                                                  const Color(0xFF006E86),
                                              buttonText:
                                                  'Set Current Location',
                                              onPicked: (pickedData) {
                                                // Move Back to Previous Screen
                                                Navigator.pop(context);

                                                print(pickedData.addressName);

                                                setState(() {
                                                  // Set the Longitude and Langitude
                                                  propertyLocationData[
                                                      'isSet'] = 'yes';
                                                  propertyLocationData[
                                                          'latitude'] =
                                                      pickedData
                                                          .latLong.latitude;
                                                  propertyLocationData[
                                                          'longitude'] =
                                                      pickedData
                                                          .latLong.longitude;
                                                  propertyLocationData[
                                                          'address'] =
                                                      pickedData.addressName;
                                                });
                                              })));
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.49,
                              height: 40,
                              decoration: BoxDecoration(
                                border: Border.all(width: 1),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                              0.49 -
                                          37,
                                      padding: const EdgeInsets.only(left: 5),
                                      child: propertyLocationData['isSet'] ==
                                              'yes'
                                          ? SizedBox(
                                              width: (MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.49) -
                                                  30,
                                              child: Text(
                                                  textAlign: TextAlign.justify,
                                                  '${propertyLocationData['address']}'),
                                            )
                                          : const Text("Open in Maps")),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
              /**
                 * Fields to Enter Property Information
                 */
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 15, top: 10),
                  child: Text(
                    "Property Info",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0XFF8D8D8D)),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /**
                     * Input property price
                     */
                  Container(
                    padding: const EdgeInsets.only(left: 15),
                    width: MediaQuery.of(context).size.width * 0.49,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            listingType == 'Rent' ? "Price/Month" : "Price",
                            style: const TextStyle(
                              fontSize: 18,
                              color: Color(0XFF5093A1),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        TextField(
                          controller: propertyPrice,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: "Price in Rupee",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                        ),
                      ],
                    ),
                  ),
                  /**
                     * Input the Land Area
                     */
                  Container(
                    padding: const EdgeInsets.only(right: 15),
                    width: MediaQuery.of(context).size.width * 0.49,
                    child: Column(
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Size(in meter)",
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0XFF5093A1),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        TextField(
                          controller: propertySize,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: "Total Land Aread in square meters",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              /**
                 * Fields to Input the living space of the property
                 */
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 15, top: 10),
                  child: Text(
                    "Living Space",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0XFF8D8D8D)),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 15),
                    width: MediaQuery.of(context).size.width * 0.49,
                    child: Column(
                      children: [
                        /**
                           * Input number of beds in the property
                           */
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "No of Beds",
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0XFF5093A1),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DropdownMenu(
                          initialSelection: noBeds,
                          onSelected: (value) {
                            noBeds = value!;
                          },
                          inputDecorationTheme: InputDecorationTheme(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0))),
                          dropdownMenuEntries: const [
                            DropdownMenuEntry(value: "1", label: "1"),
                            DropdownMenuEntry(value: "1", label: "2"),
                            DropdownMenuEntry(value: "2", label: "3"),
                            DropdownMenuEntry(value: "3", label: "4"),
                            DropdownMenuEntry(value: "5", label: "5"),
                            DropdownMenuEntry(value: "6", label: "6"),
                            DropdownMenuEntry(value: "7", label: "7"),
                            DropdownMenuEntry(value: "8", label: "8"),
                            DropdownMenuEntry(value: "9", label: "9"),
                            DropdownMenuEntry(value: "10", label: "10"),
                          ],
                          width: MediaQuery.of(context).size.width * 0.49 - 15,
                          hintText: "Select  Beds",
                        ),
                      ],
                    ),
                  ),

                  /**
                     * 
                     * Input Number of floors of the property
                     * 
                     */
                  Container(
                    margin: const EdgeInsets.only(right: 15, left: 10),
                    width: MediaQuery.of(context).size.width * 0.49 - 20,
                    child: Column(
                      children: [
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "No of Floors",
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0XFF5093A1),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: DropdownMenu(
                            initialSelection: noFloors,
                            onSelected: (value) {
                              noFloors = value!;
                            },
                            inputDecorationTheme: InputDecorationTheme(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0))),
                            dropdownMenuEntries: const [
                              DropdownMenuEntry(value: "1", label: "1"),
                              DropdownMenuEntry(value: "1", label: "2"),
                              DropdownMenuEntry(value: "2", label: "3"),
                              DropdownMenuEntry(value: "3", label: "4"),
                            ],
                            width:
                                MediaQuery.of(context).size.width * 0.49 - 15,
                            hintText: "Select  Floors",
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              /**
                 * 
                 * Field to add pictures of the property
                 * 
                 */
              Align(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, top: 10),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: const Text(
                      "Ad Pictures",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0XFF8D8D8D)),
                    ),
                  ),
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(right: 15),
                  height: 200,
                  child: InkWell(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            // Select Image from the User
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return SizedBox(
                                      height: 200,
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: Column(children: <Widget>[
                                          /**
                                           * Modal Header Bar
                                           */
                                          Container(
                                            margin: const EdgeInsets.only(
                                                top: 10, bottom: 10),
                                            child: Row(
                                              children: [
                                                /**
                                                 * Modal Title
                                                 */
                                                const Text(
                                                  "Select Picture",
                                                  style: TextStyle(
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0XFF8D8D8D)),
                                                ),
                                                const Spacer(),
                                                /**
                                                 * Modal Close Button
                                                 */
                                                Container(
                                                  child: CloseButton(
                                                    color:
                                                        const Color(0XFF006E86),
                                                    onPressed: () {
                                                      // Move to the previous screen
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),

                                          // Take Picture from Camera Button
                                          ElevatedButton(
                                            style: const ButtonStyle(
                                                backgroundColor:
                                                    MaterialStatePropertyAll(
                                                        Color.fromARGB(255, 230,
                                                            230, 230))),
                                            onPressed: () {
                                              // take picture from camera
                                              pickImage(ImageSource.camera,
                                                  context, index);
                                            },
                                            child: const Row(
                                              children: <Widget>[
                                                Icon(Icons.camera_alt),
                                                SizedBox(width: 10),
                                                Text("Take Picture From Camera")
                                              ],
                                            ),
                                          ),

                                          Container(
                                              margin: const EdgeInsets.only(
                                                  top: 7, bottom: 7),
                                              child: const Text(
                                                  "-------------------- OR --------------------")),

                                          // Take Picture from Galery Button
                                          ElevatedButton(
                                              style: const ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStatePropertyAll(
                                                          Color.fromARGB(255,
                                                              230, 230, 230))),
                                              onPressed: () {
                                                // take picture from gallery
                                                pickImage(ImageSource.gallery,
                                                    context, index);
                                              },
                                              child: const Row(
                                                children: <Widget>[
                                                  Icon(Icons
                                                      .photo_size_select_actual_rounded),
                                                  SizedBox(width: 10),
                                                  Text(
                                                      "Select Picture From Gallery")
                                                ],
                                              ))
                                        ]),
                                      ));
                                });
                          },
                          child: Container(
                            height: 300,
                            margin: const EdgeInsets.only(left: 15),
                            width: MediaQuery.of(context).size.width * 0.70,
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 216, 216, 216),
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Center(
                                child: propertyImages.length >= index + 1
                                    ? Image.file(propertyImages[index]!,
                                        width: 300, fit: BoxFit.fill)
                                    : const Icon(
                                        Icons.camera_alt_rounded,
                                        color: Color(0xFF006E86),
                                        size: 40,
                                      )),
                          ),
                        );
                      },
                      itemCount: propertyImages.length + 1,
                    ),
                  )),

              /**
              * Description of the property entry field
              */
              Align(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, top: 10),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: const Text(
                      "Description",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0XFF8D8D8D)),
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.all(10),
                child: TextField(
                    maxLines: 10,
                    minLines: 5,
                    controller: propertyDescription,
                    decoration: InputDecoration(
                        hintText:
                            "Please provide the complete details of the property.",
                        helperMaxLines: 150,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(style: BorderStyle.solid)))),
              ),

              // Optional to add features
              Align(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, top: 10),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: const Text(
                      "Optional Features",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0XFF8D8D8D)),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    /**
                     * Opens Page to create the 2D Layout of the property
                     */
                    InkWell(
                      onTap: () async {
                        // Open 2D Layout List
                        var newLayoutData = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LayoutList(
                                      LayoutData: LayoutData,
                                    )));
                        setState(() {
                          LayoutData = newLayoutData;
                        });
                      },
                      child: Container(
                          padding: const EdgeInsets.only(
                              top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
                          decoration: BoxDecoration(
                              color: const Color(0xFFECECEC),
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: getBoxShadow()),
                          margin: const EdgeInsets.only(top: 15),
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: const ListTile(
                                    leading: Icon(
                                      Icons.map_outlined,
                                      size: 30,
                                    ),
                                    title: Text("Edit 2D Layout",
                                        style: TextStyle(fontSize: 16)),
                                    trailing: InkWell(
                                        child: Icon(Icons.arrow_forward_ios)),
                                  ),
                                ),
                              )
                            ],
                          )),
                    ),

                    /**
                     * Load Page to List Virtual Visits
                     */
                    InkWell(
                      onTap: () async {
                        // Open Virtual Visit List
                        var newVirtualVisitData = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VirtualVisitList(
                                      VirtualVisitData: VirtualVisitData,
                                    )));
                        setState(() {
                          VirtualVisitData = newVirtualVisitData;
                        });
                      },
                      child: Container(
                          padding: const EdgeInsets.only(
                              top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
                          decoration: BoxDecoration(
                              color: const Color(0xFFECECEC),
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: getBoxShadow()),
                          margin: const EdgeInsets.only(top: 15),
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: const ListTile(
                                    leading: Icon(
                                      Icons.vrpano_sharp,
                                      size: 30,
                                    ),
                                    title: Text("Edit Virtual Visit",
                                        style: TextStyle(fontSize: 16)),
                                    trailing: InkWell(
                                        child: Icon(Icons.arrow_forward_ios)),
                                  ),
                                ),
                              )
                            ],
                          )),
                    ),
                  ],
                ),
              ),

              // Button to submit the data to the server
              Center(
                  child: Container(
                margin: const EdgeInsets.only(top: 30, bottom: 20),
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
                      // Submit the Data to the Server
                      submitPropertyDataToServer(context);
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )),
              ))
            ]),
          ),
        ),
      ),
    );
  }
}
