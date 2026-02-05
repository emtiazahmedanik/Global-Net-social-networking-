import 'package:flutter/material.dart';

class LinksWidget extends StatelessWidget {
  final String imageUrl;
  final String link;

  const LinksWidget({super.key, required this.imageUrl, required this.link});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              width: 74,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),

          SizedBox(width: 12),

          Expanded(
            child: Text(
              link,
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
