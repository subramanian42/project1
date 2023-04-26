import 'package:flutter/material.dart';

class CarouselDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
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
            child: Image.network(
              'https://th.bing.com/th/id/R.04f18c0adddab4d14f07c5495cf3a148?rik=%2fqDB8SEtNHho2w&riu=http%3a%2f%2f3.bp.blogspot.com%2f-uouUxAYLb6A%2fUD3ewRmqDDI%2fAAAAAAAAB_8%2fP0NgA-3JQV4%2fs1600%2fStatue%2bof%2bLiberty.jpg&ehk=Hw%2f9nZ7sjyJ7a51UbSNVfk1Zb3IRBiguz4lqq3I8wgo%3d&risl=&pid=ImgRaw&r=0',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
