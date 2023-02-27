

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'package:video_compress/video_compress.dart';

import '../models/post.dart';
import '../repositories/repository.dart';

// Upload Videos and Images
class UploadVideoController extends GetxController {
  // Repository? _repository;
 //LatLng? _fileLocation;
  final Repository _repository = Repository();







  _compressVideo(String videoPath) async {
    final compressedVideo = await VideoCompress.compressVideo(
      videoPath,
      quality: VideoQuality.MediumQuality,
    );
    return compressedVideo!.file;
  }

  Future<String> _uploadVideoToStorage(String id, String videoPath) async {
    Reference ref = FirebaseStorage.instance.ref().child('videos').child(id);

    UploadTask uploadTask = ref.putFile(await _compressVideo(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  _getThumbnail(String videoPath) async {
    final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
    return thumbnail;
  }

  Future<String?> createGifFromVideo(String videoPath) async {
    final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();

    // Set the output file path for the GIF
    String outputPath = "/path/to/output/file.gif";

    // Set the start and end time for the GIF
    String startTime = "0";
    String duration = "2"; // duration in seconds

    // Set the size and frame rate for the GIF
    String size = "320x240";
    String frameRate = "10";

    // Use the `execute` method to run the ffmpeg command to create the GIF
    int result = await _flutterFFmpeg.execute(
        " -i $videoPath -ss $startTime -t $duration -s $size -r $frameRate $outputPath"
    );

    if (result == 0) {
      // The GIF was successfully created, so return the output file path
      return outputPath;
    } else {
      // There was an error creating the GIF, so return null
      return null;
    }
  }

  List<String> getHashtags(String text) {
    // Use a regular expression to match words that start with "#"
    RegExp regExp = new RegExp(r"#(\w+)");

    // Use the `allMatches` method to find all the hashtags in the text
    Iterable<Match> matches = regExp.allMatches(text);

    // Create a list to store the hashtags
    List<String> hashtags = <String>[];

    // Add each hashtag to the list
    int count = 0;
    for (Match match in matches) {
      if (count >= 5) {
        break;
      }
      hashtags.add(match.group(0)!);
      count++;
    }
    // Return the list of hashtags
    return hashtags;
  }

  Future<String> _uploadThumbnailToStorage(String id, String videoPath) async {
    Reference ref = FirebaseStorage.instance.ref().child('thumbnails').child(id);
    UploadTask uploadTask = ref.putFile(await _getThumbnail(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> _uploadImageToStorage(String id, String videoPath) async {
    Reference ref = FirebaseStorage.instance.ref().child('images').child(id);
    UploadTask uploadTask = ref.putString(videoPath);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }



  // upload video
  uploadVideo(String caption, String videoPath) async {

      LatLng fileLocation = await _repository.getCurrentLocation();
      double latitude = fileLocation.latitude;
      double longitude = fileLocation.longitude;
      GeoFirePoint geopoint = GeoFlutterFire().point(latitude: latitude, longitude: longitude);

      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('profile').doc(userId).get();
      // get id
      var allDocs = await FirebaseFirestore.instance.collection('videos').get();
      int len = allDocs.docs.length;
      String videoUrl = await _uploadVideoToStorage("Video $len", videoPath);
      String thumbnail = await _uploadThumbnailToStorage(
          "Video $len", videoPath);

      // _fileLocation ??= location;
      String city = await _repository.getCityFromLatLng(fileLocation);
      String country = await _repository.getCountryFromLatLng(fileLocation);
      String? getGif = await createGifFromVideo(videoPath);
      List<String> tags = getHashtags(caption);

      Post video = Post(
        username: (userDoc.data()! as Map<String, dynamic>)['userName'],
        uid: userId,
        id: "Video $len",
        commentCount: 0,
        shareCount: 0,
        caption: caption,
        videoUrl: videoUrl,
        thumbnail: thumbnail,
        imageUrl: "n/a",
        profilePhoto: (userDoc.data()! as Map<String, dynamic>)['profilePic'],
        likeCount: 0,
        likeList: [],
        createdAt: DateTime.now().toUtc().toString(),
        hashTags: tags,
        cityString: city,
        countryString: country,
        gifUrl: getGif,
        position: geopoint.data,
        isVideo: true,


      );

      await FirebaseFirestore.instance.collection('videos')
          .doc('Video $len')
          .set(
        video.toJson(),

      );
      Get.back();


  }

  // upload Image
  uploadImage(String caption, String imagePath) async {
    try {

      LatLng fileLocation = await _repository.getCurrentLocation();
      double latitude = fileLocation.latitude;
      double longitude = fileLocation.longitude;
      GeoFirePoint geopoint = GeoFlutterFire().point(latitude: latitude, longitude: longitude);

      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('profile').doc(userId).get();
      // get id
      var allDocs = await FirebaseFirestore.instance.collection('images').get();
      int len = allDocs.docs.length;
      String imageUrl = await _uploadImageToStorage("Image $len", imagePath);
      
     // _fileLocation ??= location;
      String city = await _repository.getCityFromLatLng(fileLocation);
      String country = await _repository.getCountryFromLatLng(fileLocation);
      List<String> tags = getHashtags(caption) ;

      Post image = Post(
        username: (userDoc.data()! as Map<String, dynamic>)['userName'],
        uid: userId,
        id: "Image $len",
        commentCount: 0,
        shareCount: 0,
        caption: caption,
        imageUrl: imageUrl,
        profilePhoto: (userDoc.data()! as Map<String, dynamic>)['profilePic'],
        likeCount: 0,
        likeList: [],
        createdAt: DateTime.now().toUtc().toString(),
        hashTags: tags,
        cityString: city,
        countryString: country,
        position: geopoint.data,
        isVideo: false,


      );

      await FirebaseFirestore.instance.collection('images').doc('Image $len').set(
        image.toJson(),

      );
      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error Uploading Image',
        e.toString(),
      );
    }
  }



}