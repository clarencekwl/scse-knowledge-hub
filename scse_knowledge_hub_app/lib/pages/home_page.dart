import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scse_knowledge_hub_app/pages/create_question_page.dart';
import 'package:scse_knowledge_hub_app/pages/question_details_page.dart';
import 'package:scse_knowledge_hub_app/providers/question_provider.dart';
import 'package:scse_knowledge_hub_app/utils/styles.dart';
import 'package:scse_knowledge_hub_app/widget/nav_bar_widget.dart';
import 'package:scse_knowledge_hub_app/widget/no_glow_scroll.dart';
import 'package:scse_knowledge_hub_app/widget/question_card_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late QuestionProvider _questionProvider;
  ScrollController _scrollController = ScrollController();
  final String _welcomeText = "Hi, Clarence";
  late String _titleText;
  late bool _currentSliverAppBarExpandedStatus;
  bool _isSliverAppBarExpanded = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await _questionProvider.getQuestions();
      log("Number of questions:  ${_questionProvider.listOfQuestions.length}");
    });
    _titleText = _welcomeText;
    _scrollController = ScrollController()
      ..addListener(() {
        _currentSliverAppBarExpandedStatus = _isSliverAppBarExpanded;
        _isSliverAppBarExpanded = _scrollController.offset >
            (Styles.kScreenHeight(context) * 0.16 - kToolbarHeight);
        if (_isSliverAppBarExpanded != _currentSliverAppBarExpandedStatus) {
          _titleText = _isSliverAppBarExpanded ? "Questions" : _welcomeText;
          setState(() {});
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    _questionProvider = Provider.of(context);
    return Scaffold(
      drawer: NavBar(),
      body: SafeArea(
        top: false,
        child: ScrollConfiguration(
          behavior: NoGlowScrollBehavior(),
          child: StretchingOverscrollIndicator(
            axisDirection: AxisDirection.down,
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: <Widget>[
                SliverAppBar(
                    pinned: true,
                    backgroundColor: Styles.primaryBlueColor,
                    expandedHeight: Styles.kScreenHeight(context) * 0.16,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: false,
                      titlePadding: _isSliverAppBarExpanded
                          ? EdgeInsets.only(top: 10, bottom: 10, left: 50)
                          : EdgeInsets.only(bottom: 20, left: 25),
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _titleText,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                            textScaleFactor: 1,
                          ),
                          SizedBox(height: 2.5),
                          Text(
                            "Share your knowledge or ask for help!",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 8,
                            ),
                            textScaleFactor: 1,
                          ),
                        ],
                      ),
                      background: Stack(
                        children: [
                          Container(
                            color: Styles.primaryBlueColor,
                          ),
                          Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                width: Styles.kScreenWidth(context) * 0.4,
                                height: Styles.kScreenHeight(context) * 0.15,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.1),
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(50)),
                                ),
                              )),
                          Positioned(
                            top: 30,
                            right: 20,
                            child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Styles.primaryGreyColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20))),
                                onPressed: () async {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          CreateQuestionPage()));
                                },
                                icon: const Icon(Icons.question_mark),
                                label: Text("Ask")),
                          ),
                          Positioned(
                            top: 70,
                            right: 20,
                            child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Styles.primaryGreyColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20))),
                                onPressed: () async {
                                  await _questionProvider.updateQuestion(
                                      docID: "t9OPUj5d0gUXeOZkMcyC");
                                },
                                icon: const Icon(Icons.update),
                                label: Text("Update")),
                          ),
                          Positioned(
                            top: 30,
                            right: 110,
                            child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Styles.primaryGreyColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20))),
                                onPressed: () async {
                                  await _questionProvider.createQuestion(
                                    title: "",
                                    description:
                                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliquaadasdasdasdas dasdasdasdas dasdasdasdasd asdasdad dasd aasdasd asdasda sdaa dasd dsd sd szxc asdas d asd dsd asd dsd sds d",
                                    userID: "bmDrMYHQR4YThCLGFOMY",
                                  );
                                },
                                icon: const Icon(Icons.add),
                                label: Text("Add")),
                          )
                        ],
                      ),
                    )),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: QuestionCard(
                          question: _questionProvider.listOfQuestions[index],
                          onTap: () {
                            {
                              log("card tap!!");
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => QuestionDetailsPage(
                                      question: _questionProvider
                                          .listOfQuestions[index])));
                            }
                          },
                        ),
                      );
                    },
                    childCount: _questionProvider.listOfQuestions.length,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
