import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:project1/models/post.dart';


class VideoController extends GetxController {
  final Rx<List<Post>> _videoList = Rx<List<Post>>([]);

  List<Post> get videoList => _videoList.value;

  @override
  void onInit() {
    super.onInit();
    _videoList.bindStream(
        FirebaseFirestore.instance.collection('videos').snapshots().map<List<Post>>((QuerySnapshot query) {
          List<Post> retVal = [];
          for (var element in query.docs) {
            retVal.add(
              Post.fromSnap(element),
            );
          }
          return retVal;
        }));
  }

  likeVideo(String id) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('videos').doc(id).get();
    var uid = FirebaseAuth.instance.currentUser!.uid;
    if ((doc.data()! as dynamic)['likeList'].contains(uid)) {
      await  FirebaseFirestore.instance
          .collection('videos').doc(id).update({
        'likeList': FieldValue.arrayRemove([uid]),
      });
    } else {
      await  FirebaseFirestore.instance
          .collection('videos').doc(id).update({
        'likeList': FieldValue.arrayUnion([uid]),
      });
    }
  }


}