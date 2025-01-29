// ignore_for_file: unnecessary_null_comparison
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smuctblooddonation/core/utils/size_utils.dart';
import '../../core/utils/image_constant.dart';
import '../../theme/theme_helper.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';
import '../Drawer/admin_drawer.dart';
import '../Drawer/donor_drawer.dart';
import '../Drawer/staff_drawer.dart';

class EditBloodStorage extends StatefulWidget {
  @override
  State<EditBloodStorage> createState() => _EditBloodStorageState();
}

class _EditBloodStorageState extends State<EditBloodStorage> {
  Widget _buildDrawer(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return SizedBox
          .shrink(); // Return an empty widget if user is not logged in
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots(),
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
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('Blood Storage').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No Blood Storage data available.'),
            );
          }

          // Display Blood Storage data wrapped with circular box decoration
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final bloodStorage = snapshot.data!.docs[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildBloodStorageItem(context, bloodStorage),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildBloodStorageItem(
      BuildContext context, DocumentSnapshot bloodStorage) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.grey[200],
      ),
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Blood Type: ${bloodStorage['bloodType']}',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8.0),
          Text(
            'Bag: ${bloodStorage['bag']}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 8.0),
          Text(
            'Date: ${bloodStorage['date'] != null ? bloodStorage['date'].toDate().toString().substring(0, 10) : 'Not specified'}',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16.0),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: 60,
              height: 30,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditBloodStoragePage(bloodStorage: bloodStorage),
                    ),
                  );
                },
                child: Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EditBloodStoragePage extends StatefulWidget {
  final DocumentSnapshot bloodStorage;

  const EditBloodStoragePage({Key? key, required this.bloodStorage})
      : super(key: key);

  @override
  _EditBloodStoragePageState createState() => _EditBloodStoragePageState();
}

class _EditBloodStoragePageState extends State<EditBloodStoragePage> {
  late TextEditingController _bagController;
  late String _bloodType = 'Select blood type';
  late DateTime _date;

  @override
  void initState() {
    super.initState();
    _bagController = TextEditingController(text: widget.bloodStorage['bag']);
    _bloodType = widget.bloodStorage['bloodType'];
    _date = widget.bloodStorage['date'].toDate();
  }

  /// Section Widget
  Column bloodTypeDropDownMenu() {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            "BLOOD TYPE",
            style: TextStyle(fontSize: 16,color: Colors.black),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey[400], // Adjust the color as needed
            borderRadius:
                BorderRadius.circular(20.0), // Adjust the radius as needed
          ),
          child: DropdownButtonFormField<String>(
            value: _bloodType,
            onChanged: (newValue) {
              setState(() {
                _bloodType = newValue!;
              });
            },
            validator: (val) => val!.isEmpty ? 'Select blood type' : null,
            items: <String>[
              'Select blood type',
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

  Widget bagSection() {
    return Padding(
      padding: EdgeInsets.only(right: 5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "BAG",
            style: TextStyle(fontSize: 16,color: Colors.black),
          ),
          SizedBox(height: 3.v),
          CustomTextFormField(
            controller: _bagController,
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
            style: TextStyle(fontSize: 16,color: Colors.black),
          ),
        ),
        SizedBox(height: 4.v),
        Container(
          height: 60,
          padding: EdgeInsets.symmetric(horizontal: 1.h),
          decoration: BoxDecoration(
            color: Colors.grey[400], // Adjust the color as needed
            borderRadius:
                BorderRadius.circular(16.0), // Adjust the radius as needed
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  _selectDate(
                      context); // Function to show the date picker dialog
                },
                child: AbsorbPointer(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, top: 5),
                    child: TextFormField(
                      controller: TextEditingController(
                        text: _date != null
                            ? DateFormat('yyyy-MM-dd').format(
                                _date) // Display selected date if available
                            : '', // Display empty text if no date is selected
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
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
      initialDate: _date,
      // Use selected date if available, else use current date
      firstDate: DateTime(1900),
      // Adjust as needed
      lastDate: DateTime.now(), // Adjust as needed
    );
    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
      });
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
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.0),
                bagSection(),
                SizedBox(height: 16.0),
                bloodTypeDropDownMenu(),
                SizedBox(height: 16.0),
                dateSection(),
                SizedBox(height: 16.0),
                CustomElevatedButton(
                  onPressed: (){
                    _saveEditedData();
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
        ),
      ),
    );
  }

  void _saveEditedData() async {
    try {
      // Update Blood Storage data in Firebase
      await widget.bloodStorage.reference.update({
        'bag': _bagController.text,
        'bloodType': _bloodType,
        'date': _date,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Blood Storage data updated successfully'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating Blood Storage data: $e'),
        ),
      );
    }
  }
}
