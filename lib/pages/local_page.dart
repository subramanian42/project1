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
      appBar: const _CustomAppBar(),
      //bottomNavigationBar: const CustomBottomAppBar(),
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

class _CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  const _CustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildButton(context, 'For You'),
          _buildButton(context, 'Following'),
        ],
      ),
    );
  }

  TextButton _buildButton(
      BuildContext context,
      String text,
      ) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        fixedSize: const Size(100, 50),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}
