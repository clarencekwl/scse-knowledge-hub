import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:scse_knowledge_hub_app/utils/styles.dart';
import 'package:scse_knowledge_hub_app/widget/loading.dart';
import 'package:scse_knowledge_hub_app/widget/no_glow_scroll.dart';

class GalleryPhotoViewWrapper extends StatefulWidget {
  GalleryPhotoViewWrapper({
    this.loadingBuilder,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.initialIndex = 0,
    required this.galleryItems,
    this.scrollDirection = Axis.horizontal,
    // this.isMemory = false,
  }) : pageController = PageController(initialPage: initialIndex);

  final LoadingBuilder? loadingBuilder;
  final BoxDecoration? backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  final List galleryItems;
  // final bool? isMemory;
  final Axis scrollDirection;

  @override
  State<StatefulWidget> createState() {
    return _GalleryPhotoViewWrapperState();
  }
}

class _GalleryPhotoViewWrapperState extends State<GalleryPhotoViewWrapper> {
  late int currentIndex = widget.initialIndex;

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: const Key('key'),
      direction: DismissDirection.vertical,
      onDismissed: (_) => Navigator.of(context).pop(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.black.withOpacity(0.1),
          actions: [
            if (widget.galleryItems.length > 1)
              Container(
                margin: const EdgeInsets.only(right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _numberIndicators(widget.galleryItems.length, currentIndex)
                  ],
                ),
              )
          ],
          // iconTheme: IconThemeData(color: Styles.kPrimaryBlueColor),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Container(
          decoration: widget.backgroundDecoration,
          constraints:
              BoxConstraints.expand(height: Styles.kScreenHeight(context)),
          child: ScrollConfiguration(
            behavior: NoGlowScrollBehavior(),
            child: StretchingOverscrollIndicator(
              axisDirection: AxisDirection.right,
              child: PhotoViewGallery.builder(
                scrollPhysics: AlwaysScrollableScrollPhysics(),
                builder: ((context, index) {
                  // final BasicImage item = widget.galleryItems[index];
                  var item = widget.galleryItems[index];
                  return PhotoViewGalleryPageOptions.customChild(
                    initialScale: PhotoViewComputedScale.contained,
                    minScale:
                        // PhotoViewComputedScale.contained * (0.5 + index / 10),
                        PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.covered * 4.1,
                    heroAttributes: PhotoViewHeroAttributes(tag: item),
                    child: widget.galleryItems[index].runtimeType == String
                        ? Image.network(
                            item,
                            fit: BoxFit.contain,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (null == loadingProgress) {
                                return child;
                              } else {
                                return Center(
                                    child: Loading(
                                  height: 30,
                                  width: 30,
                                  size: 30,
                                  backgroundColor: Colors.transparent,
                                  iconColor: Colors.grey[400],
                                ));
                              }
                            },
                          )
                        : Image.memory(
                            item,
                            fit: BoxFit.contain,
                          ),
                    // child: widget.isMemory!
                    //     ? CachedMemoryImage(
                    //         uniqueKey: item.fileContent,
                    //         base64: item.fileContent,
                    //         gaplessPlayback: true,
                    //         placeholder: Center(
                    //           child: Loading(
                    //             height: 30,
                    //             width: 30,
                    //             size: 30,
                    //             backgroundColor: Colors.transparent,
                    //           ),
                    //         ),
                    //         errorBuilder: (context, error, stackTrace) => Icon(
                    //           Icons.error,
                    //           color: Colors.white,
                    //         ),
                    //       )
                    //     : CachedNetworkImage(
                    //         imageUrl: item, //! URL String
                    //         errorWidget: (context, url, error) => Icon(
                    //           Icons.error,
                    //           color: Colors.white,
                    //         ),
                    //         placeholder: (context, url) => Center(
                    //           child: Loading(
                    //             height: 30,
                    //             width: 30,
                    //             size: 30,
                    //             backgroundColor: Colors.transparent,
                    //           ),
                    //         ),
                    //       ),
                  );
                }),
                itemCount: widget.galleryItems.length,
                loadingBuilder: widget.loadingBuilder,
                backgroundDecoration: widget.backgroundDecoration,
                pageController: widget.pageController,
                onPageChanged: onPageChanged,
                scrollDirection: widget.scrollDirection,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _numberIndicators(int length, int currentIndex) {
    return Container(
      padding: const EdgeInsets.all(5),
      width: 40,
      height: 26,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey.withOpacity(0.5)),
      child: Text(
        "${currentIndex + 1}/${length}",
        style: TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }
}
