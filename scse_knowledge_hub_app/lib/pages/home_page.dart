import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:scse_knowledge_hub_app/utils/styles.dart';
import 'package:scse_knowledge_hub_app/widget/nav_bar_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
              backgroundColor: Styles.primaryGreyColor,
              expandedHeight: Styles.kScreenHeight(context) * 0.15,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(bottom: 20, left: 25),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Hi, Clarence",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
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
                      top: 50,
                      right: 20,
                      child: InkWell(
                          onTap: () {
                            // TODO: on tap profile icon
                          },
                          child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Styles.primaryGreyColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20))),
                              onPressed: () => null,
                              icon: Icon(Icons.add),
                              label: Text("Ask"))),
                    )
                  ],
                ),
              )),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, int index) {
                return ListTile(
                  leading: Container(
                      padding: EdgeInsets.all(8),
                      width: 100,
                      child: Placeholder()),
                  title: Text('Place ${index + 1}', textScaleFactor: 2),
                );
              },
              childCount: 20,
            ),
          ),
        ],
      ),
    );
  }
}
