
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../resources/auth_methods.dart';
import 'login_screen.dart';


class MessageScreen extends StatefulWidget {
  MessageScreen() : super();

  final String title = "Carousel Demo";

  @override
  MessageScreenState createState() => MessageScreenState();
}

class MessageScreenState extends State<MessageScreen> {

  PageController pageController = PageController(initialPage: 0, viewportFraction: 0.8);
  late VideoPlayerController _controller;
  // final List<String> _videoFiles =  ["video_1.mp4", "video_2.mp4", "video_3.mp4","video_4.mp4","video_5.mp4"] ;

  @override
  void initState(){
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/video_2.mp4')
      ..initialize().then((value) {
        _controller.play();
        _controller.setLooping(true);
        setState(() {});
      });
  }

  @override
  void dispose(){
    super.dispose();
    _controller.dispose();

  }

  @override
  Widget build(BuildContext context) {
    //  _controller.play();
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'log ut',
              onPressed: ()async {
                await AuthMethods().signOut();
                Navigator.of(context)
                    .pushReplacement(
                  MaterialPageRoute(
                    builder: (context) =>
                    const LoginScreen(),
                  ),
                );

              },
            ), //IconButton
          ]
      ),

      body: Center(
        child: Container(
          height: 372,
          margin: EdgeInsets.only(top:25),
          child: PageView.builder(
              dragStartBehavior: DragStartBehavior.down,
              controller: pageController,
              itemCount: 5,
              itemBuilder: (context, position){
                position = position % 5;
                return videoSlider(position);
              }),
        ),
      ),
    );
  }

  videoSlider(int index){
    return AnimatedBuilder(
      animation: pageController,
      builder: (context, widget){
        double value = 1;
        if(pageController.position.haveDimensions){
          value = pageController.page! - index;
          value = (1-(value.abs()*0.3)).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value)*372,
            width: Curves.easeInOut.transform(value)*300,
            child: widget,
          ),
        );
      },
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: VideoPlayer(_controller),
          ),
          const Align(
              alignment: Alignment.topRight,
              child: Padding(padding: EdgeInsets.all(5),
                child: Icon(Icons.close, size: 15, color:Colors.white,),)
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom:15),
              height: 370/2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  const Padding(padding: EdgeInsets.only(bottom:15),
                      child:CircleAvatar(backgroundColor: Colors.black, backgroundImage: NetworkImage(    'https://www.freepnglogos.com/uploads/lakers-logo-png/lakers-free-hd-logo-png-2.png',
                      ), radius: 30,)),
                  Padding(padding: EdgeInsets.only(bottom:6),
                      child:Text('Spook', style:TextStyle(color:Colors.white))),
                  Text('@spook_clothing', style:TextStyle(color:Colors.white.withOpacity(0.5))),
                  Container(
                      height: 50,
                      margin: EdgeInsets.only(left:50, right:50, top:12),
                      decoration: BoxDecoration(
                        color: Color(0xfe2b54).withOpacity(1),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Center(child: Text('Follow', style: TextStyle(color:Colors.white),),)
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }



}