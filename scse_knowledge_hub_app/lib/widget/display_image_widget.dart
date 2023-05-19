import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:scse_knowledge_hub_app/widget/loading.dart';

class DisplayImage extends StatefulWidget {
  final String imageUrl;
  final bool hasBorderRadius;
  const DisplayImage(
      {required this.imageUrl, required this.hasBorderRadius, Key? key})
      : super(key: key);

  @override
  State<DisplayImage> createState() => _DisplayImage();
}

class _DisplayImage extends State<DisplayImage> {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: widget.imageUrl,
      imageBuilder: (context, imageProvider) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: true == widget.hasBorderRadius
                ? BorderRadius.circular(12)
                : null,
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
      errorWidget: (context, url, error) {
        return Icon(Icons.error);
      },
      placeholder: (context, url) {
        return Center(
          child: Loading(
            height: 30,
            width: 30,
            size: 30,
            backgroundColor: Colors.transparent,
            iconColor: Colors.grey[400],
          ),
        );
      },
    );
  }
}
