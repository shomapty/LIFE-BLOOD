import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../core/FirebaseAuth/firebaseAuthentication.dart';
import '../../core/utils/image_constant.dart';
import '../../core/utils/size_utils.dart';
import '../../core/utils/validation_functions.dart';
import '../../theme/app_decoration.dart';
import '../../theme/custom_text_style.dart';
import '../../theme/theme_helper.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';
import '../Drawer/admin_drawer.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {

  final FirebaseAuthService _auth = FirebaseAuthService();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void _uploadData() {
    DonorDataUploader.uploadDonorData(
      name: nameController.text,
      email: emailController.text,
      password: passwordController.text,
    );
  }

  void _signUp() async {
    try {
      String email = emailController.text; // Trim to remove unnecessary spaces
      String password = passwordController.text; // Trim to remove unnecessary spaces
      if (_formKey.currentState!.validate()) {
        User? user = await _auth.signUpWithEmailAndPassword(email, password);

        if (user != null) {
          // SignUp successful
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.accessible_forward,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Successfully Added Donor",
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
            duration: Duration(seconds: 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 6,
          ),);
          _uploadData(); // Upload data to Firebase
          print("Data uploaded successfully");
          print("User successfully created");
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Some error found!",
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
            duration: Duration(seconds: 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 6,
          ),);
          print("Unexpected error: User is null");
          print(email);
        }
      }
    } catch (e) {
      print("Sign-up failed: $e");
    }
  }

  void onTapScreenTitle(String routeName) {
    Get.toNamed(routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        title: Text(
          "Blood Donation",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      drawer: AdminDrawer(),
      body: Container(
        width: SizeUtils.width,
        height: SizeUtils.height,
        decoration: BoxDecoration(
          color: theme.colorScheme.onPrimary,
          image: DecorationImage(
            image: AssetImage(
              ImageConstant.imgSignupScreen,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 30.v),
              Text(
                "Add Donor",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: theme.textTheme.displayMedium,
              ),
              SizedBox(height: 10),
              Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 42.h,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 2.h),
                        padding: EdgeInsets.symmetric(
                          horizontal: 30.h,
                          vertical: 16.v,
                        ),
                        decoration: AppDecoration.fillPrimaryContainer.copyWith(
                          borderRadius: BorderRadiusStyle.roundedBorder36,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildNameColumn(),
                            SizedBox(height: 17.v),
                            _buildEmailColumn(),
                            SizedBox(height: 17.v),
                            _buildPasswordColumn(),
                            SizedBox(height: 26.v),
                            CustomElevatedButton(
                              onPressed: (){
                                _signUp();
                              },
                              text: "lbl_sign_up".tr,
                              margin: EdgeInsets.only(right: 9.h),
                            ),
                            SizedBox(height: 16.v),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  /// Section Widget
  Widget _buildNameColumn() {
    return Padding(
      padding: EdgeInsets.only(right: 9.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "lbl_name".tr,
            style: CustomTextStyles.bodyMediumGray700,
          ),
          SizedBox(height: 3.v),
          CustomTextFormField(
            controller: nameController,
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildEmailColumn() {
    return Padding(
      padding: EdgeInsets.only(right: 9.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "EMAIL",
            style: CustomTextStyles.bodyMediumGray700,
          ),
          SizedBox(height: 2.v),
          CustomTextFormField(
            controller: emailController,
            textInputType: TextInputType.emailAddress,
            validator: (value) {
              RegExp regExp = RegExp(emailPattern);
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              } else if (!regExp.hasMatch(value)) {
                return 'Please enter a valid address';
              }
              return null;
            },
          )
        ],
      ),
    );
  }


  /// Section Widget

  Widget _buildPasswordColumn() {
    bool obscureText = true; // Initial state of password visibility
    return Padding(
      padding: EdgeInsets.only(right: 9.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "lbl_password".tr,
            style: CustomTextStyles.bodyMediumGray700,
          ),
          SizedBox(height: 3.v),
          CustomTextFormField(
            controller: passwordController,
            textInputType: TextInputType.visiblePassword,
            obscureText: obscureText,
            validator: (value) {
              if (value!.length < 5) {
                return 'Must be more then 5 character';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
