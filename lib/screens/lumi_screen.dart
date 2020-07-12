import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:summit2/screens/todoScreens/todo_home.dart';
import 'package:http/http.dart';

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
            authorizationCode = url.split('?code=')[1];
            print("authorization code: $authorizationCode");
            Navigator.pushNamed(context, TodoHome.id);
            flutterWebviewPlugin.close();
          }
        });
      }
    });
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