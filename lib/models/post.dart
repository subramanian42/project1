import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Post {

  String? username;
  String? uid;
  String? id;
  int? commentCount;
  int? shareCount;
  String? caption;
  String? videoUrl;
  String? imageUrl;
  String? thumbnail;
  String? profilePhoto;
  int? likeCount;
  List<String>? likeList;
  String? createdAt;
  List<String>? hashTags;
  String? cityString;
  String? countryString;
  String? gifUrl;
  Object? position;
  bool? isVideo;

  Post({

    this.username,
    this.uid,
    this.id,
    this.commentCount,
    this.shareCount,
    this.caption,
    this.videoUrl,
    this.imageUrl,
    this.thumbnail,
    this.profilePhoto,
    this.likeCount,
    this.likeList,
    this.createdAt,
    this.hashTags,
    this.cityString,
    this.countryString,
    this.gifUrl,
    this.position,
    this.isVideo,
  });

  Map<String, dynamic> toJson() => {
    "username": username,
    "uid": uid,
    "id": id,
    "caption": caption,
    "likeCount": likeCount,
    "commentCount": commentCount ?? 0,
    "shareCount": shareCount ?? 0,
    "createdAt": createdAt,
    "videoUrl": videoUrl,
    "imageUrl": imageUrl,
    "likeList": likeList,
    "hashTags": hashTags,
    "profilePhoto": profilePhoto,
    "thumbnail": thumbnail,
    "cityString": cityString,
    "countryString": countryString,
    "gifUrl": gifUrl,
    "position": position,
    "isVideo" : isVideo,
  };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      username: snapshot['username'],
      uid: snapshot['uid'],
      id: snapshot['id'],
      caption: snapshot['caption'],
      likeCount: snapshot['likeCount'],
      shareCount: snapshot['shareCount'],
      commentCount: snapshot['commentCount'],
      createdAt: snapshot['createdAt'],
      videoUrl: snapshot['videoUrl'],
      imageUrl: snapshot['imageUrl'],
      likeList: (snapshot['likeList'] as List<dynamic>).cast<String>(),
      hashTags: (snapshot['hashTags'] as List<dynamic>).cast<String>(),
      profilePhoto: snapshot['profilePhoto'],
      thumbnail: snapshot['thumbnail'],
      cityString: snapshot['cityString'],
      countryString: snapshot['countryString'],
      gifUrl: snapshot['gifUrl'],
      position: snapshot['position'],
      isVideo: snapshot['isVideo'],

    );
  }
}


