import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vivid_estate_frontend_flutter/Classes/User.dart';
import 'package:vivid_estate_frontend_flutter/Helpers/Help.dart';

// ignore: must_be_immutable
class ReportIssue extends StatefulWidget {
  ReportIssue({super.key, required this.user});
  User user;
  @override
  State<ReportIssue> createState() => _ReportIssueState();
}

class _ReportIssueState extends State<ReportIssue> {
  // Variables to Store the Data
  var issueType = "0";
  var reportDate = "dd/mm/yy";
  var issueDetails = TextEditingController();

  // Submit the User Issue report to the Server
  void submitUserIssue(userContext) async {
    // Check Entered Information
    if (reportDate == "dd/mm/yy") {
      displaySnackBar(context, "Please choose date of issue");
    }

    // Nothing entered in the issue details
    if (issueDetails.text.isEmpty) {
      displaySnackBar(context, "Please describe your issue in detail");
    }

    // Issue Type not Selected
    if (issueType == "0") {
      displaySnackBar(context, "Please select an Issue Type");
    }

    // Now we submit the User Issue
    widget.user
        .submitIssue(userContext, issueType, reportDate, issueDetails.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Container(
          child: CloseButton(
            color: const Color(0xFF006E86),
            onPressed: () {
              //Move to the previous screen as close icon pressed
              Navigator.pop(context);
            },
          ),
        ),
        title: const Text(
          "Issue Report",
          style: TextStyle(fontSize: 28),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 30, right: 30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  child: const Text(
                    "Issue Type:",
                    style: TextStyle(fontSize: 22),
                  )),
              const SizedBox(
                height: 5,
              ),
              DropdownMenu(
                  initialSelection: "0",
                  onSelected: (val) {
                    if (val! == "0") {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Please select an Issue Type")));
                    } else {
                      setState(() {
                        issueType = val;
                      });
                    }
                  },
                  expandedInsets: EdgeInsets.zero,
                  inputDecorationTheme: InputDecorationTheme(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                  dropdownMenuEntries: const <DropdownMenuEntry<String>>[
                    DropdownMenuEntry(
                        value: "0", label: "Select Type of the issue"),
                    DropdownMenuEntry(
                        value: "Misleading Advertisement",
                        label: "Misleading Advertisement"),
                    DropdownMenuEntry(
                        value: "Seller Conduct", label: "Seller Conduct"),
                    DropdownMenuEntry(
                        value: "Application Error or Bugs",
                        label: "Application Error or Bugs"),
                    DropdownMenuEntry(
                        value: "Account/Profile", label: "Account/Profile"),
                    DropdownMenuEntry(
                        value: "Spam Messages", label: "Spam Messages"),
                  ]),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                  height: 30,
                  width: MediaQuery.of(context).size.width,
                  child: const Text(
                    "Issue Occur Date:",
                    style: TextStyle(fontSize: 22),
                  )),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                onTap: () async {
                  // Get the Date from the User
                  var selectedDate = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1990),
                      lastDate: DateTime.now());

                  // Format Our Date
                  var formatter = DateFormat('dd/MM/yy');

                  // Now we Set the Date
                  setState(() {
                    reportDate = formatter.format(selectedDate!);
                  });
                },
                decoration: InputDecoration(
                    hintText: reportDate,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(style: BorderStyle.solid))),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 40,
                width: MediaQuery.of(context).size.width,
                child: const Text(
                  "Issue Details:",
                  style: TextStyle(fontSize: 22),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                child: TextField(
                  controller: issueDetails,
                  maxLines: 10,
                  minLines: 1,
                  decoration: InputDecoration(
                      hintText: "Please provide the issue details"
                          " so we can find the whats went wrong.",
                      helperMaxLines: 150,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              const BorderSide(style: BorderStyle.solid))),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: SizedBox(
                  height: 50,
                  width: 200,
                  child: OutlinedButton(
                    onPressed: () {
                      // Submit the Issue to the Server
                      submitUserIssue(context);
                    },
                    style: OutlinedButton.styleFrom(
                      elevation: 20,
                      backgroundColor: const Color(0xFF006E86),
                      side: const BorderSide(width: 4, color: Colors.black),
                      shadowColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                    ),
                    child: const Text(
                      'Submit Issue',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
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
