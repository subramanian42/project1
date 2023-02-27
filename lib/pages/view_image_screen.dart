import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:get/get_core/src/get_main.dart';
import 'package:video_player/video_player.dart';

import '../controllers/upload_video_controller.dart';

class ImageViewPage extends StatefulWidget {
  const ImageViewPage({Key? key, required this.path}) : super(key: key);
  final String path;

  @override
  State<ImageViewPage> createState() => _ImageViewPageState();
}

class _ImageViewPageState extends State<ImageViewPage> {


  TextEditingController _captionController = TextEditingController();

  UploadVideoController uploadVideoController =
  Get.put(UploadVideoController());


  late LatLng currentPosition ;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<LatLng>  _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled){
      return Future.error("Location Services are Disabled");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied){
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever){
      return Future.error('Location permissions are permanently denied,We cannot access location');
    }
    else {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
      setState(() {
        currentPosition = LatLng(position.latitude, position.longitude);
      });
    }
    return currentPosition;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
              icon: const Icon(
                Icons.crop_rotate,
                size: 27,
              ),
              onPressed: () {}),
          IconButton(
              icon: const Icon(
                Icons.emoji_emotions_outlined,
                size: 27,
              ),
              onPressed: () {}),
          IconButton(
              icon: const Icon(
                Icons.title,
                size: 27,
              ),
              onPressed: () {}),
          IconButton(
              icon: const Icon(
                Icons.edit,
                size: 27,
              ),
              onPressed: () {}),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 150,
              child: Image.file(
                File(widget.path),
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                color: Colors.black38,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                child: TextFormField(
                  controller: _captionController,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                  maxLines: 6,
                  minLines: 1,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Add Caption....",
                      prefixIcon: const Icon(
                        Icons.add_photo_alternate,
                        color: Colors.white,
                        size: 27,
                      ),
                      hintStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                      suffixIcon: InkWell(
                        onTap: () => uploadVideoController.uploadImage(
                            _captionController.text,
                            widget.path),
                        child: CircleAvatar(
                          radius: 27,
                          backgroundColor: Colors.tealAccent[700],
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 27,
                          ),
                        ),
                      )
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}