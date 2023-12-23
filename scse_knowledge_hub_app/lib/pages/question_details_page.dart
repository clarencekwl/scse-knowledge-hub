// import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scse_knowledge_hub_app/models/Question.dart';
import 'package:scse_knowledge_hub_app/pages/home_page.dart';
import 'package:scse_knowledge_hub_app/pages/update_question_page.dart';
import 'package:scse_knowledge_hub_app/providers/question_provider.dart';
import 'package:scse_knowledge_hub_app/providers/user_provider.dart';
import 'package:scse_knowledge_hub_app/utils/styles.dart';
import 'package:scse_knowledge_hub_app/widget/display_image_widget.dart';
import 'package:scse_knowledge_hub_app/widget/image_preview_box_widget.dart';
import 'package:scse_knowledge_hub_app/widget/no_glow_scroll.dart';
import 'package:scse_knowledge_hub_app/widget/open_images.dart';
import 'package:scse_knowledge_hub_app/widget/reply_card_widget.dart';
import 'package:scse_knowledge_hub_app/widget/warning_dialog_widget.dart';

class QuestionDetailsPage extends StatefulWidget {
  final Question question;
  const QuestionDetailsPage({
    Key? key,
    required this.question,
  }) : super(key: key);

  @override
  State<QuestionDetailsPage> createState() => _QuestionDetailsPageState();
}

class _QuestionDetailsPageState extends State<QuestionDetailsPage> {
  final TextEditingController _replyController = TextEditingController();
  late QuestionProvider _questionProvider;
  late UserProvider _userProvider;
  bool _isUserQuestion = false;
  bool _isLoading = false;
  bool _isDelete = false;
  bool _isTaggedReply = false;
  String _taggedUser = '';

  //! TEMP: Images
  List<String> listOfThumbnailUrls = [
    'http://images.saymedia-content.com/.image/c_limit%2Ccs_srgb%2Cq_auto:eco%2Cw_1190/MTc2Mjg1ODI0ODMxMjAyNDk0/why-every-teenage-girl-should-learn-how-to-code.webp',
    'https://zubairkhanqureshi.files.wordpress.com/2014/08/2.png',
  ];

  @override
  void initState() {
    Future.microtask(() async {
      _isLoading = true;
      setState(() {});
      await _questionProvider.getAllRepliesForQuestion(
          questionId: widget.question.id);
      if (_userProvider.user.id == widget.question.userId) {
        _isUserQuestion = true;
      }
      _isLoading = false;
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _questionProvider = Provider.of(context);
    _userProvider = Provider.of(context);
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Styles.primaryBackgroundColor,
        appBar: AppBar(
            elevation: _isUserQuestion ? 2 : 0,
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Styles.primaryBackgroundColor,
            actions: _isUserQuestion
                ? <Widget>[
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => UpdateQuestionPage(
                                  question: widget.question,
                                )));
                      },
                      icon: Icon(Icons.edit_document),
                      color: Styles.primaryBlueColor,
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return WarningDialogWidget(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Text('Question will be permanently removed',
                                      textAlign: TextAlign.center),
                                  Text('Are you sure?',
                                      textAlign: TextAlign.center),
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
                          // The following code will be executed after the dialog is closed
                          if (_isDelete) {
                            _isLoading = true;
                            setState(() {});

                            await _questionProvider
                                .deleteQuestion(
                              questionId: widget.question.id,
                              userId: _userProvider.user.id,
                            )
                                .then((_) {
                              _isLoading = false;
                              setState(() {});

                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => HomePage(),
                                ),
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Question successfully deleted.'),
                                ),
                              );
                            });
                          }
                        });
                      },
                      icon: Icon(Icons.delete_rounded),
                      color: Colors.red,
                    ),
                  ]
                : null),
        body: Stack(
          children: [
            ScrollConfiguration(
              behavior: NoGlowScrollBehavior(),
              child: StretchingOverscrollIndicator(
                axisDirection: AxisDirection.down,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      questionDetails(),
                      SizedBox(height: 25),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          "Replies (${widget.question.numberOfReplies})",
                          style: TextStyle(
                              color: Styles.primaryLightBlueColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 15),
                      ListView.builder(
                        padding: EdgeInsets.only(bottom: 60),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _questionProvider.listOfReplies.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: ReplyCard(
                              reply: _questionProvider.listOfReplies[index],
                              question: widget.question,
                              onReplyButtonPressed: (userName) {
                                _isTaggedReply = true;
                                _taggedUser = userName;
                                setState(() {});
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.white,
                padding:
                    EdgeInsets.only(left: 20, right: 10, bottom: 10, top: 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_isTaggedReply)
                      Row(
                        children: [
                          RichText(
                            text: TextSpan(
                              style: TextStyle(color: Colors.black),
                              text: "Replying to ",
                              children: <TextSpan>[
                                TextSpan(
                                  text: _taggedUser,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      "  \u00B7 ", // Unicode character for middle dot
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                _isTaggedReply = false;
                                setState(() {});
                              },
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                              controller: _replyController,
                              maxLines: null,
                              decoration: InputDecoration(
                                hintText: 'Write a reply...',
                              ),
                              cursorColor: Styles.primaryLightBlueColor),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Styles.primaryLightBlueColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          onPressed: () async {
                            _isLoading = true;
                            setState(() {});
                            _isTaggedReply
                                ? await _questionProvider.addReply(
                                    userId: _userProvider.user.id,
                                    userName: _userProvider.user.name,
                                    question: widget.question,
                                    content: _replyController.text,
                                    taggedUserId: _taggedUser)
                                : await _questionProvider.addReply(
                                    userId: _userProvider.user.id,
                                    userName: _userProvider.user.name,
                                    question: widget.question,
                                    content: _replyController.text);
                            await _questionProvider.getAllRepliesForQuestion(
                                questionId: widget.question.id);
                            _isLoading = false;
                            _isTaggedReply = false;

                            FocusScopeNode currentFocus =
                                FocusScope.of(context);

                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                            _replyController.clear();
                            setState(() {});
                          },
                          child: Icon(Icons.send_rounded),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (_isLoading)
              Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.black.withOpacity(0.3),
                  child: Center(
                    child: SizedBox(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator(
                            color: Styles.primaryBlueColor)),
                  ))
          ],
        ),
      ),
    );
  }

  Widget questionDetails() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(25),
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25))),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                false == widget.question.anonymous
                    ? Expanded(
                        child: Text(widget.question.userName,
                            style: TextStyle(
                                color: Colors.black,
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.bold,
                                fontSize: 14)),
                      )
                    : Expanded(
                        child: Text("Anonymous",
                            style: TextStyle(
                                color: Colors.black87,
                                fontStyle: FontStyle.italic,
                                overflow: TextOverflow.ellipsis,
                                fontSize: 14)),
                      ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      Styles.formatTimeDifference(
                          DateTime.now().difference(widget.question.timestamp)),
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    Text(
                      widget.question.topic,
                      style: TextStyle(color: Colors.blueGrey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(widget.question.title,
                style: TextStyle(
                    color: Styles.primaryBlueColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
            SizedBox(
              height: 10,
            ),
            Text(
              widget.question.description,
              style: TextStyle(fontSize: 12),
            ),
            SizedBox(
              height: 10,
            ),
            widget.question.imageUrls.isNotEmpty
                ? SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.question.imageUrls.length,
                      itemBuilder: (context, index) {
                        return ImagePreviewBoxWidget(
                          displayOnly: true,
                          image: DisplayImage(
                              imageUrl: widget.question.imageUrls[index],
                              hasBorderRadius: true),
                          onTap: () {
                            OpenImages(
                                    context: context,
                                    index: index,
                                    images: widget.question.imageUrls)
                                .imageOpenTransition();
                          },
                        );
                      },
                    ),
                  )
                : Text(
                    "No Attachments/Images",
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic),
                  ),
          ],
        ),
      ),
    );
  }
}
