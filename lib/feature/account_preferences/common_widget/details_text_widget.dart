import 'package:flutter/material.dart';
import 'package:jdadzok/feature/account_preferences/controller/expandable_text_controller.dart';

class ExpandableText extends StatelessWidget {
  final String text;
  final int maxLines;
  final ExpandableTextController controller;

  const ExpandableText({
    super.key,
    required this.text,
    this.maxLines = 3,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final isExpanded = controller.isExpanded;

        final textSpan = TextSpan(
          text: text,
          style: TextStyle(fontSize: 16, color: Colors.black),
        );
        final textPainter = TextPainter(
          text: textSpan,
          maxLines: maxLines,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: MediaQuery.of(context).size.width);

        final isOverflowing = textPainter.didExceedMaxLines;

        if (!isOverflowing && !isExpanded) {
          return Text(
            text,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 16),
          );
        }

        return Stack(
          children: [
            Text(
              text,
              maxLines: isExpanded ? null : maxLines,
              overflow: isExpanded
                  ? TextOverflow.visible
                  : TextOverflow.ellipsis,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            if (!isExpanded)
              Positioned(
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: controller.toggle,
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(left: 4.0),
                    child: Text(
                      'See more',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            if (isExpanded)
              Positioned(
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: controller.toggle,
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(left: 4.0),
                    child: Text(
                      'See less',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
