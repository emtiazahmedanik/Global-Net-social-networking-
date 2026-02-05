import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'about_us_controller.dart';

class AboutUsScreen extends StatelessWidget {
  final AboutUsController controller = Get.put(AboutUsController());

  AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(onPressed: ()=>Get.back(), icon: Icon(Icons.arrow_back_ios_new_rounded)),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.aboutUsData.isEmpty) {
          return Center(child: Text('No data available'));
        }

        final data = controller.aboutUsData;
        final photos = List<String>.from(data['photos'] ?? []);
        final aboutText = data['about'] ?? '';

        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'About Us',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              if (photos.isNotEmpty)
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: photos.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            photos[index],
                            width: 300,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              SizedBox(height: 16),
              Text(
                aboutText,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),

            ],
          ),
        );
      }),
    );
  }
}
