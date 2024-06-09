import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:panorama_viewer/panorama_viewer.dart';
import 'package:vivid_estate_frontend_flutter/Authentication/ServerInfo.dart';

class PanoramaView extends StatefulWidget {
  const PanoramaView({super.key, required this.VisitLocation});

  final String VisitLocation;

  @override
  State<PanoramaView> createState() => _PanoramaViewState();
}

class _PanoramaViewState extends State<PanoramaView> {
  // Help With Server
  var server = ServerInfo();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Center(
      child: PanoramaViewer(
        child: Image.network("${server.host}/static/${widget.VisitLocation}"),
      ),
    ));
  }
}
