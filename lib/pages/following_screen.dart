import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project1/pages/profile_screen.dart';

import '../models/user.dart';


class FollowingScreen extends StatelessWidget {
  const FollowingScreen({Key? key, required this.userId}) : super(key: key);
  final String userId;
  @override
  Widget build(BuildContext context) {
    // final settingsManager =
    // Provider.of<SettingsProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          splashRadius: 20,
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 24,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
        bottomOpacity: 0.0,
        title: const Text(
          'Following',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'Arial',
          ),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('profile')
              .doc(userId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: CircularProgressIndicator());
            }

            final followingList = snapshot.data!['followingList'] as List<dynamic>;

            if (followingList.isEmpty) {
              return const SizedBox();
            }

            return ListView.builder(
              itemCount: followingList!.length,
              itemBuilder: (context, index) {
                final followingUserId = followingList[index];

                // debugPrint(followingUserId.userName);
                // if (followingUserId.userId ==
                //     FirebaseAuth.instance.currentUser!.uid) {
                //   return const SizedBox();
                // }
               
                return StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                    .collection('profile')
                    .doc(followingUserId)
                    .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data == null) {
                      return const SizedBox(); // Placeholder widget while loading
                    }
                    
                    final followingUser = snapshot.data!;
                    
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                              uid: followingUser.get('userId'),
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: followingUser.get('profilePic') == ""
                                ? Image.asset(
                              'assets/default_image.jpg',
                              fit: BoxFit.cover,
                            )
                                : CachedNetworkImage(
                              imageUrl: followingUser.get('profilePic'),
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) =>
                              const Center(
                                child: FaIcon(
                                    FontAwesomeIcons.circleExclamation),
                              ),
                              // placeholder: (context, url) =>
                              //     Shimmer.fromColors(
                              //         baseColor: Colors.grey.shade400,
                              //         highlightColor:
                              //         Colors.grey.shade300,
                              //         child: SizedBox(
                              //             height: MediaQuery.of(context)
                              //                 .size
                              //                 .height /
                              //                 3.3,
                              //             width: double.infinity)),
                            ),
                          ),
                        ),
                        title: Text(
                          followingUser.get('userName'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: 'Arial',
                          ),
                        ),
                        subtitle: Text(
                          followingUser.get('location'),
                          style: const TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.normal,
                              fontSize: 14),
                        ),
                        trailing: const Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color:Colors.white
                                ,
                            size: 18,
                          ),
                        ),
                      ),
                    );
                  }
                );
              },
            );
          }),
    );
  }
}