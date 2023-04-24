//import 'dart:io';
//import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';
//import 'package:video_player/video_player.dart';

import '../models/notifications.dart';
import '../models/user.dart';
import '../providers/location_provider.dart';

/// Class that communicates with external APIs.
class Repository {
  static const _anonymousUUID = '00000000-0000-0000-0000-000000000000';
  late FlutterSecureStorage _localStorage;
  String? get userId => FirebaseAuth.instance.currentUser!.uid ;
  List<AppNotification> _notifications = [];
  final _notificationsStreamController =
  BehaviorSubject<List<AppNotification>>();

  /// Emits list of in app notification.
  Stream<List<AppNotification>> get notificationsStream =>
      _notificationsStreamController.stream;

  static const _timestampOfLastSeenNotification =
      'timestampOfLastSeenNotification';

  /// In memory cache of profileDetails.
  @visibleForTesting
  final Map<String, UserModel> profileDetailsCache = {};
  final _profileStreamController =
  BehaviorSubject<Map<String, UserModel>>();





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

  /// Loads the 50 most recent notifications.
  Future<void> getNotifications() async {
    if (userId == null) {
      // If the user is not signed in, do not emit anything
      return;
    }

    final query = FirebaseFirestore.instance.collection('notifications')
        .where('receiver_user_id', isEqualTo: userId)
        .where('action_user_id', isNotEqualTo: userId)
        .orderBy('created_at')
        .limit(50);

    final querySnapshot = await query.get();
    final data = querySnapshot.docs.map((doc) => doc.data()).toList();

    final timestampOfLastSeenNotification =
    await _localStorage.read(key: _timestampOfLastSeenNotification);
    DateTime? createdAtOfLastSeenNotification;
    if (timestampOfLastSeenNotification != null) {
      createdAtOfLastSeenNotification =
          DateTime.parse(timestampOfLastSeenNotification);
    }

    _notifications = AppNotification.fromData(data,
        createdAtOfLastSeenNotification: createdAtOfLastSeenNotification);
    _notificationsStreamController.sink.add(_notifications);

    Future<AppNotification> _replaceCommentTextWithMentionedUserName(
        AppNotification notification,
        ) async {
      if (notification.commentText == null) {
        return notification;
      }
      final commentText =
      await replaceMentionsWithUserNames(notification.commentText!);
      return notification.copyWith(commentText: commentText);
    }

    _notifications = await Future.wait(
        _notifications.map(_replaceCommentTextWithMentionedUserName));
    _notificationsStreamController.sink.add(_notifications);
  }


  /// Replaces user ids found in comments with user names
  Future<String> replaceMentionsWithUserNames(
      String comment,
      ) async {
    await Future.wait(
        getUserIdsInComment(comment).map(getProfileDetail).toList());
    final regExp = RegExp(
        r'@[0-9a-f]{8}\b-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-\b[0-9a-f]{12}\b');
    final replacedComment = comment.replaceAllMapped(regExp, (match) {
      final key = match.group(0)!.substring(1);
      final name = profileDetailsCache[key]?.userName;

      /// Return the original id if no profile was found with the id
      return '@${name ?? match.group(0)!.substring(1)}';
    });
    return replacedComment;
  }

  /// Returns list of userIds that are present in a comment
  List<String> getUserIdsInComment(String comment) {
    final regExp = RegExp(
        r'@[0-9a-f]{8}\b-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-\b[0-9a-f]{12}\b');
    final matches = regExp.allMatches(comment);
    return matches.map((match) => match.group(0)!.substring(1)).toList();
  }

  /// Get profile detail of a certain user.
  Future<void> getProfileDetail(String targetUid) async {
    if (profileDetailsCache[targetUid] != null) {
      return;
    }

    final DocumentSnapshot profileDoc = await FirebaseFirestore.instance.collection('profile').doc(targetUid).get();
    final Map<String, dynamic> params = {
      'my_user_id': userId ?? _anonymousUUID,
      'target_user_id': targetUid,
    };

    final QuerySnapshot querySnapshot = await profileDoc.reference.collection('rpc').where('name', isEqualTo: 'profile_detail').where('params', isEqualTo: params).get();
    final List<QueryDocumentSnapshot> docs = querySnapshot.docs;

    if (docs.isEmpty) {
      throw PlatformException(
        code: 'No User',
        message: 'Could not find the user.',
      );
    }

    final Map<String, dynamic>? data = docs.first.get('results');

    if (data == null || data.isEmpty) {
      throw PlatformException(
        code: 'No User',
        message: 'Could not find the user.',
      );
    }

    final profile = UserModel.fromData(data);
    profileDetailsCache[targetUid] = profile;
    _profileStreamController.sink.add(profileDetailsCache);
  }

  /// Updates the timestamp of when the user has last seen notifications.
  ///
  /// Timestamp of when the user has last seen notifications is used to
  /// determine which notification is unread.
  Future<void> updateTimestampOfLastSeenNotification(DateTime time) async {
    await _localStorage.write(
        key: _timestampOfLastSeenNotification, value: time.toIso8601String());
  }





}