import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project1/homepage.dart';
import 'package:project1/pages/camera_page.dart';
import 'package:project1/pages/messagesScreen.dart';
import 'package:project1/pages/profile_screen.dart';
import 'package:project1/pages/local_page.dart';
import 'package:uuid/uuid.dart';



const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const MyHomePage(),
  const LocalPage(),
   const CameraPage(),
  MessageScreen(),
  ProfileScreen(),
];