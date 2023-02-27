

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:custom_marker/marker_icon.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project1/pages/camera_page.dart';
import 'package:project1/pages/feed_screen.dart';
import 'package:project1/repositories/repository.dart';
import 'package:project1/widgets/panel_widget.dart';
import 'package:search_map_place_updated/search_map_place_updated.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:video_player/video_player.dart';




const LatLng currentLocation = LatLng(28.5421109,-81.3790304);

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late GoogleMapController mapController;
  final Repository _repository = Repository();
  late StreamSubscription subscription ;
  final List<VideoPlayerController> _controllers = [];
  final Map<String, Marker> markers = {};
  List<String> _videoUrls = [];
 
  late VideoPlayerController _controller ;
  final List<Marker> availableMarkers = [];
  final Set<Marker> _markers = Set();
  CameraPosition? position;
  Set<Circle> circles = {};



  List<String>? listofVideos(String videoUrl){
    _videoUrls.add(videoUrl);

    return _videoUrls;
  }




  void _addMarker(LatLng location, String id, String videoUrl) {
    listofVideos(videoUrl);

    final marker = Marker(
      markerId: MarkerId(id),
      position: location,
      onTap: () {
        List<Marker> markerValues = markers.values.toList();
        int indexOfMarker = markerValues.indexOf(markers[id]!);

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => FeedScreen(videoUrls: _videoUrls, initialPage: indexOfMarker)));
      },
    );
    setState(() {
      markers[id] = marker;

    });
  }

  loadData(LatLng centerPoint) async {

      _markers.add(
          Marker(
              markerId: const MarkerId('1'),
              icon: await MarkerIcon.downloadResizePictureCircle(
                  'https://www.florida-palm-trees.com/wp-content/uploads/2021/03/acai-palm-tree-euterpe-oleracea650x550m.jpg',
                  size: 150,
                  addBorder: true,
                  borderColor: Colors.orangeAccent,
                  borderSize: 15) ,
              position: centerPoint ,
              onTap: (){
                //Navigator.push(context, MaterialPageRoute(builder: (context) => VideoPage(videoURL: videoURL)));
              }
          ));
      setState(() {

      });


  }


  // void _addMarker(LatLng location, String id, String videoURL) {
  //   final marker = Marker(
  //     markerId: MarkerId(id),
  //     position: location,
  //     onTap: () {
  //       listofVideos(videoURL);
  //       List<Marker> markerValues = markers.values.toList();
  //       int indexOfMarker = markerValues.indexOf(markers[id]!);
  //       _controller = VideoPlayerController.network(videoURL);
  //       _controller.initialize().then((_) {
  //         setState(() {});
  //         // _controller.setLooping(true);
  //         _controller.play();
  //       });
  //       Navigator.push(
  //           context, MaterialPageRoute(builder: (context) => FeedScreen(controller: _controller)));
  //     },
  //   );
  //   setState(() {
  //     markers[id] = marker;
  //
  //   });
  // }

  Future<LatLng> _getVisibleRegionCenter() async {
    final visibleRegion = await mapController.getVisibleRegion() ;
    LatLng center = getCenter(visibleRegion,visibleRegion.southwest.longitude,visibleRegion.northeast.longitude);
    return center;
  }

  LatLng getCenter(LatLngBounds visibleRegion,double longitudeSW,double longitudeNE){
    if ((visibleRegion.southwest.longitude - visibleRegion.northeast.longitude > 180) || (visibleRegion.northeast.longitude - visibleRegion.southwest.longitude > 180)) {
      longitudeSW += 360;
      longitudeSW %= 360;
      longitudeNE += 360;
      longitudeNE %= 360;
    }
    double centerLatitude = (visibleRegion.southwest.latitude + visibleRegion.northeast.latitude) / 2; // = 55.043348151638
    double centerLongitude = (visibleRegion.southwest.longitude + visibleRegion.northeast.longitude) / 2; // = -1.991765383125
    LatLng center = LatLng(centerLatitude,centerLongitude);

    return center;
  }

  void loadVideos (List<DocumentSnapshot> documentList){
      _videoUrls.clear();
    for (var doc in documentList) {

      String videoUrl = doc.get('videoUrl');
      listofVideos(videoUrl);

    }

  }







  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection("videos").get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        GeoPoint location = doc.get("position") as GeoPoint;
        LatLng latlng = LatLng(location.latitude, location.longitude);
        String id = doc.id;
        _addMarker(latlng, id, doc.get('videoUrl'));
      });
    });

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final baseTop = MediaQuery.of(context).size.height * 0.6;
    return  Scaffold(
      //resizeToAvoidBottomInset: true,
      // resizeToAvoidBottomPadding: false,

      body: SafeArea(
        child: SlidingUpPanel(
          panelBuilder: (controller) => PanelWidget(
            controller: controller,
          ),
          minHeight:MediaQuery.of(context).size.height * 0.03,
          maxHeight:MediaQuery.of(context).size.height * 0.75,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
          //parallaxEnabled: true,
          parallaxOffset: .5,
          body: Stack(
            children:<Widget> [
              GoogleMap(
                    initialCameraPosition: const CameraPosition(
                      target: currentLocation,
                      zoom: 5,
                    ),
                    markers: _markers, //Set<Marker>.of(markers.values),
                    onMapCreated: (GoogleMapController controller){
                      setState(() {
                        mapController = controller;
                      });

                    },
                circles: circles,
                onCameraMove:  (cameraPosition) => position = cameraPosition, // get zoom level(CameraPosition cameraPosition) {double zoomLevel = cameraPosition.zoom; print("Current Zoom Level: $zoomLevel");},
                onCameraIdle: () async {
                  if (position != null) {
                    var vr = await mapController.getVisibleRegion() ;
                    // Option 1: Get distance between the corners of visible map & divide by 2
                    double distanceInMeters = Geolocator.distanceBetween(
                      vr.northeast.latitude,
                      vr.northeast.longitude,
                      vr.southwest.latitude,
                      vr.southwest.longitude,
                    );
                    double radiusInMeters = distanceInMeters / 2;
                    setState(() {
                      circles = {
                        Circle(
                          circleId: const CircleId('id'),
                          fillColor: const Color.fromARGB(80, 185, 105, 229),
                          strokeColor: Colors.purple,
                          strokeWidth: 1,
                          center: LatLng(
                              position!.target.latitude, position!.target.longitude),
                          radius: radiusInMeters,
                        )
                      };
                    });

                    String field = 'position';
                    final geo = GeoFlutterFire();
                    GeoFirePoint center = geo.point(
                      latitude: position!.target.latitude,
                      longitude: position!.target.longitude,
                    );
                    // Add your query / call your function here
                  _repository.getVideoList(center,  radiusInMeters, field,true).listen((event) {
                        loadVideos(event);

                      });
                  }
                },
                  ),


              SearchMapPlaceWidget(
                hasClearButton: true,
                placeType: PlaceType.address,
                placeholder: 'Enter a location',
                apiKey: 'AIzaSyD3cxRC4N2SbSPqRZQvXcuLx3SSqJ0UWQQ',
                onSelected: (Place place) async {
                  Geolocation? geolocation = await place.geolocation as Geolocation;
                  mapController.animateCamera(
                      CameraUpdate.newLatLng(
                          geolocation.coordinates
                      )
                  );
                  mapController.animateCamera(
                      CameraUpdate.newLatLngBounds(geolocation.bounds, 0)
                  );
                  },
              ),
              Positioned(
                top: 10,
                right: 10,
                child: FloatingActionButton(
                  child: Text("1!"),
                  onPressed: () async {
                    LatLng centerPoint = await _getVisibleRegionCenter();
                    loadData(centerPoint);
                    },
                ),
              ),
              Positioned(
                top: 100,
                right: 10,
                child: FloatingActionButton(
                  child: Text("Search"),
                  onPressed: () async {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => FeedScreen(videoUrls: _videoUrls, initialPage: 0 )));
                  },
                ),
              ),


            ],
          ),
        ),
      ),

    );
  }


}

