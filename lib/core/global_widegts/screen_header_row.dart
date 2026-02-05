import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/global_widegts/custom_button.dart';
import 'package:jdadzok/core/style/global_text_style.dart';

class ScreenHeaderRow extends StatelessWidget {
  final String title;
  final bool? hasLastButton;
  final String? buttonTitle;
  final VoidCallback? buttonAction;
  const ScreenHeaderRow({
    super.key,
    required this.title,
    this.hasLastButton,
    this.buttonTitle,
    this.buttonAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Get.back();
          },
          child: CircleAvatar(
            backgroundColor: Color(0XFFEFEFEF),
            child: Icon(Icons.arrow_back, color: Colors.grey.shade700),
          ),
        ),
        Spacer(),
        Text(
          title,
          //"NGO",
          style: globalTextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        Spacer(),
        if (hasLastButton == true) ...[
          CustomButton(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            text: buttonTitle.toString(),
            onPressed: buttonAction!,
          ),
        ],
      ],
    );
  }
}
