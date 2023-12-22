// import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scse_knowledge_hub_app/models/Question.dart';
import 'package:scse_knowledge_hub_app/models/Reply.dart';
import 'package:scse_knowledge_hub_app/providers/question_provider.dart';
import 'package:scse_knowledge_hub_app/providers/user_provider.dart';
import 'package:scse_knowledge_hub_app/utils/styles.dart';
import 'package:scse_knowledge_hub_app/widget/warning_dialog_widget.dart';

class ReplyCard extends StatefulWidget {
  final Reply reply;
  final Question question;
  final Function(String) onReplyButtonPressed;
  const ReplyCard(
      {Key? key,
      required this.reply,
      required this.question,
      required this.onReplyButtonPressed})
      : super(key: key);
  @override
  State<ReplyCard> createState() => _ReplyCardState();
}

class _ReplyCardState extends State<ReplyCard> {
  late QuestionProvider _questionProvider;
  late UserProvider _userProvider;
  bool _isUserReply = false;

  @override
  void initState() {
    Future.microtask(() async {
      if (_userProvider.user.id == widget.reply.userId) {
        _isUserReply = true;
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _questionProvider = Provider.of(context);
    _userProvider = Provider.of(context);
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(widget.reply.userName,
                      style: TextStyle(
                          color: Colors.black,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                          fontSize: 14)),
                ),
                InkWell(
                  onTap: () {
                    widget.onReplyButtonPressed(widget.reply.userName);
                  },
                  child: Row(
                    children: const [
                      Icon(
                        Icons.reply_outlined,
                        size: 20,
                      ),
                      Text(
                        "Reply",
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Text(
                Styles.formatTimeDifference(
                    DateTime.now().difference(widget.reply.timestamp)),
                style: TextStyle(color: Colors.grey, fontSize: 10)),
            SizedBox(height: 10),
            Row(
              children: [
                if (widget.reply.taggedUserId != null)
                  Text(
                    "@${widget.reply.taggedUserId!} ",
                    style: TextStyle(color: Styles.primaryLightBlueColor),
                  ),
                Expanded(
                  child: Text(
                    widget.reply.content,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                if (_isUserReply)
                  IconButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return WarningDialogWidget(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Text('Your reply will be permanently removed',
                                      textAlign: TextAlign.center),
                                  Text('Are you sure?',
                                      textAlign: TextAlign.center),
                                ],
                              ),
                              onConfirm: () async {
                                await _questionProvider.deleteReply(
                                    userId: _userProvider.user.id,
                                    question: widget.question,
                                    replyId: widget.reply.id);
                                Navigator.pop(context);
                              },
                              onCancel: () {
                                Navigator.pop(context);
                              },
                            );
                          },
                        );
                      },
                      icon: Icon(
                        Icons.remove,
                        color: Colors.redAccent,
                      ))
              ],
            ),
            // SizedBox(height: 10),
            // Styles.bottomRowIcons(Icons.thumb_up_alt_rounded, "${40} Likes"),
          ],
        ),
      ),
    );
  }

  // Widget cardDetails() {
  //   return Padding(
  //     padding: const EdgeInsets.all(15),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text("Clarence Kway",
  //             style: TextStyle(
  //                 color: Colors.black,
  //                 overflow: TextOverflow.ellipsis,
  //                 fontWeight: FontWeight.bold,
  //                 fontSize: 14)),
  //         Text("1h ago", style: TextStyle(color: Colors.grey, fontSize: 10)),
  //         Expanded(
  //           child: Text(
  //             "LMAOOO try harder bro this one so easy.",
  //             style: TextStyle(fontSize: 12),
  //           ),
  //         ),
  //         Styles.bottomRowIcons(Icons.thumb_up_alt_rounded, "${40} Likes"),
  //       ],
  //     ),
  //   );
  // }
}
