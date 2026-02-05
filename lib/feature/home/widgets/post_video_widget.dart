import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../../theme/app_colors.dart';
import 'package:jdadzok/feature/home/model/feed_response_model.dart';

class PostVideo extends StatelessWidget {
  final PostModel post;

  const PostVideo({super.key, required this.post});

  Future<VideoPlayerController> initializeVideo(String url) async {
    final controller = VideoPlayerController.networkUrl(Uri.parse(url));
    await controller.initialize();
    controller.setLooping(true);
    return controller;
  }

  @override
  Widget build(BuildContext context) {
    if (post.mediaUrls.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      height: 223,
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: FutureBuilder<VideoPlayerController>(
          future: initializeVideo(post.mediaUrls.first),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
              );
            }

            if (!snapshot.hasData) {
              return Center(
                child: Icon(Icons.videocam_off,
                    color: AppColors.greyText, size: 48),
              );
            }

            final controller = snapshot.data!;
            controller.play(); // Auto play

            return GestureDetector(
              onTap: () {
                controller.value.isPlaying
                    ? controller.pause()
                    : controller.play();
              },
              child: ValueListenableBuilder<VideoPlayerValue>(
                valueListenable: controller,
                builder: (context, value, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      // 🎥 Video with BoxFit.cover (fills like image)
                      FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: controller.value.size.width,
                          height: controller.value.size.height,
                          child: VideoPlayer(controller),
                        ),
                      ),

                      // Show play icon when video is paused
                      if (!value.isPlaying)
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.black45,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(12),
                          child: const Icon(
                            Icons.play_arrow,
                            size: 48,
                            color: Colors.white,
                          ),
                        ),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
