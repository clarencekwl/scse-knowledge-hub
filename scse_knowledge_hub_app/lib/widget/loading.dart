import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  final double? size;
  final double? height;
  final double? width;
  final Color? backgroundColor;
  final Color? iconColor;

  Loading({
    this.height,
    this.width,
    this.size,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? double.infinity,
      width: width ?? double.infinity,
      color: backgroundColor ?? Colors.black.withOpacity(0.3),
      child: SpinKitCircle(
        color: iconColor ?? Colors.white70,
        size: size ?? 50.0,
      ),
    );
  }
}
