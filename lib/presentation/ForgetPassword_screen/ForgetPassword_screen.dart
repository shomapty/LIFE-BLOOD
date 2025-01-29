import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smuctblooddonation/core/utils/size_utils.dart';
import '../../core/app_export.dart';
import '../../core/utils/image_constant.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_decoration.dart';
import '../../theme/custom_text_style.dart';
import '../../theme/theme_helper.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';

class ForgetPasswordScreen extends StatefulWidget {
  ForgetPasswordScreen({Key? key})
      : super(
          key: key,
        );

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {

  final auth = FirebaseAuth.instance;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController donorEmailController = TextEditingController();


  void onTapScreenTitle(String routeName) {
    Get.toNamed(routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: theme.colorScheme.onPrimary,
          image: DecorationImage(
            image: AssetImage(
              ImageConstant.imgSignupScreen,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 30),
            Text(
              "Blood Donation",
              style: TextStyle(
                  fontSize: 32,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 80),
            Text(
              "Reset Password",
              style: TextStyle(
                fontSize: 42,
                color: Colors.black,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 30,),
            Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.only(
                  left: 42.h,
                  right: 42.h,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 2.h),
                      padding: EdgeInsets.symmetric(
                        horizontal: 30.h,
                        vertical: 41.v,
                      ),
                      decoration: AppDecoration.fillPrimaryContainer.copyWith(
                        borderRadius: BorderRadiusStyle.roundedBorder36,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildDonorEmailColumn(),
                          SizedBox(height: 20.v),
                          CustomElevatedButton(
                            onPressed: (){
                              resetPassword();
                              onTapScreenTitle(AppRoutes.loginScreen);
                            },
                            text: "Reset Password",
                            margin: EdgeInsets.only(right: 8.h),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5.v)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  ///Reset Function
  resetPassword(){
    String email = donorEmailController.text.toString();
    auth.sendPasswordResetEmail(email: email);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Row(
        children: [
          Icon(
            Icons.notifications_active_outlined,
            color: Colors.red,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "We have sent you email to recover password, please check email",
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 5), // Adjust the duration as needed
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 6,
      margin: EdgeInsets.all(20),
    ));
  }

  /// Section Widget
  Widget _buildDonorEmailColumn() {
    return Padding(
      padding: EdgeInsets.only(right: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "EMAIL",
            style: CustomTextStyles.bodyMediumGray700_1,
          ),
          SizedBox(height: 3.v),
          CustomTextFormField(
            controller: donorEmailController,
          )
        ],
      ),
    );
  }
}
