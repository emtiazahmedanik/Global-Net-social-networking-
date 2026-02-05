import 'package:flutter/material.dart';
import 'package:jdadzok/core/style/global_text_style.dart';

class CreateNGOTextField extends StatelessWidget {
  final String labelName;
  final String hintName;
  final bool? readOnly;
  final Color? fillColor;
  final int? maxOfLine;
  final VoidCallback? onChangedAction;
  final TextEditingController? teController;
  final IconButton? iconButton;
  final Icon? suffixIcon;
  const CreateNGOTextField({
    super.key,
    required this.labelName,
    required this.hintName,
    this.fillColor,
    this.maxOfLine,
    this.onChangedAction,
    this.teController,
    this.iconButton,this.suffixIcon, this.readOnly ,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelName,
          style: globalTextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0XFF6A6A6A),
          ),
        ),
        SizedBox(height: 10),
        TextFormField(
          textInputAction: TextInputAction.next,
          controller: teController,
          maxLines: maxOfLine ?? 1,
          readOnly: readOnly ?? false,
          decoration: InputDecoration(
            suffixIcon: iconButton,
            hintText: hintName,
            hintStyle: globalTextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0XFF6A6A6A),
            ),
            fillColor: fillColor ?? Colors.grey.shade200,
            filled: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          onTap: onChangedAction,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Enter $labelName';
            }
            // if (value.length < 3) {
            //   return 'Name must be at least 3 characters';
            // }
            return null;
          },
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
