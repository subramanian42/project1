
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/animated_line.dart';

class ViewStoryScreen extends StatefulWidget {

  DocumentSnapshot<Object?> user;

ViewStoryScreen({Key? key, required this.user}) : super(key: key);

@override
State<ViewStoryScreen> createState() => _ViewStoryScreenState();
}

class _ViewStoryScreenState extends State<ViewStoryScreen> with TickerProviderStateMixin {

  late PageController _pageController;
  late AnimationController _animationController;
  int _currentStory = 0;
  late List<DocumentSnapshot> _images;

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('images')
        .where('uid', isEqualTo: widget.user['userId'])
        .get()
        .then((querySnapshot) {
      setState(() => _images = querySnapshot.docs);
    });

    _pageController = PageController(viewportFraction: .99);
    _animationController = AnimationController(vsync: this);
    _showStory();
    _animationController.addStatusListener(_statusListener);

    super.initState();
  }

  @override
  void dispose() {
    _animationController.removeStatusListener( _statusListener );
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }


  void _statusListener(AnimationStatus status){
    if( status == AnimationStatus.completed ){
      _nextStory();
    }
  }


  void _showStory(){

    _animationController
      ..reset()
      ..duration = const Duration(seconds: 4)
      ..forward();
  }


  void _nextStory() {

    if( _currentStory <  _images.length - 1){

      setState(() => _currentStory++);

      _pageController.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOutQuint
      );
      _showStory();

    }
  }


  void _previousStory(){

    if( _currentStory > 0 ){
      setState(() => _currentStory--);
      _pageController.previousPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOutQuint
      );
      _showStory();
    }

  }


  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      body:  Stack(
            fit: StackFit.expand,
            children: [
              GestureDetector(
                onTapDown: (details){
                  if( details.globalPosition.dx < size.width / 2 ){
                    _previousStory();
                  }else{
                    _nextStory();
                  }
                } ,
                child: PageView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  itemCount: _images.length,
                  itemBuilder: (context, index) {
                    var image = _images[index];
                    return CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: image.get('imageUrl'),
                    );
                  },
                ),
              ),

              const SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const SizedBox(height: 30.0),

                    // * Animated Line //
                    Row(
                      children: List.generate(_images.length, (index) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 7.0),
                            child: AnimatedLineStory(
                                index: index,
                                selectedIndex: _currentStory,
                                animationController: _animationController
                            ),
                          )
                      )
                      ),
                    ),


                    const SizedBox(height: 20.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(widget.user.get('profilePic')),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.user.get('displayName'),style: TextStyle(color: Colors.white),),
                              const Text('Hace 5 horas', style: TextStyle(color: Colors.white),)
                            ],
                          ),
                        ),
                        IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close, color: Colors.white, )
                        )
                      ],
                    ),

                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Container(
                                color: Colors.white.withOpacity(.1),
                                child: TextField(
                                  decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.only(left: 20.0),

                                      hintText: 'Escribe un comentario',
                                      hintStyle: GoogleFonts.roboto(color: Colors.white)
                                  ),
                                ),
                              ),
                            )
                        ),
                        const SizedBox(width: 10.0),
                        IconButton(
                            onPressed: (){},
                            icon: const Icon(Icons.send_rounded, color: Colors.white )
                        )
                      ],
                    )
                  ],
                ),
              ),


            ],
          )

    );
  }
}