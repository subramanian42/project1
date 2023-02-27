
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VideoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('videos').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var video = snapshot.data!.docs[index].data();
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Image.network(video['thumbnail']),
                    title: Text(video['caption']),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoThumbnailsPage(
                            videos: snapshot.data!.docs.map((doc) => doc.data()).toList(),
                            selectedVideoIndex: index,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class VideoThumbnailsPage extends StatelessWidget {
  final List<Map<String, dynamic>> videos;
  final int selectedVideoIndex;

  VideoThumbnailsPage({required this.videos, required this.selectedVideoIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Thumbnails'),
      ),
      body: Container(
        child: PageView.builder(
          itemCount: videos.length,
          itemBuilder: (context, index) {
            return Container(
              child: Image.network(videos[index]['thumbnail']),
            );
          },
          controller: PageController(
            initialPage: selectedVideoIndex,
          ),
        ),
      ),
    );
  }
}















// vidoe versonnnnnnnnnnnñ

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:video_player/video_player.dart';
//
// class VideoList extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: EdgeInsets.all(8.0),
//         child: StreamBuilder(
//           stream: FirebaseFirestore.instance.collection('videos').snapshots(),
//           builder: (context, snapshot) {
//             if (!snapshot.hasData) {
//               return CircularProgressIndicator();
//             }
//             return ListView.builder(
//               itemCount: snapshot.data!.docs.length,
//               itemBuilder: (context, index) {
//                 var video = snapshot.data!.docs[index].data();
//                 return Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: ListTile(
//                     leading: Image.network(video['thumbnail']),
//                     title: Text(video['caption']),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => VideoThumbnailsPage(
//                             videos: snapshot.data!.docs.map((doc) => doc.data()).toList(),
//                             selectedVideoIndex: index,
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
//
// class VideoThumbnailsPage extends StatelessWidget {
//   final List<Map<String, dynamic>> videos;
//   final int selectedVideoIndex;
//
//   VideoThumbnailsPage({required this.videos, required this.selectedVideoIndex});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Videos'),
//       ),
//       body: Container(
//         child: PageView.builder(
//           itemCount: videos.length,
//           itemBuilder: (context, index) {
//             return Container(
//               child: VideoPlayer(
//                VideoPlayerController.network(videos[index]['videoUrl']),
//               ),
//             );
//           },
//           controller: PageController(
//             initialPage: selectedVideoIndex,
//           ),
//         ),
//       ),
//     );
//   }
// }
