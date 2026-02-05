import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

class EmojiPickerSheet extends StatelessWidget {
  final TextEditingController controller;

  const EmojiPickerSheet({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: EmojiPicker(
        textEditingController: controller,
        config: Config(
          // This is IMPORTANT
          checkPlatformCompatibility: false,

          emojiViewConfig: EmojiViewConfig(
            emojiSizeMax: 28 *
                (foundation.defaultTargetPlatform == TargetPlatform.iOS
                    ? 1.20
                    : 1.0),
          ),

          categoryViewConfig: const CategoryViewConfig(),
          bottomActionBarConfig: const BottomActionBarConfig(),
          skinToneConfig: const SkinToneConfig(),
          searchViewConfig: const SearchViewConfig(),

          viewOrderConfig: const ViewOrderConfig(
            top: EmojiPickerItem.categoryBar,
            middle: EmojiPickerItem.emojiView,
            bottom: EmojiPickerItem.searchBar,
          ),
        ),
      ),
    );
  }
}
