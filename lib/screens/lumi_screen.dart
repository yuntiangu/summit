import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:summit2/screens/todoScreens/todo_home.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
//import 'package:http/http.dart';
import 'package:dio/dio.dart';

class LumiScreen extends StatefulWidget {
  static const String id = 'lumi_screen';

  @override
  _LumiScreenState createState() => new _LumiScreenState();
}

class _LumiScreenState extends State<LumiScreen> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  StreamSubscription _onDestroy;
  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewStateChanged> _onStateChanged;
  final _auth = FirebaseAuth.instance;
  String authorizationCode;
  String redirectUri = 'summit2:/oauth2-redirect';
  String accessToken;
  dynamic apiResponse;
  String lumiEmail;

  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    _onDestroy.cancel();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    flutterWebviewPlugin.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    flutterWebviewPlugin.close();

    // Add a listener to on destroy WebView, so you can make came actions.
    _onDestroy = flutterWebviewPlugin.onDestroy.listen((_) {
      print("destroy");
    });

    _onStateChanged =
        flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      print("onStateChanged: ${state.type} ${state.url}");
    });

    // Add a listener to on url changed
    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        setState(() {
          print("URL changed: $url");
          print(redirectUri);
          if (url.startsWith(redirectUri)) {
            this.authorizationCode = url.split('?code=')[1];
            print("authorization code: $authorizationCode");
            getAccessToken(authorizationCode).then((value) {
              this.accessToken = value;
              print('access token: $accessToken');
              callApi().then((value) {
                this.apiResponse = value;
                print('api response: $apiResponse');
                lumiEmail = getLumiEmail();
                print(lumiEmail);
                firebaseUser(lumiEmail);
              });
            });
            //Navigator.pushNamed(context, TodoHome.id);
            //flutterWebviewPlugin.close();
          }
        });
      }
    });
  }

  Future<String> getAccessToken(String authorizationCode) async {
    var dio = Dio();
    Response response = await dio.post(
      'https://luminus.azure-api.net/login/ADFSToken',
      options: Options(
        headers: {
          'Ocp-Apim-Subscription-Key': 'c9672e39d6854ec084706e9a944f8b21',
        },
        contentType: 'application/x-www-form-urlencoded',
        followRedirects: true,
      ),
      data: {
        'grant_type': 'authorization_code',
        'resource': 'sg_edu_nus_oauth',
        'client_id': 'INC000002163230',
        'code': authorizationCode,
        "redirect_uri": "summit2:/oauth2-redirect"
      },
    );
    String accessToken = response.data['access_token'];

    return accessToken;
    //print('pls work sighs ${response.data['access_token']}');
  }

  Future<dynamic> callApi() async {
    var dio = Dio();
    Response response = await dio.get(
      'https://luminus.azure-api.net/module',
      options: Options(
        headers: {
          'Ocp-Apim-Subscription-Key': 'c9672e39d6854ec084706e9a944f8b21',
          'Authorization': 'Bearer ${this.accessToken}',
        }
      ),
    );
    return response.data;
  }

  String getLumiEmail() {
    final parts = accessToken.split('.');
    final payload = utf8.decode(base64.decode(base64.normalize(parts[1])));
    final payloadMap = json.decode(payload);
    return payloadMap['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress'];
  }

  void firebaseUser(String luminusUser) async {
    try {
      print('hmm');
      final user = await _auth.signInWithEmailAndPassword(email: luminusUser, password: 'luminus_auth');
      if (user != null) {
        Navigator.pushNamed(context, TodoHome.id);
        flutterWebviewPlugin.close();
      }
    } catch (e) {
      print(e);
      try {
        final newUser = await _auth.createUserWithEmailAndPassword(
          email: luminusUser,
          password: 'luminus_auth',
        );
        if (newUser != null) {
          Navigator.pushNamed(context, TodoHome.id);
          flutterWebviewPlugin.close();
        }
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String loginUrl =
        "https://vafs.nus.edu.sg/adfs/oauth2/authorize?response_type=code&client_id=INC000002163230&resource=sg_edu_nus_oauth&redirect_uri=summit2%3A%2Foauth2-redirect";
    return new WebviewScaffold(
        url: loginUrl,
        appBar: new AppBar(
          title: new Text("Login to LumiNUS"),
        ));
  }
}
