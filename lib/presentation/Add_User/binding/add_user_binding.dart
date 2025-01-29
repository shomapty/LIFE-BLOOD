import '../../../core/app_export.dart';
import '../controller/add_user_controller.dart';

/// A binding class for the SignupScreen.
///
/// This class ensures that the SignupController is created when the
/// SignupScreen is first loaded.
class AddUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddUserController());
  }
}
