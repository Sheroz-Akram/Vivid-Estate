import 'package:flutter/material.dart';

class ReportIssue extends StatefulWidget {
  const ReportIssue({super.key});
  @override
  State<ReportIssue> createState() => _ReportIssueState();
}

class _ReportIssueState extends State<ReportIssue> {
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
                  expandedInsets: EdgeInsets.zero,
                  inputDecorationTheme: InputDecorationTheme(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                  dropdownMenuEntries: const <DropdownMenuEntry<String>>[
                    DropdownMenuEntry(
                        value: "0", label: "Select Type of issue"),
                    DropdownMenuEntry(value: "1", label: " issue"),
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
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                    hintText: "dd/mm/yy -:- -",
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
                      debugPrint("button Submit press ");
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
