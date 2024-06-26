// import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scse_knowledge_hub_app/models/Question.dart';
import 'package:scse_knowledge_hub_app/models/Reply.dart';
import 'package:scse_knowledge_hub_app/models/User.dart';
import 'package:scse_knowledge_hub_app/pages/profile_page.dart';
// import 'package:scse_knowledge_hub_app/providers/question_provider.dart';
import 'package:scse_knowledge_hub_app/providers/user_provider.dart';
import 'package:scse_knowledge_hub_app/utils/styles.dart';
import 'package:scse_knowledge_hub_app/widget/warning_dialog_widget.dart';

class ReplyCard extends StatefulWidget {
  final Reply reply;
  final Question question;

  final bool isFocused;
  final Function(String, String) onReplyButtonPressed;
  final Function(String, double) onReplyCardPressed;
  final Function(String) onDeleteReply;
  const ReplyCard({
    Key? key,
    required this.reply,
    required this.question,
    required this.isFocused,
    required this.onReplyButtonPressed,
    required this.onReplyCardPressed,
    required this.onDeleteReply,
  }) : super(key: key);
  @override
  State<ReplyCard> createState() => _ReplyCardState();
}

class _ReplyCardState extends State<ReplyCard> {
  final GlobalKey _cardKey = GlobalKey();
  // late QuestionProvider _questionProvider;
  late UserProvider _userProvider;
  bool _isUserReply = false;
  bool _isDelete = false;

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
    // _questionProvider = Provider.of(context);
    _userProvider = Provider.of(context);

    return InkWell(
      onTap: () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final RenderBox renderBox =
              _cardKey.currentContext!.findRenderObject() as RenderBox;
          final cardHeight = renderBox.size.height;

          if (widget.reply.taggedReplyId != null) {
            widget.onReplyCardPressed(
              widget.reply.taggedReplyId!,
              cardHeight,
            );
          }
        });
      },
      child: KeyedSubtree(
        key: _cardKey,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: widget.isFocused
                ? Border.all(color: Colors.blue, width: 2.0)
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          User user = await _userProvider.getUser(
                              userID: widget.reply.userId);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ProfilePage(
                                    user: user,
                                  )));
                        },
                        child: Text(widget.reply.userName,
                            style: TextStyle(
                                color: Colors.black,
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.bold,
                                fontSize: 14)),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        widget.onReplyButtonPressed(
                            widget.reply.userName, widget.reply.id);
                      },
                      child: Row(
                        children: const [
                          Icon(Icons.reply_outlined, size: 20),
                          Text("Reply", style: TextStyle(fontSize: 12)),
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
                      SizedBox(
                        width: 100,
                        child: Text(
                          "@${widget.reply.taggedUserId!} ",
                          style: TextStyle(
                            color: Styles.primaryLightBlueColor,
                          ),
                        ),
                      ),
                    Expanded(
                      child: Text(
                        widget.reply.content,
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    if (_isUserReply)
                      IconButton(
                        padding: EdgeInsets.all(0),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return WarningDialogWidget(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Text(
                                        'Your reply will be permanently removed',
                                        textAlign: TextAlign.center),
                                    Text('Are you sure?',
                                        textAlign: TextAlign.center)
                                  ],
                                ),
                                onConfirm: () {
                                  _isDelete = true;
                                  Navigator.pop(context);
                                },
                                onCancel: () {
                                  _isDelete = false;
                                  Navigator.pop(context);
                                },
                              );
                            },
                          ).then((value) async {
                            if (_isDelete) {
                              widget.onDeleteReply(widget.reply.id);
                            }
                          });
                        },
                        icon: Icon(
                          Icons.remove,
                          color: Colors.redAccent,
                        ),
                      )
                  ],
                ),
                // SizedBox(height: 10),
                // Styles.bottomRowIcons(Icons.thumb_up_alt_rounded, "${40} Likes"),
              ],
            ),
          ),
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
