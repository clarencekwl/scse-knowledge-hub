import 'dart:developer';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scse_knowledge_hub_app/pages/create_question_page.dart';
import 'package:scse_knowledge_hub_app/pages/question_details_page.dart';
import 'package:scse_knowledge_hub_app/pages/search_page.dart';
import 'package:scse_knowledge_hub_app/providers/notification_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:scse_knowledge_hub_app/providers/question_provider.dart';
import 'package:scse_knowledge_hub_app/providers/user_provider.dart';
import 'package:scse_knowledge_hub_app/utils/styles.dart';
import 'package:scse_knowledge_hub_app/widget/nav_bar_widget.dart';
import 'package:scse_knowledge_hub_app/widget/no_glow_scroll.dart';
import 'package:scse_knowledge_hub_app/widget/question_card_widget.dart';

class HomePage extends StatefulWidget {
  final List<String>? selectedTopics;
  const HomePage({
    Key? key,
    this.selectedTopics,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late QuestionProvider _questionProvider;
  late UserProvider _userProvider;
  ScrollController _scrollController = ScrollController();
  late TabController _tabController;

  late String _welcomeText = "";
  late String _titleText = "";
  late bool _currentSliverAppBarExpandedStatus;
  bool _isSliverAppBarExpanded = false;
  bool _isLoading = false;
  bool _isLoadMoreRunning = false;
  int _currentTab = 0;
  bool _isFilter = false;

  @override
  void initState() {
    super.initState();
    FocusManager.instance.primaryFocus?.unfocus();
    Future.microtask(() async {
      log("user: ${_userProvider.user.name}");
      await NotificationProvider().setup();
      await NotificationProvider.addAndStoreFCMToken(
          userId: _userProvider.user.id);
      _welcomeText = "Hi, ${_userProvider.user.name}";
      _titleText = _welcomeText;

      _isLoading = true;
      setState(() {});
      await _questionProvider.getQuestions();
      log("Number of questions: ${_questionProvider.listOfQuestions.length}");
      _isFilter = _questionProvider.getFilteredQuestions(widget.selectedTopics);
      _isLoading = false;
      setState(() {});
    });
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    scrollController();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationProvider.setContext(context);
    });
    setupNotificationMessage();
  }

  void scrollController() {
    _scrollController = ScrollController()
      ..addListener(() async {
        _currentSliverAppBarExpandedStatus = _isSliverAppBarExpanded;
        _isSliverAppBarExpanded = _scrollController.offset >
            (Styles.kScreenHeight(context) * 0.16 - kToolbarHeight);
        if (_isSliverAppBarExpanded != _currentSliverAppBarExpandedStatus) {
          _titleText = _isSliverAppBarExpanded ? "Questions" : _welcomeText;
          setState(() {});
        }
        if (!_isLoadMoreRunning &&
            false == _questionProvider.isLastPage &&
            _scrollController.position.pixels >
                0.99 * _scrollController.position.maxScrollExtent) {
          log("LOAD MORE");
          _isLoadMoreRunning = true;
          setState(() {});

          // Introduce a delay of 1 second here
          await Future.delayed(Duration(seconds: 1));

          await _questionProvider.getQuestions();
          _isLoadMoreRunning = false;
          setState(() {});
        }
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> setupNotificationMessage() async {
    try {
      //! APP KILLED
      RemoteMessage? initialMessage =
          await FirebaseMessaging.instance.getInitialMessage();

      if (initialMessage != null) {
        log('App killed but received notification: ${initialMessage.data}');
        await _questionProvider.getQuestion(
            questionId: initialMessage.data['questionId']);

        Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (context) => QuestionDetailsPage(
                    question: _questionProvider.currentQuestion!)))
            .then((value) => _questionProvider.getQuestions(onRefreshed: true));
      }

      //! APP IN FOREGROUND
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        log("App in foreground message data: ${message.data}");
        Map<String, dynamic> data = message.data;
        await NotificationProvider.showNotification(
            title: data['title'],
            body: data['body'],
            payload: data['questionId']);
      });

      // //! APP IN BACKGROUND
      // FirebaseMessaging.onMessageOpenedApp
      //     .listen((RemoteMessage message) async {
      //   log("App in background message data: ${message.data}");
      //   Map<String, dynamic> data = message.data;
      //   await _questionProvider.getQuestion(questionId: data['questionId']);

      //   Navigator.of(context)
      //       .push(MaterialPageRoute(
      //           builder: (context) => QuestionDetailsPage(
      //               question: _questionProvider.currentQuestion!)))
      //       .then((value) => _questionProvider.getQuestions(onRefreshed: true));
      // });
    } catch (e, stackTrace) {
      log('Error handling FCM messages: $e\n$stackTrace');
    }
  }

  @override
  Widget build(BuildContext context) {
    _questionProvider = Provider.of(context);
    _userProvider = Provider.of(context);
    return Scaffold(
      floatingActionButton: _isSliverAppBarExpanded
          ? FloatingActionButton(
              onPressed: () async {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CreateQuestionPage()));
              },
              elevation: 6,
              backgroundColor: Styles.primaryBlueColor,
              child: Icon(Icons.add, color: Colors.white),
            )
          // FloatingActionButton(
          //     onPressed: () async {
          //       await NotificationProvider.showNotification(
          //         title: 'Someone replied to your question!',
          //         body: 'Go check it out',
          //         // payload: 'WTF GG',
          //       );
          //       log('notif added!');
          //     },
          //   )
          : null,
      drawer: NavBar(),
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            RefreshIndicator(
              edgeOffset: Styles.kScreenHeight(context) * 0.20,
              displacement: 50,
              color: Styles.primaryBlueColor,
              // backgroundColor: Colors.white.withOpacity(0),
              onRefresh: () async {
                await _questionProvider.getQuestions(onRefreshed: true);
              },
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
                              ? EdgeInsets.only(top: 10, bottom: 15, left: 50)
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
                                overflow: TextOverflow.ellipsis,
                                textScaleFactor: 1,
                              ),
                              SizedBox(height: 2.5),
                              if (false == _isSliverAppBarExpanded)
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
                                    height:
                                        Styles.kScreenHeight(context) * 0.15,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.1),
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(50)),
                                    ),
                                  )),
                              if (false == _isSliverAppBarExpanded)
                                Positioned(
                                  top: Styles.statusBarHeight(context) + 10,
                                  right: 20,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 6,
                                      backgroundColor: Styles.primaryGreyColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(300),
                                      ),
                                    ),
                                    onPressed: () async {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CreateQuestionPage(),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Text("Ask"),
                                        Icon(
                                          Icons.question_mark,
                                          size: 18,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      // Search Bar
                      _searchBar(context),
                      // TabBar
                      _tabBar(),
                      //Question List
                      _questionList(),
                      if (_isLoadMoreRunning)
                        SliverToBoxAdapter(
                            child: Container(
                                height: 40,
                                color: Styles.primaryBackgroundColor,
                                child: Center(
                                  child: SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: CircularProgressIndicator(
                                          color: Styles.primaryBlueColor)),
                                ))),
                    ],
                  ),
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

  SliverPersistentHeader _searchBar(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        minHeight: 55,
        maxHeight: 55,
        child: Container(
          padding: const EdgeInsets.only(
              left: 15.0, top: 10.0, bottom: 6.0, right: 15.0),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SearchPage()),
                    );
                  },
                  child: TextField(
                    enabled: false,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Search for Questions...',
                      prefixIcon: Icon(Icons.search),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            width: 1,
                            color: Colors.grey,
                          )),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SliverPersistentHeader _tabBar() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: CustomSliverAppBarDelegate(
        tabBar: TabBar(
          labelStyle: TextStyle(
            color: Styles.primaryBlueColor,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          labelColor: Styles.primaryBlueColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Styles.primaryBlueColor,
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.person, color: Colors.transparent, size: 0),
              iconMargin: EdgeInsets.all(0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.home_outlined),
                  SizedBox(width: 8),
                  Text('Home'),
                ],
              ),
            ),
            Tab(
              icon: Icon(Icons.person, color: Colors.transparent, size: 0),
              iconMargin: EdgeInsets.all(0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person_outlined),
                  SizedBox(width: 8),
                  Text('Your Questions'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverList _questionList() {
    return SliverList(
        delegate: _currentTab == 0
            ? SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Padding(
                      padding: const EdgeInsets.all(10),
                      child: QuestionCard(
                        question: _isFilter
                            ? _questionProvider.listOfFilteredQuestions[index]
                            : _questionProvider.listOfQuestions[index],
                        onTap: () {
                          {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => QuestionDetailsPage(
                                    question: _isFilter
                                        ? _questionProvider
                                            .listOfFilteredQuestions[index]
                                        : _questionProvider
                                            .listOfQuestions[index])));
                          }
                        },
                      ));
                },
                childCount: _isFilter
                    ? _questionProvider.listOfFilteredQuestions.length
                    : _questionProvider.listOfQuestions.length,
              )
            : SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Padding(
                      padding: const EdgeInsets.all(10),
                      child: QuestionCard(
                        question: _questionProvider.listOfUserQuestions[index],
                        onTap: () {
                          {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => QuestionDetailsPage(
                                    question: _questionProvider
                                        .listOfUserQuestions[index])));
                          }
                        },
                      ));
                },
                childCount: _questionProvider.listOfUserQuestions.length,
              ));
  }

  void _handleTabSelection() async {
    _currentTab = _tabController.index;
    if (_currentTab == 1 && _questionProvider.listOfUserQuestions.isEmpty) {
      _isLoading = true;
      setState(() {});
      await _questionProvider.getUserQuestions(_userProvider.user.id);
      _isLoading = false;
      log("length of list: ${_questionProvider.listOfUserQuestions.length}");
    }
    _scrollController.animateTo(0,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    setState(() {});
  }
}

class CustomSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget tabBar;

  CustomSliverAppBarDelegate({required this.tabBar});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Align(child: Container(color: Colors.white, child: tabBar));
  }

  @override
  double get maxExtent => 40;

  @override
  double get minExtent => 40;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
