import 'package:flutter/material.dart';
import 'package:scse_knowledge_hub_app/utils/styles.dart';

class ReplyCard extends StatefulWidget {
  // final Reply reply;
  // final VoidCallback? onTap;
  const ReplyCard({
    Key? key,
    // required this.reply,
    // this.onTap,
  }) : super(key: key);
  @override
  State<ReplyCard> createState() => _ReplyCardState();
}

class _ReplyCardState extends State<ReplyCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Elon Musk",
                style: TextStyle(
                    color: Colors.black,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    fontSize: 14)),
            Text("1h ago", style: TextStyle(color: Colors.grey, fontSize: 10)),
            SizedBox(height: 10),
            Text(
              "LMAOOO try harder bro this one so easy lololololololololololololololol.",
              style: TextStyle(fontSize: 12),
            ),
            SizedBox(height: 10),
            Styles.bottomRowIcons(Icons.thumb_up_alt_rounded, "${40} Likes"),
          ],
        ),
      ),
    );
  }

  // Widget cardDetails() {
  //   return Padding(
  //     padding: const EdgeInsets.all(15),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text("Clarence Kway",
  //             style: TextStyle(
  //                 color: Colors.black,
  //                 overflow: TextOverflow.ellipsis,
  //                 fontWeight: FontWeight.bold,
  //                 fontSize: 14)),
  //         Text("1h ago", style: TextStyle(color: Colors.grey, fontSize: 10)),
  //         Expanded(
  //           child: Text(
  //             "LMAOOO try harder bro this one so easy.",
  //             style: TextStyle(fontSize: 12),
  //           ),
  //         ),
  //         Styles.bottomRowIcons(Icons.thumb_up_alt_rounded, "${40} Likes"),
  //       ],
  //     ),
  //   );
  // }
}
