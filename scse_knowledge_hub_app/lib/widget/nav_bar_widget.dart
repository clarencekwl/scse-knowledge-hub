import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:scse_knowledge_hub_app/pages/home_page.dart';
import 'package:scse_knowledge_hub_app/utils/styles.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: Styles.kScreenWidth(context) * 0.6,
      backgroundColor: Styles.primaryGreyColor,
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text("Clarence",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20)),
            accountEmail: Text('example@gmail.com',
                style: TextStyle(color: Colors.white)),
            currentAccountPicture: CircleAvatar(
              radius: 25,
              backgroundColor: Styles.primaryGreyColor,
              child: const Icon(
                Icons.person_rounded,
                size: 30,
                color: Colors.white,
              ),
            ),
            decoration: BoxDecoration(
              color: Styles.primaryGreyColor,
            ),
          ),
          drawerList(
            Icons.home,
            "Home",
            () {
              log("pressed home");
              Navigator.popUntil(
                context,
                ModalRoute.withName(Navigator.defaultRouteName),
              );
            },
          ),
          drawerList(
              Icons.question_answer_rounded, "Your Questions", () => null),
          drawerList(Icons.check_rounded, "Questions answered", () => null),
        ],
      ),
    );
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
        onTap: onTap);
  }
}
