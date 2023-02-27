import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class VideoListingState extends Equatable {}

class VideoInitialState extends VideoListingState{
  @override
  // TODO: implement props
  List<Object> get props => [];

}

class VideoLoadingState extends VideoListingState{
  @override
  // TODO: implement props
  List<Object> get props => [];

}

class VideoLoadedState extends VideoListingState{
  List<String> videos;
  VideoLoadedState({required this.videos});
  get videosList => videos;

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class VideoErrorState extends VideoListingState{
  String message;
  VideoErrorState({required this.message});
  @override
  // TODO: implement props
  List<Object> get props => [];

}

class VideoEmptyState extends VideoListingState{
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

}