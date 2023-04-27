import 'package:flutter/material.dart';
import 'package:gpt_dall/widgets/text_widget.dart';
import 'package:gpt_dall/constant/constant.dart';
import '../widgets/drop_down.dart';

class Services {
  static Future<void> showModelSheet({required BuildContext context}) async {
    await showModalBottomSheet(
        backgroundColor: const Color(0xff1E1E1E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(45),
        ),
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(12).copyWith(left: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Flexible(
                  child: TextWidget(
                    label: "Chosen Model",
                    fontSize: 17,
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: ModelDropDownWidget(),
                ),
              ],
            ),
          );
        });
  }
}
