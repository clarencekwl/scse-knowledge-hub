import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scse_knowledge_hub_app/models/User.dart';
import 'package:scse_knowledge_hub_app/providers/question_provider.dart';
import 'package:scse_knowledge_hub_app/providers/user_provider.dart';
import 'package:scse_knowledge_hub_app/utils/styles.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  final User? user;
  const ProfilePage({
    Key? key,
    this.user,
  }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late UserProvider _userProvider;
  late QuestionProvider _questionProvider;
  bool _isEdit = false;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await _questionProvider
          .getUserQuestions(widget.user?.id ?? _userProvider.user.id);
      await _questionProvider
          .getUserRepliedQuestions(widget.user?.id ?? _userProvider.user.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    _userProvider = Provider.of(context);
    _questionProvider = Provider.of(context);
    return GestureDetector(
      onTap: () {
        _isEdit = false;
        _textController.clear();
        setState(() {});
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(30, 90, 162, 1),
          elevation: 0,
          actions: [
            if (widget.user == null)
              IconButton(
                  onPressed: () {
                    _isEdit = true;
                    _textController.text = _userProvider.user.name;
                    setState(() {});
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(40),
                        bottomLeft: Radius.circular(40)),
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: const [
                          Color.fromRGBO(30, 90, 162, 1),
                          Color.fromRGBO(60, 104, 158, 1),
                          Color.fromRGBO(82, 115, 156, 1)
                        ])),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Styles.primaryGreyColor,
                          child: const Icon(
                            Icons.person_rounded,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        if (!_isEdit)
                          Text(
                            widget.user == null
                                ? _userProvider.user.name
                                : widget.user!.name,
                            style: TextStyle(
                                overflow: TextOverflow.clip,
                                fontSize: 30.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        if (_isEdit)
                          TextField(
                            textAlign: TextAlign.center,
                            autofocus: _isEdit,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                                fontSize: 30.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            controller: _textController,
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Colors.transparent), // Underline color
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Colors.white), // Focus underline color
                              ),
                            ),
                            onSubmitted: (value) {
                              _userProvider.user.name = _textController.text;
                              _isEdit = false;
                              setState(() {});
                              _userProvider.changeUsername(
                                  userId: _userProvider.user.id,
                                  newUsername: _textController.text);
                              _textController.clear();
                            },
                          ),
                        SizedBox(
                          height: 50.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 15.0, top: 25, left: 20.0, right: 20),
                child: Column(
                  children: [
                    if (widget.user == null)
                      Column(
                        children: [
                          _profileField("Email", _userProvider.user.email,
                              Icons.email_rounded),
                          Divider(),
                        ],
                      ),
                    _profileField(
                      "Date Joined",
                      formatDateTime(widget.user?.dateJoined ??
                          _userProvider.user.dateJoined),
                      Icons.date_range_rounded,
                    ),
                    Divider(),
                    _profileField(
                        "No. of Question Asked",
                        _questionProvider.listOfUserQuestions.length.toString(),
                        Icons.post_add_sharp),
                    Divider(),
                    _profileField(
                        "No. of Question Replied to",
                        _questionProvider.listOfUserRepliedQuestions.length
                            .toString(),
                        Icons.reply_rounded),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _profileField(String title, String content, IconData icon) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("$title: ", style: Styles.titleTextStyle),
          const SizedBox(height: 2.5),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: Styles.primaryGreyColor,
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                content,
                style: TextStyle(fontSize: 15),
              )
            ],
          )
        ],
      ),
    );
  }

  String formatDateTime(DateTime dateTime) {
    // Using the intl package for date formatting
    return DateFormat.yMMMd().format(dateTime);
  }
}
