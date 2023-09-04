import 'package:flutter/material.dart';
import 'package:scse_knowledge_hub_app/utils/styles.dart';

class DefaultButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final Color buttonColor;
  final Color textColour;
  final IconData? icon;

  const DefaultButton(
      {required this.title,
      required this.onPressed,
      required this.buttonColor,
      required this.textColour,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 50,
        width: Styles.kScreenWidth(context) * 0.9,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8))),
          child: icon == null
              ? Text(
                  title,
                  style: TextStyle(
                      color: textColour,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      title,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    )
                  ],
                ),
        ));
  }
}
