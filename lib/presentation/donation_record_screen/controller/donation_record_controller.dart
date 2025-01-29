import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/donation_record_model.dart';

/// A controller class for the DonationRecordScreen.
///
/// This class manages the state of the DonationRecordScreen, including the
/// current donationRecordModelObj
class DonationRecordController extends GetxController {
  TextEditingController bloodIdController = TextEditingController();

  TextEditingController donorIclController = TextEditingController();

  TextEditingController bloodTypeController = TextEditingController();

  TextEditingController StatusController = TextEditingController();

  TextEditingController placeController = TextEditingController();

  Rx<DonationRecordModel> donationRecordModelObj = DonationRecordModel().obs;

  @override
  void onClose() {
    super.onClose();
    bloodIdController.dispose();
    donorIclController.dispose();
    bloodTypeController.dispose();
    StatusController.dispose();
    placeController.dispose();
  }
}
