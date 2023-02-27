

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:project1/models/user.dart' as model;
import 'package:project1/providers/user_provider.dart';
import 'package:project1/resources/firestore_methods.dart';

import 'package:project1/utils/colors.dart';
import 'package:project1/utils/global_variable.dart';
import 'package:project1/utils/utils.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';





class PostCard extends StatefulWidget {
  final snap;
  const PostCard({
    Key? key,
  required this.snap,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {


  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Scaffold(
        body: Image.network(
        widget.snap['postUrl'],
        ),
      ),
    );
  }
}



