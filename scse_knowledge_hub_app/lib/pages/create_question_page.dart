import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:scse_knowledge_hub_app/pages/question_success_page.dart';
import 'package:scse_knowledge_hub_app/providers/question_provider.dart';
import 'package:scse_knowledge_hub_app/providers/user_provider.dart';
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
  late UserProvider _userProvider;
  final TextEditingController _titleTextController = TextEditingController();
  final TextEditingController _descriptionTextController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isFormValid = false;
  bool _isLoading = false;
  bool _isAnonymous = false;
  late String _selectedTopic;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      log("user is: ${_userProvider.user.id}");
    });
  }

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
    _userProvider = Provider.of(context);
    return Scaffold(
        backgroundColor: Styles.primaryBackgroundColor,
        appBar: AppBar(
          title: Text(
            "Ask a Question!",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
              onPressed: (() async {
                _questionProvider.removeAllAttachments();
                await _questionProvider.clearImageCache();
                Navigator.of(context).pop();
              }),
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              )),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Styles.primaryBlueColor,
        ),
        body: Stack(
          children: [
            GestureDetector(
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
                    padding: const EdgeInsets.only(bottom: 20),
                    child: DefaultButton(
                        title: "Submit",
                        onPressed: (() async {
                          if (_formKey.currentState!.validate()) {
                            _isLoading = true;
                            setState(() {});
                            await _questionProvider.createQuestion(
                                title: _titleTextController.text,
                                description: _descriptionTextController.text,
                                userID: _userProvider.user.id,
                                anonymous: _isAnonymous,
                                topic: _selectedTopic);
                            _questionProvider.removeAllAttachments();
                            await _questionProvider.clearImageCache();
                            _isLoading = false;
                            setState(() {});
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => QuestionSuccessPage()),
                            );
                          }
                        }),
                        icon: _isFormValid ? Icons.check : null,
                        textColour: Colors.white,
                        buttonColor: _isFormValid
                            ? Styles.primaryBlueColor
                            : Colors.grey),
                  )
                ],
              ),
            ),
            if (_isLoading)
              Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.black.withOpacity(0.3),
                  child: Center(
                    child: SizedBox(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator(
                            color: Styles.primaryBlueColor)),
                  ))
          ],
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
        if (!isDescriptionField)
          Row(
            children: [
              Expanded(
                child: Text(
                  "(Include course code if applicable)",
                  style:
                      TextStyle(fontSize: 12, color: Styles.primaryGreyColor),
                ),
              ),
              Tooltip(
                margin: EdgeInsets.symmetric(horizontal: 15),
                message:
                    "Including course code helps to make your question more noticiable and relevant to users!",
                triggerMode: TooltipTriggerMode.tap,
                child: Icon(Icons.info_outline_rounded),
                showDuration: Duration(
                  seconds: 3,
                ),
                preferBelow: false,
              )
            ],
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
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Topic",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Styles.primaryGreyColor,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          DropdownButtonFormField<String>(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please select a topic";
                              }
                              return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            value: null,
                            hint: Text("Select a Topic..."),
                            onChanged: (value) {
                              _selectedTopic = value!;
                              log("selected topic is: $_selectedTopic");
                            },
                            items: Styles.listOfTopics.map((String topic) {
                              return DropdownMenuItem<String>(
                                value: topic,
                                child: Text(topic),
                              );
                            }).toList(),
                            decoration:
                                Styles.inputTextFieldStyle("Select Topic"),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: userInputField("Title", isDescriptionField: false),
                    ),
                  ],
                ),
                userInputField("Description", isDescriptionField: true),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Text("Attachments",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Styles.primaryGreyColor)),
                          SizedBox(width: 5),
                          Icon(Icons.attachment_outlined),
                        ],
                      ),
                    ),
                    Text("Post Anonymously",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Styles.primaryGreyColor)),
                    Switch(
                      activeTrackColor: Styles.primaryBlueColor,
                      activeColor: Styles.primaryLightBlueColor,
                      thumbIcon: thumbIcon,
                      value: _isAnonymous,
                      onChanged: (value) async {
                        _isAnonymous = value;
                        setState(() {});
                      },
                    )
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
                        child: _questionProvider.listOfAttachments.length != 3
                            ? ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    _questionProvider.listOfAttachments.length +
                                        1,
                                itemBuilder: (context, index) {
                                  if (index == 0 ||
                                      _questionProvider
                                          .listOfAttachments.isEmpty) {
                                    return ImagePreviewBoxWidget(
                                      displayOnly: false,
                                      onTap: () async {
                                        return showModalBottomSheet(
                                            context: context,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(25),
                                                    topRight:
                                                        Radius.circular(25))),
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
                                                              fromCamera:
                                                                  false),
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
                                                  mainAxisSize:
                                                      MainAxisSize.min,
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
                                                _questionProvider
                                                    .removeAttachment(
                                                        index - 1);

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
                                })
                            : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    _questionProvider.listOfAttachments.length,
                                itemBuilder: (context, index) {
                                  return ImagePreviewBoxWidget(
                                    displayOnly: false,
                                    image: Image.memory(
                                      _questionProvider
                                          .listOfAttachments[index],
                                      fit: BoxFit.cover,
                                    ),
                                    onRemove: () async {
                                      FocusScope.of(context).unfocus();
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return WarningDialogWidget(
                                              content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
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
                                                _questionProvider
                                                    .removeAttachment(index);
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

  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      // Thumb icon when the switch is selected.
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );
}
