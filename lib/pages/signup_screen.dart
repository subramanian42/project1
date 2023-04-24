import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../helper/constant.dart';
import '../helper/enum.dart';
import '../models/user.dart';
import '../resources/auth_methods.dart';
import '../utils/utils.dart';
import '../widgets/appWidgets.dart';
import '../widgets/customFlatButton.dart';
import '../widgets/newWidget/customLoader.dart';



class SignupScreen extends StatefulWidget {
  final VoidCallback? loginCallback;

  const SignupScreen({Key? key, this.loginCallback}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmController;
  late CustomLoader loader;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    loader = CustomLoader();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Widget _body(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(50),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Create Account',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Ready to Explore",
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 50),
            Input(
              label: 'Create username',
              icon: Icons.person,
              controller: _usernameController,
            ),
            SizedBox(height: 15),
            Input(
              label: 'Enter email',
              icon: Icons.mail,
              controller: _emailController,
            ),
            SizedBox(height: 15),
            Input(
              label: 'Enter password',
              icon: Icons.email,
              controller: _passwordController,
              obscure: true,
            ),
            SizedBox(height: 15),
            Input(
              label: 'Confirm password',
              icon: Icons.lock,
              controller: _confirmController,
              obscure: true,
            ),
            SizedBox(height: 50),
            Button(
              label: 'Sign Up',
              theme: theme,
              onPressed: () => _submitForm(context),
            ),
            SizedBox(height: 50),
            Container(
              width: double.infinity,
              child: Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Already have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }



  void _submitForm(BuildContext context) {
    if (_emailController.text.isEmpty) {
      Utility.customSnackBar(context, 'Please enter name');
      return;
    }
    if (_emailController.text.length > 27) {
      Utility.customSnackBar(context, 'Name length cannot exceed 27 character');
      return;
    }
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      Utility.customSnackBar(context, 'Please fill form carefully');
      return;
    } else if (_passwordController.text != _confirmController.text) {
      Utility.customSnackBar(
          context, 'Password and confirm password did not match');
      return;
    }

    loader.showLoader(context);
    var state = Provider.of<AuthMethods>(context, listen: false);
    Random random = Random();
    int randomNumber = random.nextInt(8);

    UserModel user = UserModel(
      email: _emailController.text.toLowerCase(),
      userName: _usernameController.text ,
      location: 'Somewhere in universe',
      profilePic: Constants.dummyProfilePicList[randomNumber],
      isVerified: false,
    );
    state
        .signUp(
      user,
      password: _passwordController.text,
      context: context,
    )
        .then((status) {
      print(status);
    }).whenComplete(
          () {
        loader.hideLoader();
        if (state.authStatus == AuthStatus.LOGGED_IN) {
          Navigator.pop(context);
          if (widget.loginCallback != null) widget.loginCallback!();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar:  AppBar(
        elevation: 0,
        backgroundColor: theme.backgroundColor,
        leading: BackButton(
          color: theme.primaryColor,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(child: _body(context)),
    );
  }
}













