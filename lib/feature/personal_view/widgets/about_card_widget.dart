import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jdadzok/feature/personal_view/controller/personal_profile_view_controller.dart';

class AboutCardWidget extends StatelessWidget {
  AboutCardWidget({super.key});

  final PersonalProfileViewController controller =
      Get.find<PersonalProfileViewController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'About',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 16),
              _InfoRow(
                icon: Icons.location_on_outlined,
                text: controller.profile.value?.data?.location ?? '',
              ),
              const SizedBox(height: 10),
              _InfoRow(icon: Icons.cake_outlined, text: formatDate(controller.profile.value?.data?.dateOfBirth ?? '')),
              const SizedBox(height: 10),
               _InfoRow(
                icon: Icons.work_outline,
                text: controller.profile.value?.data?.experience ?? '',
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'See all',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[700]),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}


String formatDate(String input) {
  if (input.isEmpty) return '';

  try {
    final date = DateTime.parse(input);
    return DateFormat('dd MMMM yyyy').format(date);
  } catch (e) {
    debugPrint('parse error : $e');
    return ''; // return empty if invalid format
  }
}

