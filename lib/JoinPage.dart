import 'dart:async';

import 'package:clientproject/Ads.dart';

import 'package:clientproject/ChatSystem/GroupChat.dart';
import 'package:clientproject/Login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

class JoinPage extends StatefulWidget {
  @override
  _JoinPageState createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {
  String channelId;
  Random _rnd = Random();
  String userId;
  String username;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    changeCode();
    setCode();
    // Ads().myBanner
    //   ..load()
    //   ..show();
  }

  changeCode() async {
    String getRandomString(int length) =>
        String.fromCharCodes(Iterable.generate(
            length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

    channelId = getRandomString(8);
  }

  setCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("userId");
    username = prefs.getString("Name");
    usersRefrance.document(userId).updateData({"channelId": channelId});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.amber,
      ),
      body: Container(
        alignment: Alignment.center,
        child: Center(
            child: ListView(
          children: <Widget>[
            Container(
              height: 200.0,
            ),
            Container(
              width: 300.0,
              height: 100.0,
              alignment: Alignment.center,
              child: GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40.0),
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.red, Colors.orange])),
                  width: 220.0,
                  height: 110.0,
                  alignment: Alignment.center,
                  child: RaisedButton.icon(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35.0)),
                    color: Colors.green,
                    icon: Icon(
                      Icons.record_voice_over,
                      color: Colors.white,
                    ),
                    splashColor: Colors.red,
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GroupChat(
                                    currentUserId: userId,
                                    currentUsername: username,
                                  )));
                    },
                    label: Text(
                      "Join Group Chat",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                ),
              ),
            ),
            Divider(),
            Container(
              width: 300.0,
              height: 100.0,
              alignment: Alignment.center,
              child: GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40.0),
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.black, Colors.white])),
                  width: 220.0,
                  height: 110.0,
                  alignment: Alignment.center,
                  child: RaisedButton.icon(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35.0)),
                    color: Colors.green,
                    icon: Icon(
                      Icons.record_voice_over,
                      color: Colors.white,
                    ),
                    splashColor: Colors.red,
                    onPressed: () async {
                      ///Perform backend here////

                      // await BackendCode.getCurrentUser();
                      // await pushUser();
                    },
                    label: Text(
                      "Join Video Call",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }

  // pushUser() {
  //   usersRefrance.document(currentUser.id).get().then((doc) {
  //     if (doc.exists) {
  //       channelId = doc.data['channelId'];
  //     }
  //   });

  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => CallPage(
  //               channelName: channelId, role: ClientRole.Broadcaster)));
  // }

  Future<void> _handleCameraAndMic() async {
    await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone],
    );
  }
}
