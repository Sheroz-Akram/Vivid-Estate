import 'package:flutter/material.dart';
import 'package:vivid_estate_frontend_flutter/User.dart';

class CnicPage extends StatefulWidget {
  const CnicPage({super.key, required this.userInfo});

  final User userInfo;

  @override
  State<CnicPage> createState() => _CnicPageState();
}

class _CnicPageState extends State<CnicPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const Scaffold(
      body: Center(
        child: Text("CNIC Page"),
      ),
    );
  }
}
