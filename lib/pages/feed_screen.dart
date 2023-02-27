

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';



class FeedScreen extends StatefulWidget {
  final List<String> videoUrls;
  final int initialPage;

  FeedScreen({required this.videoUrls, required this.initialPage}) ;
     

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late PageController _pageController;
  late VideoPlayerController _videoPlayerController;
  late int currentPage;

  @override
  void initState() {
    super.initState();
    currentPage = widget.initialPage;
    _pageController = PageController(initialPage: currentPage);
    _videoPlayerController = VideoPlayerController.network(widget.videoUrls[currentPage]);
    _videoPlayerController.initialize().then((_) {
      setState(() {});
    });
    _videoPlayerController.play();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(color: Colors.red),
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.videoUrls.length,
        onPageChanged: (index) {
          setState(() {
            currentPage = index;
            _videoPlayerController.dispose();
            _videoPlayerController = VideoPlayerController.network(widget.videoUrls[index],
            );
            _videoPlayerController.initialize().then((_) {
              setState(() {});
            });
            _videoPlayerController.play();
          });
        },

        itemBuilder: (context, index) {
          index = index % widget.videoUrls.length;
          return videoSlider(index);
        },
      ),
    );
  }

  videoSlider(int index){
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, widget){
        double value = 1;
        if(_pageController.position.haveDimensions){
          value = _pageController.page! - index;
          value = (1-(value.abs()*0.3)).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value)*372,
            width: Curves.easeInOut.transform(value)*300,
            child: widget,
          ),
        );
      },
      child: Stack(
        children: <Widget>[
          _videoPlayerController.value.isInitialized
              ? ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: VideoPlayer(_videoPlayerController),
          )
              :const Center(
            child: CircularProgressIndicator(),
          ),

        ],
      ),
    );
  }
}












// Container(
//           child: AspectRatio(
//             aspectRatio: _videoPlayerController.value.aspectRatio,
//             child: VideoPlayer(_videoPlayerController),
//           ),
//         );










//
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
//
//
// class FeedScreen extends StatefulWidget {
//   final List<String> thumbnails;
//   final int index;
//
//   FeedScreen({
//     required this.thumbnails,
//     required this.index,
//   });
//
//   @override
//   _FeedScreenState createState() => _FeedScreenState();
// }
//
// class _FeedScreenState extends State<FeedScreen> {
//   late List<VideoPlayerController> _videoControllers;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: PageView.builder(
//         itemCount: widget.thumbnails.length,
//         itemBuilder: (context, index) {
//           return Container(
//             child: Image.network(widget.thumbnails[index]),
//           );
//         },
//         controller: PageController(
//           initialPage: widget.index,
//         ),
//       ),
//     );
//   }
// }













































// import 'package:flutter/material.dart';
//
//
// class FeedScreen extends StatelessWidget {
//   const FeedScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return  MaterialApp(
//       home: Center(child:
//       Image.network('https://naples.floridaweekly.com/wp-content/uploads/images/2018-03-01/1p9.jpg')
//       ),
//     );
//   }
// }