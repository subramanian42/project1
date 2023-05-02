import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CarouselItem extends StatefulWidget {
  final String videoUrl;
  
  CarouselItem({required this.videoUrl});

  @override
  _CarouselItemState createState() => _CarouselItemState();
}

class _CarouselItemState extends State<CarouselItem> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // _controller = VideoPlayerController.asset('assets/videos/video_2.mp4')
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((value) {
        _controller.play();
        _controller.setLooping(true);
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: DismissiblePage(
        onDismissed: () {
          Navigator.of(context).pop();
        },
        // Note that scrollable widget inside DismissiblePage might limit the functionality
        // If scroll direction matches DismissiblePage direction
        direction: DismissiblePageDismissDirection.multi,
        isFullScreen: false,
        child: Padding(
          padding: const EdgeInsets.only(top:15),
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.97,
              height: MediaQuery.of(context).size.height * 0.88,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35),
                color: Colors.grey[200],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(35),
                child: Stack(
                    children: <Widget>[
                      Hero(
                        tag: 'video-${widget.videoUrl}',
                        child: VideoPlayer(_controller),
                      ),
                      // Black GRADIENT
                      Container(
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
      
                                colors: <Color> [
                                  Colors.transparent,
                                  Colors.transparent,
                                  Colors.transparent,
                                  Colors.transparent,
                                  Colors.transparent,
                                  Colors.black87
                                ]
                            )
                        ),
                      ),
      
                      //CONTROLS
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          _topNavBar(),
                          _postData()
                        ],
                      ),
                      Positioned(
                        bottom: 25 , right: 1,
                        child: _interactionButtons(),
                      )
                    ]
                ),
              ),
            ),
          ),
        ),
      ),

    );
  }

  Widget _topNavBar(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),

      child: InkWell(
        onTap: () => Navigator.pop(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: <Widget>[
            Column(
              children: <Widget>[

                SizedBox(width: 05.0,),
                Icon(Icons.arrow_back_ios_outlined, size: 25, color:Colors.white54,
                ),
              ],
            ),

            Column(
              children: const <Widget>[
                Text(
                  'Back',
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white54
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _interactionButtons(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Align(
        alignment: Alignment.bottomRight,

        child: Padding(
          padding: EdgeInsets.only(right: 6.0),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: <Widget>[
              Container(
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
              const SizedBox(height: 5),
              GestureDetector(
                onTap: (){
                  showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20),
                          )
                      ),
                      builder: (ctx) {
                        return Container(
                          height: MediaQuery.of(context).size.height  * 0.5,
                          child: const Center(
                            child: Text("Likes List"),
                          ),
                        );
                      });
                },
                child: const Text(
                  'Likes',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white60,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              const SizedBox(height: 14),
              GestureDetector(
                onTap: (){
                  showModalBottomSheet(
                      context: context,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20),
                          )
                      ),
                      builder: (ctx) {
                        return Container(
                          height: MediaQuery.of(context).size.height  * 0.5,
                          child: const Center(
                            child: Text("Comments"),
                          ),
                        );
                      });
                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFfafafa).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(30),
                    image: const DecorationImage(
                      scale: 2.3,
                      image: AssetImage("assets/images/ic_message.png"),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Comment',
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.white60,
                    fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 14),
              GestureDetector(
                onTap: (){
                  showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20),
                          )
                      ),
                      builder: (ctx) {
                        return Container(
                          height: MediaQuery.of(context).size.height  * 0.5,
                          child: const Center(
                            child: Text("Share Option"),
                          ),
                        );
                      });
                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFfafafa).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(30),
                    image: const DecorationImage(
                      scale: 2.3,
                      image: AssetImage("assets/images/ic_send.png"),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _postData(){
    return Padding(
      padding: EdgeInsets.only(left: 10.0, bottom: 0, right: 8.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    border: Border.all(
                      color: Colors.black,
                      width: .01,
                    )
                ),

                child: ClipOval(
                    child: Image.network('https://media.istockphoto.com/id/1176363686/vector/smiling-young-asian-girl-profile-avatar-vector-icon.jpg?s=612x612&w=0&k=20&c=QuyZJNKexFQgDPr9u91hKieWKOYbaFxPb0b0gwmd-Lo=',
                      width: 40.0,
                      height: 40.0,
                      fit: BoxFit.cover,
                    )
                ),
              ),
              SizedBox(width: 6.0,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '@USERNAME',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 2,),
                  const Text(
                    '12 hours ago',
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.normal,
                      fontSize: 12,

                    ),
                  ),
                ],
              ),



            ],
          ),

          SizedBox(height: 5.0,),

          Row(
            children: <Widget>[
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: <Widget>[


                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        children: const <Widget>[
                          Icon(Icons.pin_drop_outlined, size: 25, color:Colors.white,),

                          SizedBox(width: 05.0,),

                          Text(
                            'location',
                            style: TextStyle(
                                color: Colors.white
                            ),
                          ),

                          SizedBox(width: 20.0,),

                        ],
                      ),
                    )
                  ],
                ),
              ),

            ],
          )

        ],
      ),
    );
  }


}


