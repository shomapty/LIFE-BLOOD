// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../core/app_export.dart';
import '../../core/utils/image_constant.dart';
import '../../core/utils/size_utils.dart';
import '../../localization/Notification/notification_service.dart';
import '../../theme/app_decoration.dart';
import '../../theme/custom_text_style.dart';
import '../../theme/theme_helper.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';
import '../Drawer/admin_drawer.dart';

class CampaignInformationScreen extends StatefulWidget {
  CampaignInformationScreen({Key? key}) : super(key: key);

  @override
  State<CampaignInformationScreen> createState() =>
      _CampaignInformationScreenState();
}

class _CampaignInformationScreenState extends State<CampaignInformationScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();

  List<File> _images = [];

  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.isTokenRefresh();
    notificationServices.getDeviceToken().then((value) {
      if (kDebugMode) {
        print("Device Token: ");
        print(value);
      }
    });
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
      body: SingleChildScrollView(
        child: Container(
          width: SizeUtils.width,
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
              SizedBox(height: 8.v),
              Text(
                " Campaign\nInformation",
                style: theme.textTheme.displayMedium,
              ),
              SizedBox(height: 16.v),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 18.h),
                  padding: EdgeInsets.symmetric(
                    horizontal: 30.h,
                    vertical: 37.v,
                  ),
                  decoration: AppDecoration.fillPrimaryContainer.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder36,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 6.v),
                      _buildNameSection(),
                      SizedBox(height: 20.v),
                      _buildPlaceSection(),
                      SizedBox(height: 20.v),
                      _buildStartDateSection(),
                      SizedBox(height: 20.v),
                      _buildEndDateSection(),
                      SizedBox(height: 20.v),
                      _buildStartTimeSection(),
                      SizedBox(height: 20.v),
                      _buildEndTimeSection(),
                      SizedBox(height: 20.v),
                      CustomElevatedButton(
                        text: "SELECT IMAGES",
                        margin: EdgeInsets.only(
                          left: 4.h,
                          right: 5.h,
                        ),
                        onPressed: () {
                          _getImage();
                        },
                      ),
                      SizedBox(height: 20.v),
                      _images.isEmpty
                          ? Container()
                          : Column(
                        children: _images.map((image) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.file(
                              image,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 20.v),
                      CustomElevatedButton(
                        text: "lbl_save".tr,
                        margin: EdgeInsets.only(
                          left: 4.h,
                          right: 5.h,
                        ),
                        onPressed: () {
                          _saveCampaignInformation();
                        },
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

  Widget _buildNameSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "NAME",
          style: CustomTextStyles.bodyMediumGray700,
        ),
        SizedBox(height: 3.v),
        Padding(
          padding: EdgeInsets.only(right: 4.h),
          child: CustomTextFormField(
            controller: nameController,
          ),
        )
      ],
    );
  }

  Widget _buildPlaceSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "PLACE",
            style: CustomTextStyles.bodyMediumGray700_1,
          ),
          SizedBox(height: 4.v),
          Padding(
            padding: EdgeInsets.only(right: 2.h),
            child: CustomTextFormField(
              controller: placeController,
            ),
          )
        ],
      ),
    );
  }



  Widget _buildStartDateSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "START DATE",
            style: CustomTextStyles.bodyMediumGray700_1,
          ),
          SizedBox(height: 4.v),
          Padding(
            padding: EdgeInsets.only(right: 2.h),
            child: GestureDetector(
              onTap: () async {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (selectedDate != null) {
                  startDateController.text =
                      DateFormat('yyyy-MM-dd').format(selectedDate);
                }
              },
              child: AbsorbPointer(
                child: CustomTextFormField(
                  controller: startDateController,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEndDateSection() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 4.h),
            child: Text(
              "END DATE",
              style: CustomTextStyles.bodyMediumGray700,
            ),
          ),
          SizedBox(height: 4.v),
          Padding(
            padding: EdgeInsets.only(left: 4.h),
            child: GestureDetector(
              onTap: () async {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (selectedDate != null) {
                  endDateController.text =
                      DateFormat('yyyy-MM-dd').format(selectedDate);
                }
              },
              child: AbsorbPointer(
                child: CustomTextFormField(
                  controller: endDateController,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildStartTimeSection() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 4.h),
            child: Text(
              "START TIME",
              style: CustomTextStyles.bodyMediumGray700,
            ),
          ),
          SizedBox(height: 4.v),
          Padding(
            padding: EdgeInsets.only(left: 4.h),
            child: GestureDetector(
              onTap: () async {
                TimeOfDay? selectedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (selectedTime != null) {
                  final now = DateTime.now();
                  final selectedDateTime = DateTime(
                      now.year,
                      now.month,
                      now.day,
                      selectedTime.hour,
                      selectedTime.minute
                  );
                  startTimeController.text = DateFormat('hh:mm a').format(selectedDateTime);
                }
              },
              child: AbsorbPointer(
                child: CustomTextFormField(
                  controller: startTimeController,
                  textInputAction: TextInputAction.done,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEndTimeSection() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 4.h),
            child: Text(
              "END TIME",
              style: CustomTextStyles.bodyMediumGray700,
            ),
          ),
          SizedBox(height: 4.v),
          Padding(
            padding: EdgeInsets.only(left: 4.h),
            child: GestureDetector(
              onTap: () async {
                TimeOfDay? selectedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (selectedTime != null) {
                  final now = DateTime.now();
                  final selectedDateTime = DateTime(
                      now.year,
                      now.month,
                      now.day,
                      selectedTime.hour,
                      selectedTime.minute
                  );
                  endTimeController.text = DateFormat('hh:mm a').format(selectedDateTime);
                }
              },
              child: AbsorbPointer(
                child: CustomTextFormField(
                  controller: endTimeController,
                  textInputAction: TextInputAction.done,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }




  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage(
      maxWidth: 800,
      maxHeight: 600,
      imageQuality: 85,
    );
    setState(() {
      if (pickedFiles != null) {
        // Add the selected images to the list
        _images.addAll(pickedFiles.map((file) => File(file.path)));
      }
    });
  }

  Future<void> _saveCampaignInformation() async {
    // Check if all fields are filled
    if (nameController.text.isEmpty ||
        startDateController.text.isEmpty ||
        placeController.text.isEmpty ||
        endDateController.text.isEmpty ||
        startTimeController.text.isEmpty ||
        endTimeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.notifications_active_outlined,
              color: Colors.red,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                "Filled all the field",
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
      ));
      return;
    }

    // Save campaign information to Firebase
    try {
      User? firebaseUser = FirebaseAuth.instance.currentUser;
      List<String> imageUrl = [];

      for (var imageFile in _images) {
        Reference ref = FirebaseStorage.instance.ref().child(
            'Campaign_images/${DateTime.now().millisecondsSinceEpoch}_${_images.indexOf(imageFile)}.jpg');

        UploadTask uploadTask = ref.putFile(imageFile);
        TaskSnapshot snapshot = await uploadTask;
        String imageURL = await snapshot.ref.getDownloadURL();
        imageUrl.add(imageURL);
      }

      await FirebaseFirestore.instance.collection('campaigns').add({
        'name': nameController.text,
        'startDate': startDateController.text,
        'place': placeController.text,
        'endDate': endDateController.text,
        'endTime': endTimeController.text,
        'startTime': startTimeController.text,
        "userId": firebaseUser?.uid,
        "imageUrl": imageUrl[0],
        "moreImagesUrl": imageUrl,
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.notifications_active_outlined,
              color: Colors.red,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                "Campaign Posted",
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
      ));
      sendNotification();
    } catch (error) {
      print('Error saving campaign information: $error');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: $error"),
      ));
    }
  }

  void sendNotification() async {
    notificationServices.getDeviceToken().then((value) async {
      var data = {
        'to': '',
        'priority': 'high',
        'notification': {
          'title': 'New Campaign',
          'body': 'A new campaign has been posted!',
        },
        'data': {
          'type': 'campaign',
          'id': 'new_campaign',
        }
      };
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'key=AAAALFupjFY:APA91bH-YMWkjM6hi3-xUF8kOnPPl_PtRhz4g7QHBImtTfU2dikMyp9jCXkfib3nJVzyoayNtlmOcFGjxkOl4GGvrkktvlOVysfNai7Sha8j4pRi1_uEqco9Yp4Cl74_BemEC6OO84ik', // Replace with your server key
        },
      );
    });
  }
}
