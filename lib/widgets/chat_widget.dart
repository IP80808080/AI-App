import 'package:flutter/material.dart';
import 'package:gpt_dall/constant/constant.dart';
import 'package:gpt_dall/widgets/text_widget.dart';
import 'assest_control.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({super.key, required this.msg, required this.chatIndex});

  final String msg;
  final int chatIndex;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: chatIndex == 0 ? scaffoldBackgroundColor : cardColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  chatIndex == 0
                      ? AssetsManager.userImage
                      : AssetsManager.botImage,
                  width: 25,
                  height: 25,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextWidget(
                    label: msg,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
