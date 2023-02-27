import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:developer' as developer;




void cprint(dynamic data,
    {String? errorIn, String? event, String label = 'Log'}) {
  /// Print logs only in development mode
  if (kDebugMode) {
    if (errorIn != null) {
      print(
          '****************************** error ******************************');
      developer.log('[Error]',
          time: DateTime.now(), error: data, name: errorIn);
      print(
          '****************************** error ******************************');
    } else if (data != null) {
      developer.log(data, time: DateTime.now(), name: label);
    }
    if (event != null) {
      //Utility.logEvent(event, parameter: {});
    }
  }
}


class Utility{

  // for picking up image from gallery
  static pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);
    if (_file != null) {
      return await _file.readAsBytes();
    }
    print('No Image Selected');
  }

// for displaying snackbars
  static showSnackBar(BuildContext context, String text) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

 static customSnackBar(BuildContext context, String msg,
      {double height = 30, Color backgroundColor = Colors.black}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    final snackBar = SnackBar(
      backgroundColor: backgroundColor,
      content: Text(
        msg,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static String getUserName({
    required String id,
    required String name,
  }) {
    String userName = '';
    if (name.length > 15) {
      name = name.substring(0, 6);
    }
    name = name.split(' ')[0];
    id = id.substring(0, 4).toLowerCase();
    userName = '@$name$id';
    return userName;
  }

  static bool validateCredentials(
      BuildContext context, String? email, String? password) {
    if (email == null || email.isEmpty) {
      customSnackBar(context, 'Please enter email id');
      return false;
    } else if (password == null || password.isEmpty) {
      customSnackBar(context, 'Please enter password');
      return false;
    } else if (password.length < 8) {
      customSnackBar(context, 'Password must me 8 character long');
      return false;
    }

    var status = validateEmail(email);
    if (!status) {
      customSnackBar(context, 'Please enter valid email id');
      return false;
    }
    return true;
  }

  static bool validateEmail(String email) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = RegExp(p);

    var status = regExp.hasMatch(email);
    return status;
  }




}



