import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/app_export.dart';
import '../../core/utils/image_constant.dart';
import '../../core/utils/size_utils.dart';
import '../../theme/app_decoration.dart';
import '../../theme/custom_text_style.dart';
import '../../theme/theme_helper.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';
import '../Drawer/donor_drawer.dart';

class DonationFormScreen extends StatefulWidget {
  const DonationFormScreen({Key? key}) : super(key: key);

  @override
  State<DonationFormScreen> createState() => _DonationFormScreenState();
}

class _DonationFormScreenState extends State<DonationFormScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController currentJobController = TextEditingController();
  TextEditingController hpController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController icNumberController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  String race = 'Malay';
  String maritalStatus = 'Single';
  DateTime? selectedDate;
  String loggedInUserName = 'null';
  String loggedInUserEmail = 'null';

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // Retrieve the user document from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        // Extract the name field from the user document
        String userName = userDoc['name'];
        String userEmail = userDoc['email'];

        setState(() {
          loggedInUserName = userName;
          loggedInUserEmail = userEmail;
        });
      }
    } catch (e) {
      print("Error getting user data: $e");
    }
  }

  Future<void> _saveDonationFormData(BuildContext context) async {
    try {
      // Get inputted data from the controller
      String name = loggedInUserName;
      String email = loggedInUserEmail;
      String icNumber = icNumberController.text;
      String age = ageController.text;
      String currentJob = currentJobController.text;
      String hpNumber = hpController.text;
      String address = addressController.text;
      String height = heightController.text;
      String weight = weightController.text;

      // Create a reference to the Firestore collection "Donation Form"
      CollectionReference donationFormRef =
          FirebaseFirestore.instance.collection('Donation Form');

      // Add a new document with the data
      await donationFormRef.add({
        'name': name,
        'email': email,
        'icNumber': icNumber,
        'dob': selectedDate,
        'age': age,
        'race': race,
        'maritalStatus': maritalStatus,
        'currentJob': currentJob,
        'hpNumber': hpNumber,
        'address': address,
        'height': height,
        'weight': weight,
      });
      User? user = _auth.currentUser;
      if (user != null) {
        // Create a reference to the Firestore document for the logged-in user
        DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

        // Update the user document with the data
        await userRef.update({
          'name': name,
          'email': email,
          'icNumber': icNumber,
          'dob': selectedDate,
          'age': age,
          'race': race,
          'maritalStatus': maritalStatus,
          'currentJob': currentJob,
          'hpNumber': hpNumber,
          'address': address,
          'height': height,
          'weight': weight,
        });

        // Display a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Blood Donation Form Submitted',
              style: TextStyle(color: Colors.red),
            ),
            backgroundColor: Colors.white,
          ),
        );
        print('User data updated successfully');
      }

      // Display a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Blood Donation Form Submitted',
            style: TextStyle(color: Colors.red),
          ),
          backgroundColor: Colors.white,
        ),
      );
      print('Donation form data uploaded successfully');
    } catch (e) {
      // Handle errors and display error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error submitting donation form: $e',
            style: TextStyle(color: Colors.red),
          ),
          backgroundColor: Colors.white,
        ),
      );
      print('Error uploading donation form data: $e');
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
      drawer: DonorDrawer(),
      body: SingleChildScrollView(
        child: Container(
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
            child: Column(
              children: [
                SizedBox(height: 8.v),
                Text(
                  "Donation Form",
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
                        _buildEmailSection(),
                        SizedBox(height: 20.v),
                        _buildIcSection(),
                        SizedBox(height: 20.v),
                        dobSection(),
                        SizedBox(height: 20.v),
                        _ageSection(),
                        SizedBox(height: 20.v),
                        raceDropDownMenu(),
                        SizedBox(height: 20.v),
                        maritalStatusDropDownMenu(),
                        SizedBox(height: 20.v),
                        currentJobSection(),
                        SizedBox(height: 20.v),
                        hpNoSection(),
                        SizedBox(height: 20.v),
                        addressSection(),
                        SizedBox(height: 20.v),
                        _buildHeightSection(),
                        SizedBox(height: 19.v),
                        _buildWeightSection(),
                        SizedBox(height: 38.v),
                        CustomElevatedButton(
                          onPressed: () {
                            _saveDonationFormData(context);
                          },
                          text: "lbl_save".tr,
                          margin: EdgeInsets.only(
                            left: 4.h,
                            right: 5.h,
                          ),
                        ),
                        SizedBox(height: 19.v),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Column maritalStatusDropDownMenu() {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            "MARITAL STATUS",
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
            value: maritalStatus,
            onChanged: (newValue) {
              setState(() {
                maritalStatus = newValue!;
              });
            },
            validator: (val) => val!.isEmpty ? 'Select Marital Status' : null,
            items: <String>[
              'Single',
              'Married',
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
  Column raceDropDownMenu() {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            "RACE",
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
            value: race,
            onChanged: (newValue) {
              setState(() {
                race = newValue!;
              });
            },
            validator: (val) => val!.isEmpty ? 'Select Race' : null,
            items: <String>[
              'Malay',
              'Chinese',
              'Indian',
              'Iban',
              'Murat',
              'Kadazan',
              'Bidayuh',
              'Melanau',
              'Bajau'
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
  Widget _buildEmailSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "EMAIL",
          style: CustomTextStyles.bodyMediumGray700,
        ),
        SizedBox(height: 3.v),
        Padding(
          padding: EdgeInsets.only(left: 4.h),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 55,
            decoration: BoxDecoration(
              color: Colors.grey[400], // Adjust the color as needed
              borderRadius:
                  BorderRadius.circular(16.0), // Adjust the radius as needed
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            // Adjust padding as needed
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                loggedInUserEmail,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
  Widget _buildNameSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "FULL NAME",
          style: CustomTextStyles.bodyMediumGray700,
        ),
        SizedBox(height: 3.v),
        Padding(
          padding: EdgeInsets.only(left: 4.h),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 55,
            decoration: BoxDecoration(
              color: Colors.grey[400], // Adjust the color as needed
              borderRadius:
                  BorderRadius.circular(16.0), // Adjust the radius as needed
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            // Adjust padding as needed
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                loggedInUserName,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  /// Section Widget
  Widget dobSection() {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            "DATE OF BIRTH",
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




  /// Section Widget
  Widget _ageSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "AGE",
            style: CustomTextStyles.bodyMediumGray700_1,
          ),
          SizedBox(height: 4.v),
          Padding(
            padding: EdgeInsets.only(right: 2.h),
            child: CustomTextFormField(
              controller: ageController,
            ),
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildIcSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "IC / PASSPORT NUMBERS",
            style: CustomTextStyles.bodyMediumGray700_1,
          ),
          SizedBox(height: 4.v),
          Padding(
            padding: EdgeInsets.only(right: 2.h),
            child: CustomTextFormField(
              controller: icNumberController,
            ),
          )
        ],
      ),
    );
  }

  ///Section Widget
  Widget addressSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "ADDRESS",
            style: CustomTextStyles.bodyMediumGray700_1,
          ),
          SizedBox(height: 4.v),
          Padding(
            padding: EdgeInsets.only(right: 2.h),
            child: CustomTextFormField(
              controller: addressController,
            ),
          )
        ],
      ),
    );
  }

  ///Section Widget
  Widget hpNoSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "H/P NO",
            style: CustomTextStyles.bodyMediumGray700_1,
          ),
          SizedBox(height: 4.v),
          Padding(
            padding: EdgeInsets.only(right: 2.h),
            child: CustomTextFormField(
              controller: hpController,
            ),
          )
        ],
      ),
    );
  }



  ///Section Widget
  Widget currentJobSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "CURRENT JOB",
            style: CustomTextStyles.bodyMediumGray700_1,
          ),
          SizedBox(height: 4.v),
          Padding(
            padding: EdgeInsets.only(right: 2.h),
            child: CustomTextFormField(
              controller: currentJobController,
            ),
          )
        ],
      ),
    );
  }



  /// Section Widget
  Widget _buildHeightSection() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 4.h),
            child: Text(
              "HEIGHT (cm)",
              style: CustomTextStyles.bodyMediumGray700,
            ),
          ),
          SizedBox(height: 4.v),
          Padding(
            padding: EdgeInsets.only(left: 4.h),
            child: CustomTextFormField(
              controller: heightController,
            ),
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildWeightSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.h),
          child: Text(
            "WEIGHT",
            style: CustomTextStyles.bodyMediumGray700,
          ),
        ),
        SizedBox(height: 4.v),
        Padding(
          padding: EdgeInsets.only(left: 4.h),
          child: CustomTextFormField(
            controller: weightController,
            textInputAction: TextInputAction.done,
          ),
        )
      ],
    );
  }
}
