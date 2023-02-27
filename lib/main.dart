import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project1/pages/login_screen.dart';
import 'package:project1/pages/signup_screen.dart';
import 'package:project1/resources/auth_methods.dart';
import 'package:project1/responsive/mobile_screen_layout.dart';
import 'package:project1/state/appState.dart';
import 'homepage.dart';
import 'package:project1/pages/local_page.dart';
import 'package:project1/pages/camera_page.dart';
import 'package:project1/pages/messagesScreen.dart';
import 'package:project1/pages/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:project1/providers/user_provider.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>(create: (_) => AppState()),
        ChangeNotifierProvider<AuthMethods>(create: (_) => AuthMethods()),
      ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(

          primarySwatch: Colors.grey,
        ),
        home:  StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              // Checking if the snapshot has any data or not
              if (snapshot.hasData) {
                // if snapshot has data which means user is logged in then we check the width of screen and accordingly display the screen layout
                return const MobileScreenLayout();
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }

            // means connection to future hasnt been made yet
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return const LoginScreen();
          },
        ),
        routes: {
          '/signup': (context) => const SignupScreen(),
             '/local': (context) => const LocalPage(),
          '/home': (context) => const MyHomePage(),
          '/post': (context) =>  const CameraPage(),
          '/message': (context) =>  MessageScreen(),
          '/profile': (context) => ProfileScreen(),





        },
      ),
    );
  }
}


