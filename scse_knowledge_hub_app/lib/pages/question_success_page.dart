import 'package:flutter/material.dart';
import 'package:scse_knowledge_hub_app/utils/styles.dart';
import 'package:scse_knowledge_hub_app/widget/default_button.dart';

class QuestionSuccessPage extends StatefulWidget {
  const QuestionSuccessPage({Key? key}) : super(key: key);

  @override
  State<QuestionSuccessPage> createState() => _QuestionSuccessPageState();
}

class _QuestionSuccessPageState extends State<QuestionSuccessPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
                Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Image.asset(
                        'assets/images/question_success_image.png',
                        height: Styles.kScreenHeight(context) * 0.42,
                        width: Styles.kScreenHeight(context) * 0.4,
                      ),
                      SizedBox(height: 10),
                      Text("Question sent!", style: Styles.titleTextStyle),
                      SizedBox(height: 15),
                      Text("Congratulations")
                    ],
                  ),
                ),
                DefaultButton(
                    title: "Done",
                    onPressed: (() {
                      Navigator.pop(context);
                    }),
                    textColour: Colors.white,
                    buttonColor: Styles.primaryBlueColor),
                SizedBox(
                  height: 30,
                )
              ],
            )));
  }
}
