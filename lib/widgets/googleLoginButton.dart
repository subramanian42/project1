import 'package:flutter/material.dart';
import 'package:project1/resources/auth_methods.dart';
import 'package:provider/provider.dart';

import '../utils/utils.dart';
import 'newWidget/customLoader.dart';
import 'newWidget/rippleButton.dart';



class GoogleLoginButton extends StatelessWidget {
  const GoogleLoginButton({
    Key? key,
    required this.loader,
    this.loginCallback,
  }) : super(key: key);
  final CustomLoader loader;
  final Function? loginCallback;
  void _googleLogin(context) {
    var state = Provider.of<AuthMethods>(context, listen: false);
    loader.showLoader(context);
    state.handleGoogleSignIn().then((status) {
      // print(status)
      if (state.user != null) {
        loader.hideLoader();
        Navigator.pop(context);
        if (loginCallback != null) loginCallback!();
      } else {
        loader.hideLoader();
        cprint('Unable to login', errorIn: '_googleLoginButton');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RippleButton(
      onPressed: () {
        _googleLogin(context);
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0xffeeeeee),
              blurRadius: 15,
              offset: Offset(5, 5),
            ),
          ],
        ),
        child: Wrap(
          children: <Widget>[
            Image.asset(
              'assets/images/google_logo.png',
              height: 20,
              width: 20,
            ),
            const SizedBox(width: 10),
            const Text(
              'Continue with Google',
              selectionColor: Colors.black54,
            ),
          ],
        ),
      ),
    );
  }
}