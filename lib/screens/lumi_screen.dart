import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:provider/provider.dart';
import 'package:summit2/models/category/todo_category_data.dart';
import 'package:summit2/models/task/todo_task_data.dart';
import 'package:summit2/screens/todoScreens/todo_home.dart';

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
  final databaseReference = Firestore.instance;
  String authorizationCode;
  String redirectUri = 'summit2:/oauth2-redirect';
  String accessToken;
  dynamic apiResponseMod;
  dynamic apiResponseTimetable;
  String lumiEmail;
  String lumiSub;

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
              callApiModule().then((value) {
                this.apiResponseMod = value;
                print('api response: $apiResponseMod');
                lumiEmail = getLumiEmail();
                print(lumiEmail);
                lumiSub = getLumiSub();
                callApiTimetable('2010').then((value) {
                  this.apiResponseTimetable = value;
                  firebaseUser(
                      lumiEmail, lumiSub, apiResponseMod, apiResponseTimetable);
                });
              });
            });
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

  Future<dynamic> callApiModule() async {
    var dio = Dio();
    Response response = await dio.get(
      'https://luminus.azure-api.net/module/?populate=termDetail,Creator,isMandatory',
      options: Options(headers: {
        'Ocp-Apim-Subscription-Key': 'c9672e39d6854ec084706e9a944f8b21',
        'Authorization': 'Bearer ${this.accessToken}',
      }),
    );
    return response.data;
  }

  String getLumiEmail() {
    final parts = accessToken.split('.');
    final payload = utf8.decode(base64.decode(base64.normalize(parts[1])));
    final payloadMap = json.decode(payload);
    return payloadMap[
        'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress'];
  }

  String getLumiSub() {
    final parts = accessToken.split('.');
    final payload = utf8.decode(base64.decode(base64.normalize(parts[1])));
    final payloadMap = json.decode(payload);
    print(payloadMap['sub']);
    return payloadMap['sub'];
  }

  void firebaseUser(String lumiEmail, String lumiSub, dynamic apiResponseMod,
      dynamic apiResponseTimetable) async {
    try {
      print('hmm');
      final user = await _auth.signInWithEmailAndPassword(
          email: lumiEmail, password: lumiSub);
      getModule(apiResponseMod);
      getTimetable(apiResponseTimetable);
    } catch (e) {
      print(e);
      try {
        print('creating new user');
        final newUser = await _auth.createUserWithEmailAndPassword(
          email: lumiEmail,
          password: lumiSub,
        );
        getModule(apiResponseMod);
        getTimetable(apiResponseTimetable);
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> getModule(dynamic apiResponse) async {
    for (var module in apiResponse['data']) {
      String modName = module['name'];
      String modId = module['id'];
      print(modName);
      final FirebaseUser user = await _auth.currentUser();
      final email = user.email;
      print('CHECK EMAIL: $email');
      DocumentReference doc = databaseReference
          .collection('user')
          .document(email)
          .collection('to do')
          .document(modName);
      doc.get().then((docSnapshot) {
        if (!docSnapshot.exists) {
          Provider.of<CategoryData>(context, listen: false)
              .addCategory(modName);
        }
        print('calling tasks');
        callApiTask(modId).then((value) {
          print('API called');
          getTask(modName, value);
        });
      });
    }
  }

  Future<dynamic> callApiTask(String moduleId) async {
    var dio = Dio();
    Response response = await dio.get(
      'https://luminus.azure-api.net/files/$moduleId/tv',
      options: Options(headers: {
        'Ocp-Apim-Subscription-Key': 'c9672e39d6854ec084706e9a944f8b21',
        'Authorization': 'Bearer ${this.accessToken}',
      }),
    );
    return response.data;
  }

  Future<void> getTask(String categoryTitle, dynamic apiResponse) async {
    print('getTask');
    for (var task in apiResponse['data']) {
      String taskName = task['name'];
      DateTime dueDateTime =
          (task['endDate'] == null) ? null : DateTime.parse(task['endDate']);
      DateTime reminderDateTime = (dueDateTime == null)
          ? null
          : dueDateTime.subtract(Duration(days: 1));
      final FirebaseUser user = await _auth.currentUser();
      final email = user.email;
      DocumentReference doc = databaseReference
          .collection('user')
          .document(email)
          .collection('to do')
          .document(categoryTitle);
      bool toAdd = true;
      doc.get().then((docSnapshot) async {
        docSnapshot.data.forEach((key, value) {
          if (key == taskName) {
            toAdd = false;
          }
        });
        if (toAdd == true) {
          print('%%%% ADDING: $taskName');
          Provider.of<TaskData>(context, listen: false).addTaskFirestore(
              categoryTitle, taskName, dueDateTime, reminderDateTime);
        }
      });
    }
    Navigator.pushNamed(context, TodoHome.id);
    flutterWebviewPlugin.close();
  }

  Future<dynamic> callApiTimetable(String term) async {
    var dio = Dio();
    Response response = await dio.get(
      'https://luminus.azure-api.net/nus/StudentTimetable?Term=$term',
      options: Options(headers: {
        'Ocp-Apim-Subscription-Key': 'c9672e39d6854ec084706e9a944f8b21',
        'Authorization': 'Bearer ${this.accessToken}',
      }),
    );
    return response.data;
  }

  Future<void> getTimetable(dynamic apiResponse) async {
    print('getTimetable');
    for (var event in apiResponse['data']) {
      String eventName = '${event['module']}  ${event['activityText']}';
      DateTime date = DateTime.parse(event['eventdate']);
      String eventTime = '${event['start_time']} to ${event['end_time']}';
      String location = event['room'];
      final FirebaseUser user = await _auth.currentUser();
      final email = user.email;
      DocumentReference doc = databaseReference
          .collection('user')
          .document(email)
          .collection('events')
          .document('$eventName $date');
      doc.get().then((docSnapshot) {
        if (!docSnapshot.exists) {
          doc.setData({
            "id": doc.documentID,
            "title": eventName,
            "description": "time: $eventTime \nlocation: $location",
            "event_date": date == null ? null : Timestamp.fromDate(date),
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String loginUrl =
        "https://vafs.nus.edu.sg/adfs/oauth2/authorize?response_type=code&client_id=INC000002163230&resource=sg_edu_nus_oauth&redirect_uri=summit2%3A%2Foauth2-redirect";
    return WebviewScaffold(
      url: loginUrl,
      appBar: AppBar(
        title: new Text("Login to LumiNUS"),
      ),
    );
  }
}
