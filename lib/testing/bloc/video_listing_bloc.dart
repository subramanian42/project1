// import 'package:bloc/bloc.dart';
// import 'package:flutter/foundation.dart';
// import 'package:project1/testing/bloc/video_listing_events.dart';
// import 'package:project1/testing/bloc/video_listing_states.dart';
// import 'package:rxdart/rxdart.dart';
//
//
//
// class VideoListingBloc extends Bloc<VideoListingEvent, VideoListingState> {
//   List<String> imageUrls;
//
//   VideoListingBloc({required this.imageUrls}) ;
//
//   @override
//   // TODO: implement initialState
//   VideoListingState get initialState =>  VideoInitialState();
//
//
//
//   @override
//   Stream<VideoListingState> mapEventToState(
//       VideoListingEvent event) async* {
//     print("mapEventToState");
//     yield VideoLoadingState();
//     try {
//       List<String> videos;
//       if (event is VideoSelectedEvent) {
//         videos = imageUrls;
//       }
//       if (videos.length == 0) {
//         yield VideoEmptyState();
//       } else {
//         yield VideoLoadedState(videos: videos);
//       }
//     } catch (e) {
//       yield VideoErrorState(message: e.toString());
//     }
//   }
// }