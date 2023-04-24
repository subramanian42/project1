import 'package:flutter/material.dart';
import 'package:project1/pages/comments_screen.dart';
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
  final VideoController videoController = Get.put(VideoController());

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
        child: SafeArea(
          child: Stack(
            children: [
              VideoPlayer(videoPlayerController),
              Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,

                        colors: <Color> [
                          Colors.transparent,
                          Colors.transparent,
                          Colors.transparent,
                          Colors.transparent,
                          Colors.transparent,
                          Colors.black87
                        ]
                    )
                ),
              ),

              //CONTROLS
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: <Widget>[
                  _topNavBar(),
                  Column(
                    children: <Widget>[
                      _buildVideoActions(context),
                      _buildVideoCaption(context)
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      )
          : Container(

      ),
    );
  }

  Widget _topNavBar(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),

      child: InkWell(
        onTap: () => Navigator.pop(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: <Widget>[
            Column(
              children: <Widget>[

                SizedBox(width: 05.0,),
                Icon(Icons.arrow_back_ios_outlined, size: 25, color:Colors.white54,
                ),
              ],
            ),

            Column(
              children: const <Widget>[
                Text(
                  'Back',
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white54
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }


  Align _buildVideoActions(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,

      child: Padding(
        padding: EdgeInsets.only(right: 8.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: <Widget>[
            // Imagen perfil
            SizedBox(height: 25.0,),

            InkWell(
                onTap: () {
                  videoController.likeVideo(widget.post.id!);
                },
                child: Icon(Icons.favorite_outline_rounded, size: 45, color:Colors.white,)),
            SizedBox(height: 5.0,),
            Text(
              widget.post.likeList!.length.toString(),
              style: TextStyle(
                  fontSize: 10.0,
                  color: Colors.white
              ),
            ),

            SizedBox(height: 20.0,),

            InkWell(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => CommentScreen(id: widget.post.id!,)) ),
                child: Icon(Icons.mode_comment_outlined, size: 45, color:Colors.white,)),
            SizedBox(height: 5.0,),
            Text(
              '5109',
              style: TextStyle(
                  fontSize: 10.0,
                  color: Colors.white
              ),
            ),

            SizedBox(height: 20.0,),

            Icon(Icons.mobile_screen_share, size: 45, color:Colors.white,),
            SizedBox(height: 5.0,),
            Text(
              '119',
              style: TextStyle(
                  fontSize: 10.0,
                  color: Colors.white
              ),
            ),

          ],
        ),
      ),
    );
  }

  GestureDetector _buildVideoCaption(BuildContext context) {
    return GestureDetector(
        onTap: () {
          // Navigator.pushNamed(
          //   context,
          //   ProfileScreen.routeName,
          //   arguments: widget.post,
          // );
        },
        child: Padding(
          padding: EdgeInsets.only(left: 15.0, bottom: 15.0, right: 8.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        border: Border.all(
                          color: Colors.black,
                          width: .01,
                        )
                    ),

                    child: ClipOval(
                        child: Image.network('https://media.istockphoto.com/id/1176363686/vector/smiling-young-asian-girl-profile-avatar-vector-icon.jpg?s=612x612&w=0&k=20&c=QuyZJNKexFQgDPr9u91hKieWKOYbaFxPb0b0gwmd-Lo=',
                          width: 40.0,
                          height: 40.0,
                          fit: BoxFit.cover,
                        )
                    ),
                  ),
                  SizedBox(width: 10.0,),
                  Text(
                    '${widget.post.username}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                    ),
                  ),

                  SizedBox(width: 15.0,),

                  ElevatedButton(
                    onPressed: () {
                      // Add your logic here for when the button is pressed
                    },
                    child: Text(
                      'Follow',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white60,
                      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 2.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  )

                ],
              ),

              SizedBox(height: 15.0,),

              Row(
                children: <Widget>[
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: <Widget>[
                        Container(
                          child: Text(
                            ' ${widget.post.caption!}',
                            style: const TextStyle(
                                color: Colors.white
                            ),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            children: const <Widget>[
                              Icon(Icons.pin_drop_outlined, size: 25, color:Colors.white,),

                              SizedBox(width: 05.0,),

                              Text(
                                'location',
                                style: TextStyle(
                                    color: Colors.white
                                ),
                              ),

                              SizedBox(width: 20.0,),

                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                ],
              )

            ],
          ),
        )
    );
  }
}

