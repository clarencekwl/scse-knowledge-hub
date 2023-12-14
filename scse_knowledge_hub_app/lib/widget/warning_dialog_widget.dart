import 'package:flutter/material.dart';
import 'package:scse_knowledge_hub_app/utils/styles.dart';

class WarningDialogWidget extends StatelessWidget {
  final String? title;
  final Widget content;
  final List<Widget>? actions;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  const WarningDialogWidget({
    Key? key,
    this.title,
    required this.content,
    this.actions,
    this.onConfirm,
    this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Center(
        child: Text(
          title ?? "Warning",
          style: TextStyle(color: Colors.redAccent),
        ),
      ),
      titlePadding: EdgeInsets.only(top: 20),
      content: content,
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      actions: actions ??
          [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: onCancel ??
                        () {
                          Navigator.of(context).pop();
                        },
                    child: Container(
                      width: Styles.kScreenWidth(context) * 0.2,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(1.0, 1.0),
                            color: Colors.grey[300]!,
                            blurRadius: 3,
                          )
                        ],
                      ),
                      child: Center(
                        child:
                            Text('No', style: TextStyle(color: Colors.black)),
                      ),
                    )),
                InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: onConfirm ??
                        () {
                          Navigator.of(context).pop();
                        },
                    child: Container(
                      width: Styles.kScreenWidth(context) * 0.2,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Styles.primaryBlueColor,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(1.0, 1.0),
                            color: Colors.grey[300]!,
                            blurRadius: 3,
                          )
                        ],
                      ),
                      child: Center(
                        child:
                            Text('Yes', style: TextStyle(color: Colors.white)),
                      ),
                    )),
              ],
            ),
          ],
      actionsPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
    );
  }
}
