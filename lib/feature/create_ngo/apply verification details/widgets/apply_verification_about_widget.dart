import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/feature/create_ngo/apply%20verification%20details/controller/apply_verification_controller.dart';

class ApplyVerificationAboutWidget extends StatelessWidget {
  const ApplyVerificationAboutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ApplyVerificationController>();

    return Obx(() {
      // Don't show if no data
      if (!controller.hasData) {
        return SizedBox.shrink();
      }

      final location = controller.location.isNotEmpty
          ? controller.location
          : 'Not specified';
      final foundingDateFormatted = controller.foundingDateFormatted.isNotEmpty
          ? controller.foundingDateFormatted
          : 'Not specified';
      final mission = controller.mission.isNotEmpty
          ? controller.mission
          : 'No mission available';

      return Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            _InfoRow(icon: Icons.location_on_outlined, text: location),
            const SizedBox(height: 10),
            _InfoRow(icon: Icons.cake_outlined, text: foundingDateFormatted),
            const SizedBox(height: 10),
            _InfoRow(icon: Icons.work_outline, text: mission),
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
      );
    });
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
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
        ),
      ],
    );
  }
}
