
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class VideoListingEvent extends Equatable {}

class VideoSelectedEvent extends VideoListingEvent {
  int currentImageIndex ;

  VideoSelectedEvent({required this.currentImageIndex});
  @override
  List<Object> get props => [currentImageIndex];
}