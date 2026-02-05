import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jdadzok/feature/create_ngo/ngo_main_profile_screen/controller/ngo_main_profile_screen_controller.dart';

class NgoProfileAboutWidget extends StatelessWidget {
  const NgoProfileAboutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final NgoMainProfileScreenController controller = Get.find();
    final about = controller.org.value?.about;
    final profile = controller.org.value?.profile;

    final location = about?.location ?? profile?.location ?? 'Not specified';
    final foundingDate = about?.foundingDate;
    final foundingText = foundingDate != null ? DateFormat('dd MMM, yyyy').format(foundingDate) : 'Not specified';
    final mission = about?.mission ?? 'No mission available';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('About', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          _InfoRow(icon: Icons.location_on_outlined, text: location),
          const SizedBox(height: 10),
          _InfoRow(icon: Icons.cake_outlined, text: foundingText),
          const SizedBox(height: 10),
          _InfoRow(icon: Icons.work_outline, text: mission),
          const SizedBox(height: 16),
          Center(child: Text('See all', style: TextStyle(decoration: TextDecoration.underline, color: Colors.grey[700]))),
        ],
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
        Expanded(child: Text(text, style: const TextStyle(fontSize: 14, color: Colors.black87))),
      ],
    );
  }
}
