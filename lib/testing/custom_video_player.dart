import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../controllers/video_controller.dart';
import '../models/post.dart';
import '../pages/profile_screen.dart';
import 'package:get/get.dart';



class CustomVideoPlayer extends StatefulWidget {

   const CustomVideoPlayer({
    Key? key,
    required this.post,
  }) : super(key: key);

  final Post post;



  @override
  _CustomVideoPlayerState createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late VideoPlayerController videoPlayerController;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(widget.post.videoUrl!)
      ..initialize().then((_) {
        setState(() {});
      });
    super.initState();


  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(videoPlayerController.dataSource),
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction > 0.50) {
          videoPlayerController.play();
        } else {
          if (mounted) {
            videoPlayerController.pause();
          }
        }
      },
      child: videoPlayerController.value.isInitialized
          ? GestureDetector(
        onTap: () {
          setState(() {
            if (videoPlayerController.value.isPlaying) {
              videoPlayerController.pause();
            } else {
              videoPlayerController.play();
            }
          });
        },
        child: AspectRatio(
          aspectRatio: videoPlayerController.value.aspectRatio,

          child: Stack(
            children: [
              VideoPlayer(videoPlayerController),
              const Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black,
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.0, 0.2, 0.8, 1.0],
                    ),
                  ),
                ),
              ),
              _buildVideoCaption(context),
             _buildVideoActions(context),
            ],
          ),
        ),
      )
          : Container(

      ),
    );
  }

  Align _buildVideoActions(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        height: videoPlayerController.value.size.height,
        width: MediaQuery.of(context).size.width * 0.2,
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            _VideoAction(
              icon: Icons.favorite,
              value: '11.4k',
            ),
            SizedBox(height: 10),
            _VideoAction(
              icon: Icons.comment,
              value: '1.4k',
            ),
            SizedBox(height: 10),
            _VideoAction(
              icon: Icons.forward_rounded,
              value: '500',
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  GestureDetector _buildVideoCaption(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          ProfileScreen.routeName,
          arguments: widget.post,
        );
      },
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          height: 125,
          width: MediaQuery.of(context).size.width * 0.75,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.post.username}',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                 widget.post.caption!,
                maxLines: 3,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VideoAction extends StatelessWidget {
  const _VideoAction({
    Key? key,
    required this.icon,
    required this.value,
  }) : super(key: key);

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: Center(
            child: Ink(
              decoration: const ShapeDecoration(
                color: Colors.black,
                shape: CircleBorder(),
              ),
              child: IconButton(
                icon: Icon(icon),
                color: Colors.white,
                onPressed: () {},
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}