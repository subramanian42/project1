import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final Function()? function;
  final String text;
  const FollowButton({
    Key? key,
    required this.text,
    this.function
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 125),
      child: ElevatedButton(
        onPressed: function,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          minimumSize: Size(120.0, 35.0),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}




