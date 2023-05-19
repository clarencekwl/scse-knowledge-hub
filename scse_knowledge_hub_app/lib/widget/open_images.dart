import 'package:flutter/material.dart';
import 'package:scse_knowledge_hub_app/widget/gallery_photo_view_wrapper_widget.dart';

class OpenImages {
  BuildContext context;
  int index;
  List images;

  OpenImages(
      {required this.context, required this.index, required this.images});

  imageOpenTransition() {
    showGeneralDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position:
              Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
      pageBuilder: (context, anim1, anim2) {
        return GalleryPhotoViewWrapper(
          galleryItems: images,
          // isMemory: true,
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          initialIndex: index,
          scrollDirection: Axis.horizontal,
        );
      },
    );
    FocusScope.of(context).unfocus();
  }
  // void open(BuildContext context, int index, List images) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => GalleryPhotoViewWrapper(
  //         galleryItems: images,
  //         // isMemory: true,
  //         backgroundDecoration: const BoxDecoration(
  //           color: Colors.black,
  //         ),
  //         initialIndex: index,
  //         scrollDirection: Axis.horizontal,
  //       ),
  //     ),
  //   );
  // }
}
