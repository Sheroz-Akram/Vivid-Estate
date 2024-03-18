import 'package:flutter/material.dart';

class Send extends StatefulWidget {
  const Send(
      {super.key,
      required this.message,
      required this.time,
      required this.status});
  final String message;
  final String time;
  final String status;
  @override
  State<Send> createState() => _Send();
}

class _Send extends State<Send> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45,
          ),
          child: Card(
            elevation: 1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            color: const Color(0xFF006E86),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 60, top: 5, bottom: 20),
                  child: Text(
                    widget.message,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                const SizedBox(
                  width: 5,
                  height: 10,
                ),
                Positioned(
                  bottom: 4,
                  right: 10,
                  child: Row(
                    children: [
                      Text(
                        widget.time,
                        style: const TextStyle(
                            fontSize: 13, color: Colors.white54),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Icon(
                        widget.status.toLowerCase() == "viewed"
                            ? Icons.done_all
                            : Icons.done,
                        size: 20,
                        color: Colors.white54,
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
