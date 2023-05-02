import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project1/pages/edit_profile_screen.dart';
import 'package:project1/pages/messagesScreen.dart';
import 'package:project1/pages/settings_screen.dart';
import 'package:project1/pages/view_story_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/post.dart';
import '../resources/auth_methods.dart';
import '../resources/firestore_methods.dart';
import '../testing/custom_video_player_preview.dart';
import '../testing/user_model.dart';
import '../testing/videoList.dart';
import '../utils/utils.dart';
import '../widgets/follow_button.dart';
import 'following_screen.dart';


class ProfileScreen extends StatefulWidget {
  final String uid;

  const ProfileScreen({Key? key, required this.uid}) : super(key: key);



  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
 late bool isFollowing ;
  bool isLoading = false;

  late List<DocumentSnapshot> _imagePosts = [];
  late List<DocumentSnapshot> _videoPosts = [];
  late List<DocumentSnapshot> _storyPosts = [];
  late DocumentSnapshot<Object?> firstStory;
  late Map<String, List<DocumentSnapshot>> _groupedPosts = {};



  @override
  void initState() {
    super.initState();
    getData();
  }

  _launchURLApp(String siteUrl) async {
    var url = Uri.parse(siteUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,

      );
    } else {
      throw 'Could not launch $url';
    }
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {

      FirebaseFirestore.instance
          .collection('images')
          .where('uid', isEqualTo: widget.uid)
          .get()
          .then((querySnapshot) {
        setState(() {
          _imagePosts = querySnapshot.docs;
          _mergePosts();
        });
      });

      FirebaseFirestore.instance
          .collection('videos')
          .where('uid', isEqualTo: widget.uid)
          .get()
          .then((querySnapshot) {
        setState(() {
          _videoPosts = querySnapshot.docs;
          _mergePosts();
        });
      });

      var userSnap = await FirebaseFirestore.instance
          .collection('profile')
          .doc(widget.uid)
          .get();

      userData = userSnap.data()!;
      followers = userSnap.data()!['followersList'].length;
      following = userSnap.data()!['followingList'].length;
      isFollowing = userSnap
          .data()!['followersList']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (error) {
      Utility.customSnackBar(context, error.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  void _mergePosts() {
    if (_imagePosts.isNotEmpty || _videoPosts.isNotEmpty) {
      _storyPosts = [];
      _storyPosts.addAll(_imagePosts);
      _storyPosts.addAll(_videoPosts);
      _storyPosts.sort((a, b) => b['createdAt'].compareTo(a['createdAt']));
      setState(() {
        firstStory = _storyPosts.first;
        _groupPostsByCity();
      });
    }
  }


  void _groupPostsByCity() {
    _groupedPosts = {};
    for (var post in _storyPosts) {
      String cityString = post['cityString'];
      if (!_groupedPosts.containsKey(cityString)) {
        _groupedPosts[cityString] = [];
      }
      _groupedPosts[cityString]!.add(post);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height / 2.20,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SizedBox(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height / 3.3,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      child: Image.network(
                        userData['bannerImage'] ?? '', //https://pixy.org/download/55685/
                        fit: BoxFit.cover,
                      ),
                    ),

                    Positioned(
                      top: 3,
                      right: 5,
                      child: Row(
                        children: [
                          //settings icon
                          IconButton(
                            onPressed: () {
                              context;
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
                            },
                            splashRadius: 20,
                            icon: CircleAvatar(
                              backgroundColor: Colors.white.withOpacity(0.9),
                              child: const FaIcon(
                                FontAwesomeIcons.gear,
                                color: Colors.grey,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // back button

                    Padding(
                        padding: const EdgeInsets.only(top: 155),
                        child: _profileInfoContainer()
                    ),

                    // PROFILE PICTURE WIDGET
                    Positioned(
                      top: 95,
                      left: 25,
                      child: SizedBox(
                          width: 115.0,
                          height: 115.0,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2.0,
                              ),
                            ),
                            child: ClipOval(
                              child: Image.network(
                                userData['profilePic'] ?? '',
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15,),
              // Posts display
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Container(
                  height: 275,
                  child: GestureDetector(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _groupedPosts.length,
                      itemBuilder: (BuildContext context, int outerIndex) {
                        String cityString = _groupedPosts.keys.elementAt(outerIndex);
                        List<DocumentSnapshot> posts = _groupedPosts[cityString]!;
                        DocumentSnapshot post = posts[0]; // Access the first post

                        return Card(
                          margin: EdgeInsets.only(right: 9.0),
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 0.0,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => ViewStoryScreen(
                                        storyPosts: posts,
                                        firstStory: post,
                                        uid: widget.uid,
                                      )));
                            },
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(post['thumbnail']),
                                      fit: BoxFit.cover,
                                      scale: 2.0,
                                    ),
                                  ),
                                  width: 175.0,
                                ),
                                Positioned(
                                 // left: 8.0,
                                  bottom: 0,
                                  child: Container(
                                    width: 175.0,
                                    padding:const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      gradient: LinearGradient(
                                          begin: Alignment.bottomRight,
                                          colors: [
                                            Colors.black.withOpacity(.8),
                                            Colors.black.withOpacity(.2),
                                          ]
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          color: Colors.orange,
                                          size: 16.0,
                                        ),
                                        SizedBox(width: 4.0),
                                        Text(
                                          cityString,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _profileInfoContainer() {
    return Stack(
        children:  <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.0),
            child: Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height / 3.8,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 31, 30, 29),    //const kGreyColor2
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            ),
          ),
          Positioned(
            top: 3,
            left: 145,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userData['displayName']?.toString() ?? '',
                    maxLines: 1,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'Arial',
                    ),
                  ),
                  SizedBox(height: 1,),
                  Text(
                    userData['userName'] ?? '',
                    maxLines: 1,
                    style: const TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.normal,
                        fontSize: 14),
                  ),
                  SizedBox(height: 1,),
                  Row(
                    children: [
                      Row(
                        children: const [
                          Text(
                            '1',
                            maxLines: 1,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                          Text(
                            ' City',
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              fontFamily: 'Open Sans',),
                          ),
                        ],
                      ),
                      const Text(
                        '  ●  ',
                        maxLines: 1,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => FollowingScreen(userId: userData['userId'])));
                        },
                        child: Row(
                          children: [
                            Text(
                              following.toString(),
                              maxLines: 1,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            ),
                            const Text(
                              ' Following',
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                fontFamily: 'Open Sans',
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),

                ],
              ),
            ),
          ),
          Positioned(
            top: 65,
            left: 8,
            child: Container(
              width: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.pin_drop_outlined, size: 15, color:Colors.white,),
                      Text(
                        userData['location'] ?? '',
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          fontFamily: 'Open Sans',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6,),
                  Text(
                    userData['bio'] ?? '',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize: 14),
                  ),
                  SizedBox(height: 6,),
                  GestureDetector(
                    onTap: () => _launchURLApp(userData['webSite']),
                    child: Text(
                      userData['webSite'] ?? '',
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.normal,
                          fontSize: 14),
                    ),
                  ),
                  SizedBox(height: 17,),
                  Row(
                    children: [
                      FirebaseAuth.instance.currentUser!.uid ==
                          widget.uid
                          ? FollowButton(
                        text: 'Edit Profile',
                        function: () async {

                          Navigator.of(context)
                              .push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditProfileScreen(
                                    uid: userData['userId'],
                                    locationPre: userData['location'],
                                    displayNamePre: userData['displayName'],
                                    biographyPre: userData['bio'],
                                    picturePre: userData['profilePic'],
                                    bannerPre: userData['bannerImage'],
                                    userName: userData['userName'],
                                  ),
                            ),
                          );

                        },
                      )
                          : isFollowing
                          ? FollowButton(
                        text: 'Following',
                        function: () async {
                          await FireStoreMethods()
                              .followUser(
                            FirebaseAuth.instance
                                .currentUser!.uid,
                            userData['userId'],
                          );

                          setState(() {
                            isFollowing = false;
                            followers--;
                          });
                        },
                      )
                          : FollowButton(
                        text: 'Follow',
                        function: () async {
                          await FireStoreMethods()
                              .followUser(
                            FirebaseAuth.instance
                                .currentUser!.uid,
                            userData['userId'],
                          );

                          setState(() {
                            isFollowing = true;
                            followers++;
                          });
                        },
                      )
                    ],
                  ),




                ],
              ),
            ),

          )
        ]
    );
  }


}



