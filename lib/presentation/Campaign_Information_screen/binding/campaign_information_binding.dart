import '../../../core/app_export.dart';
import '../controller/campaign_information_controller.dart';

/// A binding class for the DonationHistoryScreen.
///
/// This class ensures that the DonationHistoryController is created when the
/// DonationHistoryScreen is first loaded.
class CampaignInformationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CampaignInformationController());
  }
}
