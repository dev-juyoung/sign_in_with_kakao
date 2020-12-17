import 'package:flutter/material.dart';
import 'package:sign_in_with_kakao/sign_in_with_kakao.dart';

void main() {
  runApp(SignInWithKakaoDemo());
}

class SignInWithKakaoDemo extends StatefulWidget {
  @override
  _SignInWithKakaoDemoState createState() => _SignInWithKakaoDemoState();
}

class _SignInWithKakaoDemoState extends State<SignInWithKakaoDemo> {
  AuthToken _authToken;

  void _login() async {
    try {
      final authToken = await SignInWithKakao.login();
      print('[AuthToken]::$authToken');

      setState(() {
        _authToken = authToken;
      });
    } on AuthFailureException catch (error) {
      print('[AuthFailureException]::$error');
    } catch (error) {
      print('[Exception]::$error');
    }
  }

  void _logout() async {
    final logoutResult = await SignInWithKakao.logout();
    print('[LOGOUT][RESULT]::$logoutResult');

    setState(() {
      _authToken = null;
    });
  }

  void _me() async {
    try {
      final accessToken = await SignInWithKakao.accessTokenInfo();
      final result = await SignInWithKakao.me();
      print('[AccessTokenInfo]::$accessToken');
      print('[USER]::$result');
    } catch (error) {
      print('[Exception]::$error');
    }
  }

  void _updateProfile() async {
    try {
      final result = await SignInWithKakao.updateProfile({'job': 'developer'});
      print('[UPDATE PROFILE]::$result');
    } catch (error) {
      print('[Exception]::$error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Sign in with Kakao Demo'),
        ),
        body: Container(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RaisedButton(
                child: Text('User.me'),
                onPressed: _me,
              ),
              RaisedButton(
                child: Text('User.updateProfile'),
                onPressed: _updateProfile,
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(_authToken != null ? Icons.logout : Icons.login_rounded),
          onPressed: _authToken != null ? _logout : _login,
        ),
      ),
    );
  }
}
