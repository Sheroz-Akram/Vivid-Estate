import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vivid_estate_frontend_flutter/BuyerScreens/PanoramaView.dart';
import 'package:vivid_estate_frontend_flutter/SellerScreens/2D%20Layout/drawing_page.dart';

class LayoutList extends StatefulWidget {
  const LayoutList({super.key, required this.LayoutData});

  final LayoutData;

  @override
  State<LayoutList> createState() => _LayoutListState();
}

class _LayoutListState extends State<LayoutList> {
  // Controllers To Handle Input
  var nameController = TextEditingController();

  // Store the Virtual Visit Data
  var LayoutData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Set Our Virtual Visit Data
    setState(() {
      LayoutData = widget.LayoutData;
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
                  "2D Layouts",
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 22,
                      color: Color(0XFF006E86)),
                ),

                const Spacer(),

                // Button to Add new Virtual Visit
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: ElevatedButton(
                      onPressed: () {
                        // Show Dialog to Ask Name of Virtual Visit
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Enter Floor Details'),
                                content: SingleChildScrollView(
                                  child: Column(
                                    children: <Widget>[
                                      TextField(
                                        controller: nameController,
                                        decoration: const InputDecoration(
                                          labelText: 'Floor Name',
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      String name = nameController.text;

                                      if (name.isNotEmpty) {
                                        print('Floor Name: $name');

                                        // Pop the Dialog Box
                                        Navigator.pop(context);

                                        // Open Virtual Visit Creation Page
                                        await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DrawingPage(
                                                      updateParentData: (String
                                                          fileLocation) {
                                                        if (fileLocation
                                                            .isNotEmpty) {
                                                          setState(() {
                                                            LayoutData.add({
                                                              "FloorName": name,
                                                              "FileLocation":
                                                                  fileLocation
                                                            });
                                                          });
                                                        }
                                                      },
                                                    )));

                                        // Check if Got Virual Visit
                                      } else {
                                        // Display Message
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "Please Fill Complete Information")));
                                      }
                                    },
                                    child: const Text('Next'),
                                  ),
                                ],
                              );
                            });

                        // Open Virtual Visit Capture Page
                      },
                      child: const Icon(
                        Icons.add,
                        size: 30,
                      )),
                )
              ],
            ),

            // Display List of All Virtual Visits
            LayoutData.isNotEmpty
                ? Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            // View Property in 360 View
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PanoramaView(
                                        VisitLocation: LayoutData.elementAt(
                                            index)['FileLocation'])));
                          },
                          child: Container(
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
                                        LayoutData.elementAt(
                                            index)['FloorName'],
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                ElevatedButton(
                                    onPressed: () {
                                      // Delete Property
                                      setState(() {
                                        LayoutData.removeAt(index);
                                      });
                                    },
                                    style: const ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Color.fromARGB(
                                                    135, 247, 218, 216))),
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ))
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: LayoutData.length,
                    ),
                  )
                : const Center(
                    child: Text("No Layout Found."),
                  ),

            // Button To Save Virtual Visits
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, LayoutData);
                },
                child: const Text("Save"))
          ],
        ),
      ),
    );
  }
}
