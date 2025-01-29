import '../../../core/app_export.dart';
import '../controller/donation_record_controller.dart';

/// A binding class for the DonationRecordScreen.
///
/// This class ensures that the DonationRecordController is created when the
/// DonationRecordScreen is first loaded.
class DonationRecordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DonationRecordController());
  }
}
