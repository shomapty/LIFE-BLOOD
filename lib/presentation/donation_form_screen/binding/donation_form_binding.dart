import '../../../core/app_export.dart';
import '../controller/donation_form_controller.dart';

/// A binding class for the DonationHistoryScreen.
///
/// This class ensures that the DonationHistoryController is created when the
/// DonationHistoryScreen is first loaded.
class DonationFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DonationFormController());
  }
}
