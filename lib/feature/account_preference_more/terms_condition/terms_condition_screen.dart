import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'terms_condition_controller.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class TermsConditionScreen extends StatelessWidget {
  final TermsConditionController controller = Get.put(TermsConditionController());

  TermsConditionScreen({super.key});

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

        if (controller.privacyPolicyData.isEmpty) {
          return Center(child: Text('No data available'));
        }

        final data = controller.privacyPolicyData;
        final text = data['text'] ?? '';

        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MarkdownBody(
                data: text, // Render markdown text
                styleSheet: MarkdownStyleSheet(
                  p: TextStyle(fontSize: 16),
                  h1: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  h2: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 16),

            ],
          ),
        );
      }),
    );
  }
}
