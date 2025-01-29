import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/donation_form_model.dart';

/// A controller class for the DonationHistoryScreen.
///
/// This class manages the state of the DonationHistoryScreen, including the
/// current donationHistoryModelObj
class DonationFormController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController bloodPressureController = TextEditingController();
  TextEditingController haemoglobinLevelController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  Rx<DonationFormModel> donationHistoryModelObj = DonationFormModel().obs;

  @override
  void onClose() {
    super.onClose();
    nameController.dispose();
    bloodPressureController.dispose();
    haemoglobinLevelController.dispose();
    heightController.dispose();
    weightController.dispose();
  }
}
