import 'package:elsab/constants/app_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:elsab/components/class_user.dart';
import 'auth_controller.dart';
import 'user_controller.dart';

class LoginScreen extends StatefulWidget {
  @override
  State createState() {
    return _LoginScreen();
  }
}

class _LoginScreen extends State<LoginScreen> {
  GlobalKey<FormState> _key = new GlobalKey();
  AutovalidateMode _validate = AutovalidateMode.disabled;
  String? email, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.0,
      ),
      body: Form(
        key: _key,
        autovalidateMode: _validate,
        child: ListView(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.only(top: 32.0, right: 16.0, left: 16.0),
              child: Text(
                'Sign In',
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(minWidth: double.infinity),
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 32.0, right: 24.0, left: 24.0),
                child: TextFormField(
                    textAlignVertical: TextAlignVertical.center,
                    textInputAction: TextInputAction.next,
                    validator: validateEmail,
                    onSaved: (val) => email = val,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    style: TextStyle(fontSize: 18.0),
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: Colors.black54,
                    decoration: InputDecoration(
                        contentPadding:
                            new EdgeInsets.only(left: 16, right: 16),
                        fillColor: Colors.white,
                        hintText: 'E-mail Address',
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide:
                                BorderSide(color: Colors.black54, width: 2.0)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ))),
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(minWidth: double.infinity),
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 32.0, right: 24.0, left: 24.0),
                child: TextFormField(
                    textAlignVertical: TextAlignVertical.center,
                    validator: validatePassword,
                    onSaved: (val) => password = val,
                    onFieldSubmitted: (password) async {
                      await login();
                    },
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    style: TextStyle(fontSize: 18.0),
                    cursorColor: Colors.black54,
                    decoration: InputDecoration(
                        contentPadding:
                            new EdgeInsets.only(left: 16, right: 16),
                        fillColor: Colors.white,
                        hintText: 'Password',
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide:
                                BorderSide(color: Colors.black54, width: 2.0)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 40.0, left: 40.0, top: 40),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: double.infinity),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black54,
                    padding: EdgeInsets.only(top: 12, bottom: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        side: BorderSide(color: Colors.black54)),
                  ),
                  child: Text(
                    'Log In',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () => login(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Center(
                child: Text(
                  'OR',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(right: 40.0, left: 40.0, bottom: 20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: double.infinity),
                child: ElevatedButton.icon(
                  label: Text(
                    'Facebook Login',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  icon: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Image.asset(
                      'assets/images/facebook_logo.png',
                      color: Colors.white,
                      height: 30,
                      width: 30,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      side: BorderSide(
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  onPressed: () async => loginWithFacebook(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  login() async {
    if (_key.currentState?.validate() ?? false) {
      _key.currentState!.save();
      await _loginWithEmailAndPassword();
    } else {
      setState(() {
        _validate = AutovalidateMode.onUserInteraction;
      });
    }
  }

  _loginWithEmailAndPassword() async {
    await showProgress(context, 'Logging in, please wait...', false);
    dynamic result = await FireStoreUtils.loginWithEmailAndPassword(
        email!.trim(), password!.trim());
    await hideProgress();
    if (result != null && result is User) {
      print('Mail-check');
      showAlertDialog(context, 'Login success', "Successfully logged in");
      Constants.isSignedIn = true;
      Constants.user = result;
    } else if (result != null && result is String) {
      showAlertDialog(context, 'Couldn\'t Authenticate', result);
    } else {
      showAlertDialog(
          context, 'Couldn\'t Authenticate', 'Login failed, Please try again.');
    }
  }

  loginWithFacebook() async {
    try {
      await showProgress(context, 'Logging in, Please wait...', false);
      dynamic result = await FireStoreUtils.loginWithFacebook();
      await hideProgress();
      if (result != null && result is User) {
        print('FB-check');
      } else if (result != null && result is String) {
        showAlertDialog(context, 'Error', result);
      } else {
        showAlertDialog(context, 'Error', 'Couldn\'t login with facebook.');
      }
    } catch (e, s) {
      await hideProgress();
      print('_LoginScreen.loginWithFacebook $e $s');
      showAlertDialog(context, 'Error', 'Couldn\'t login with facebook.');
    }
  }
}
