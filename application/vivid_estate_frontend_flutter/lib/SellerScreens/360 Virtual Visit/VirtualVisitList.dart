import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vivid_estate_frontend_flutter/SellerScreens/360%20Virtual%20Visit/VirtualVisitCapture.dart';

class VirtualVisitList extends StatefulWidget {
  const VirtualVisitList({super.key, required this.VirtualVisitData});

  final VirtualVisitData;

  @override
  State<VirtualVisitList> createState() => _VirtualVisitListState();
}

class _VirtualVisitListState extends State<VirtualVisitList> {
  // Controllers To Handle Input
  var nameController = TextEditingController();
  var lengthController = TextEditingController();
  var widthController = TextEditingController();
  var heightController = TextEditingController();

  // Store the Virtual Visit Data
  var VirtualVisitData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Set Our Virtual Visit Data
    setState(() {
      VirtualVisitData = widget.VirtualVisitData;
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
                  "Virtual Visits",
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
                                title: const Text('Enter Room Details'),
                                content: SingleChildScrollView(
                                  child: Column(
                                    children: <Widget>[
                                      TextField(
                                        controller: nameController,
                                        decoration: const InputDecoration(
                                          labelText: 'Room Name',
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      TextField(
                                        controller: lengthController,
                                        decoration: const InputDecoration(
                                          labelText: 'Length',
                                        ),
                                        keyboardType: TextInputType.number,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      TextField(
                                        controller: widthController,
                                        decoration: const InputDecoration(
                                          labelText: 'Width',
                                        ),
                                        keyboardType: TextInputType.number,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      TextField(
                                        controller: heightController,
                                        decoration: const InputDecoration(
                                          labelText: 'Height',
                                        ),
                                        keyboardType: TextInputType.number,
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
                                      String length = lengthController.text;
                                      String width = widthController.text;
                                      String height = heightController.text;

                                      if (name.isNotEmpty &&
                                          length.isNotEmpty &&
                                          width.isNotEmpty &&
                                          height.isNotEmpty) {
                                        print('Room Name: $name');
                                        print('Length: $length');
                                        print('Width: $width');
                                        print('Height: $height');

                                        // Pop the Dialog Box
                                        Navigator.pop(context);

                                        // Open Virtual Visit Creation Page
                                        String virtualVistLocation =
                                            await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const VirtualVisitCapture()));

                                        // Check if Got Virual Visit
                                        if (virtualVistLocation.isNotEmpty) {
                                          setState(() {
                                            VirtualVisitData.add({
                                              "RoomName": name,
                                              "Length": length,
                                              "Width": width,
                                              "Height": height,
                                              "VirtualVisitLocation":
                                                  virtualVistLocation
                                            });
                                          });
                                        }
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
            VirtualVisitData.isNotEmpty
                ? Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            // View Property in 360 View
                            // To Be Implemented
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
                                        VirtualVisitData.elementAt(
                                            index)['RoomName'],
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            "Dimensions: ${VirtualVisitData.elementAt(index)['Length']}x${VirtualVisitData.elementAt(index)['Width']}x${VirtualVisitData.elementAt(index)['Height']}")),
                                  ],
                                ),
                                const Spacer(),
                                ElevatedButton(
                                    onPressed: () {
                                      // Delete Property
                                      setState(() {
                                        VirtualVisitData.removeAt(index);
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
                      itemCount: VirtualVisitData.length,
                    ),
                  )
                : const Center(
                    child: Text("No Virtual Visits"),
                  ),

            // Button To Save Virtual Visits
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, VirtualVisitData);
                },
                child: const Text("Save"))
          ],
        ),
      ),
    );
  }
}
