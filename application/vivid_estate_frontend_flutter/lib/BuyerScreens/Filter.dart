import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPage();
}

class _FilterPage extends State<FilterPage> {
  // Filter Information
  var selectedPropertyType = 'None';
  RangeValues priceRange = const RangeValues(0, 10000000);
  String selectedLocation = 'Lahore, Punjab';
  RangeValues sizeRange = const RangeValues(0, 1000);
  int noOfBeds = 5;
  int noOfFloors = 2;
  var newValue;
  late String _selectedLocation = '1';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      // Move to previous Screen
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close,
                      size: 30,
                    ),
                    color: const Color(0xFF006E86),
                  ),
                  InkWell(
                      onTap: () {
                        print(" Clear action ");
                      },
                      child: const Text(
                        "Clear all",
                        style: TextStyle(
                          color: Color(0xFF006E86),
                          fontFamily: "font1",
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ],
              ),
              Container(
                padding: const EdgeInsets.only(left: 10),
                child: const Text(
                  'Filters List',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: "font1",
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 25, left: 10, top: 10),
                child: Text(
                  'Property Type',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: "font1",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
              const Divider(
                color: Colors.black,
                thickness: 1,
                height: 40,
              ),
              const Text(
                'Price Range',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "font1",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      children: [
                        Center(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.sizeOf(context).width * 0.40,
                                  child: Column(
                                    children: [
                                      const Row(
                                        children: [
                                          Text("From:"),
                                        ],
                                      ),
                                      TextField(
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                              hintText: "Lowest",
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ))),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: (MediaQuery.sizeOf(context).width *
                                          0.20) -
                                      40,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.sizeOf(context).width * 0.40,
                                  child: Column(children: [
                                    const Row(
                                      children: [
                                        Text("To:"),
                                      ],
                                    ),
                                    TextField(
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            hintText: "Highest",
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ))),
                                  ]),
                                ),
                              ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Divider(
                color: Colors.black,
                thickness: 1,
                height: 40,
              ),
              const Text(
                'Select Location',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "font1",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Lahore,Punjab",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
              const Divider(
                color: Colors.black,
                thickness: 1,
                height: 40,
              ),
              const Text(
                'Property Size (in meters)',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "font1",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: SizedBox(
                                  width:
                                      MediaQuery.sizeOf(context).width * 0.40,
                                  child: Column(
                                    children: [
                                      const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text("From:"),
                                        ],
                                      ),
                                      TextField(
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                              hintText: "Lowest",
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ))),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width:
                                    (MediaQuery.sizeOf(context).width * 0.20) -
                                        40,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: SizedBox(
                                  width:
                                      MediaQuery.sizeOf(context).width * 0.40,
                                  child: Column(children: [
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text("To:"),
                                      ],
                                    ),
                                    TextField(
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            hintText: "Highest",
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ))),
                                  ]),
                                ),
                              ),
                            ]),
                      ],
                    ),
                  ),
                ),
              ),
              const Divider(
                color: Colors.black,
                thickness: 1,
                height: 40,
              ),
              const Text(
                'Living Space',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "font1",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width * 0.40,
                              height: 100,
                              child: Column(
                                children: [
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("No of Beds:"),
                                    ],
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.40,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors
                                              .grey), // Adjust color as needed
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(
                                              10)), // Modify radius for desired curvature
                                    ),
                                    child: Center(
                                      child: DropdownButton<String>(
                                        icon: const Icon(Icons.bed_outlined),
                                        underline: const SizedBox.shrink(),
                                        items: <String>['1', '2', '3', '4']
                                            .map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),

                                        // Not necessary for Option 1
                                        value: _selectedLocation,
                                        onChanged: (newValue) {
                                          setState(() {
                                            _selectedLocation = newValue!;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: (MediaQuery.sizeOf(context).width * 0.20) -
                                  40,
                            ),
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width * 0.40,
                              height: 100,
                              child: Column(children: [
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text("No of Floors:"),
                                  ],
                                ),
                                Container(
                                  width:
                                      MediaQuery.sizeOf(context).width * 0.40,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors
                                            .grey), // Adjust color as needed
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(
                                            10)), // Modify radius for desired curvature
                                  ),
                                  child: Center(
                                    child: DropdownButton<String>(
                                      underline: const SizedBox.shrink(),
                                      icon: const Icon(Icons.stairs_outlined),
                                      items: <String>['1', '2', '3']
                                          .map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),

                                      // Not necessary for Option 1
                                      value: _selectedLocation,
                                      onChanged: (newValue) {
                                        setState(() {
                                          _selectedLocation = newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                          ]),
                    ],
                  ),
                ),
              ),
              Center(
                child: SizedBox(
                  height: 50,
                  width: 200,
                  child: OutlinedButton(
                    onPressed: () {
                      // Apply filters
                    },
                    style: ButtonStyle(
                      shadowColor: MaterialStateColor.resolveWith(
                          (states) => const Color.fromARGB(255, 107, 107, 107)),
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => const Color(0xFF006E86)),
                      side: MaterialStateProperty.all<BorderSide>(
                        const BorderSide(width: 4, color: Colors.black),
                      ),
                    ),
                    child: const Text(
                      'Apply',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
