import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clientproject/ChatSystem/FullPhoto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:clientproject/Login.dart';

class chats extends StatelessWidget {
  final String currentUserId;
  final String currentUsername;

  chats({
    @required this.currentUserId,
    @required this.currentUsername,
  });

  @override
  _GroupChatState createState() => _GroupChatState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Group Chat",
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: GroupChat(
        currentUserId: currentUserId,
        currentUsername: currentUsername,
      ),
    );
  }
}

class GroupChat extends StatefulWidget {
  final String currentUserId;
  final String currentUsername;

  GroupChat({
    @required this.currentUserId,
    @required this.currentUsername,
  });

  @override
  _GroupChatState createState() => _GroupChatState();
}

class _GroupChatState extends State<GroupChat> {
  final TextEditingController MessageController = new TextEditingController();
  final ScrollController listScrollController = new ScrollController();

  bool isLoading;

  File imageFile;
  String imgUrl;

  String chatId;
  String id;

  var listMessage;

  @override
  void initState() {
    super.initState();
    isLoading = false;
  }

  createInputField() {
    return Container(
      child: Row(
        children: <Widget>[
          //For sending image
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.image),
                color: Colors.lightBlueAccent,
                onPressed: getImage,
              ),
            ),
            color: Colors.white,
          ),

          //for sending emoji

          Flexible(
            child: Material(
              child: Container(
                  child: TextField(
                style: TextStyle(color: Colors.black, fontSize: 18.0),
                controller: MessageController,
                decoration: InputDecoration.collapsed(
                    hintText: "Message..",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    )),
              )),
            ),
          ),
          //Send icon
          Material(
              child: Container(
            child: IconButton(
              icon: Icon(Icons.send),
              color: Colors.orangeAccent,
              onPressed: () => onSendMessage(MessageController.text, 0),
            ),
          )),
        ],
      ),
      width: double.infinity,
      height: 55.0,
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(
            color: Colors.grey,
            width: 0.5,
          )),
          color: Colors.white),
    );
  }

  void onSendMessage(String content, int type) {
    print("working");
    if (content != "") {
      MessageController.clear();
      groupChatRefrance
          .document(DateTime.now().millisecondsSinceEpoch.toString())
          .setData({
        "idFrom": widget.currentUserId,
        "Time": DateTime.now().millisecondsSinceEpoch.toString(),
        "content": content,
        "type": type,
        "username": widget.currentUsername,
      });

      listScrollController.animateTo(0.0,
          duration: Duration(microseconds: 300), curve: Curves.bounceIn);
    } else {
      print("problem");
      Fluttertoast.showToast(msg: "Empty message. Can't be send.");
    }
  }

  createListMessages() {
    return Flexible(
      child: id == ""
          ? Center(child: CircularProgressIndicator())
          : StreamBuilder(
              stream: groupChatRefrance
                  .orderBy("Time", descending: true)
                  .limit(300)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  listMessage = snapshot.data.documents;
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) =>
                        createItom(index, snapshot.data.documents[index]),
                    itemCount: snapshot.data.documents.length,
                    reverse: true,
                    controller: listScrollController,
                  );
                }
              },
            ),
    );
  }

  bool isLastMsgLeft(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]["idFrom"] == id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMsgRight(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]["idFrom"] != id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Widget createItom(int index, DocumentSnapshot document) {
    //my messsages - rightside
    if (document['idFrom'] == widget.currentUserId) {
      return Row(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: Text(document['username']),
          ),
          //for text msg
          document['type'] == 0
              ? Column(
                  children: <Widget>[
                    Container(
                      child: Text(
                        document['content'],
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w400),
                      ),
                      padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 15.0),
                      width: 200.0,
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      margin: EdgeInsets.only(left: 10.0),
                    ),
                    Container(
                      height: 30.0,
                      width: 80.0,
                      alignment: Alignment.centerRight,
                      child: Text(
                        DateFormat.jm().format(
                            DateTime.fromMillisecondsSinceEpoch(
                                int.parse(document["Time"]))),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 13.0,
                            fontStyle: FontStyle.italic),
                      ),
                    )
                  ],
                )
//              Container(
//                  child: Text(
//                    document['content'],
//                    style: TextStyle(
//                        color: Colors.white,
//                        fontSize: 16.0,
//                        fontWeight: FontWeight.w500),
//                  ),
//                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 15.0),
//                  width: 200.0,
//                  decoration: BoxDecoration(
//                    color: Colors.orangeAccent,
//                    borderRadius: BorderRadius.circular(15.0),
//                  ),
//                  margin: EdgeInsets.only(
//                      bottom: isLastMsgRight(index) ? 20.0 : 10.0, right: 10.0),
//                )
              //for image file
              : document['type'] == 1
                  ? Container(
                      child: FlatButton(
                        child: Material(
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Container(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.deepOrange),
                              ),
                              width: 200.0,
                              height: 200.0,
                              padding: EdgeInsets.all(70.0),
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                            ),
                            errorWidget: (context, url, error) => Material(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              child: Image.asset(
                                "assets/images/errorImg.png",
                                width: 200.0,
                                height: 200.0,
                                fit: BoxFit.cover,
                              ),
                              clipBehavior: Clip.hardEdge,
                            ),
                            imageUrl: document['content'],
                            width: 200.0,
                            height: 200.0,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          clipBehavior: Clip.hardEdge,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      FullPhoto(url: document['content'])));
                        },
                      ),
                      margin: EdgeInsets.only(
                          bottom: isLastMsgRight(index) ? 20.0 : 10.0,
                          right: 10.0),
                    )
                  //for stikers
                  : Column(
                      children: <Widget>[
                        Container(
                          child: Image.asset(
                            "assets/images/gifs/${document['content']}.gif",
                            width: 100.0,
                            height: 100.0,
                            fit: BoxFit.cover,
                          ),
                          margin: EdgeInsets.only(
                              bottom: isLastMsgRight(index) ? 20.0 : 10.0,
                              right: 10.0),
                        ),
                        Container(
                          height: 30.0,
                          width: 140.0,
                          alignment: Alignment.topLeft,
                          child: Text(
                            DateFormat.jm().format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    int.parse(document["Time"]))),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 13.0,
                                fontStyle: FontStyle.italic),
                          ),
                          margin: EdgeInsets.only(
                              left: 10.0, top: 5.0, bottom: 5.0),
                        )
                      ],
                    ),
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } //receiver side
    else {
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: Text(document['username']),
                ),
                document['type'] == 0
                    ? Column(
                        children: <Widget>[
                          Container(
                            child: Text(
                              document['content'],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400),
                            ),
                            padding:
                                EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 15.0),
                            width: 200.0,
                            decoration: BoxDecoration(
                              color: Colors.lightBlueAccent,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            margin: EdgeInsets.only(left: 10.0),
                          ),
                          Container(
                            height: 30.0,
                            width: 140.0,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              DateFormat.jm().format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      int.parse(document["Time"]))),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.0,
                                  fontStyle: FontStyle.italic),
                            ),
                          )
                        ],
                      )
                    : document['type'] == 1
                        ? Column(
                            children: <Widget>[
                              Container(
                                child: FlatButton(
                                  child: Material(
                                    child: CachedNetworkImage(
                                      placeholder: (context, url) => Container(
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.deepOrange),
                                        ),
                                        width: 200.0,
                                        height: 200.0,
                                        padding: EdgeInsets.all(70.0),
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Material(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                        child: Image.asset(
                                          "assets/images/errorImg.png",
                                          width: 200.0,
                                          height: 200.0,
                                          fit: BoxFit.cover,
                                        ),
                                        clipBehavior: Clip.hardEdge,
                                      ),
                                      imageUrl: document['content'],
                                      width: 200.0,
                                      height: 200.0,
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    clipBehavior: Clip.hardEdge,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => FullPhoto(
                                                url: document['content'])));
                                  },
                                ),
                                margin: EdgeInsets.only(left: 10.0),
                              ),
                              Container(
                                height: 30.0,
                                width: 140.0,
                                alignment: Alignment.topLeft,
                                child: Text(
                                  DateFormat.jm().format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          int.parse(document["Time"]))),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13.0,
                                      fontStyle: FontStyle.italic),
                                ),
                                margin: EdgeInsets.only(
                                    left: 50.0, top: 20.0, bottom: 5.0),
                              )
                            ],
                          )
                        : Column(
                            children: <Widget>[
                              Container(
                                child: Image.asset(
                                  "assets/images/gifs/${document['content']}.gif",
                                  width: 100.0,
                                  height: 100.0,
                                  fit: BoxFit.cover,
                                ),
                                margin: EdgeInsets.only(
                                    bottom: isLastMsgRight(index) ? 20.0 : 10.0,
                                    right: 10.0),
                              ),
                              Container(
                                height: 30.0,
                                width: 140.0,
                                alignment: Alignment.topLeft,
                                child: Text(
                                  DateFormat.jm().format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          int.parse(document["Time"]))),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13.0,
                                      fontStyle: FontStyle.italic),
                                ),
                                margin: EdgeInsets.only(
                                    left: 50.0, top: 20.0, bottom: 5.0),
                              )
                            ],
                          ),
              ],
            ),
            //Message time
//            isLastMsgLeft(index)
//                 Container(
//                    child: Text(
//                      DateFormat.jm().format(
//                          DateTime.fromMillisecondsSinceEpoch(
//                              int.parse(document["Time"]))),
//                      style: TextStyle(
//                          color: Colors.black,
//                          fontSize: 13.0,
//                          fontStyle: FontStyle.italic),
//                    ),
//                    margin: EdgeInsets.only(left: 50.0, top: 20.0, bottom: 5.0),
//                  )
//                : Container(),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

  // goTUser(BuildContext context , { String usersProfileId}){
  //     Navigator.push(context, MaterialPageRoute(builder: (context) => MePage(userProfileId: usersProfileId)));
  // }

  Widget willpop() {
    return WillPopScope(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              createListMessages(),
              //show Stikers

              createInputField(),
            ],
          ),
          createLoading(),
        ],
      ),
      onWillPop: onBackPress,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[500],
        title: Text(
          "Group Chat",
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: willpop(),
    );
  }

  createLoading() {
    return Positioned(
      child: isLoading ? CircularProgressIndicator() : Container(),
    );
  }

  Future<bool> onBackPress() {
    Navigator.pop(context, true);
  }

  Future getImage() async {
    // ignore: deprecated_member_use
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      isLoading = true;
    }
    uploadingFile();
  }

  uploadingFile() async {
    String filename = widget.currentUsername.toString();
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child("Images")
        .child(widget.currentUsername)
        .child(filename);

    StorageUploadTask storageUploadTask = storageReference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot =
        await storageUploadTask.onComplete;

    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imgUrl = downloadUrl;
      setState(() {
        isLoading = false;
        onSendMessage(imgUrl, 1);
      });
    }, onError: (error) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "error: " + error);
    });
  }
}
