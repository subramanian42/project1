import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class UserModel extends Equatable {
  String? key;
  String? email;
  String? userId;
  String? displayName;
  String? userName;
  String? webSite;
  String? profilePic;
  String? bannerImage;
  String? contact;
  String? bio;
  String? location;
  String? dob;
  String? createdAt;
  bool? isVerified;
  int? cityCount;
  int? followers;
  int? following;
  String? fcmToken;
  List<String>? followersList;
  List<String>? followingList;

  UserModel(
      {this.email,
        this.userId,
        this.displayName,
        this.profilePic,
        this.bannerImage,
        this.key,
        this.contact,
        this.bio,
        this.dob,
        this.location,
        this.createdAt,
        this.userName,
        this.cityCount,
        this.followers,
        this.following,
        this.webSite,
        this.isVerified,
        this.fcmToken,
        this.followersList,
        this.followingList});

  UserModel.fromJson(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return;
    }
    followersList ??= [];
    email = map['email'];
    userId = map['userId'];
    displayName = map['displayName'];
    profilePic = map['profilePic'];
    bannerImage = map['bannerImage'];
    key = map['key'];
    dob = map['dob'];
    bio = map['bio'];
    location = map['location'];
    contact = map['contact'];
    createdAt = map['createdAt'];
    cityCount = map['cityCount'];
    followers = map['followers'];
    following = map['following'];
    userName = map['userName'];
    webSite = map['webSite'];
    fcmToken = map['fcmToken'];
    isVerified = map['isVerified'] ?? false;
    if (map['followerList'] != null) {
      followersList = <String>[];
      map['followerList'].forEach((value) {
        followersList!.add(value);
      });
    }
    followers = followersList != null ? followersList!.length : null;
    if (map['followingList'] != null) {
      followingList = <String>[];
      map['followingList'].forEach((value) {
        followingList!.add(value);
      });
    }
    following = followingList != null ? followingList!.length : null;
  }
  toJson() {
    return {
      'key': key,
      "userId": userId,
      "email": email,
      'displayName': displayName,
      'profilePic': profilePic,
      'bannerImage': bannerImage,
      'contact': contact,
      'dob': dob,
      'bio': bio,
      'location': location,
      'createdAt': createdAt,
      'cityCount': cityCount,
      'followers': followersList != null ? followersList!.length : null,
      'following': followingList != null ? followingList!.length : null,
      'userName': userName,
      'webSite': webSite,
      'isVerified': isVerified ?? false,
      'fcmToken': fcmToken,
      'followerList': followersList,
      'followingList': followingList
    };
  }

  UserModel copyWith({
    String? email,
    String? userId,
    String? displayName,
    String? profilePic,
    String? key,
    String? contact,
    String? bio,
    String? dob,
    String? bannerImage,
    String? location,
    String? createdAt,
    String? userName,
    int? cityCount,
    int? followers,
    int? following,
    String? webSite,
    bool? isVerified,
    String? fcmToken,
    List<String>? followingList,
    List<String>? followersList,
  }) {
    return UserModel(
      email: email ?? this.email,
      bio: bio ?? this.bio,
      contact: contact ?? this.contact,
      createdAt: createdAt ?? this.createdAt,
      displayName: displayName ?? this.displayName,
      dob: dob ?? this.dob,
      cityCount: cityCount ?? this.cityCount,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      isVerified: isVerified ?? this.isVerified,
      key: key ?? this.key,
      location: location ?? this.location,
      profilePic: profilePic ?? this.profilePic,
      bannerImage: bannerImage ?? this.bannerImage,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      webSite: webSite ?? this.webSite,
      fcmToken: fcmToken ?? this.fcmToken,
      followersList: followersList ?? this.followersList,
      followingList: followingList ?? this.followingList,
    );
  }

  String get getFollower {
    return '${followers ?? 0}';
  }

  String get getFollowing {
    return '${following ?? 0}';
  }

  @override
  List<Object?> get props => [
    key,
    email,
    userId,
    displayName,
    userName,
    webSite,
    profilePic,
    bannerImage,
    contact,
    bio,
    location,
    dob,
    createdAt,
    isVerified,
    cityCount,
    followers,
    following,
    fcmToken,
    followersList,
    followingList
  ];
}



















// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// class User {
//   final String email;
//   final String uid;
//   final String photoUrl;
//   final String username;
//   final String bioLocation;
//   final List followers;
//   final List following;
//   //final LatLng currentLocation;
//
//   const User(
//       {required this.username,
//         required this.uid,
//         required this.photoUrl,
//         required this.email,
//         required this.bioLocation,
//         required this.followers,
//         required this.following,
//       //  required this.currentLocation
//
//
//       });
//
//   static User fromSnap(DocumentSnapshot snap) {
//     var snapshot = snap.data() as Map<String, dynamic>;
//
//     return User(
//       username: snapshot["username"],
//       uid: snapshot["uid"],
//       email: snapshot["email"],
//       photoUrl: snapshot["photoUrl"],
//       bioLocation: snapshot["bioLocation"],
//       followers: snapshot["followers"],
//       following: snapshot["following"],
//     //  currentLocation: snapshot["currentLocation"]
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     "username": username,
//     "uid": uid,
//     "email": email,
//     "photoUrl": photoUrl,
//     "bioLocation": bioLocation,
//     "followers": followers,
//     "following": following,
//   };
// }