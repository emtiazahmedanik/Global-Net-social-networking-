import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import '../../../theme/app_colors.dart';

class CommentInput extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onEmoji;
  final VoidCallback onPickImage;
  final VoidCallback onTapRemoveImage;
  final Function(bool) onFileSelectionChanged;
  final RxString selectedMediaPath;

  const CommentInput({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onFileSelectionChanged,
    required this.onEmoji,
    required this.onPickImage,
    required this.selectedMediaPath,
    required this.onTapRemoveImage
  });

  @override
  State<CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  bool _hasContent = false;
  bool _hasSelectedFile = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_checkContent);
  }

  void _checkContent() {
    final hasText = widget.controller.text.trim().isNotEmpty;
    if (_hasContent != (hasText || _hasSelectedFile)) {
      setState(() {
        _hasContent = hasText || _hasSelectedFile;
      });
    }
  }

  void _handleSend() {
    if (widget.controller.text.trim().isNotEmpty ) {
      widget.onSend();
      widget.controller.clear();
      setState(() {
        _hasSelectedFile = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(100),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 2,
              offset: Offset(0, 0),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            Obx(
              () => widget.selectedMediaPath.value.isNotEmpty
                  ? Stack(
                      children: [
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: Image.file(
                            File(widget.selectedMediaPath.value),
                          ),
                        ),
                        GestureDetector(
                          onTap: widget.onTapRemoveImage,
                          child: CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.grey.shade400,
                            child: Icon(Icons.close_rounded,size: 13,),),
                        )
                      ],
                    )
                  : SizedBox.shrink(),
            ),
            Expanded(
              child: TextField(
                controller: widget.controller,
                textAlignVertical: TextAlignVertical.center,
                decoration: const InputDecoration(
                  hintText: 'Add comment...',
                  hintStyle: TextStyle(
                    color: Color(0xFF6A6A6A),
                    fontSize: 15,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
              ),
            ),
            Row(
              children: [
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: widget.onPickImage,
                  child: const Icon(
                    Icons.attach_file,
                    size: 18,
                    color: Color(0xFF6A6A6A),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: widget.onEmoji,
                  child: const Icon(
                    Icons.emoji_emotions_outlined,
                    size: 18,
                    color: Color(0xFF6A6A6A),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _handleSend,
                  child: Icon(
                    Icons.send,
                    size: 18,
                    color: _hasContent
                        ? AppColors.primaryColor
                        : const Color(0xFF6A6A6A),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(_checkContent);
    super.dispose();
  }
}
