import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_painter/image_painter.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:provider/provider.dart';
import 'package:scse_knowledge_hub_app/providers/question_provider.dart';
import 'package:scse_knowledge_hub_app/utils/styles.dart';
import 'package:scse_knowledge_hub_app/widget/loading.dart';
import 'package:scse_knowledge_hub_app/widget/text_delegate.dart';

class ImagePainterPage extends StatefulWidget {
  final File imageFile;
  const ImagePainterPage({
    Key? key,
    required this.imageFile,
  }) : super(key: key);

  @override
  State<ImagePainterPage> createState() => _ImagePainterPageState();
}

class _ImagePainterPageState extends State<ImagePainterPage> {
  final _key = GlobalKey<ScaffoldState>();
  final _imagekey = GlobalKey<ImagePainterState>();
  late QuestionProvider _questionProvider;
  bool _isLoading = false;
  bool _isLandscape = false;

  @override
  void initState() {
    Future.microtask(() async {
      _isLandscape = await isLandscape(widget.imageFile);
      log('_isLandscape: $_isLandscape');
      setState(() {});
    });
    super.initState();
  }

  Future<bool> isLandscape(File imageFile) async {
    final Uint8List bytes = await imageFile.readAsBytes();
    final ui.Codec codec = await ui.instantiateImageCodec(bytes);
    final ui.Image image = (await codec.getNextFrame()).image;
    return image.width > image.height;
  }

  // Future<Uint8List> compressImage(Uint8List img) async {
  //   return await FlutterImageCompress.compressWithList(img,
  //       minHeight: _isLandscape ? 1500 : 2000,
  //       minWidth: _isLandscape ? 2000 : 1500,
  //       quality: 90);
  // }

  @override
  Widget build(BuildContext context) {
    _questionProvider = Provider.of(context);
    return Stack(
      children: [
        Scaffold(
            key: _key,
            backgroundColor: Colors.black,
            appBar: AppBar(
              title: Text(
                'Annotate',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              elevation: 0,
              backgroundColor: Styles.primaryBlueColor,
              actions: [
                Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    child: IconButton(
                      icon: Icon(
                        Icons.check_circle_outline_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        _isLoading = true;
                        setState(() {});

                        // Uint8List compressedAnnotatedImage =
                        //     await compressImage(
                        //         (await _imagekey.currentState!.exportImage())!);

                        _questionProvider.addAttachment(
                            (await _imagekey.currentState!.exportImage())!);

                        // Uint8List compressedOriginalImage = await compressImage(
                        //     widget.imageFile.readAsBytesSync());

                        //* Check Image Size Function
                        // Future<Size> getImageSize(Uint8List imageBytes) async {
                        //   final Completer<Size> completer = Completer();
                        //   final ui.Codec codec =
                        //       await ui.instantiateImageCodec(imageBytes);
                        //   codec.getNextFrame().then((frame) {
                        //     completer.complete(Size(frame.image.width.toDouble(),
                        //         frame.image.height.toDouble()));
                        //   });
                        //   return completer.future;
                        // }

                        // final Size imageSize =
                        //     await getImageSize(compressedAnnotatedImage);
                        // log('height: ${imageSize.height}');
                        // log('width: ${imageSize.width}');

                        // ServiceAppointment appointment =
                        //     _serviceAppointmentProvider
                        //         .currentServiceAppointment!;
                        // int timeNow = DateTime.now().millisecondsSinceEpoch;
                        // String oriName =
                        //     '${appointment.workOrder?.recordType?.replaceAll(' ', '_')}_${appointment.workOrder?.unit?.unitCode}_${appointment.workOrder?.workOrderNumber}_original_${_userId}_$timeNow.png';
                        // String paintedName =
                        //     '${appointment.workOrder?.recordType?.replaceAll(' ', '_')}_${appointment.workOrder?.unit?.unitCode}_${appointment.workOrder?.workOrderNumber}_annotated_${_userId}_$timeNow.png';
                        // log('ori: $oriName');
                        // log('painted: $paintedName');
                        // FileAsset oriImg = FileAsset(
                        //   fileID: timeNow.toString(),
                        //   fileRelativePath: _serviceAppointmentProvider
                        //           .currentServiceAppointment!
                        //           .workOrder!
                        //           .awsFolderPath! +
                        //       oriName,
                        //   fileType: 'Work Order Image',
                        //   fileKey: oriName,
                        //   fileContent: base64Encode(compressedOriginalImage),
                        // );
                        // FileAsset paintedImg = FileAsset(
                        //   fileID: timeNow.toString(),
                        //   fileRelativePath: _serviceAppointmentProvider
                        //           .currentServiceAppointment!
                        //           .workOrder!
                        //           .awsFolderPath! +
                        //       paintedName,
                        //   fileType: 'Work Order Image',
                        //   fileKey: paintedName,
                        //   fileContent: base64Encode(compressedAnnotatedImage),
                        // );
                        // _serviceAppointmentProvider.addFileAsset(
                        //   ori: oriImg,
                        //   painted: paintedImg,
                        // );

                        log('endDir');
                        _isLoading = false;
                        setState(() {});
                        Navigator.of(context).pop();
                      },
                    ))
              ],
              leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back_ios_new_rounded)),
            ),
            body: ImagePainter.file(
              widget.imageFile,
              key: _imagekey,
              scalable: true,
              initialStrokeWidth: 6,
              textDelegate: PainterTextDelegate(),
              controlsAtTop: false,
              clearAllIcon: Icon(Icons.cancel_outlined),
              colorIcon: Icon(
                Icons.colorize_rounded,
              ),
            )),
        if (_isLoading) Loading()
      ],
    );
  }
}
