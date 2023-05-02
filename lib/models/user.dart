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
  List<String>? citiesList;

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
        this.followingList,
        this.citiesList,
      });

  UserModel.fromJson(Map<dynamic, dynamic>? map, DocumentReference<Object?> reference) {
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
    citiesList = map['citiesList'];
    isVerified = map['isVerified'] ?? false;
    if (map['followersList'] != null) {
      followersList = <String>[];
      map['followersList'].forEach((value) {
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
      'followersList': followersList,
      'followingList': followingList,
      'citiesList': citiesList
    };
  }

  factory UserModel.fromData(Map<String, dynamic> data) {
    return UserModel.fromJson(data['profile'], data['ref']);
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
    List<String>? citiesList,
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
      citiesList: citiesList ?? this.citiesList,

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
    followingList,
    citiesList,
  ];

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    final userModel = UserModel.fromJson(
        snapshot.data() as Map<String, dynamic>, snapshot.reference);
    return userModel;
  }
}

