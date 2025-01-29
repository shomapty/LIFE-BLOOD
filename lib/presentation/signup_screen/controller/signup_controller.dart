import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/signup_model.dart';

/// A controller class for the SignupScreen.
///
/// This class manages the state of the SignupScreen, including the
/// current signupModelObj
class SignupController extends GetxController {
  TextEditingController nameController = TextEditingController();

  TextEditingController valueoneController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController dateOfBirthController = TextEditingController();

  Rx<SignupModel> signupModelObj = SignupModel().obs;




  @override
  void onClose() {
    super.onClose();
    nameController.dispose();
    valueoneController.dispose();
    passwordController.dispose();
    dateOfBirthController.dispose();
  }
}
