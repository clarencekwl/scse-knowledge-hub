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
                        'assets/images/question_success_image.jpg',
                        height: Styles.kScreenHeight(context) * 0.42,
                        width: Styles.kScreenHeight(context) * 0.4,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Question Posted!",
                        style: TextStyle(
                          color: Styles.primaryBlueColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                        ),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 30),
                        child: Text(
                          "Congratulations! Your question has been successfully posted. Now, embark on a rewarding learning journey!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color:
                                Colors.grey, // Adjust color to your preference
                            fontSize: 15,
                          ),
                        ),
                      ),
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
