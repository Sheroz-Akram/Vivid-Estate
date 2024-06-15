import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:vivid_estate_frontend_flutter/Authentication/ServerInfo.dart';

class FullScreenImageView extends StatefulWidget {
  final List<dynamic> images;
  final int initialIndex;

  const FullScreenImageView(
      {super.key, required this.images, required this.initialIndex});

  @override
  _FullScreenImageViewState createState() => _FullScreenImageViewState();
}

class _FullScreenImageViewState extends State<FullScreenImageView> {
  late PageController _pageController;
  var server = ServerInfo();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leadingWidth: 150,
          leading: Row(
            children: [
              // Back Button
              IconButton(
                  onPressed: () {},
                  icon: InkWell(
                      onTap: () {
                        // Move to the Prevous Page
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back_ios_outlined,
                        color: Color(0XFF00627C),
                      ))),
              const Text(
                "Back",
                style: TextStyle(
                    color: Color(0XFF00627C),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ],
          )),
      body: PhotoViewGallery.builder(
        pageController: _pageController,
        itemCount: widget.images.length,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider:
                NetworkImage("${server.host}/static/${widget.images[index]}"),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
          );
        },
        scrollPhysics: const BouncingScrollPhysics(),
        backgroundDecoration: const BoxDecoration(color: Colors.black),
      ),
    );
  }
}
