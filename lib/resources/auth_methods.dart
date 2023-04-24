import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path/path.dart' as path;

import '../helper/enum.dart';
import '../models/user.dart';
import '../utils/utils.dart';



class AuthMethods extends ChangeNotifier  {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  bool isSignInWithGoogle = false;
  User? user;
  late String userId;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // List<UserModel> _profileUserModelList;
  UserModel? _userModel;
  UserModel? get userModel => _userModel;
  UserModel? get profileUserModel => _userModel;


  bool _isBusy = false;
  bool get isbusy => _isBusy;
  set isBusy(bool value) {
    if (value != _isBusy) {
      _isBusy = value;
      notifyListeners();
    }
  }

  /// Verify user's credentials for login
  Future<String?> signIn(String email, String password,
      {required BuildContext context}) async {
    try {
      isBusy = true;
      var result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      user = result.user;
      userId = user!.uid;
      return user!.uid;
    } on FirebaseException catch (error) {
      if (error.code == 'firebase_auth/user-not-found') {
        Utility.customSnackBar(context, 'User not found');
      } else {
        Utility.customSnackBar(
          context,
          error.message ?? 'Something went wrong',
        );
      }
      cprint(error, errorIn: 'signIn');
      return null;
    } catch (error) {
      Utility.customSnackBar(context, error.toString());
      cprint(error, errorIn: 'signIn');

      return null;
    } finally {
      isBusy = false;
    }
  }

  /// Create user from `google login`
  /// If user is new then it create a new user
  /// If user is old then it just `authenticate` user and return firebase user data
  Future<User?> handleGoogleSignIn() async {
    try {
      /// Record log in firebase kAnalytics about Google login
      // kAnalytics.logLogin(loginMethod: 'google_login');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google login cancelled by user');
      }
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      user = (await _firebaseAuth.signInWithCredential(credential)).user;
      authStatus = AuthStatus.LOGGED_IN;
      userId = user!.uid;
      isSignInWithGoogle = true;
      createUserFromGoogleSignIn(user!);
      notifyListeners();
      return user;
    } on PlatformException catch (error) {
      user = null;
      authStatus = AuthStatus.NOT_LOGGED_IN;
      cprint(error, errorIn: 'handleGoogleSignIn');
      return null;
    } on Exception catch (error) {
      user = null;
      authStatus = AuthStatus.NOT_LOGGED_IN;
      cprint(error, errorIn: 'handleGoogleSignIn');
      return null;
    } catch (error) {
      user = null;
      authStatus = AuthStatus.NOT_LOGGED_IN;
      cprint(error, errorIn: 'handleGoogleSignIn');
      return null;
    }
  }

  /// Create user profile from google login
  void createUserFromGoogleSignIn(User user) {
    var diff = DateTime.now().difference(user.metadata.creationTime!);
    // Check if user is new or old
    // If user is new then add new user to firebase realtime kDatabase
    if (diff < const Duration(seconds: 15)) {
      UserModel model = UserModel(
        bio: 'Edit profile to update bio',
        dob: DateTime(1950, DateTime.now().month, DateTime.now().day + 3)
            .toString(),
        location: 'Somewhere in universe',
        profilePic: user.photoURL!,
        displayName: user.displayName!,
        email: user.email!,
        key: user.uid,
        userId: user.uid,
        contact: user.phoneNumber!,
        isVerified: user.emailVerified,
      );
      createUser(model, newUser: true);
    } else {
      cprint('Last login at: ${user.metadata.lastSignInTime}');
    }
  }


  /// Create new user's profile in db
  Future<String?> signUp(UserModel userModel,
      {required BuildContext context, required String password}) async {
    try {
      isBusy = true;
      var result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: userModel.email!,
        password: password,
      );
      user = result.user;
      authStatus = AuthStatus.LOGGED_IN;
      // kAnalytics.logSignUp(signUpMethod: 'register');
      result.user!.updateDisplayName(
        userModel.displayName,
      );
      result.user!.updatePhotoURL(userModel.profilePic);

      _userModel = userModel;
      _userModel!.key = user!.uid;
      _userModel!.userId = user!.uid;
      createUser(_userModel!, newUser: true);
      return user!.uid;
    } catch (error) {
      isBusy = false;
      cprint(error, errorIn: 'signUp');
      Utility.customSnackBar(context, error.toString());
      return null;
    }
  }

  /// `Create` and `Update` user
  /// IF `newUser` is true new user is created
  /// Else existing user will update with new values
  void createUser(UserModel user, {bool newUser = false}) {
    if (newUser) {
      // Create username by the combination of name and id
      // user.userName =
      //     Utility.getUserName(id: user.userId!, name: user.displayName!);
      // kAnalytics.logEvent(name: 'create_newUser');

      // Time at which user is created
      user.createdAt = DateTime.now().toUtc().toString();
    }

    //kDatabase.child('profile').child(user.userId!).set(user.toJson());

    // adding user in our database
    _firestore
        .collection("profile")
        .doc(user.userId!)
        .set(user.toJson());

    _userModel = user;
    isBusy = false;
  }

  /// Fetch current user profile
  Future<User?> getCurrentUser() async {
    try {
      isBusy = true;
      // Utility.logEvent('get_currentUSer', parameter: {});
      user = _firebaseAuth.currentUser;
      if (user != null) {
        // await getProfileUser();
        authStatus = AuthStatus.LOGGED_IN;
        userId = user!.uid;
      } else {
        authStatus = AuthStatus.NOT_LOGGED_IN;
      }
      isBusy = false;
      return user;
    } catch (error) {
      isBusy = false;
      cprint(error, errorIn: 'getCurrentUser');
      authStatus = AuthStatus.NOT_LOGGED_IN;
      return null;
    }
  }

  /// Reload user to get refresh user data
  void reloadUser() async {
    await user!.reload();
    user = _firebaseAuth.currentUser;
    if (user!.emailVerified) {
      userModel!.isVerified = true;
      // If user verified his email
      // Update user in firebase realtime kDatabase
      createUser(userModel!);
      cprint('UserModel email verification complete');
      // Utility.logEvent('email_verification_complete',
      //     parameter: {userModel!.userName!: user!.email});
    }
  }

  /// `Update user` profile
  Future<void> updateUser(
      docId, disPlayName, location, bio, profilePicture, bannerImage) async {
    await FirebaseFirestore.instance.collection('profile')
        .doc(docId)
        .update({
      "displayName": disPlayName,
      "bio": bio,
      "location": location,
      "profilePic": profilePicture,
      "bannerImage": bannerImage,

    })
        .then((_) => print("success"))
        .catchError((error) => print('Failed: $error'));
  }



  // /// `Fetch` user `detail` whose userId is passed
  // Future<UserModel?> getUserDetail(String userId) async {
  //   UserModel user;
  //   var event = await kDatabase.child('profile').child(userId).once();
  //
  //   final map = event.snapshot.value as Map?;
  //   if (map != null) {
  //     user = UserModel.fromJson(map);
  //     user.key = event.snapshot.key!;
  //     return user;
  //   } else {
  //     return null;
  //   }
  // }



  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }



}




// class AuthMethods {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   // get user details
//   Future<model.User> getUserDetails() async {
//     User currentUser = _auth.currentUser!;
//
//     DocumentSnapshot documentSnapshot =
//     await _firestore.collection('users').doc(currentUser.uid).get();
//
//     return model.User.fromSnap(documentSnapshot);
//   }
//
//   // Signing Up User
//
//   Future<String> signUpUser({
//     required String email,
//     required String password,
//     required String username,
//     required String bioLocation,
//     required Uint8List file,
//
//   }) async {
//     String res = "Some error Occurred";
//     try {
//       if (email.isNotEmpty ||
//           password.isNotEmpty ||
//           username.isNotEmpty ||
//           bioLocation.isNotEmpty
//          // || file != null
//       ) {
//         // registering user in auth with email and password
//         UserCredential cred = await _auth.createUserWithEmailAndPassword(
//           email: email,
//           password: password,
//         );
//
//         String photoUrl =
//         await StorageMethods().uploadImageToStorage('profilePics', file, false);
//
//         model.User _user = model.User(
//           username: username,
//           uid: cred.user!.uid,
//           photoUrl: photoUrl,
//           email: email,
//           bioLocation: bioLocation,
//           followers: [],
//           following: [],
//
//
//         );
//
//         // adding user in our database
//         await _firestore
//             .collection("users")
//             .doc(cred.user!.uid)
//             .set(_user.toJson());
//
//         res = "success";
//       } else {
//         res = "Please enter all the fields";
//       }
//     } catch (err) {
//       return err.toString();
//     }
//     return res;
//   }
//
//   // logging in user
//   Future<String> loginUser({
//     required String email,
//     required String password,
//   }) async {
//     String res = "Some error Occurred";
//     try {
//       if (email.isNotEmpty || password.isNotEmpty) {
//         // logging in user with email and password
//         await _auth.signInWithEmailAndPassword(
//           email: email,
//           password: password,
//         );
//         res = "success";
//       } else {
//         res = "Please enter all the fields";
//       }
//     } catch (err) {
//       return err.toString();
//     }
//     return res;
//   }
//
//   Future<void> signOut() async {
//     await _auth.signOut();
//   }
// }