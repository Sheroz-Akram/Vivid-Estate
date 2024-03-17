import 'package:flutter/material.dart';

class Reply extends StatefulWidget {
  const Reply({super.key, required this.message, required this.time});
  final String message;
  final String time;

  @override
  State<Reply> createState() => _Reply();
}

class _Reply extends State<Reply> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45,
          ),
          child: Card(
            elevation: 1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            // color: Colors.blue,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 60, top: 5, bottom: 20),
                  child: Text(
                    widget.message,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(
                  width: 5,
                  height: 10,
                ),
                Positioned(
                  bottom: 4,
                  right: 10,
                  child: Text(
                    widget.time,
                    style: const TextStyle(fontSize: 13, color: Colors.black),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
