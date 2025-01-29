import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smuctblooddonation/core/utils/size_utils.dart';
import '../../core/FirebaseAuth/firebaseAuthentication.dart';
import '../../core/app_export.dart';
import '../../core/utils/image_constant.dart';
import '../../core/utils/validation_functions.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_decoration.dart';
import '../../theme/custom_text_style.dart';
import '../../theme/theme_helper.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_image_view.dart';
import '../../widgets/custom_text_form_field.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key})
      : super(
          key: key,
        );

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final FirebaseAuthService _auth = FirebaseAuthService();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  Future<void> signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        print("Sign-in aborted by user");
        return;
      }

      GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        print("User signed in with Google: ${userCredential.user!.email}");

        route();
      } else {
        print("Google sign-in failed, no user found.");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Failed to sign in with Google"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print("Google sign-in failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("An error occurred during Google sign-in"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  void _signIn() async {
    try {

      String email = emailController.text;
      String password = passwordController.text;

      if (_formKey.currentState!.validate()) {
        User? user = await _auth.signInWithEmailAndPassword(email, password);

        if (user != null) {
          route();
          print("User is successfully SignIn");
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Email or Password Incorrect",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 5), // Adjust the duration as needed
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 6,
            //margin: EdgeInsets.all(20),
          ),);
          print("Unexpected error: User is null");
        }
      }
    } catch (e) {
      print("Sign-up failed: $e");
    }
  }

  void route() async {
    User? user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        if (documentSnapshot.get('type') == "donor") {
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
                    "Welcome Hero",
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
          onTapScreenTitle(AppRoutes.campaignPostSceen);
        }
        else if (documentSnapshot.get('type') == "admin") {
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
                    "Welcome back Sir",
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
          onTapScreenTitle(AppRoutes.campaignPostSceen);
        }
        else if (documentSnapshot.get('type') == "staff") {
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
                    "Welcome back Dear Staff",
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
          onTapScreenTitle(AppRoutes.campaignPostSceen);
        }
        else {
          setState(() {
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
                      "Some error in logging in!",
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
          });
          return 'Document does not exist on the database';
        }
      } else {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Some error in logging in!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 3), // Adjust the duration as needed
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 6,
            margin: EdgeInsets.all(20),
          ));
        });
        return 'Document does not exist on the database';
      }
    });
  }

  void onTapScreenTitle(String routeName) {
    Get.toNamed(routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
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
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            children: [
              SizedBox(height: 30.v),
              Text(
                "lbl_blood_donation".tr,
                style: TextStyle(
                    fontSize: 32,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              //SizedBox(height: 5.v),
              Text(
                "lbl_login".tr,
                style: theme.textTheme.displayLarge,
              ),
              SizedBox(height: 6.v),
              Text(
                "msg_sign_in_to_continue".tr,
                style: CustomTextStyles.bodyLargeBlack900,
              ),
              SizedBox(height: 10,),
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
                            _buildEmailColumn(),
                            SizedBox(height: 20.v),
                            _buildPasswordColumn(),
                            SizedBox(height: 45.v),
                            CustomElevatedButton(
                              onPressed: (){
                                _signIn();
                              },
                              text: "lbl_log_in2".tr,
                              margin: EdgeInsets.only(right: 8.h),
                            ),
                            SizedBox(height: 11.v),
                            TextButton(
                              onPressed: () {
                                onTapScreenTitle(AppRoutes.resetPassword);
                              },
                              child: Text(
                                "msg_forget_password".tr,
                                style: theme.textTheme.bodyLarge,
                              ),
                            ),
                            SizedBox(height: 21.v),
                            Text(
                              "lbl_or_login_with".tr,
                              style: theme.textTheme.bodyLarge,
                            ),
                            SizedBox(height: 14.v),
                            TextButton(
                              onPressed: (){
                                signInWithGoogle();
                              },
                              child: CustomImageView(
                                imagePath: ImageConstant.imgGLogo1,
                                height: 62.adaptSize,
                                width: 62.adaptSize,
                              ),
                            ),
                            SizedBox(height: 32.v),
                            TextButton(
                              onPressed: (){
                                onTapScreenTitle(AppRoutes.signupScreen);
                              },
                              child: Text(
                                "lbl_signup2".tr,
                                style: theme.textTheme.bodyLarge,
                              ),
                            )
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
      ),
    );
  }

  /// Section Widget
  Widget _buildEmailColumn() {
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
            controller: emailController,
            validator: (value) {
              RegExp regExp = RegExp(emailPattern);
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              } else if (!regExp.hasMatch(value)) {
                return 'Please enter a valid email address';
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
    return Padding(
      padding: EdgeInsets.only(right: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 1.h),
            child: Text(
              "lbl_password".tr,
              style: CustomTextStyles.bodyMediumGray700,
            ),
          ),
          SizedBox(height: 4.v),
          Padding(
            padding: EdgeInsets.only(left: 1.h),
            child: CustomTextFormField(
              controller: passwordController,
              textInputAction: TextInputAction.done,
              textInputType: TextInputType.visiblePassword,
              obscureText: true,
              validator: (value) {
                if (value!.length < 5) {
                  return 'Must be more then 5 character';
                }
                return null;
              },
            ),
          )
        ],
      ),
    );
  }
}
