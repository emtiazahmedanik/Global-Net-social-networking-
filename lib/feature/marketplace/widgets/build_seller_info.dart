import 'package:flutter/material.dart';
import 'package:jdadzok/feature/marketplace/model/marketplace_product_model.dart';

Widget buildSellerInfo(MarketplaceProduct product) {
  return Row(
    children: [
       Text(
        product.seller.email,
        style: TextStyle(
          fontSize: 14,
          color: Color(0xFF6A6A6A),
          fontWeight: FontWeight.w500,
        ),
      ),
      const SizedBox(width: 8),
      Container(
        width: 20,
        height: 20,
        decoration: const BoxDecoration(
          color: Color(0xFF4285F4),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, color: Colors.white, size: 14),
      ),
    ],
  );
}
