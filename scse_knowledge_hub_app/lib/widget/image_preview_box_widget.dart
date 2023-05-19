import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:scse_knowledge_hub_app/utils/styles.dart';

class ImagePreviewBoxWidget extends StatelessWidget {
  final Widget? image;
  final Color? borderColor;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;
  final bool displayOnly;
  const ImagePreviewBoxWidget({
    this.image,
    this.borderColor,
    this.onTap,
    this.onRemove,
    required this.displayOnly,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 75,
          width: 75,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: Center(
            child: Stack(
              children: [
                Positioned(
                  bottom: 0,
                  child: InkWell(
                    onTap: onTap ??
                        () {
                          log('open image!');
                        },
                    child: Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: borderColor ?? Styles.primaryBlueColor),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: image ??
                            Icon(
                              Icons.add_a_photo_rounded,
                              size: 36,
                              color: Styles.primaryBlueColor,
                            ),
                      ),
                    ),
                  ),
                ),
                if (null != image && false == displayOnly)
                  Positioned(
                      right: 0,
                      top: 0,
                      child: InkWell(
                        onTap: onRemove ??
                            () {
                              log('remove image!');
                            },
                        child: Container(
                          height: 25,
                          width: 25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.red,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      )),
              ],
            ),
          ),
        ),
        SizedBox(width: 10),
      ],
    );
  }
}
