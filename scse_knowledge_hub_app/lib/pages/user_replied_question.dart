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

  @override
  void initState() {
    Future.microtask(() async {
      await _questionProvider.getUserRepliedQuestions(_userProvider.user.id);
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
            "Questions You Replied To!",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Styles.primaryBlueColor,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                      ),
                    ),
                    child: Text(
                        _questionProvider.listOfUserRepliedQuestions.isNotEmpty
                            ? "Your Own Questions Won't Appear Here"
                            : "You Haven't Replied to Any Questions",
                        style: TextStyle(
                          color: Styles.primaryBlueColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        )),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: NoGlowScrollBehavior(),
                child: StretchingOverscrollIndicator(
                  axisDirection: AxisDirection.down,
                  child: ListView.builder(
                    padding: EdgeInsets.all(10),
                    shrinkWrap: true,
                    itemCount:
                        _questionProvider.listOfUserRepliedQuestions.length,
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
