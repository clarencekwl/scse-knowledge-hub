import 'package:flutter/material.dart';
import 'package:scse_knowledge_hub_app/models/Question.dart';
import 'package:scse_knowledge_hub_app/utils/styles.dart';

class QuestionCard extends StatefulWidget {
  final Question question;
  final VoidCallback? onTap;
  const QuestionCard({
    Key? key,
    required this.question,
    this.onTap,
  }) : super(key: key);
  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 175,
      // width: Styles.kScreenWidth(context) * 0.9,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: widget.onTap,
          child: cardDetails(),
        ),
      ),
    );
  }

  Widget cardDetails() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.question.title,
              style: TextStyle(
                  color: Styles.titleTextColor,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Text(
                  widget.question.user,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
              Text("1h ago", style: TextStyle(color: Colors.grey, fontSize: 10))
            ],
          ),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                widget.question.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Styles.bottomRowIcons(
                  Icons.thumb_up_alt_rounded, "${widget.question.likes} Likes"),
              Styles.bottomRowIcons(
                  Icons.reply_rounded, "${widget.question.replies} Replies")
            ],
          )
        ],
      ),
    );
  }
}
