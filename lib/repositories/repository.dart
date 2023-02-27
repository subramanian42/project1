//import 'dart:io';
//import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:video_player/video_player.dart';

import '../providers/location_provider.dart';

/// Class that communicates with external APIs.
class Repository {





  /// Opens device's camera roll to find videos taken in the past.
  Future<XFile?> getVideoFile() async {
    try {
      final pickedVideo =
      await ImagePicker().pickVideo(source: ImageSource.gallery);
      if (pickedVideo != null) {
        return XFile(pickedVideo.path);
      }
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  /// Find the location attached to a video file from a video path.
  Future<LatLng?> getVideoLocation(String videoPath) async {
    final videoInfo = await FlutterVideoInfo().getVideoInfo(videoPath);
    final locationString = videoInfo?.location;
    if (locationString != null) {
      print(locationString);
      final matches = RegExp(r'(\+|\-)(\d*\.?\d*)').allMatches(locationString);
      final lat = double.parse(matches.elementAt(0).group(0)!);
      final lng = double.parse(matches.elementAt(1).group(0)!);
      return LatLng(lat, lng);
    }
  }





  Future<String> getCityFromLatLng(LatLng? latLng) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(latLng!.latitude,latLng.longitude);
    Placemark placemark = placemarks.first;
    return placemark.locality.toString();
  }

  Future<String> getCountryFromLatLng(LatLng? latLng) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(latLng!.latitude,latLng.longitude);
    Placemark placemark = placemarks.first;
    return placemark.country.toString();
  }

  Future<LatLng>  getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LatLng currentPosition;

    if (!serviceEnabled) {
      return Future.error("Location Services are Disabled");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied,We cannot access location');
    }
    else {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium);

      currentPosition = LatLng(position.latitude, position.longitude);
    }
    return currentPosition;
  }

//Returns a list of video documents
  Stream<List<DocumentSnapshot>> getVideoList(GeoFirePoint center,double radius,String field, bool strictMode){

    final CollectionReference videosCollection = FirebaseFirestore.instance.collection('videos');

    Stream<List<DocumentSnapshot>> stream = GeoFlutterFire().collection(collectionRef: videosCollection)
        .within(center: center, radius: radius, field: field, strictMode: strictMode);

    return stream;

  }











}