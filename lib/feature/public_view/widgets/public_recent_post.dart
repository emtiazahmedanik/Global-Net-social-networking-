import 'package:flutter/material.dart';

class PublicRecentPost extends StatelessWidget {
  const PublicRecentPost({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    int crossAxisCount = 3;
    if (screenWidth > 600) {
      crossAxisCount = 4;
    } else if (screenWidth > 900) {
      crossAxisCount = 5;
    }

    final double itemWidth =
        (screenWidth - 32 - ((crossAxisCount - 1) * 8)) / crossAxisCount;
    final double itemHeight = itemWidth * (157 / 107);
    final double aspectRatio = itemWidth / itemHeight;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: aspectRatio,
        ),
        itemCount: 9,
        itemBuilder: (context, index) {
          final imagePath = 'assets/images/recent_post_image${index + 1}.png';
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FullScreenImageViewer(imagePath: imagePath),
                ),
              );
            },
            child: ClipRRect(
              child: AspectRatio(
                aspectRatio: 107 / 157,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


class FullScreenImageViewer extends StatelessWidget {
  final String imagePath;

  const FullScreenImageViewer({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff2D55FF).withValues(alpha: .8),

      body: Center(
        child: InteractiveViewer(
          child: Image.asset(imagePath, fit: BoxFit.contain),
        ),
      ),
    );
  }
}