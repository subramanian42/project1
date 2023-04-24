import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:custom_marker/marker_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project1/pages/camera_page.dart';
import 'package:project1/pages/feed_screen.dart';
import 'package:project1/pages/search_screen.dart';
import 'package:project1/repositories/repository.dart';
import 'package:project1/testing/carouselDisplay.dart';
import 'package:project1/testing/carousel_item.dart';
import 'package:project1/testing/user_model.dart';
import 'package:project1/utils/constants.dart';
import 'package:project1/widgets/panel_widget.dart';
import 'package:search_map_place_updated/search_map_place_updated.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:video_player/video_player.dart';

const LatLng currentLocation = LatLng(28.5421109, -81.3790304);

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late GoogleMapController mapController;
  final Repository _repository = Repository();
  late VideoPlayerController _controller;
  CameraPosition? position;
  Set<Circle> circles = {};
  late List<DocumentSnapshot> _mapVideos = [];
  int _currentVideoIndex = 0;

  /// Whether the carousel is opened or not.
  bool _isCarouselOpened = false;


  Future<LatLng> _getVisibleRegionCenter() async {
    final visibleRegion = await mapController.getVisibleRegion();
    LatLng center = getCenter(visibleRegion, visibleRegion.southwest.longitude,
        visibleRegion.northeast.longitude);
    return center;
  }

  LatLng getCenter(
      LatLngBounds visibleRegion, double longitudeSW, double longitudeNE) {
    if ((visibleRegion.southwest.longitude - visibleRegion.northeast.longitude >
        180) ||
        (visibleRegion.northeast.longitude - visibleRegion.southwest.longitude >
            180)) {
      longitudeSW += 360;
      longitudeSW %= 360;
      longitudeNE += 360;
      longitudeNE %= 360;
    }
    double centerLatitude =
        (visibleRegion.southwest.latitude + visibleRegion.northeast.latitude) /
            2; // = 55.043348151638
    double centerLongitude = (visibleRegion.southwest.longitude +
        visibleRegion.northeast.longitude) /
        2; // = -1.991765383125
    LatLng center = LatLng(centerLatitude, centerLongitude);

    return center;
  }



  void _initVideoController(int index) {
    if (index == _currentVideoIndex) {
      _controller = VideoPlayerController.network(
        _mapVideos[_currentVideoIndex].get('videoUrl'),
      )..initialize().then((_) {
        _controller.setLooping(true);
        _controller.play();
        setState(() {});
      });
    }
  }



  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('videos')
        .where('uid', isEqualTo: 'Lgm4blpd47PkNgB6HPuuEmG0uHG3')
        .get()
        .then((querySnapshot) {
      setState(() => _mapVideos = querySnapshot.docs);

      _controller = VideoPlayerController.network('');
    });
  }
  void _initVideoPlayer(DocumentSnapshot video) {
    _controller = VideoPlayerController.network(video.get('videoUrl'))
      ..initialize().then((value) {
        _controller.play();
        _controller.setLooping(true);
        setState(() {});
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
    return WillPopScope(
      onWillPop: () async {
        if (_isCarouselOpened) {
          setState(() {
            _isCarouselOpened = false;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            SafeArea(
              child: Stack(
                children: <Widget>[
                  GoogleMap(
                    initialCameraPosition: const CameraPosition(
                      target: currentLocation,
                      zoom: 5,
                    ),
                   // markers: _markers, //Set<Marker>.of(markers.values),
                    onMapCreated: (GoogleMapController controller) {
                      setState(() {
                        mapController = controller;
                      });
                      mapController.setMapStyle(mapTheme);
                    },
                    circles: circles,
                    onCameraMove: (cameraPosition) => position =
                        cameraPosition, // get zoom level(CameraPosition cameraPosition) {double zoomLevel = cameraPosition.zoom; print("Current Zoom Level: $zoomLevel");},
                    onCameraIdle: () async {
                      if (position != null) {
                        var vr = await mapController.getVisibleRegion();
                        // Option 1: Get distance between the corners of visible map & divide by 2
                        double distanceInMeters = Geolocator.distanceBetween(
                          vr.northeast.latitude,
                          vr.northeast.longitude,
                          vr.southwest.latitude,
                          vr.southwest.longitude,
                        );
                        double radiusInMeters = distanceInMeters / 2;
                        // setState(() {
                        //   circles = {
                        //     Circle(
                        //       circleId: const CircleId('id'),
                        //       fillColor:
                        //       const Color.fromARGB(80, 185, 105, 229),
                        //       strokeColor: Colors.purple,
                        //       strokeWidth: 1,
                        //       center: LatLng(position!.target.latitude,
                        //           position!.target.longitude),
                        //       radius: radiusInMeters,
                        //     )
                        //   };
                        // });

                        String field = 'position';
                        final geo = GeoFlutterFire();
                        GeoFirePoint center = geo.point(
                          latitude: position!.target.latitude,
                          longitude: position!.target.longitude,
                        );
                        // Add your query / call your function here
                        _repository
                            .getVideoList(center, radiusInMeters, field, true)
                            .listen((event) {
                          //loadVideos(event);
                        });
                      }
                    },
                  ),
                  Positioned(
                    top: 12,
                    left: 2,
                    child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              GestureDetector(
                                onTap: (){
                                  context;
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const PanelWidget()));
                                },
                                child: CircleAvatar(
                                  radius:  22,
                                  backgroundColor: Colors.transparent.withOpacity(.5),
                                  child: const Center(
                                    child: Icon(
                                      Icons.notifications,
                                      color: Colors.white,
                                      size: 26,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10,),
                              GestureDetector(
                                onTap: (){
                                  context;
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()));
                                },
                                child: CircleAvatar(
                                  radius:  22,
                                  backgroundColor: Colors.transparent.withOpacity(.5),
                                  child: const Center(
                                    child: Icon(
                                      Icons.search,
                                      color: Colors.white,
                                      size: 26,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width:75 ,),
                        const Text(
                          "Map",
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width:100 ,),
                        CircleAvatar(
                          radius:  22,
                          backgroundColor: Colors.transparent.withOpacity(.5),
                          child: const Center(
                            child: Icon(
                              Icons.settings,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // SearchMapPlaceWidget(
                  //   hasClearButton: true,
                  //   placeType: PlaceType.address,
                  //   placeholder: 'Enter a location',
                  //   apiKey: 'AIzaSyD3cxRC4N2SbSPqRZQvXcuLx3SSqJ0UWQQ',
                  //   onSelected: (Place place) async {
                  //     Geolocation? geolocation =
                  //     await place.geolocation as Geolocation;
                  //     mapController.animateCamera(
                  //         CameraUpdate.newLatLng(geolocation.coordinates));
                  //     mapController.animateCamera(
                  //         CameraUpdate.newLatLngBounds(
                  //             geolocation.bounds, 0));
                  //   },
                  // ),
                  // Positioned(
                  //   top: 10,
                  //   right: 10,
                  //   child: FloatingActionButton(
                  //     child: Text("1!"),
                  //     onPressed: () async {
                  //       LatLng centerPoint = await _getVisibleRegionCenter();
                  //       loadData(centerPoint);
                  //     },
                  //   ),
                  // ),
                  Positioned(
                    top: 100,
                    right: 10,
                    child: FloatingActionButton(
                      child: Text("Search"),
                      onPressed: () async {
                        // Navigator.push(
                        //     context, MaterialPageRoute(builder: (context) => FeedScreen(videoUrls: _videoUrls, initialPage: 0 )));
                        setState(() {
                          _isCarouselOpened = true;
                        });
                      },
                    ),
                  ),
                ],
              ),


            ),
            _isCarouselOpened
                ? Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isCarouselOpened = false;
                  });
                },
              ),
            )
                : Container(),
            _isCarouselOpened
                ? Positioned(
              bottom: 0.0,
              right: 0.0,
              left: 0.0,
              child: Container(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 400.0,
                    enlargeCenterPage: true,
                    viewportFraction: 0.7,
                    onPageChanged: (index, reason) {
                      _initVideoPlayer(_mapVideos[index]);
                    },


                  ),
                  items: _mapVideos.map((video) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8.0)),
                          child: Stack(
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return CarouselItem();
                                      },
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                                    child: VideoPlayer(_controller),
                                  ),
                                ),
                                const Align(
                                    alignment: Alignment.topRight,
                                    child: Padding(padding: EdgeInsets.all(5),
                                      child: Icon(Icons.more_vert_rounded, size: 20, color:Colors.white,),)
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: Padding(padding: EdgeInsets.all(5),
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFfafafa).withOpacity(0.5),
                                            borderRadius: BorderRadius.circular(30),
                                            image: const DecorationImage(
                                              scale: 2.3,
                                              image: AssetImage("assets/images/ic_heart.png"),
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                ),
                                Positioned(
                                    bottom: 5, left: 5,
                                    child: Padding(padding: const EdgeInsets.all(5),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text("@Username", maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),),
                                          const SizedBox(height: 8,),
                                          Row(
                                            children: const [
                                              //SvgPicture.asset("assets/images/marker.svg", width: 15, height: 15, color: Colors.white,),
                                              Icon(Icons.pin_drop_outlined, size: 15, color:Colors.white,),
                                              SizedBox(width: 5,),
                                              Text("location", style: TextStyle(fontSize: 13, color: Colors.white,),),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                ),


                              ]
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            )
                : Container(),
          ],
        ),
      ),
    );
  }
}