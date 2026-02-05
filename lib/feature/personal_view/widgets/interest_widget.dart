import 'package:flutter/material.dart';

class IntersetsWidget extends StatelessWidget {
  const IntersetsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Interests',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  height: 1.8,
                  color: Color(0xff000000),
                ),
              ),
              Spacer(),
              GestureDetector(
                child: Text(
                  'Edit',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff000000),
                  ),
                ),
                onTap: () {
                  debugPrint('Edit tapped');
                },
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xff000000)),
            ],
          ),
        ],
      ),
    );
  }
}
