import 'package:flutter/material.dart';

// primaryColor = #9b51e0 rgb(155,81,224)

class Styles {
  //* SCSE Knowledge Hub Styles
  static Color primaryBackgroundColor = const Color.fromRGBO(239, 242, 247, 1);
  static Color primaryGreyColor = const Color.fromRGBO(58, 66, 86, 1.0);
  static Color titleTextColor = Color.fromRGBO(48, 121, 210, 1);
  static Color titleDetailsTextColor = Color.fromRGBO(48, 81, 210, 1);
  static Color primaryBlueColor = Color.fromRGBO(30, 90, 162, 1);

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

  //* Pixium Boilerplate Styles
  static Color pixiumPurpleColor = Color.fromRGBO(108, 79, 240, 1);
  static Color pixiumRedColor = Color.fromRGBO(219, 56, 50, 1);
  static Color? appAccentColor = Colors.cyan[600];
  static Color appCanvasColor = Colors.white;
  static Color appBackground = Colors.blue;
  static Color? commonDarkBackground = Colors.grey[200];
  static Color? commonDarkCardBackground = Colors.grey[200]; // #1e2d3b

  static Size screenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  static double kScreenHeight(BuildContext context,
      {double percentage = 1, double reducedBy = 0.0}) {
    return (screenSize(context).height - reducedBy) * percentage;
  }

  static double kScreenWidth(BuildContext context,
      {double percentage = 1, double reducedBy = 0.0}) {
    return (screenSize(context).width - reducedBy) * percentage;
  }

  static Color? appDrawerIconColor = Colors.grey[800];
  static TextStyle appDrawerTextStyle = TextStyle(color: Colors.grey[900]);

  static TextStyle defaultStyle = TextStyle(
    color: Colors.grey[800],
  );

  static TextStyle h1 = defaultStyle.copyWith(
    fontWeight: FontWeight.w700,
    fontSize: 18.0,
    height: 22 / 18,
    color: Colors.grey[700],
  );

  static TextStyle h1AppName = defaultStyle.copyWith(
    fontSize: 30.0,
    height: 35,
    fontFamily: 'Prata',
  );

  static TextStyle title = defaultStyle.copyWith(
    fontSize: 30.0,
    height: 35,
    fontFamily: 'Prata',
  );

  static TextStyle display1 = defaultStyle.copyWith(
    fontSize: 30.0,
    fontFamily: 'Radicals',
  );

  static TextStyle h1White = defaultStyle.copyWith(
    fontWeight: FontWeight.w700,
    fontSize: 18.0,
    height: 22 / 18,
    color: Colors.white,
  );

  static TextStyle p = defaultStyle.copyWith(
    fontSize: 16.0,
    color: Colors.grey[800],
  );

  static TextStyle pTheme = p.copyWith(
    color: pixiumPurpleColor,
  );

  static TextStyle pWhite = p.copyWith(
    color: Colors.white,
  );

  static TextStyle pMuted = p.copyWith(
    color: Colors.grey[500],
  );

  static TextStyle pForgotPassword = p.copyWith(
    color: Colors.blue,
  );

  static TextStyle pButton = defaultStyle.copyWith(
    fontSize: 15.0,
  );

  static TextStyle error = defaultStyle.copyWith(
    fontWeight: FontWeight.w500,
    fontSize: 14.0,
    color: Colors.red,
  );

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

  // static int redColor = 0xffff2d55;
  static Color tipColor = Color.fromRGBO(255, 226, 108, 1);
  static Color matchWonCardSideColor = Color.fromRGBO(22, 160, 133, 1);
  static Color matchLostCardSideColor = Color.fromRGBO(211, 84, 0, 1);
  static Color? vipCardBgColor = Colors.orange[100];
}
