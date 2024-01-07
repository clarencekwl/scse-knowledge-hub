import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scse_knowledge_hub_app/pages/question_details_page.dart';
import 'package:scse_knowledge_hub_app/providers/question_provider.dart';
import 'package:scse_knowledge_hub_app/providers/user_provider.dart';
import 'package:scse_knowledge_hub_app/utils/styles.dart';
import 'package:scse_knowledge_hub_app/widget/no_glow_scroll.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late UserProvider _userProvider;
  late QuestionProvider _questionProvider;
  bool _isLoading = false;

  @override
  void initState() {
    Future.microtask(() async {
      _isLoading = true;
      setState(() {});
      await _questionProvider.getNotifications(userId: _userProvider.user.id);
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
            "Notifications",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Styles.primaryBlueColor,
        ),
        body: Stack(
          children: [
            ScrollConfiguration(
              behavior: NoGlowScrollBehavior(),
              child: StretchingOverscrollIndicator(
                axisDirection: AxisDirection.down,
                child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return Divider(thickness: 1.5);
                  },
                  padding: EdgeInsets.all(10),
                  shrinkWrap: true,
                  itemCount: _questionProvider.listOfNotifications.length,
                  itemBuilder: (
                    context,
                    index,
                  ) {
                    return Column(
                      children: [
                        ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${_questionProvider.listOfNotifications[index].senderName} replied to your question!",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                              SizedBox(height: 5),
                              Text(
                                  "Question: ${_questionProvider.listOfNotifications[index].questionTitle} ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 12,
                                  ))
                            ],
                          ),
                          subtitleTextStyle: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              Styles.formatTimeDifference(DateTime.now()
                                  .difference(_questionProvider
                                      .listOfNotifications[index].timestamp)),
                            ),
                          ),
                          trailing: GestureDetector(
                            onTap: () async {
                              _isLoading = true;
                              setState(() {});
                              await _questionProvider
                                  .removeNotificationFromList(
                                      userId: _userProvider.user.id,
                                      notificationId: _questionProvider
                                          .listOfNotifications[index].id);
                              _isLoading = false;
                              setState(() {});
                            },
                            child: Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.redAccent,
                            ),
                          ),
                          onTap: () async {
                            {
                              _isLoading = true;
                              setState(() {});
                              await _questionProvider.getQuestion(
                                  questionId: _questionProvider
                                      .listOfNotifications[index].questionId);
                              _isLoading = false;
                              setState(() {});
                              if (_questionProvider.currentQuestion != null) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => QuestionDetailsPage(
                                        question: _questionProvider
                                            .currentQuestion!)));
                              }
                            }
                          },
                        ),
                      ],
                    );
                  },
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
        ));
  }
}
