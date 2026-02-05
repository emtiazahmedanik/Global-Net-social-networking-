import 'package:flutter/material.dart';

Color capColorFrom(String cap) {
  switch (cap) {
    case 'GREEN':
      return Colors.green;
    case 'YELLOW':
      return Colors.yellow.shade700;
    case 'RED':
      return Colors.red;
    case 'BLACK':
      return Colors.black;
    case 'OSTRICH_FEATHER':
      return Colors.purple;
    default:
      return Colors.grey;
  }
}
