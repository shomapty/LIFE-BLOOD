import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/app_export.dart';
import '../../core/utils/image_constant.dart';
import '../../core/utils/size_utils.dart';
import '../../core/utils/validation_functions.dart';
import '../../theme/app_decoration.dart';
import '../../theme/custom_text_style.dart';
import '../../theme/theme_helper.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';
import '../Drawer/admin_drawer.dart';
import '../Drawer/donor_drawer.dart';
import '../Drawer/staff_drawer.dart';


class DonationRecordScreen extends StatefulWidget {
  DonationRecordScreen({Key? key})
      : super(
          key: key,
        );

  @override
  State<DonationRecordScreen> createState() => _DonationRecordScreenState();
}

class _DonationRecordScreenState extends State<DonationRecordScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController bloodIdController = TextEditingController();
  TextEditingController donorIclController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController haemoglobinController = TextEditingController();
  String status = 'In Process';
  String bloodType = 'A+';
  DateTime? selectedDate;

  Widget _buildDrawer(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return SizedBox.shrink(); // Return an empty widget if user is not logged in
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          print('Error retrieving user data: ${snapshot.error}');
          return SizedBox.shrink();
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          print('User document does not exist');
          return SizedBox.shrink();
        }

        final userRole = snapshot.data!.get('type');

        switch (userRole) {
          case 'admin':
            return AdminDrawer();
          case 'donor':
            return DonorDrawer();
          case 'staff':
            return StaffDrawer();
          default:
            print('Unknown user role: $userRole');
            return SizedBox.shrink();
        }
      },
    );
  }

  Future<void> _saveDonationData(BuildContext context) async {
    try {
      // Get inputted data from the controller
      String bloodId = bloodIdController.text;
      String icNumber = donorIclController.text;
      String place = placeController.text;
      String haemo = haemoglobinController.text;

      // Create a reference to the Firestore collection "Donation Record"
      CollectionReference donationRecordRef = FirebaseFirestore.instance.collection('Donation Record');

      // Add a new document with the data
      await donationRecordRef.add({
        'bloodId': bloodId,
        'icNumber': icNumber,
        'bloodType': bloodType,
        'status': status,
        'place': place,
        'haemoglobin': haemo,
        'date': selectedDate,
      });

      // Display a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.white,
          content: Text(
            'Blood Donation Record Added Successfully',
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    } catch (e) {
      // Handle errors and display error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.white,
          content: Text(
            'Error: $e',
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
      print('Error uploading donation record data: $e');
    }
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
      drawer: _buildDrawer(context),
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
              SizedBox(height: 20.v),
              Text(
                "lbl_donation_record".tr,
                style: theme.textTheme.displayMedium,
              ),
              SizedBox(height: 10.v),
              Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 42.h,
                    vertical: 42.v,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 30.h,
                          vertical: 37.v,
                        ),
                        decoration: AppDecoration.fillPrimaryContainer.copyWith(
                          borderRadius: BorderRadiusStyle.roundedBorder36,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 6.v),
                            _buildDonorIcSection(),
                            SizedBox(height: 20.v),
                            _buildBloodIdSection(),
                            SizedBox(height: 20.v),
                            bloodTypeDropDownMenu(),
                            SizedBox(height: 20.v),
                            _HaemoglobinLevel(),
                            SizedBox(height: 20.v),
                            StatusDropDownMenu(),
                            SizedBox(height: 19.v),
                            _buildPlaceSection(),
                            SizedBox(height: 19.v),
                            dateSection(),
                            SizedBox(height: 38.v),
                            CustomElevatedButton(
                              onPressed: (){
                                _saveDonationData(context);
                              },
                              text: "lbl_save".tr,
                              margin: EdgeInsets.only(
                                left: 4.h,
                                right: 5.h,
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
  Widget _buildBloodIdSection() {
    return Padding(
      padding: EdgeInsets.only(right: 5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "lbl_blood_id".tr,
            style: CustomTextStyles.bodyMediumGray700_1,
          ),
          SizedBox(height: 3.v),
          CustomTextFormField(
            controller: bloodIdController,
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildDonorIcSection() {
    return Container(
      margin: EdgeInsets.only(right: 5.h),
      padding: EdgeInsets.symmetric(horizontal: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "IC NUMBER",
            style: CustomTextStyles.bodyMediumGray700_1,
          ),
          SizedBox(height: 4.v),
          CustomTextFormField(
            controller: donorIclController,
            textInputType: TextInputType.emailAddress,
            validator: (value) {
              RegExp regExp = RegExp(emailPattern);
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              } else if (!regExp.hasMatch(value)) {
                return 'Please enter a ic number';
              }
              return null;
            },
          )
        ],
      ),
    );
  }

  /// Section Widget
  Column StatusDropDownMenu() {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            "STATUS",
            style: TextStyle(fontSize: 14),
          ),
        ),
        SizedBox(height: 5,),
        Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey[400], // Adjust the color as needed
            borderRadius:
            BorderRadius.circular(20.0), // Adjust the radius as needed
          ),
          child: DropdownButtonFormField<String>(
            value: status,
            onChanged: (newValue) {
              setState(() {
                status = newValue!;
              });
            },
            validator: (val) => val!.isEmpty ? 'Select status' : null,
            items: <String>[
              'In Process',
              'Donated',
              'Stored',
              'Used',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    value,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w300),
                  ),
                ),
              );
            }).toList(),
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: InputBorder
                  .none, // Remove the border of the DropdownButtonFormField
            ),
          ),
        ),
      ],
    );
  }

  /// Section Widget
  Column bloodTypeDropDownMenu() {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            "BLOOD TYPE",
            style: TextStyle(fontSize: 14),
          ),
        ),
        SizedBox(height: 5,),
        Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey[400], // Adjust the color as needed
            borderRadius:
            BorderRadius.circular(20.0), // Adjust the radius as needed
          ),
          child: DropdownButtonFormField<String>(
            value: bloodType,
            onChanged: (newValue) {
              setState(() {
                bloodType = newValue!;
              });
            },
            validator: (val) => val!.isEmpty ? 'Select blood type' : null,
            items: <String>[
              'A+',
              'B+',
              'AB+',
              'O+',
              'A-',
              'B-',
              'AB-',
              'O-',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    value,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w300),
                  ),
                ),
              );
            }).toList(),
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: InputBorder
                  .none, // Remove the border of the DropdownButtonFormField
            ),
          ),
        ),
      ],
    );
  }

  /// _buildPlaceSection
  Widget _buildPlaceSection() {
    return Padding(
      padding: EdgeInsets.only(right: 5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 4.h),
            child: Text(
              "lbl_place".tr,
              style: CustomTextStyles.bodyMediumGray700,
            ),
          ),
          SizedBox(height: 4.v),
          Padding(
            padding: EdgeInsets.only(left: 4.h),
            child: CustomTextFormField(
              controller: placeController,
              textInputAction: TextInputAction.done,
            ),
          )
        ],
      ),
    );
  }
  
  /// Section Widget
  Widget _HaemoglobinLevel() {
    return Padding(
      padding: EdgeInsets.only(right: 5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 4.h),
            child: Text(
              "HAEMOGLOBIN LEVEL",
              style: CustomTextStyles.bodyMediumGray700,
            ),
          ),
          SizedBox(height: 4.v),
          Padding(
            padding: EdgeInsets.only(left: 4.h),
            child: CustomTextFormField(
              controller: haemoglobinController,
              textInputAction: TextInputAction.done,
            ),
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget dateSection() {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            "DATE",
            style: CustomTextStyles.bodyMediumGray700_1,
          ),
        ),
        SizedBox(height: 4.v),
        Container(
          height: 60,
          padding: EdgeInsets.symmetric(horizontal: 1.h),
          decoration: BoxDecoration(
            color: Colors.grey[400], // Adjust the color as needed
            borderRadius: BorderRadius.circular(16.0), // Adjust the radius as needed
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  _selectDate(context); // Function to show the date picker dialog
                },
                child: AbsorbPointer(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20,top: 5),
                    child: TextFormField(
                      controller: TextEditingController(
                        text: selectedDate != null
                            ? DateFormat('yyyy-MM-dd').format(selectedDate!) // Display selected date if available
                            : '', // Display empty text if no date is selected
                      ),
                      decoration: InputDecoration(
                        border: InputBorder
                            .none,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

// Function to show the date picker dialog
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(), // Use selected date if available, else use current date
      firstDate: DateTime(1900), // Adjust as needed
      lastDate: DateTime.now(), // Adjust as needed
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
  
  
}
