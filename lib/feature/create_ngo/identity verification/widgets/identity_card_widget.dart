import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/route/app_route.dart';

class IdentityCardWidget extends StatelessWidget {
  final String title;
  final String subtitle;

  const IdentityCardWidget({
    super.key,
    required this.title,
    required this.subtitle,
  });

  String _getVerificationType() {
    // Map title to verification type
    if (title.contains("Government issued ID") || title.contains("Passport")) {
      return "GOVERMENT_AND_PASSPORT";
    } else if (title.contains("Business Certified") || title.contains("License")) {
      return "BUSINESS_CERTIFIED_LICENSE";
    }
    return "GOVERMENT_AND_PASSPORT"; // default
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Get arguments from previous screens to pass along
        final Map<String, dynamic>? currentArgs = Get.arguments as Map<String, dynamic>?;
        final Map<String, dynamic> newArgs = {
          ...?currentArgs,
          'verificationType': _getVerificationType(),
        };
        Get.toNamed(AppRoute.uploadDocumentScreen, arguments: newArgs);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: .05),
              blurRadius: 5,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
