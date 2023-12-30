import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scse_knowledge_hub_app/pages/home_page.dart';
import 'package:scse_knowledge_hub_app/pages/profile_page.dart';
import 'package:scse_knowledge_hub_app/pages/user_replied_question_page.dart';
import 'package:scse_knowledge_hub_app/providers/question_provider.dart';
import 'package:scse_knowledge_hub_app/providers/user_provider.dart';
import 'package:scse_knowledge_hub_app/utils/styles.dart';
import 'package:scse_knowledge_hub_app/widget/no_glow_scroll.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  late UserProvider _userProvider;
  late QuestionProvider _questionProvider;
  List<String> _tempSelectedTopics = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      _tempSelectedTopics = _questionProvider.selectedTopics;
    });
  }

  @override
  Widget build(BuildContext context) {
    _userProvider = Provider.of(context);
    _questionProvider = Provider.of(context);
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      width: Styles.kScreenWidth(context) * 0.8,
      backgroundColor: Styles.primaryGreyColor,
      child: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: StretchingOverscrollIndicator(
          axisDirection: AxisDirection.down,
          child: SingleChildScrollView(
            child: Column(
              children: [
                UserAccountsDrawerHeader(
                  margin:
                      EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 30),
                  accountName: Text(
                    _userProvider.user.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  accountEmail: Text(_userProvider.user.email,
                      style: TextStyle(color: Colors.white)),
                  currentAccountPicture: GestureDetector(
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: Styles.primaryGreyColor,
                      child: const Icon(
                        Icons.person_rounded,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => ProfilePage()),
                      );
                    },
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(20)),
                  ),
                ),
                drawerList(
                  Icons.home,
                  "Home",
                  () {
                    log("pressed home");
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                ),
                drawerList(Icons.thumb_up_sharp, "Liked Questions", () => null),
                drawerList(Icons.check_rounded, "Questions answered", () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => UserRepliedQuestionPage(),
                    ),
                  );
                }),
                // Use ExpansionTile for the dropdown menu
                ExpansionTile(
                  collapsedIconColor: Colors.white,
                  iconColor: Colors.white,
                  leading: Icon(
                    Icons.filter_list,
                    color: Colors.white,
                  ),
                  title: Text(
                    "View by Topics",
                    style: TextStyle(color: Colors.white),
                  ),
                  children: [
                    // Filter button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_tempSelectedTopics.isNotEmpty)
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueGrey,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15))),
                            onPressed: () {
                              log('Selected topics: $_tempSelectedTopics');
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => HomePage(
                                        selectedTopics:
                                            _tempSelectedTopics.isEmpty
                                                ? null
                                                : _tempSelectedTopics)),
                              );
                            },
                            child: Text("Filter"),
                          ),
                        if (_questionProvider.selectedTopics.isNotEmpty)
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueGrey,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15))),
                              onPressed: () {
                                _tempSelectedTopics = [];
                                _questionProvider.selectedTopics = [];
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => HomePage()),
                                );
                              },
                              child: Text("Clear"),
                            ),
                          ),
                      ],
                    ),

                    Divider(color: Colors.white),

                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: Styles.listOfTopics.length,
                      itemBuilder: (context, index) {
                        final topic = Styles.listOfTopics[index];
                        return CheckboxListTile(
                          title: Text(
                            topic,
                            style: TextStyle(color: Colors.white),
                          ),
                          value:
                              _questionProvider.selectedTopics.contains(topic),
                          onChanged: (value) {
                            if (value != null) {
                              if (value) {
                                _tempSelectedTopics.add(topic);
                              } else {
                                _tempSelectedTopics.remove(topic);
                              }
                            }
                            setState(() {});
                          },
                          activeColor: Colors.blueGrey,
                          tileColor:
                              _questionProvider.selectedTopics.contains(topic)
                                  ? Colors.blueGrey.withOpacity(0.3)
                                  : null,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

ListTile drawerList(IconData icon, String title, Function()? onTap) {
  return ListTile(
    leading: Icon(
      icon,
      color: Colors.white,
    ),
    title: Text(
      title,
      style: const TextStyle(color: Colors.white),
    ),
    onTap: onTap,
  );
}
