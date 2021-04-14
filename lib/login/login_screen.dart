import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:honeyroom/login/user_screen.dart';

import 'constants.dart';
import 'custom_route.dart';
import 'users.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/auth';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _success;
  String _userEmail = '';
  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> _loginUser(LoginData data) {
    return Future.delayed(loginTime).then((_) {
      if (!mockUsers.containsKey(data.name)) {
        return 'Username not exists';
      }
      if (mockUsers[data.name] != data.password) {
        return 'Password does not match';
      }
      return null;
    });
  }

  Future<void> _signupUser(LoginData data) async {
    final User user = (await _auth.createUserWithEmailAndPassword(
      email: data.name,
      password: data.password,
    ))
        .user;
    if (user != null) {
      setState(() {
        _success = true;
        _userEmail = data.name;
      });
    } else {
      _success = false;
    }
  }

  // Example code for registration.
  Future<void> _register(LoginData data) async {
    final User user = (await _auth.createUserWithEmailAndPassword(
      email: data.name,
      password: data.password,
    ))
        .user;
    if (user != null) {
      setState(() {
        _success = true;
        _userEmail = user.email;
      });
    } else {
      _success = false;
    }
  }

  Future<String> _recoverPassword(String name) {
    return Future.delayed(loginTime).then((_) {
      if (!mockUsers.containsKey(name)) {
        return 'Username not exists';
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FlutterLogin(
        title: Constants.appName,
        logo: 'assets/images/RoomGowithB.png',
        logoTag: Constants.logoTag,
        titleTag: Constants.titleTag,
        emailValidator: (value) {
          if (!value.contains('@') || !value.endsWith('.com')) {
            return "Email must contain '@' and end with '.com'";
          }
          return null;
        },
        passwordValidator: (value) {
          if (value.isEmpty) {
            return 'Password is empty';
          }
          return null;
        },
        onLogin: (loginData) {
          print('Login info');
          print('Name: ${loginData.name}');
          print('Password: ${loginData.password}');
          return _loginUser(loginData);
        },
        onSignup: (loginData) {
          print('Signup info');
          print('Name: ${loginData.name}');
          print('Password: ${loginData.password}');
          return _register(loginData);
        },
        onSubmitAnimationCompleted: () {
          Navigator.of(context).pushReplacement(FadePageRoute(
            builder: (context) => UserScreen(),
          ));
        },
        onRecoverPassword: (name) {
          print('Recover password info');
          print('Name: $name');
          return _recoverPassword(name);
          // Show new password dialog
        },
        showDebugButtons: false,
      ),
    );
  }
}
