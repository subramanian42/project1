
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

import '../widgets/animated_line.dart';

class ViewStoryScreen extends StatefulWidget {

  DocumentSnapshot<Object?> user;

  ViewStoryScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ViewStoryScreen> createState() => _ViewStoryScreenState();
}

class _ViewStoryScreenState extends State<ViewStoryScreen> with TickerProviderStateMixin {

  late PageController _pageController;
  late AnimationController _animationController;
  late VideoPlayerController? _videoPlayerController = null;
  int _currentStory = 0;
  late List<DocumentSnapshot> _imagePosts;
  late List<DocumentSnapshot> _videoPosts;
  late List<DocumentSnapshot> _storyPosts = [];
  late DocumentSnapshot<Object?> firstStory;


  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('images')
        .where('uid', isEqualTo: widget.user['userId'])
        .get()
        .then((querySnapshot) {
      setState(() => _imagePosts = querySnapshot.docs);
      _mergePosts();
    });

    FirebaseFirestore.instance
        .collection('videos')
        .where('uid', isEqualTo: widget.user['userId'])
        .get()
        .then((querySnapshot) {
      setState(() => _videoPosts = querySnapshot.docs);
      _mergePosts();
    });

    _pageController = PageController();
    _animationController = AnimationController(vsync: this);

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.stop();
        _animationController.reset();
        setState(() {
          if (_storyPosts.isNotEmpty && _currentStory + 1 < _storyPosts.length) {
            _currentStory += 1;
            _loadStory(story: _storyPosts[_currentStory]);
          } else {
            // Out of bounds - loop story
            // You can also Navigator.of(context).pop() here
            _currentStory = 0;
            _loadStory(story: firstStory);
          }
        });
      }
    });

    super.initState();
  }

  void _mergePosts() {
    if (_imagePosts != null && _videoPosts != null) {
      _storyPosts = [];
      _storyPosts.addAll(_imagePosts);
      _storyPosts.addAll(_videoPosts);
      _storyPosts.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
      setState(() {
        firstStory = _storyPosts.first;
        _loadStory(story: firstStory, animateToPage: false);
      });
    }
  }


  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }



  void _onTapDown(TapDownDetails details, DocumentSnapshot story) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double dx = details.globalPosition.dx;
    if (dx < screenWidth / 3) {
      setState(() {
        if (_currentStory - 1 >= 0) {
          _currentStory -= 1;
          _loadStory(story: _storyPosts[_currentStory]);
        }
      });
    } else if (dx > 2 * screenWidth / 3) {
      setState(() {
        if (_currentStory + 1 < _storyPosts.length) {
          _currentStory += 1;
          _loadStory(story: _storyPosts[_currentStory]);
        } else {
          // Out of bounds - loop story
          // You can also Navigator.of(context).pop() here
          _currentStory = 0;
          _loadStory(story: _storyPosts[_currentStory]);
        }
      });
    } else {
      if (story.get('isVideo') == true) {
        if (_videoPlayerController!.value.isPlaying) {
          _videoPlayerController!.pause();
          _animationController.stop();
        } else {
          _videoPlayerController!.play();
          _animationController.forward();
        }
      }
    }
  }

  void _loadStory({DocumentSnapshot? story, bool animateToPage = true}) {
    _animationController.stop();
    _animationController.reset();
    switch (story?.get('isVideo')) {
      case false:
        _animationController.duration = const Duration(seconds: 5);
        _animationController.forward();
        break;
      case true:
        _videoPlayerController?.dispose();
        _videoPlayerController = VideoPlayerController.network(story?.get('videoUrl'))
          ..initialize().then((_) {
            setState(() {});
            if (_videoPlayerController!.value.isInitialized) {
              _animationController.duration = _videoPlayerController!.value.duration;
              _videoPlayerController!.play();
              _animationController.forward();
            }
          });
        break;
    }
    if (animateToPage) {
      _pageController.animateToPage(
        _currentStory,
        duration: const Duration(milliseconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }



  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final DocumentSnapshot story = _storyPosts[_currentStory ];

    return Scaffold(

        body:  Stack(
          fit: StackFit.expand,
          children: [
            GestureDetector(
              onTapDown: (details) => _onTapDown(details, story),
              child: PageView.builder(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                itemCount: _storyPosts.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot story = _storyPosts[index];
                  switch (story.get('isVideo')) {
                    case false:
                      return CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: story.get('imageUrl'),
                      );
                    case true:
                      if(_videoPlayerController != null &&
                          _videoPlayerController!.value.isInitialized){
                        return FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: _videoPlayerController!.value.size.width,
                            height: _videoPlayerController!.value.size.height,
                            child: VideoPlayer(_videoPlayerController!),
                          ),
                        );
                      }

                  }
                  return SizedBox.shrink();

                },
              ),
            ),

            const SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(height: 30.0),

                  // * Animated Line //
                  Row(
                    children: List.generate(_storyPosts.length, (index) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 7.0),
                          child: AnimatedLineStory(
                              index: index,
                              selectedIndex: _currentStory,
                              animationController: _animationController
                          ),
                        )
                    )
                    ),
                  ),


                  const SizedBox(height: 20.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(widget.user.get('profilePic')),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.user.get('displayName'),style: TextStyle(color: Colors.white),),
                            const Text('5 hours ago', style: TextStyle(color: Colors.white),)
                          ],
                        ),
                      ),
                      IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close, color: Colors.white, )
                      )
                    ],
                  ),

                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Container(
                              color: Colors.white.withOpacity(.1),
                              child: TextField(
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(left: 20.0),

                                    hintText: 'Write a comment',
                                    hintStyle: GoogleFonts.roboto(color: Colors.white)
                                ),
                              ),
                            ),
                          )
                      ),
                      const SizedBox(width: 10.0),
                      IconButton(
                          onPressed: (){},
                          icon: const Icon(Icons.send_rounded, color: Colors.white )
                      )
                    ],
                  )
                ],
              ),
            ),


          ],
        )

    );
  }
}