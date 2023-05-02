import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileDisplay extends StatefulWidget {
  final String uid;

  ProfileDisplay({required this.uid});

  @override
  _ProfileDisplayState createState() => _ProfileDisplayState();
}

class _ProfileDisplayState extends State<ProfileDisplay> {
  late List<DocumentSnapshot> _imagePosts = [];
  late List<DocumentSnapshot> _videoPosts = [];
  late List<DocumentSnapshot> _storyPosts = [];
  late DocumentSnapshot<Object?> firstStory;
  late Map<String, List<DocumentSnapshot>> _groupedPosts = {};

  @override
  void initState() {
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

    super.initState();
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
      appBar: AppBar(
        title: Text('City Posts'),
      ),
      body: ListView.builder(
        itemCount: _groupedPosts.length,
        itemBuilder: (context, index) {
          String cityString = _groupedPosts.keys.elementAt(index);
          List<DocumentSnapshot> posts = _groupedPosts[cityString]!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  cityString,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot post = posts[index];
                  // Render the post here
                  return ListTile(
                    title: Text(post['caption']),
                    // Add other post details as needed
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
