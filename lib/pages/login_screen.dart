
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project1/homepage.dart';
import 'package:project1/pages/signup_screen.dart';
import 'package:provider/provider.dart';

import '../resources/auth_methods.dart';
import '../utils/utils.dart';
import '../widgets/appWidgets.dart';
import '../widgets/customFlatButton.dart';
import '../widgets/customWidgets.dart';
import '../widgets/googleLoginButton.dart';
import '../widgets/newWidget/customLoader.dart';
import '../widgets/text_field_input.dart';


class LoginScreen extends StatefulWidget {
  final VoidCallback? loginCallback; //!

  const LoginScreen({Key? key, this.loginCallback}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late CustomLoader loader;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    loader = CustomLoader();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _body(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(50),
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(top: 90),
                  child: Text(
                    'Hello World',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Sign in to continue',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 35),
                Input(
                  label: 'Email',
                  icon: Icons.mail,
                  controller: _emailController,
                ),
                SizedBox(height: 15),
                Input(
                  label: 'Password',
                  icon: Icons.lock,
                  controller: _passwordController,
                  obscure: true,
                ),
                SizedBox(height: 30),
                Button(
                  label: 'Login',
                  theme: theme,
                  onPressed:_emailLogin,
                ),
                SizedBox(height: 15),
                GestureDetector(
                  onTap: () {

                  },
                  child: Text(
                    'Forgo0t password?',
                    style: TextStyle(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                // GoogleLoginButton(
                //   loginCallback: widget.loginCallback!,
                //   loader: loader,
                // ),
                // SizedBox(height: 15),
                Container(
                  width: double.infinity,
                  child: Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Don't have an account? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed('/signup');
                          },
                          child: Text(
                            'Sign Up',
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
        ),
      ),
    );
  }



  void _emailLogin() {
    var state = Provider.of<AuthMethods>(context, listen: false);
    if (state.isbusy) {
      return;
    }
    loader.showLoader(context);
    var isValid = Utility.validateCredentials(
        context, _emailController.text, _passwordController.text);
    if (isValid) {
      state
          .signIn(_emailController.text, _passwordController.text,
          context: context)
          .then((status) {
        if (state.user != null) {
          loader.hideLoader();
          Navigator.of(context).
          pushReplacement(MaterialPageRoute(
              builder: (context) => const MyHomePage()));
        } else {
          cprint('Unable to login', errorIn: '_emailLoginButton');
          loader.hideLoader();
        }
      });
    } else {
      loader.hideLoader();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(context),
    );
  }
}


