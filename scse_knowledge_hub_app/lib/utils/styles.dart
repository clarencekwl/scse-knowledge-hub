import 'package:flutter/material.dart';

// primaryColor = #9b51e0 rgb(155,81,224)

class Styles {
  //* SCSE Knowledge Hub Styles
  static Color primaryBlueColor = Color.fromRGBO(30, 90, 162, 1);
  static Color primaryLightBlueColor = Color.fromRGBO(86, 155, 219, 1);
  static Color primaryBackgroundColor = const Color.fromRGBO(239, 242, 247, 1);
  static Color primaryGreyColor = const Color.fromRGBO(58, 66, 86, 1.0);
  static Color titleTextColor = Color.fromRGBO(48, 121, 210, 1);
  static Color titleDetailsTextColor = Color.fromRGBO(48, 81, 210, 1);
  static List<String> listOfTopics = [
    "Algorithms",
    "Artificial Intelligence",
    "Coding Challenges",
    "Cyber Security",
    "Data Analytics",
    "Database Management",
    "Data Science",
    "Hardware",
    "Internships/Jobs",
    "Machine Learning",
    "Networking",
    "Object-Oriented Programming",
    "Software Development",
    "Others",
  ];

  static Row bottomRowIcons(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey,
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          text,
          style: TextStyle(color: Colors.grey, fontSize: 10),
        )
      ],
    );
  }

  static TextStyle titleTextStyle = TextStyle(
    color: Styles.primaryBlueColor,
    fontWeight: FontWeight.bold,
    fontSize: 18,
  );

  static InputDecoration inputTextFieldStyle(String hintText) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white.withOpacity(0.7),
      errorStyle: const TextStyle(height: 0, fontSize: 12),
      // hintText: hintText,
      // hintStyle: TextStyle(fontSize: 14),
      isDense: true,
      // contentPadding: EdgeInsets.symmetric(vertical: 1),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: Colors.red.shade400),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: Colors.red.shade400),
        borderRadius: BorderRadius.circular(15),
      ),

      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: Styles.primaryBlueColor),
        borderRadius: BorderRadius.circular(15),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey, width: 1.2),
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }

  static Size screenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  static double statusBarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  static double kScreenHeight(BuildContext context,
      {double percentage = 1, double reducedBy = 0.0}) {
    return (screenSize(context).height - reducedBy) * percentage;
  }

  static double kScreenWidth(BuildContext context,
      {double percentage = 1, double reducedBy = 0.0}) {
    return (screenSize(context).width - reducedBy) * percentage;
  }

  static InputDecoration input = InputDecoration(
    fillColor: Colors.white,
    focusColor: Colors.grey[900],
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.blue,
        width: 2.0,
      ),
    ),
    border: OutlineInputBorder(
      gapPadding: 1.0,
      borderSide: BorderSide(
        color: Colors.grey[600]!,
        width: 1.0,
      ),
    ),
    hintStyle: TextStyle(
      color: Colors.grey[600],
    ),
  );

  static String formatTimeDifference(Duration difference) {
    if (difference.inMinutes < 2) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inDays < 365) {
      int months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      int years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }
}
