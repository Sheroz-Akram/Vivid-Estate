import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vivid_estate_frontend_flutter/BuyerScreens/PanoramaView.dart';

class VirtualVisitListBuyer extends StatefulWidget {
  const VirtualVisitListBuyer({super.key, required this.VirtualVisitData});

  final VirtualVisitData;

  @override
  State<VirtualVisitListBuyer> createState() => _VirtualVisitListBuyerState();
}

class _VirtualVisitListBuyerState extends State<VirtualVisitListBuyer> {
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PanoramaView(
                                        VisitLocation:
                                            VirtualVisitData.elementAt(
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
                                            "Dimensions: ${VirtualVisitData.elementAt(index)['Dimensions']}")),
                                  ],
                                ),
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
          ],
        ),
      ),
    );
  }
}
