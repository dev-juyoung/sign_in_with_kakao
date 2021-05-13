import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sign_in_with_kakao/sign_in_with_kakao.dart';

void main() {
  runApp(SignInWithKakaoDemo());
}

class SignInWithKakaoDemo extends StatefulWidget {
  @override
  _SignInWithKakaoDemoState createState() => _SignInWithKakaoDemoState();
}

class _SignInWithKakaoDemoState extends State<SignInWithKakaoDemo> {
  final Color _buttonColor = Color(0xFFFEE500);
  final Color _buttonTextColor = Color(0xD9000000);

  bool _isAuthorized;
  User _user;

  @override
  void initState() {
    super.initState();

    /// 프로퍼티 초기화
    _isAuthorized = false;
    _authToken = null;
    _user = null;

    /// 토큰 정보 확인
    _accessTokenInfo();
  }

  void _updateIfNecessary(VoidCallback fn) {
    if (!mounted) {
      return;
    }

    setState(fn);
  }

  void _accessTokenInfo() async {
    try {
      final tokenInfo = await SignInWithKakao.accessTokenInfo();

      if (tokenInfo.expiresIn > 0) {
        _updateIfNecessary(() => _isAuthorized = true);
        _me();
      } else {
        _updateIfNecessary(() => _isAuthorized = false);
      }
    } catch (error) {
      _updateIfNecessary(() => _isAuthorized = false);
    }
  }

  void _login() async {
    try {
      final authToken = await SignInWithKakao.login();
      _updateIfNecessary(() {
        _isAuthorized = true;
        _authToken = authToken;
      });
      _me();
    } catch (error) {
      /// 로그인 예외 처리
    }
  }

  void _me() async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      final user = await SignInWithKakao.me();
      _updateIfNecessary(() => _user = user);
    } catch (error) {
      /// 로그인 예외 처리
    }
  }

  void _logout() async {
    final succeed = await SignInWithKakao.logout();

    if (!succeed) {
      return;
    }

    _updateIfNecessary(() {
      _isAuthorized = false;
      _authToken = null;
      _user = null;
    });
  }

  void _unlink() async {
    final succeed = await SignInWithKakao.unlink();

    if (!succeed) {
      return;
    }

    _updateIfNecessary(() {
      _isAuthorized = false;
      _authToken = null;
      _user = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Sign in with Kakao Demo'),
        ),
        body: _isAuthorized ? _buildProfileView() : _buildSignInView(),
      ),
    );
  }

  Widget _buildSignInView() {
    return Container(
      width: double.infinity,
      child: Center(
        child: RaisedButton(
          child: Text('카카오 로그인'),
          color: _buttonColor,
          textColor: _buttonTextColor,
          onPressed: _login,
        ),
      ),
    );
  }

  Widget _buildProfileView() {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (_user != null) _buildAccountView() else _buildLoadingView(),
          SizedBox(height: 24.0),
          RaisedButton(
            child: Text('로그아웃'),
            color: _buttonColor,
            textColor: _buttonTextColor,
            onPressed: _logout,
          ),
          RaisedButton(
            child: Text('연결끊기'),
            color: _buttonColor,
            textColor: _buttonTextColor,
            onPressed: _unlink,
          ),
        ],
      ),
    );
  }

  Widget _buildAccountView() {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (_user.account.profile.thumbnailImageUrl != null)
            Container(
              width: 110.0,
              height: 110.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(_user.account.profile.thumbnailImageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          if (_user.account.profile.thumbnailImageUrl == null)
            Container(
              width: 110.0,
              height: 110.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
              ),
              child: Icon(
                Icons.account_circle_rounded,
                size: 110.0,
              ),
            ),
          SizedBox(height: 16.0),
          Text(
            _user.account.profile.nickname,
            style: Theme.of(context)
                .textTheme
                .headline5
                .copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingView() {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Shimmer.fromColors(
            child: Container(
              width: 110.0,
              height: 110.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
            ),
            baseColor: Colors.grey,
            highlightColor: Colors.grey[400],
          ),
          SizedBox(height: 16.0),
          Shimmer.fromColors(
            child: Text(
              '사용자 정보 조회 중...',
              style: Theme.of(context).textTheme.headline5,
            ),
            baseColor: Colors.grey,
            highlightColor: Colors.grey[400],
          ),
        ],
      ),
    );
  }
}
