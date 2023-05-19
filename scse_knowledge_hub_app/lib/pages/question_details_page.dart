import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scse_knowledge_hub_app/models/Question.dart';
import 'package:scse_knowledge_hub_app/providers/question_provider.dart';
import 'package:scse_knowledge_hub_app/utils/styles.dart';
import 'package:scse_knowledge_hub_app/widget/display_image_widget.dart';
import 'package:scse_knowledge_hub_app/widget/image_preview_box_widget.dart';
import 'package:scse_knowledge_hub_app/widget/no_glow_scroll.dart';
import 'package:scse_knowledge_hub_app/widget/open_images.dart';
import 'package:scse_knowledge_hub_app/widget/question_card_widget.dart';
import 'package:scse_knowledge_hub_app/widget/reply_card_widget.dart';

class QuestionDetailsPage extends StatefulWidget {
  final Question question;
  const QuestionDetailsPage({
    Key? key,
    required this.question,
  }) : super(key: key);

  @override
  State<QuestionDetailsPage> createState() => _QuestionDetailsPageState();
}

class _QuestionDetailsPageState extends State<QuestionDetailsPage> {
  late QuestionProvider _questionProvider;

  //! TEMP: Images
  List<String> listOfThumbnailUrls = [
    'http://images.saymedia-content.com/.image/c_limit%2Ccs_srgb%2Cq_auto:eco%2Cw_1190/MTc2Mjg1ODI0ODMxMjAyNDk0/why-every-teenage-girl-should-learn-how-to-code.webp',
    'http://www.idlewyldanalytics.com/docs/images/prog/example-code-C.png',
  ];

  @override
  Widget build(BuildContext context) {
    _questionProvider = Provider.of(context);
    return Scaffold(
      backgroundColor: Styles.primaryBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Styles.primaryBackgroundColor,
      ),
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: StretchingOverscrollIndicator(
          axisDirection: AxisDirection.down,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                questionDetails(),
                SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    "Replies (${widget.question.replies})",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 15),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: ReplyCard(),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget questionDetails() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(25),
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25))),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.question.user,
                style: TextStyle(
                    color: Colors.black,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    fontSize: 14)),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "1h ago",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
                Styles.bottomRowIcons(Icons.thumb_up_alt_rounded,
                    "${widget.question.likes} Likes"),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(widget.question.title,
                style: TextStyle(
                    color: Styles.titleDetailsTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
            SizedBox(
              height: 10,
            ),
            Text(
              widget.question.description,
              style: TextStyle(fontSize: 12),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: listOfThumbnailUrls.length,
                itemBuilder: (context, index) {
                  return ImagePreviewBoxWidget(
                    displayOnly: true,
                    image: DisplayImage(
                        imageUrl: listOfThumbnailUrls[index],
                        hasBorderRadius: true),
                    onTap: () {
                      OpenImages(
                              context: context,
                              index: index,
                              images: listOfThumbnailUrls)
                          .imageOpenTransition();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
