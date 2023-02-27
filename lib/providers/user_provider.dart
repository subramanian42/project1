// import 'package:flutter/widgets.dart';
//
// import '../models/user.dart';
// import '../resources/auth_methods.dart';
//
//
// class UserProvider with ChangeNotifier {
//   UserModel? _user;
//   final AuthMethods _authMethods = AuthMethods();
//
//    UserModel get getUser => _user!; //?? const UserModel(username: "null", uid: "null", photoUrl: "null", email: "null", bioLocation: "null", followers: [], following:[] ) ;
//
//   Future<void> refreshUser() async {
//     UserModel user = await _authMethods.getUserDetails();
//     _user = user;
//     notifyListeners();
//   }
// }