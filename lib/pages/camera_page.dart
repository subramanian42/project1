

import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:project1/pages/view_video_screen.dart';

import 'view_image_screen.dart';
//import 'package:flutter_video/video_page.dart';

late List<CameraDescription> cameras ;
class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  bool _isLoading = false;
  bool _isRecording = false;
  late CameraController _cameraController;
  bool flash = false;
  double transform = 0;
  bool iscamerafront = true;
  late Future<void> cameraValue;



  @override
  void initState() {
    _initCamera();
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
    _cameraController.dispose();
  }

  _initCamera() async {
   // final cameras = await availableCameras();
    _cameraController = CameraController(cameras[0], ResolutionPreset.high);
    cameraValue =  _cameraController.initialize();
  }


  @override
  Widget build(BuildContext context) {
      return Center(
        child: Stack(
          children: [
            FutureBuilder(
                future: cameraValue,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: CameraPreview(_cameraController));
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
            Positioned(
              bottom: 0.0,
              child: Container(
                //color: Colors.blue,
                padding: EdgeInsets.only(top: 5, bottom: 5),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            icon: Icon(
                              flash ? Icons.flash_on : Icons.flash_off,
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: () {
                              setState(() {
                                flash = !flash;
                              });
                              flash
                                  ? _cameraController
                                  .setFlashMode(FlashMode.torch)
                                  : _cameraController.setFlashMode(FlashMode.off);
                            }),
                        GestureDetector(
                          onLongPress: () async {
                            await _cameraController.startVideoRecording();
                            setState(() {
                              _isRecording = true;
                            });
                          },
                          onLongPressUp: () async {
                            XFile videopath =
                            await _cameraController.stopVideoRecording();
                            setState(() {
                              _isRecording = false;
                            });
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) => VideoViewPage(
                                      path: videopath.path,
                                    )));
                          },
                          onTap: () {
                            if (!_isRecording) takePhoto(context);
                          },
                          child: _isRecording
                              ? Icon(
                            Icons.radio_button_on,
                            color: Colors.red,
                            size: 80,
                          )
                              : Icon(
                            Icons.panorama_fish_eye,
                            color: Colors.white,
                            size: 70,
                          ),
                        ),
                        IconButton(
                            icon: Transform.rotate(
                              angle: transform,
                              child: Icon(
                                Icons.flip_camera_ios,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            onPressed: () async {
                              setState(() {
                                iscamerafront = !iscamerafront;
                                transform = transform + pi;
                              });
                              int cameraPos = iscamerafront ? 0 : 1;
                              _cameraController = CameraController(
                                  cameras[cameraPos], ResolutionPreset.high);
                              cameraValue = _cameraController.initialize();
                            }),
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      "Hold for Video, tap for photo",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
  }

  void takePhoto(BuildContext context) async {
    XFile file = await _cameraController.takePicture();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (builder) => ImageViewPage(
              path: file.path,
            )));
  }
}


