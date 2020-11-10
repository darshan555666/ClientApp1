import 'package:clientproject/JoinPage.dart';
import 'package:clientproject/Login.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';

import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:clientproject/Ads.dart';

const String testDevice = 'MobileId';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  String userId;
  static const adUnitID = "ca-app-pub 3940256099942544/8135179316";

  final String appId = "ca-app-pub-3940256099942544~3347511713";

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance.initialize(appId: appId);
    getData();
    WidgetsBinding.instance.addObserver(this);
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("userId");
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        print("Online");
        break;
      case AppLifecycleState.inactive:
        usersRefrance.document(userId).updateData({
          "isRequestToJoin": false,
          "isRequestForChat": false,
        });
        print("offline");
        break;
      case AppLifecycleState.paused:
        print("waiting");
        break;
      case AppLifecycleState.detached:
        print("offline");
        usersRefrance.document(userId).updateData({
          "isRequestToJoin": false,
          "isRequestForChat": false,
        });
        break;
    }
  }

  showAlert() {
    Alert(
      style: AlertStyle(animationType: AnimationType.shrink),
      desc:
          "Have fun while using this app, keep in mind that, don't use violent content or any nudity display behaviours, otherwise strict action will be taken.",
      context: context,
      title: "Alert",
      content: Column(
        children: <Widget>[
          Container(
            height: 10.0,
          ),
          GestureDetector(
            onTap: () async {
              Navigator.pop(context, true);
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove("Name");
              prefs.remove("userId");
              await usersRefrance.document(userId).delete();
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Login()));
            },
            child: Container(
              height: 40.0,
              width: 230.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(20.0)),
              child: Text(
                "Sign Out",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            ),
          )
        ],
      ),
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ClientApp",
            style: TextStyle(color: Colors.red, fontSize: 24.0)),
        centerTitle: true,
        backgroundColor: Colors.orange,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.info_outline,
              size: 30.0,
              color: Colors.red,
            ),
            onPressed: () async {
              showAlert();
            },
          )
        ],
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Text("Select Gender for proceed.",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 20.0,
                        fontStyle: FontStyle.italic)),
              ),
              Container(
                height: 20.0,
              ),
              GestureDetector(
                onTap: () async {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => JoinPage()));
                  // Ads().createInterstitialAd()
                  //   ..load()
                  //   ..show();
                },
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
                    color: Colors.red,
                    icon: Icon(
                      Icons.record_voice_over,
                      color: Colors.white,
                    ),
                    label: Text(
                      " Male ",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                    onPressed: () async {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => JoinPage()));
                    },
                  ),
                ),
              ),
              Container(
                height: 20.0,
              ),
              GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40.0),
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.blue, Colors.red])),
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
                    label: Text(
                      "Female",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                    onPressed: () async {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => JoinPage()));
                      // Ads().createInterstitialAd()
                      //   ..load()
                      //   ..show();
                    },
                  ),
                ),
              ),
              // NativeAdmob(
              //   adUnitID: adUnitID,
              //   numberAds: 1,
              //   type: NativeAdmobType.banner,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
