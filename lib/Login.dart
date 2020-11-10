import 'dart:math';
import 'dart:ui';

import 'package:clientproject/HomePage.dart';
import 'package:flutter/Material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

// ignore: deprecated_member_use
final usersRefrance = Firestore.instance.collection("Users");
// ignore: deprecated_member_use
final groupChatRefrance = Firestore.instance.collection("GroupChat");

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String channelId;
  String userId;
  int selectRadio;
  String gender = "Male";

  var uuid = Uuid();

  @override
  void initState() {
    // TODO: implement initState
    channelId = getRandomString(8);
    super.initState();
    selectRadio = 1;
  }

  setSlectedRadio(int val) {
    setState(() {
      selectRadio = val;
    });
  }

  var _formKey = GlobalKey<FormState>();
  Random _rnd = Random();

  TextEditingController nameController = new TextEditingController();
  TextEditingController GenderController = new TextEditingController();
  TextEditingController AgeController = new TextEditingController();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Container nameContainer() {
    return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey[200]))),
        child: TextFormField(
            controller: nameController,
            keyboardType: TextInputType.name,
            validator: (String value) {
              if (value.isEmpty) {
                return "Name cannot be empty";
              }
            },
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
            ),
            decoration: InputDecoration(
              labelText: "Enter your name",
              hintText: "Name Here.",
            )));
  }

  Container AgeContainer() {
    return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey[200]))),
        child: TextFormField(
            controller: AgeController,
            keyboardType: TextInputType.number,
            validator: (String value) {
              if (value.isEmpty) {
                return "Age Here..";
              }
            },
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
            ),
            decoration: InputDecoration(
              labelText: "Enter your Age",
              hintText: "Name Here.",
            )));
  }

  Container genderContainer() {
    return Container(
        child: Row(
      children: <Widget>[
        ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Text("Male"),
            ),
            Radio(
              value: 1,
              groupValue: selectRadio,
              activeColor: Colors.green,
              onChanged: (val) {
                setSlectedRadio(val);
                setState(() {
                  gender = "Male";
                });
              },
            ),
            Container(
              height: 20.0,
            ),
            Container(
              child: Text("Female"),
            ),
            Radio(
              value: 2,
              groupValue: selectRadio,
              activeColor: Colors.green,
              onChanged: (val) {
                setSlectedRadio(val);
                print(val);
                setState(() {
                  gender = "Female";
                });
              },
            ),
          ],
        ),
      ],
    ));
  }

  SetBackend() async {
    if (_formKey.currentState.validate()) {
      userId = uuid.v1();
      print(userId);

      usersRefrance.document(userId).setData({
        "Gender": gender,
        "profileName": nameController.text,
        "isRequestToJoin": false,
        "Age": AgeController.text,
        "channelId": channelId,
        "userId": userId,
        "UserFind": false,
      });

      ///set locally
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("Name", nameController.text);
      prefs.setString("userId", userId);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Colors.orange[900],
          Colors.orange[700],
          Colors.orange[400]
        ])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 50.0,
            ),
            Padding(
              padding: EdgeInsets.all(30.0),
              child: Column(
                children: <Widget>[
                  Text(
                    "Login",
                    style: TextStyle(color: Colors.white, fontSize: 40.0),
                  )
                ],
              ),
            ),
            Expanded(
                child: SingleChildScrollView(
              child: Container(
                height: 600,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60))),
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 60.0,
                      ),
                      Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.0),
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromRGBO(225, 95, 27, .9),
                                    blurRadius: 30,
                                    offset: Offset(0, 10)),
                              ]),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                nameContainer(),
                                AgeContainer(),
                                genderContainer(),
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 50.0,
                      ),
                      GestureDetector(
                        child: Container(
                          alignment: Alignment.center,
                          height: 50.0,
                          margin: EdgeInsets.symmetric(horizontal: 50),
                          decoration: BoxDecoration(
                              color: Colors.orange[900],
                              borderRadius: BorderRadius.circular(50)),
                          child: Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0),
                          ),
                        ),
                        onTap: () => SetBackend(),
                      )
                    ],
                  ),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
