import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smuctblooddonation/core/utils/size_utils.dart';
import '../../theme/custom_text_style.dart';
import '../../widgets/custom_text_form_field.dart';
import '../Drawer/staff_drawer.dart';

class ReadyToDonate extends StatefulWidget {
  const ReadyToDonate({Key? key}) : super(key: key);

  @override
  State<ReadyToDonate> createState() => _ReadyToDonateState();
}

class _ReadyToDonateState extends State<ReadyToDonate> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _deleteDonationForm(String docId) async {
    try {
      await _firestore.collection('Donation Form').doc(docId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Donation Form Deleted', style: TextStyle(color: Colors.red)),
          backgroundColor: Colors.white,
        ),
      );
      print('Donation form data deleted successfully');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting donation form: $e', style: TextStyle(color: Colors.red)),
          backgroundColor: Colors.white,
        ),
      );
      print('Error deleting donation form data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        title: Text(
          "Ready to Donate",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      drawer: StaffDrawer(),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('Donation Form').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              return Card(
                color: Colors.grey[300],
                margin: EdgeInsets.all(10),
                child: ListTile(
                  title: Text(doc['name'],style: TextStyle(fontWeight: FontWeight.bold),),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email : ${doc['email']}'),
                      SizedBox(height: 5),
                      Text('Age : ${doc['age']}'),
                      SizedBox(height: 5),
                      Text('Height : ${doc['height']}'),
                      SizedBox(height: 5),
                      Text('Weight : ${doc['weight']}'),
                      SizedBox(height: 5),
                      Text('Race : ${doc['race']}'),
                      SizedBox(height: 5),
                      Text('Ic Number : ${doc['icNumber']}'),
                      SizedBox(height: 5),
                      Text('Hp Number : ${doc['hpNumber']}'),
                      SizedBox(height: 5),
                      Text('Marital Status : ${doc['maritalStatus']}'),
                      SizedBox(height: 5),
                      Text('Address : ${doc['address']}'),
                      SizedBox(height: 5),
                      Text('Current Job : ${doc['currentJob']}'),
                      SizedBox(height: 5),
                    ],
                  ),
                  trailing: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: IconButton(
                          icon: Icon(Icons.edit, color: Colors.red),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditDonationForm(doc: doc),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 10,),
                      Expanded(
                        child: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _deleteDonationForm(doc.id);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class EditDonationForm extends StatefulWidget {
  final DocumentSnapshot doc;

  const EditDonationForm({required this.doc, Key? key}) : super(key: key);

  @override
  _EditDonationFormState createState() => _EditDonationFormState();
}

class _EditDonationFormState extends State<EditDonationForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _ageController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _raceController;
  late TextEditingController _icNumberController;
  late TextEditingController _hpNumberController;
  late TextEditingController _maritalStatusController;
  late TextEditingController _addressController;
  late TextEditingController _currentJobController;

  TextEditingController bloodIdController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController haemoglobinController = TextEditingController();
  String status = 'In Process';
  String bloodType = 'A+';
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.doc['name']);
    _emailController = TextEditingController(text: widget.doc['email']);
    _ageController = TextEditingController(text: widget.doc['age']);
    _heightController = TextEditingController(text: widget.doc['height']);
    _weightController = TextEditingController(text: widget.doc['weight']);
    _raceController = TextEditingController(text: widget.doc['race']);
    _icNumberController = TextEditingController(text: widget.doc['icNumber']);
    _hpNumberController = TextEditingController(text: widget.doc['hpNumber']);
    _maritalStatusController = TextEditingController(text: widget.doc['maritalStatus']);
    _addressController = TextEditingController(text: widget.doc['address']);
    _currentJobController = TextEditingController(text: widget.doc['currentJob']);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _raceController.dispose();
    _icNumberController.dispose();
    _hpNumberController.dispose();
    _maritalStatusController.dispose();
    _addressController.dispose();
    _currentJobController.dispose();
    super.dispose();
  }

  Future<void> _updateDonationForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        await widget.doc.reference.update({
          'name': _nameController.text,
          'bloodId': bloodIdController.text,
          'haemo': haemoglobinController.text,
          'place': placeController.text,
          'email': _emailController.text,
          'age': _ageController.text,
          'height': _heightController.text,
          'weight': _weightController.text,
          'race': _raceController.text,
          'icNumber': _icNumberController.text,
          'hpNumber': _hpNumberController.text,
          'maritalStatus': _maritalStatusController.text,
          'address': _addressController.text,
          'currentJob': _currentJobController.text,
        });
        //save donation record
        _saveDonationData(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Donation Form Uploaded', style: TextStyle(color: Colors.green)),
            backgroundColor: Colors.white,
          ),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating donation form: $e', style: TextStyle(color: Colors.red)),
            backgroundColor: Colors.white,
          ),
        );
      }
    }
  }

  Future<void> _saveDonationData(BuildContext context) async {
    try {
      // Get inputted data from the controller
      String bloodId = bloodIdController.text;
      String icNumber = _icNumberController.text;
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
          "Insert Donation Record",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      drawer: StaffDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 10,),
              _buildBloodIdSection(),
              SizedBox(height: 10,),
              _HaemoglobinLevel(),
              SizedBox(height: 10,),
              _buildPlaceSection(),
              SizedBox(height: 10,),
              bloodTypeDropDownMenu(),
              SizedBox(height: 10,),
              StatusDropDownMenu(),
              SizedBox(height: 10,),
              dateSection(),
              SizedBox(height: 10,),
              _nameSection(),
              SizedBox(height: 10,),
              _emailSection(),
              SizedBox(height: 10,),
              _ageSection(),
              SizedBox(height: 10,),
              _heightSection(),
              SizedBox(height: 10,),
              _weightSection(),
              SizedBox(height: 10,),
              _raceSection(),
              SizedBox(height: 10,),
              _buildDonorIcSection(),
              SizedBox(height: 10,),
              _hpSection(),
              SizedBox(height: 10,),
              _maritalSection(),
              SizedBox(height: 10,),
              _addressSection(),
              SizedBox(height: 10,),
              _jobSection(),
              SizedBox(height: 20),
              Container(
                height: 45,
                width: MediaQuery.of(context).size.width/2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.red
                ),
                child: TextButton(
                  onPressed: _updateDonationForm,
                  child: Text('Insert and Update',style: TextStyle(
                    color: Colors.white,
                    fontSize: 18
                  ),),
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
  Widget _maritalSection() {
    return Container(
      margin: EdgeInsets.only(right: 5.h),
      padding: EdgeInsets.symmetric(horizontal: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "RACE",
            style: CustomTextStyles.bodyMediumGray700_1,
          ),
          SizedBox(height: 4.v),
          CustomTextFormField(
            controller: _raceController,
            textInputType: TextInputType.emailAddress,
          )
        ],
      ),
    );
  }

  Widget _raceSection() {
    return Container(
      margin: EdgeInsets.only(right: 5.h),
      padding: EdgeInsets.symmetric(horizontal: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "RACE",
            style: CustomTextStyles.bodyMediumGray700_1,
          ),
          SizedBox(height: 4.v),
          CustomTextFormField(
            controller: _raceController,
            textInputType: TextInputType.emailAddress,
          )
        ],
      ),
    );
  }

  Widget _hpSection() {
    return Container(
      margin: EdgeInsets.only(right: 5.h),
      padding: EdgeInsets.symmetric(horizontal: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "HP",
            style: CustomTextStyles.bodyMediumGray700_1,
          ),
          SizedBox(height: 4.v),
          CustomTextFormField(
            controller: _hpNumberController,
            textInputType: TextInputType.emailAddress,
          )
        ],
      ),
    );
  }

  Widget _jobSection() {
    return Container(
      margin: EdgeInsets.only(right: 5.h),
      padding: EdgeInsets.symmetric(horizontal: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "CURRENT JOB",
            style: CustomTextStyles.bodyMediumGray700_1,
          ),
          SizedBox(height: 4.v),
          CustomTextFormField(
            controller: _currentJobController,
            textInputType: TextInputType.emailAddress,
          )
        ],
      ),
    );
  }

  Widget _addressSection() {
    return Container(
      margin: EdgeInsets.only(right: 5.h),
      padding: EdgeInsets.symmetric(horizontal: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "ADDRESS",
            style: CustomTextStyles.bodyMediumGray700_1,
          ),
          SizedBox(height: 4.v),
          CustomTextFormField(
            controller: _addressController,
            textInputType: TextInputType.emailAddress,
          )
        ],
      ),
    );
  }

  Widget _weightSection() {
    return Container(
      margin: EdgeInsets.only(right: 5.h),
      padding: EdgeInsets.symmetric(horizontal: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "WEIGHT",
            style: CustomTextStyles.bodyMediumGray700_1,
          ),
          SizedBox(height: 4.v),
          CustomTextFormField(
            controller: _weightController,
            textInputType: TextInputType.emailAddress,
          )
        ],
      ),
    );
  }

  Widget _heightSection() {
    return Container(
      margin: EdgeInsets.only(right: 5.h),
      padding: EdgeInsets.symmetric(horizontal: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "HEIGHT",
            style: CustomTextStyles.bodyMediumGray700_1,
          ),
          SizedBox(height: 4.v),
          CustomTextFormField(
            controller: _heightController,
            textInputType: TextInputType.emailAddress,
          )
        ],
      ),
    );
  }

  Widget _emailSection() {
    return Container(
      margin: EdgeInsets.only(right: 5.h),
      padding: EdgeInsets.symmetric(horizontal: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "EMAIL",
            style: CustomTextStyles.bodyMediumGray700_1,
          ),
          SizedBox(height: 4.v),
          CustomTextFormField(
            controller: _emailController,
            textInputType: TextInputType.emailAddress,
          )
        ],
      ),
    );
  }

  Widget _ageSection() {
    return Container(
      margin: EdgeInsets.only(right: 5.h),
      padding: EdgeInsets.symmetric(horizontal: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "AGE",
            style: CustomTextStyles.bodyMediumGray700_1,
          ),
          SizedBox(height: 4.v),
          CustomTextFormField(
            controller: _ageController,
            textInputType: TextInputType.emailAddress,
          )
        ],
      ),
    );
  }

  Widget _nameSection() {
    return Container(
      margin: EdgeInsets.only(right: 5.h),
      padding: EdgeInsets.symmetric(horizontal: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "NAME",
            style: CustomTextStyles.bodyMediumGray700_1,
          ),
          SizedBox(height: 4.v),
          CustomTextFormField(
            controller: _nameController,
            textInputType: TextInputType.emailAddress,
          )
        ],
      ),
    );
  }

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
            controller: _icNumberController,
            textInputType: TextInputType.phone,
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
