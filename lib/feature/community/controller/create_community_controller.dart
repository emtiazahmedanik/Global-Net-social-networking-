/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CreateCommunityController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final communityNameController = TextEditingController();
  final foundationDateController = TextEditingController();
  final fieldOfWorkController = TextEditingController();
  final aboutController = TextEditingController();
  final addressController = TextEditingController();

  void pickFoundationDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      foundationDateController.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }
}
*/
