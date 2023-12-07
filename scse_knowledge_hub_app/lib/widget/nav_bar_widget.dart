import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:scse_knowledge_hub_app/pages/home_page.dart';
import 'package:scse_knowledge_hub_app/utils/styles.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      width: Styles.kScreenWidth(context) * 0.8,
      backgroundColor: Styles.primaryGreyColor,
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            margin: EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 30),
            accountName: Text("Clarence",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20)),
            accountEmail: Text('clarencekway@gmail.com',
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
                color: Colors.grey.withOpacity(0.1),
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(20))),
          ),
          drawerList(
            Icons.home,
            "Home",
            () {
              log("pressed home");
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => HomePage()));
            },
          ),
          drawerList(Icons.thumb_up_sharp, "Liked Questions", () => null),
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
