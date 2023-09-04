import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:scse_knowledge_hub_app/providers/question_provider.dart';
import 'package:scse_knowledge_hub_app/utils/styles.dart';
import 'package:scse_knowledge_hub_app/widget/default_button.dart';
import 'package:scse_knowledge_hub_app/widget/image_painter_page.dart';
import 'package:scse_knowledge_hub_app/widget/image_preview_box_widget.dart';
import 'package:scse_knowledge_hub_app/widget/no_glow_scroll.dart';
import 'package:scse_knowledge_hub_app/widget/open_images.dart';
import 'package:scse_knowledge_hub_app/widget/warning_dialog_widget.dart';

class CreateQuestionPage extends StatefulWidget {
  const CreateQuestionPage({super.key});

  @override
  State<CreateQuestionPage> createState() => _CreateQuestionPageState();
}

class _CreateQuestionPageState extends State<CreateQuestionPage> {
  late QuestionProvider _questionProvider;
  final TextEditingController _titleTextController = TextEditingController();
  final TextEditingController _descriptionTextController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isFormValid = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _titleTextController.dispose();
    _descriptionTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _questionProvider = Provider.of(context);
    return Scaffold(
        backgroundColor: Styles.primaryBackgroundColor,
        appBar: AppBar(
          title: Text(
            "Ask a Question!",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Styles.primaryBlueColor,
        ),
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Column(
            children: [
              Expanded(child: createQuestionForm()),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: DefaultButton(
                    title: "Submit",
                    onPressed: (() async {
                      if (_formKey.currentState!.validate()) {
                        _questionProvider.removeAllAttachments();
                        _questionProvider.clearImageCache();
                        // Navigator.pop(context);
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => CaseSuccessPage()),
                        // );
                      }
                    }),
                    icon: _isFormValid ? Icons.check : null,
                    textColour: Colors.white,
                    buttonColor:
                        _isFormValid ? Styles.primaryBlueColor : Colors.grey),
              )
            ],
          ),
        ));
  }

  InkWell attachmentSelection(BuildContext context,
      {required bool fromCamera}) {
    return InkWell(
        onTap: () async {
          File? imageFile = await getImage(fromCamera);

          if (null != imageFile) {
            Navigator.of(context)
                .push(MaterialPageRoute(
              builder: (context) => ImagePainterPage(
                imageFile: imageFile,
              ),
            ))
                .then((value) async {
              await imageFile.delete(recursive: true);
              Navigator.pop(context);
            });
            FocusScope.of(context).unfocus();
          } else {
            log('failed');
          }
        },
        child: true == fromCamera
            ? ListTile(
                leading: Icon(Icons.camera_alt_outlined,
                    color: Styles.primaryBlueColor),
                title: const Text("Take from Camera"),
              )
            : ListTile(
                leading: Icon(
                  Icons.image_outlined,
                  color: Styles.primaryBlueColor,
                ),
                title: const Text("Choose from Gallery"),
              ));
  }

  Future<File?> getImage(bool fromCamera) async {
    try {
      XFile? image = await ImagePicker().pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      );
      if (image == null) return null;
      return File(image.path);
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Widget userInputField(String title, {required isDescriptionField}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Styles.primaryGreyColor),
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          style: TextStyle(),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          maxLines: isDescriptionField ? null : 1,
          minLines: isDescriptionField ? 10 : 1,
          validator: (value) {
            if (value!.isEmpty) {
              return "Please enter text";
            }
            return null;
          },
          controller: isDescriptionField
              ? _descriptionTextController
              : _titleTextController,
          decoration: Styles.inputTextFieldStyle("Enter $title"),
        ),
        SizedBox(
          height: 18,
        ),
      ],
    );
  }

  Widget createQuestionForm() {
    return Form(
      key: _formKey,
      onChanged: () {
        if (_titleTextController.text.isNotEmpty &&
            _descriptionTextController.text.isNotEmpty) {
          _isFormValid = true;
        } else {
          _isFormValid = false;
        }
        setState(() {});
      },
      child: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: StretchingOverscrollIndicator(
          axisDirection: AxisDirection.down,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TASK TITLE
                userInputField("Title", isDescriptionField: false),
                userInputField("Description", isDescriptionField: true),
                Row(
                  children: [
                    Text("Attachments",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Styles.primaryGreyColor)),
                    SizedBox(width: 5),
                    Icon(Icons.attachment_outlined)
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                // ATTACHMENT FIELD
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        height: 80,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                _questionProvider.listOfAttachments.length + 1,
                            itemBuilder: (context, index) {
                              if (index == 0 ||
                                  _questionProvider.listOfAttachments.isEmpty) {
                                return ImagePreviewBoxWidget(
                                  displayOnly: false,
                                  onTap: () async {
                                    return showModalBottomSheet(
                                        context: context,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(25),
                                                topRight: Radius.circular(25))),
                                        builder: ((context) => SafeArea(
                                              child: Container(
                                                  height: 150,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10),
                                                  child: Column(
                                                    children: [
                                                      attachmentSelection(
                                                          context,
                                                          fromCamera: false),
                                                      const Divider(),
                                                      attachmentSelection(
                                                          context,
                                                          fromCamera: true)
                                                    ],
                                                  )),
                                            )));
                                  },
                                );
                              }
                              return ImagePreviewBoxWidget(
                                displayOnly: false,
                                image: Image.memory(
                                  _questionProvider
                                      .listOfAttachments[index - 1],
                                  fit: BoxFit.cover,
                                ),
                                onRemove: () async {
                                  FocusScope.of(context).unfocus();
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return WarningDialogWidget(
                                          content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: const [
                                                Text(
                                                    'Image will be removed permanently',
                                                    textAlign:
                                                        TextAlign.center),
                                                Text('Are you sure?',
                                                    textAlign:
                                                        TextAlign.center),
                                              ]),
                                          onConfirm: () {
                                            _questionProvider.listOfAttachments
                                                .clear();
                                            _questionProvider.clearImageCache();
                                            Navigator.of(context).pop();
                                            setState(() {});
                                          },
                                          onCancel: () {
                                            Navigator.of(context).pop();
                                          },
                                        );
                                      });
                                },
                                onTap: () {
                                  OpenImages(
                                          context: context,
                                          index: index,
                                          images: _questionProvider
                                              .listOfAttachments)
                                      .imageOpenTransition();
                                },
                              );
                            })),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
