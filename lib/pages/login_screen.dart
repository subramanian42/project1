
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project1/homepage.dart';
import 'package:project1/pages/signup_screen.dart';
import 'package:provider/provider.dart';

import '../resources/auth_methods.dart';
import '../utils/utils.dart';
import '../widgets/customFlatButton.dart';
import '../widgets/customWidgets.dart';
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
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 150),
            _entryField('Enter email', controller: _emailController),
            _entryField('Enter password',
                controller: _passwordController, isPassword: true),
            _emailLoginButton(context),
            const SizedBox(height: 20),
            _labelButton('Forget password?', onPressed: () {
              Navigator.of(context).pushNamed('/ForgetPasswordPage');
            }),
            const Divider(
              height: 30,
            ),
            const SizedBox(
              height: 30,
            ),
            _labelButton('Sign Up?', onPressed: () {
              Navigator.of(context).pushNamed('/signup');
            }),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _entryField(String hint,
      {required TextEditingController controller, bool isPassword = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal,
        ),
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              borderSide: BorderSide(color: Colors.blue)),
          contentPadding:
          const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
      ),
    );
  }

  Widget _labelButton(String title, {Function? onPressed}) {
    return TextButton(
      onPressed: () {
        if (onPressed != null) {
          onPressed();
        }
      },
      child: Text(
        title,
        style: const TextStyle(
            color: Colors.lightBlueAccent,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _emailLoginButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 35),
      child: CustomFlatButton(
        label: "Submit",
        onPressed: _emailLogin,
        borderRadius: 30,
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
      key: _scaffoldKey,
      appBar: AppBar(
        title: customText('Sign in',
            context: context, style: const TextStyle(fontSize: 20)),
        centerTitle: true,
      ),
      body: _body(context),
    );
  }
}


