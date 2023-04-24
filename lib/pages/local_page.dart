import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/video_controller.dart';
import '../models/post.dart';
import '../testing/custom_video_player.dart';




class LocalPage extends StatefulWidget {
  static const routeName = '/';


  const LocalPage({
    Key? key,
  }) : super(key: key);

  @override
  State<LocalPage> createState() => _LocalPageState();
}

class _LocalPageState extends State<LocalPage> {
  final VideoController videoController = Get.put(VideoController());



  @override
  Widget build(BuildContext context) {
    List<Post> posts = videoController.videoList ;
    // Post? post = ModalRoute.of(context)!.settings.arguments as Post?;
    // if (post != null) posts.insert(0, post);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Obx(
              () {
            return Stack(
              children: [
                PageView.builder(
                  itemCount: videoController.videoList.length,
                  controller: PageController(initialPage: 0, viewportFraction: 1),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index)  {
                    final data = videoController.videoList[index];
                    return CustomVideoPlayer( post: data,);
                  },
                ),
              ],
            );
          }
      ),
    );
  }
}
