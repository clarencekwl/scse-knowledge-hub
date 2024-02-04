import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scse_knowledge_hub_app/pages/question_details_page.dart';
import 'package:scse_knowledge_hub_app/providers/question_provider.dart';
import 'package:scse_knowledge_hub_app/providers/user_provider.dart';
import 'package:scse_knowledge_hub_app/utils/styles.dart';
import 'package:scse_knowledge_hub_app/widget/no_glow_scroll.dart';
import 'package:scse_knowledge_hub_app/widget/question_card_widget.dart';

class UserRepliedQuestionPage extends StatefulWidget {
  const UserRepliedQuestionPage({super.key});

  @override
  State<UserRepliedQuestionPage> createState() =>
      _UserRepliedQuestionPageState();
}

class _UserRepliedQuestionPageState extends State<UserRepliedQuestionPage> {
  late UserProvider _userProvider;
  late QuestionProvider _questionProvider;
  bool _isLoading = false;

  @override
  void initState() {
    Future.microtask(() async {
      _isLoading = true;
      setState(() {});
      _questionProvider.listOfUserRepliedQuestions.clear();
      await _questionProvider.getUserRepliedQuestions(_userProvider.user.id);
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
    _userProvider = Provider.of(context);
    _questionProvider = Provider.of(context);

    return Scaffold(
        backgroundColor: Styles.primaryBackgroundColor,
        appBar: AppBar(
          title: Text(
            "Question Replied",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Styles.primaryBlueColor,
        ),
        body: _questionProvider.listOfUserRepliedQuestions.isEmpty
            ? Stack(
                children: [
                  Center(
                    child: Text("You Haven't Replied to Any Questions",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        )),
                  ),
                  if (_isLoading)
                    Container(
                        height: double.infinity,
                        width: double.infinity,
                        color: Colors.white,
                        child: Center(
                          child: SizedBox(
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator(
                                  color: Styles.primaryBlueColor)),
                        ))
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ScrollConfiguration(
                      behavior: NoGlowScrollBehavior(),
                      child: StretchingOverscrollIndicator(
                        axisDirection: AxisDirection.down,
                        child: ListView.builder(
                          padding: EdgeInsets.all(10),
                          shrinkWrap: true,
                          itemCount: _questionProvider
                              .listOfUserRepliedQuestions.length,
                          itemBuilder: (context, index) {
                            return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: QuestionCard(
                                  question: _questionProvider
                                      .listOfUserRepliedQuestions[index],
                                  onTap: () {
                                    {
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => QuestionDetailsPage(
                                              question: _questionProvider
                                                      .listOfUserRepliedQuestions[
                                                  index])));
                                    }
                                  },
                                ));
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ));
  }
}
