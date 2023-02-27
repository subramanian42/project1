import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project1/resources/storage_methods.dart';
import 'package:project1/models/user.dart' as model;

import '../helper/enum.dart';
import '../models/user.dart';
import '../utils/utils.dart';



class AuthMethods extends ChangeNotifier  {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;

  User? user;
  late String userId;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
      user.userName =
          Utility.getUserName(id: user.userId!, name: user.displayName!);
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