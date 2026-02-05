import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../model/category_model.dart';

class CategoryChip extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;
  final bool isFirstCategory;

  const CategoryChip({
    super.key,
    required this.category,
    required this.onTap,
    this.isFirstCategory = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        padding: const EdgeInsets.only(
          top: 12,
          left: 14,
          right: 18,
          bottom: 12,
        ),
        decoration: ShapeDecoration(
          color: category.isSelected ? AppColors.primaryColor : AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9999),
          ),
          shadows: const [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 2,
              offset: Offset(0, 0),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (category.emoji != null) ...[
              Text(
                category.emoji!,
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Instrument Sans',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
            ],
            Text(
              category.name,
              style: TextStyle(
                color: category.isSelected ? AppColors.white : AppColors.black,
                fontSize: isFirstCategory ? 14 : 15,
                fontFamily: isFirstCategory ? 'Inter' : 'TikTok Text',
                fontWeight: FontWeight.w500,
                height: isFirstCategory ? 1.21 : 1.13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
