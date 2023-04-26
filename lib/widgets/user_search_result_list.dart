import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project1/pages/profile_screen.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';


// ignore: must_be_immutable
class UserSearchResultList extends StatelessWidget {
  UserSearchResultList({
    Key? key,
    required this.searchName,
    required this.snapshot,
  }) : super(key: key);
  String searchName;
  final AsyncSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    searchName = searchName.toLowerCase();
    // final settingsManager = Provider.of<SettingsProvider>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        searchName.isEmpty
            ? const Padding(
          padding: EdgeInsets.only(left: 14.0),
          child: Text('Suggestions',
            style: TextStyle(
                color: Colors.white60,
                fontWeight: FontWeight.w600,
                fontSize: 17),
          ),
        )
            : const SizedBox(),
        Expanded(
          child: ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              UserModel user = UserModel.fromSnapshot(
                snapshot.data.docs[index],
              );
              if (user.userId == FirebaseAuth.instance.currentUser!.uid) {
                return const SizedBox();
              }
              if (user.userName!.isEmpty) {
                return InkWell(
                  key: const Key('userSearchResultList'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileScreen(uid: user.userId! ,)),
                      //arguments: user.id,
                    );
                  },
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: user.profilePic == ""
                            ? Image.asset(
                          'assets/default_image.jpg',
                          fit: BoxFit.cover,
                        )
                            : CachedNetworkImage(
                          imageUrl: user.profilePic!,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) =>
                          const Center(
                            child: FaIcon(
                                FontAwesomeIcons.circleExclamation),
                          ),
                          // placeholder: (context, url) =>
                          //     Shimmer.fromColors(
                          //         baseColor: Colors.grey.shade400,
                          //         highlightColor: Colors.grey.shade300,
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
                      user.userName!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: 'Arial',
                      ),
                    ),
                    subtitle: Text(
                      user.displayName!,
                      style: const TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.normal,
                          fontSize: 14),
                    ),
                    trailing: const Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                );
              }

              if (user.userName
                  .toString()
                  .toLowerCase()
                  .startsWith(searchName.toLowerCase())) {
                return InkWell(
                  key: const Key('userSearchResultList'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileScreen(uid: user.userId! ,)),
                      // arguments: user.userId,
                    );
                  },
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: user.profilePic == ""
                            ? Image.asset(
                          'assets/default_image.jpg',
                          fit: BoxFit.cover,
                        )
                            : CachedNetworkImage(
                          imageUrl: user.profilePic!,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) =>
                          const Center(
                            child: FaIcon(
                                FontAwesomeIcons.circleExclamation),
                          ),
                          // placeholder: (context, url) =>
                          //     Shimmer.fromColors(
                          //         baseColor: Colors.grey.shade400,
                          //         highlightColor: Colors.grey.shade300,
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
                      user.userName!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: 'Arial',
                      ),
                    ),
                    subtitle: Text(
                      user.displayName!,
                      style: const TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.normal,
                          fontSize: 14),
                    ),
                    trailing: const Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
      ],
    );
  }
}