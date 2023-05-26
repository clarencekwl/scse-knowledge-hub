import 'package:flutter/material.dart';
import 'package:scse_knowledge_hub_app/utils/styles.dart';

class DefaultButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final Color color;
  final IconData? icon;

  DefaultButton(
      {required this.title,
      required this.onPressed,
      required this.color,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 50,
        width: Styles.kScreenWidth(context) * 0.9,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              backgroundColor: color,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8))),
          child: icon == null
              ? Text(
                  title,
                  style: TextStyle(
                      color: Colors.white,
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
