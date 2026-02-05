import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jdadzok/feature/analytics/controller/keymatrix_controller.dart';

class KeymatrixWidget extends StatelessWidget {
  const KeymatrixWidget({super.key});

  String _getFormattedDate() {
    final now = DateTime.now();
    return DateFormat('dd MMMM, yyyy').format(now);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<KeymatrixController>();

    final timeOptions = {
      '7d': '7days',
      '1m': '1months',
      '6m': '6months',
      '1y': '1years',
    };

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Key Matrix',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      height: 1.8,
                      color: Color(0xff000000),
                    ),
                  ),
                  Text(
                    _getFormattedDate(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff6A6A6A),
                    ),
                  ),
                ],
              ),
              Spacer(),
              Obx(() {
                return GestureDetector(
                  onTap: () async {
                    final selected = await showMenu<String>(
                      context: context,
                      position: RelativeRect.fromLTRB(
                        MediaQuery.of(context).size.width - 120,
                        100,
                        16,
                        0,
                      ),
                      items: timeOptions.entries.map((entry) {
                        return PopupMenuItem<String>(
                          value: entry.key,
                          child: Text(entry.value),
                        );
                      }).toList(),
                    );

                    if (selected != null) {
                      controller.selectedRange.value = selected;
                      controller.fetchMetrics();
                    }
                  },
                  child: Container(
                    height: 32,
                    width: 80,
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(21),
                      color: Color(0XFF6A6A6A).withValues(alpha: .6),
                    ),
                    child: Row(
                      children: [
                        Text(timeOptions[controller.selectedRange.value] ?? '7days'),
                        Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}
