import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/campaign_information_model.dart';

/// A controller class for the DonationHistoryScreen.
///
/// This class manages the state of the DonationHistoryScreen, including the
/// current donationHistoryModelObj
class CampaignInformationController extends GetxController {
  TextEditingController nameController = TextEditingController();

  TextEditingController startDateController = TextEditingController();

  TextEditingController placeController = TextEditingController();

  TextEditingController endDateController = TextEditingController();

  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();

  Rx<campaigninformationModel> donationHistoryModelObj = campaigninformationModel().obs;

  @override
  void onClose() {
    super.onClose();
    nameController.dispose();
    startDateController.dispose();
    placeController.dispose();
    endDateController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
  }
}
