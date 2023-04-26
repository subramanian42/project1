import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as tago;

import '../controllers/comment_controller.dart';

class CommentScreen extends StatelessWidget {
  final String id;
  CommentScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _commentController = TextEditingController();
  CommentController commentController = Get.put(CommentController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    commentController.updatePostId(id);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          splashRadius: 20,
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 24,
          ),
        ),
        actions: [
          IconButton(
            splashRadius: 20,
            onPressed: () {},
            icon: const Icon(
              Icons.more_horiz,
              color: Colors.black,
              size: 24,
            ),
          ),
        ],
        title: Text(
          'Comments',
          style:
          Theme.of(context).textTheme.headline2!.copyWith(fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                return ListView.builder(
                    itemCount: commentController.comments.length,
                    itemBuilder: (context, index) {
                      final comment = commentController.comments[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 16,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 18,
                                child: CachedNetworkImage(
                                  imageUrl: comment.profilePhoto,
                                  fit: BoxFit.cover,
                                  // errorWidget: (context, url, error) => const Center(
                                  //   child: FaIcon(FontAwesomeIcons.circleExclamation),
                                  // ),
                                  // placeholder: (context, url) => Shimmer.fromColors(
                                  //   baseColor: Colors.grey.shade400,
                                  //   highlightColor: Colors.grey.shade300,
                                  //   child: SizedBox(
                                  //     height: MediaQuery.of(context).size.height / 3.3,
                                  //     width: double.infinity,
                                  //   ),
                                  // ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            comment.username,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                            Theme.of(context).textTheme.bodyText2!.copyWith(
                                              fontSize: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          tago.format(
                                            comment.datePublished.toDate(),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                            fontSize: 10,
                                            color: Colors.grey,
                                            // settingsManager.darkMode
                                            //     ? Colors.grey
                                            //     : Colors.grey.shade800,
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(right: 10.0),
                                                child: Text(
                                                  comment.comment,
                                                  softWrap: true,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2!
                                                      .copyWith(
                                                    fontSize: 14,
                                                    color: Colors.white70,
                                                    // settingsManager.darkMode
                                                    //     ? Colors.white70
                                                    //     : Colors.grey.shade800,
                                                    fontWeight: FontWeight.w400,
                                                    height: 1.4,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 05),
                                    Row(
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                              fontSize: 13,
                                              color: Colors.grey,
                                              // settingsManager.darkMode
                                              //     ? Colors.grey
                                              //     : Colors.grey.shade600,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: '${comment.likes.length} ',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  // settingsManager.darkMode
                                                  //     ? Colors.white
                                                  //     : Colors.black,
                                                ),
                                              ),
                                              const TextSpan(
                                                text: 'like',  //likeOrUnlikeText()
                                                // recognizer: TapGestureRecognizer()
                                                //   ..onTap = () async {
                                                //     commentProvider.likeOrUnlikeComment(
                                                //       postId: widget.postId,
                                                //       userId: FirebaseAuth.instance.currentUser!.uid,
                                                //       commentId: widget.comment.commentId,
                                                //       likes: widget.comment.likes,
                                                //     );
                                                //   },
                                              ),
                                              const TextSpan(text: '  ●  '),
                                              const TextSpan(
                                                  text: 'Reply'//showReplyField ? 'Cancel' : 'Reply',
                                                // recognizer: TapGestureRecognizer()
                                                //   ..onTap = () {
                                                //     setState(() {
                                                //       showReplyField = !showReplyField;
                                                //     });
                                                //   },
                                              ),

                                            ],
                                          ),
                                        ),
                                        //const SizedBox(height: 15),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 190),
                                          child: InkWell(
                                            onTap: () =>
                                                commentController.likeComment(comment.id),
                                            child: Icon(
                                              Icons.favorite,
                                              size: 20,
                                              color: comment.likes
                                                  .contains(FirebaseAuth.instance.currentUser!.uid)
                                                  ? Colors.red
                                                  : Colors.white30,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // showReplyField
                                    //     ? Padding(
                                    //   padding: const EdgeInsets.only(top: 16.0),
                                    //   child: Row(
                                    //     children: [
                                    //       Expanded(
                                    //         child: TextField(
                                    //           textAlign: TextAlign.start,
                                    //           textAlignVertical: TextAlignVertical.center,
                                    //           style: Theme.of(context)
                                    //               .textTheme
                                    //               .headline3!
                                    //               .copyWith(
                                    //             fontWeight: FontWeight.w600,
                                    //             fontSize: 13,
                                    //           ),
                                    //           controller: _replyController,
                                    //           cursorColor: settingsManager.darkMode
                                    //               ? Colors.white
                                    //               : Colors.black,
                                    //           autofocus: false,
                                    //           autocorrect: false,
                                    //           keyboardType: TextInputType.text,
                                    //           decoration: InputDecoration(
                                    //             isDense: true,
                                    //             suffixIcon: IconButton(
                                    //               splashRadius: 20,
                                    //               iconSize: 20,
                                    //               onPressed: () async {
                                    //                 postProvider.replyComment(
                                    //                   userName: widget.user!.userName,
                                    //                   profileImage: widget.user!.photoUrl,
                                    //                   postId: widget.postId,
                                    //                   text: _replyController.text,
                                    //                   uid: widget.user!.id,
                                    //                   commentId: widget.comment.commentId,
                                    //                 );
                                    //                 _replyController.clear();
                                    //               },
                                    //               icon: Icon(
                                    //                 Icons.send,
                                    //                 color: settingsManager.darkMode
                                    //                     ? Colors.white
                                    //                     : kBlackColor,
                                    //               ),
                                    //             ),
                                    //             fillColor: settingsManager.darkMode
                                    //                 ? kGreyColor
                                    //                 : kGreyColor4,
                                    //             filled: true,
                                    //             contentPadding:
                                    //             const EdgeInsets.only(left: 14),
                                    //             hintText: 'Reply',
                                    //             hintStyle: Theme.of(context)
                                    //                 .textTheme
                                    //                 .headline4!
                                    //                 .copyWith(
                                    //               fontSize: 13,
                                    //               color: settingsManager.darkMode
                                    //                   ? Colors.grey.shade600
                                    //                   : Colors.grey.shade700,
                                    //               fontWeight: FontWeight.bold,
                                    //             ),
                                    //             focusedErrorBorder: kFocusedErrorBorder,
                                    //             errorBorder: kErrorBorder,
                                    //             enabledBorder: kEnabledBorder,
                                    //             focusedBorder: kFocusedBorder,
                                    //             border: kBorder,
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // )
                                    const SizedBox.shrink(),

                                    //!
                                    // StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                    //   stream: replyStreamResult,
                                    //   builder: (context, snapshot) {
                                    //     if (snapshot.connectionState == ConnectionState.waiting) {
                                    //       return const SizedBox();
                                    //     }
                                    //     return Column(
                                    //       mainAxisSize: MainAxisSize.min,
                                    //       children: [
                                    //         Flexible(
                                    //           child: ListView.builder(
                                    //             shrinkWrap: true,
                                    //             physics: const NeverScrollableScrollPhysics(),
                                    //             itemCount: snapshot.data!.docs.length,
                                    //             itemBuilder: (context, index) {
                                    //               ReplyModel reply = ReplyModel.fromSnapshot(
                                    //                   snapshot.data!.docs[index]);
                                    //               return ReplyCard(
                                    //                 reply: reply,
                                    //                 comment: widget.comment,
                                    //                 postId: widget.postId,
                                    //               );
                                    //             },
                                    //           ),
                                    //         ),
                                    //       ],
                                    //     );
                                    //   },
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                            //
                          ],
                        ),
                      );
                    });
              }),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12)
                  .copyWith(top: 8),
              child: Form(
                key: _formKey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  textBaseline: TextBaseline.ideographic,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  children: [
                    Expanded(
                      child: TextFormField(
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Field is empty';
                          }
                          return null;
                        },
                        textAlign: TextAlign.start,
                        textAlignVertical: TextAlignVertical.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        controller: _commentController,
                        autofocus: false,
                        autocorrect: false,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              splashRadius: 20,
                              onPressed: () async {
                                commentController.postComment(_commentController.text);
                                final validForm =
                                _formKey.currentState!.validate();
                                if (validForm) {
                                  // !: Post comment.
                                  _commentController.clear();
                                }
                              },
                              icon: const Icon(
                                Icons.send,
                                color: Colors.deepOrange,
                              ),
                            ),
                            counterText: ' ',
                            fillColor: Colors.black45,
                            // settingsManager.darkMode
                            //     ? kGreyColor
                            //     : kGreyColor4,
                            filled: true,
                            isCollapsed: true,
                            contentPadding: const EdgeInsets.all(.50),
                            hintText: 'Add a comment',
                            hintStyle: Theme.of(context)
                                .textTheme
                                .headline4!
                                .copyWith(
                              fontSize: 20,
                              color: Colors.grey.shade700,
                              // settingsManager.darkMode
                              //     ? Colors.grey.shade600
                              //     : Colors.grey.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                            focusedErrorBorder:  OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade800),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder:  OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade800),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }
}


// class CommentCard extends StatefulWidget {
//   const CommentCard({
//     Key? key,
//     required this.comment,
//     required this.postId,
//     required this.user,
//   }) : super(key: key);
//   final UserModel? user;
//   final CommentModel comment;
//   final String postId;
//   @override
//   State<CommentCard> createState() => _CommentCardState();
// }
//
// class _CommentCardState extends State<CommentCard> {
//   bool showReplyField = false;
//   String daysBetween(DateTime commentedDate) {
//     String date;
//     if ((DateTime.now().difference(widget.comment.dateCommented).inHours / 24)
//         .round() ==
//         1) {
//       date = DateFormat('kk:mm').format(
//         widget.comment.dateCommented,
//       );
//       return 'Yesterday at $date';
//     }
//     if ((DateTime.now().difference(widget.comment.dateCommented).inHours / 24)
//         .round() >
//         1) {
//       date = DateFormat('dd MMMM, kk:mm').format(
//         widget.comment.dateCommented,
//       );
//       return date;
//     } else {
//       date = DateFormat('kk:mm').format(
//         widget.comment.dateCommented,
//       );
//       return 'Today at $date';
//     }
//   }
//
//   String likeOrUnlikeText() {
//     if (widget.comment.likes.contains(FirebaseAuth.instance.currentUser!.uid)) {
//       return "Unlike";
//     }
//     return 'Like';
//   }
//
//   final TextEditingController _replyController = TextEditingController();
//
//   @override
//   void dispose() {
//     _replyController.dispose();
//     super.dispose();
//   }
//
//   Stream<QuerySnapshot<Map<String, dynamic>>>? replyStreamResult;
//   @override
//   void initState() {
//     replyStreamResult = FirebaseFirestore.instance
//         .collection('posts')
//         .doc(widget.postId)
//         .collection('comments')
//         .doc(widget.comment.commentId)
//         .collection('replies')
//         .orderBy("dateCommented", descending: true)
//         .snapshots();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final postProvider =
//     Provider.of<RecipePostProvider>(context, listen: false);
//     final settingsManager =
//     Provider.of<SettingsProvider>(context, listen: false);
//     final commentProvider =
//     Provider.of<RecipePostProvider>(context, listen: false);
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         vertical: 16,
//         horizontal: 16,
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(100),
//             child: CircleAvatar(
//               backgroundColor: Colors.white,
//               radius: 18,
//               child: CachedNetworkImage(
//                 imageUrl: widget.comment.profilePhoto,
//                 fit: BoxFit.cover,
//                 // errorWidget: (context, url, error) => const Center(
//                 //   child: FaIcon(FontAwesomeIcons.circleExclamation),
//                 // ),
//                 // placeholder: (context, url) => Shimmer.fromColors(
//                 //   baseColor: Colors.grey.shade400,
//                 //   highlightColor: Colors.grey.shade300,
//                 //   child: SizedBox(
//                 //     height: MediaQuery.of(context).size.height / 3.3,
//                 //     width: double.infinity,
//                 //   ),
//                 // ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.only(left: 16),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Text(
//                           widget.comment.username,
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style:
//                           Theme.of(context).textTheme.bodyText2!.copyWith(
//                             fontSize: 14,
//                           ),
//                         ),
//                       ),
//                       Text(
//                         tago.format(
//                           widget.comment.datePublished.toDate(),
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: Theme.of(context).textTheme.bodyText2!.copyWith(
//                           fontSize: 10,
//                           color: settingsManager.darkMode
//                               ? Colors.grey
//                               : Colors.grey.shade800,
//                         ),
//                       )
//                     ],
//                   ),
//                   const SizedBox(height: 4),
//                   Column(
//                     mainAxisSize: MainAxisSize.max,
//                     children: [
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Padding(
//                               padding: const EdgeInsets.only(right: 10.0),
//                               child: Text(
//                                 widget.comment.comment,
//                                 softWrap: true,
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .bodyText2!
//                                     .copyWith(
//                                   fontSize: 14,
//                                   color: settingsManager.darkMode
//                                       ? Colors.white70
//                                       : Colors.grey.shade800,
//                                   fontWeight: FontWeight.w400,
//                                   height: 1.4,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   RichText(
//                     text: TextSpan(
//                       style: Theme.of(context).textTheme.bodyText2!.copyWith(
//                         fontSize: 13,
//                         color: settingsManager.darkMode
//                             ? Colors.grey
//                             : Colors.grey.shade600,
//                       ),
//                       children: [
//                         TextSpan(
//                           text: '${widget.comment.likes.length} ',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: settingsManager.darkMode
//                                 ? Colors.white
//                                 : Colors.black,
//                           ),
//                         ),
//                         const TextSpan(
//                           text: 'like',  //likeOrUnlikeText()
//                           // recognizer: TapGestureRecognizer()
//                           //   ..onTap = () async {
//                           //     commentProvider.likeOrUnlikeComment(
//                           //       postId: widget.postId,
//                           //       userId: FirebaseAuth.instance.currentUser!.uid,
//                           //       commentId: widget.comment.commentId,
//                           //       likes: widget.comment.likes,
//                           //     );
//                           //   },
//                         ),
//                         const TextSpan(text: '  ●  '),
//                         const TextSpan(
//                           text: 'Reply'//showReplyField ? 'Cancel' : 'Reply',
//                           // recognizer: TapGestureRecognizer()
//                           //   ..onTap = () {
//                           //     setState(() {
//                           //       showReplyField = !showReplyField;
//                           //     });
//                           //   },
//                         ),
//                         const TextSpan(text: '  ●  '),
//                         const TextSpan(text: 'Report'),
//                       ],
//                     ),
//                   ),
//                   // showReplyField
//                   //     ? Padding(
//                   //   padding: const EdgeInsets.only(top: 16.0),
//                   //   child: Row(
//                   //     children: [
//                   //       Expanded(
//                   //         child: TextField(
//                   //           textAlign: TextAlign.start,
//                   //           textAlignVertical: TextAlignVertical.center,
//                   //           style: Theme.of(context)
//                   //               .textTheme
//                   //               .headline3!
//                   //               .copyWith(
//                   //             fontWeight: FontWeight.w600,
//                   //             fontSize: 13,
//                   //           ),
//                   //           controller: _replyController,
//                   //           cursorColor: settingsManager.darkMode
//                   //               ? Colors.white
//                   //               : Colors.black,
//                   //           autofocus: false,
//                   //           autocorrect: false,
//                   //           keyboardType: TextInputType.text,
//                   //           decoration: InputDecoration(
//                   //             isDense: true,
//                   //             suffixIcon: IconButton(
//                   //               splashRadius: 20,
//                   //               iconSize: 20,
//                   //               onPressed: () async {
//                   //                 postProvider.replyComment(
//                   //                   userName: widget.user!.userName,
//                   //                   profileImage: widget.user!.photoUrl,
//                   //                   postId: widget.postId,
//                   //                   text: _replyController.text,
//                   //                   uid: widget.user!.id,
//                   //                   commentId: widget.comment.commentId,
//                   //                 );
//                   //                 _replyController.clear();
//                   //               },
//                   //               icon: Icon(
//                   //                 Icons.send,
//                   //                 color: settingsManager.darkMode
//                   //                     ? Colors.white
//                   //                     : kBlackColor,
//                   //               ),
//                   //             ),
//                   //             fillColor: settingsManager.darkMode
//                   //                 ? kGreyColor
//                   //                 : kGreyColor4,
//                   //             filled: true,
//                   //             contentPadding:
//                   //             const EdgeInsets.only(left: 14),
//                   //             hintText: 'Reply',
//                   //             hintStyle: Theme.of(context)
//                   //                 .textTheme
//                   //                 .headline4!
//                   //                 .copyWith(
//                   //               fontSize: 13,
//                   //               color: settingsManager.darkMode
//                   //                   ? Colors.grey.shade600
//                   //                   : Colors.grey.shade700,
//                   //               fontWeight: FontWeight.bold,
//                   //             ),
//                   //             focusedErrorBorder: kFocusedErrorBorder,
//                   //             errorBorder: kErrorBorder,
//                   //             enabledBorder: kEnabledBorder,
//                   //             focusedBorder: kFocusedBorder,
//                   //             border: kBorder,
//                   //           ),
//                   //         ),
//                   //       ),
//                   //     ],
//                   //   ),
//                   // )
//                   const SizedBox.shrink(),
//
//                   //!
//                   // StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//                   //   stream: replyStreamResult,
//                   //   builder: (context, snapshot) {
//                   //     if (snapshot.connectionState == ConnectionState.waiting) {
//                   //       return const SizedBox();
//                   //     }
//                   //     return Column(
//                   //       mainAxisSize: MainAxisSize.min,
//                   //       children: [
//                   //         Flexible(
//                   //           child: ListView.builder(
//                   //             shrinkWrap: true,
//                   //             physics: const NeverScrollableScrollPhysics(),
//                   //             itemCount: snapshot.data!.docs.length,
//                   //             itemBuilder: (context, index) {
//                   //               ReplyModel reply = ReplyModel.fromSnapshot(
//                   //                   snapshot.data!.docs[index]);
//                   //               return ReplyCard(
//                   //                 reply: reply,
//                   //                 comment: widget.comment,
//                   //                 postId: widget.postId,
//                   //               );
//                   //             },
//                   //           ),
//                   //         ),
//                   //       ],
//                   //     );
//                   //   },
//                   // ),
//                 ],
//               ),
//             ),
//           ),
//           //
//         ],
//       ),
//     );
//   }
// }







