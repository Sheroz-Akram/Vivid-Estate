// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vivid_estate_frontend_flutter/BuyerScreens/PostView.dart';
import 'package:vivid_estate_frontend_flutter/Helpers/Help.dart';

// ignore: must_be_immutable
class PropertySearchPreview extends StatefulWidget {
  PropertySearchPreview({super.key, required this.propertySimpleInformation});

  // Store the Information Needed for the property
  dynamic propertySimpleInformation;

  @override
  State<PropertySearchPreview> createState() => _PropertySearchPreview();
}

/// Display The Preview of the Property
class _PropertySearchPreview extends State<PropertySearchPreview> {
  @override
  Widget build(BuildContext context) {
    return
        // Show the preview of the ad
        InkWell(
      onTap: () {
        // Open the Detail POST View of the Property
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PostView(
                    PropertyID: widget.propertySimpleInformation['PropertyID']
                        .toString())));
      },
      child: Container(
        margin: const EdgeInsets.all(6.0),
        decoration: BoxDecoration(
          color: const Color(0XFFE2E2E2),
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(
                  255, 107, 107, 107), // Set shadow color to black
              blurRadius: 4.0, // Adjust blur for softness
              spreadRadius: 1.0, // Adjust spread for size
              offset: Offset(0.0, 0.0), // Offset the shadow
            ),
          ],
        ),
        // Display All the Data of the Property
        child: Column(
          children: [
            /**
             * Display the Image of the Property
             */
            SizedBox(
              height: 200,
              width: MediaQuery.of(context).size.width - 30,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: Image.network(
                  widget.propertySimpleInformation['PropertyImageAddress'],
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            // Display Price
            Container(
              padding: const EdgeInsets.only(left: 5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Price: ${formatNumber(widget.propertySimpleInformation['Price'])}",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            // Display Location
            Container(
              padding: const EdgeInsets.only(left: 5),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                    "Location: ${widget.propertySimpleInformation['Location']}"),
              ),
            ),

            // Display Type of the Property
            Container(
              padding: const EdgeInsets.only(left: 5),
              child: Align(
                alignment: Alignment.bottomLeft,
                child:
                    Text("Type: ${widget.propertySimpleInformation['Type']}"),
              ),
            ),

            // Sized Box for bottom margin
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
