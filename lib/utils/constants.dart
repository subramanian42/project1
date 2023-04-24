import 'package:flutter/material.dart';

/// Size of each markers on a map
const defaultMarkerSize = 75.0;

/// Width of the border of markers on maps
const borderWidth = 5.0;

/// Red color used in the app.
const appRed = Color(0xFFD73763);

/// Orange color used in the app.
const appOrange = Color(0xFFF6935C);

/// Yellow color used in the app.
const appYellow = Color(0xFFDFC14F);

/// Blue color used in the app.
const appBlue = Color(0xFF3790E3);

/// Light blue color used in the app.
const appLightBlue = Color(0xFF43CBE9);

/// Purple color used in the app.
const appPurple = Color(0xFF8F42A0);

/// Background color of a button.
const buttonBackgroundColor = Color(0x33000000);

/// Background color of a frosted dialog.
const dialogBackgroundColor = Color(0x26000000);

/// Gradient of red and orange.
const redOrangeGradient = LinearGradient(
  colors: [
    appRed,
    appOrange,
  ],
);

/// Gradient of blue and light blue.
const blueGradient = LinearGradient(colors: [
  appBlue,
  appLightBlue,
]);

/// Maximum duration of video that users can post.
/// Anything beyond this duration will be cropped out.
const maxVideoDuration = Duration(seconds: 30);

/// Preloader to be shownn when loading something.
const preloader = Center(
  child: CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(appRed),
  ),
);

/// Utility method to convert timestamp to human readable text.
final String Function(DateTime, {DateTime? seed}) howLongAgo = (
    DateTime time, {
      DateTime? seed,
    }) {
  final now = seed ?? DateTime.now();
  final difference = now.difference(time);
  if (difference < const Duration(minutes: 1)) {
    return 'now';
  } else if (difference < const Duration(hours: 1)) {
    return '${difference.inMinutes}m';
  } else if (difference < const Duration(days: 1)) {
    return '${difference.inHours}h';
  } else if (difference < const Duration(days: 30)) {
    return '${difference.inDays}d';
  } else if (now.year == time.year) {
    return '${time.month < 10 ? '0' : ''}${time.month}-'
        '${time.day < 10 ? '0' : ''}${time.day}';
  } else {
    return '${time.year}-${time.month < 10 ? '0' : ''}'
        '${time.month}-${time.day < 10 ? '0' : ''}${time.day}';
  }
};

/// Extention method to easily display snack bar.
extension ShowSnackBar on BuildContext {
  /// Extention method to easily display snack bar.
  void showSnackbar(String text) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(text)));
  }

  /// Extention method to easily display error snack bar.
  void showErrorSnackbar(String text) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(
        text,
        style: const TextStyle(color: Color(0xFFFFFFFF)),
      ),
      backgroundColor: appRed,
    ));
  }
}


/// Google map's theme for this app.
const mapTheme =
// ignore: lines_longer_than_80_chars
    '[{"featureType": "administrative.locality","elementType": "labels","stylers": [{"visibility": "on"}]},{"featureType": "administrative.land_parcel","elementType": "geometry","stylers": [{"visibility": "off"}]},{"featureType": "administrative.land_parcel","elementType": "labels","stylers": [{"visibility": "off"}]},{"featureType": "landscape.natural.landcover","elementType": "geometry","stylers": [{"visibility": "on"},{"lightness": "-11"},{"saturation": "-11"}]},{"featureType": "landscape.natural.landcover","elementType": "labels.text","stylers": [{"visibility": "on"}]},{"featureType": "landscape.natural.terrain","elementType": "geometry","stylers": [{"visibility": "on"},{"lightness": "-5"}]},{"featureType": "poi.business","elementType": "labels","stylers": [{"visibility": "off"}]},{"featureType": "poi.government","elementType": "labels","stylers": [{"visibility": "off"}]},{"featureType": "poi.medical","elementType": "labels","stylers": [{"visibility": "off"}]},{"featureType": "poi.place_of_worship","elementType": "labels","stylers": [{"visibility": "off"}]},{"featureType": "poi.school","elementType": "geometry.fill","stylers": [{"visibility": "off"}]},{"featureType": "poi.school","elementType": "labels","stylers": [{"visibility": "off"}]},{"featureType": "road","elementType": "geometry","stylers": [{"visibility": "off"}]},{"featureType": "road","elementType": "labels","stylers": [{"visibility": "off"}]},{"featureType": "road.highway","elementType": "labels","stylers": [{"visibility": "off"}]},{"featureType": "road.highway.controlled_access","elementType": "geometry","stylers": [{"visibility": "off"}]},{"featureType": "road.highway.controlled_access","elementType": "labels","stylers": [{"visibility": "off"}]},{"featureType": "transit","elementType": "labels","stylers": [{"visibility": "off"}]},{"featureType": "water","elementType": "geometry.fill","stylers": [{"lightness": "-69"}]}]' ;
