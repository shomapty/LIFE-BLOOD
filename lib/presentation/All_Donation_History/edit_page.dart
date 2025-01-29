import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditDonationDetailsPage extends StatefulWidget {
  final String recordId;

  const EditDonationDetailsPage({Key? key, required this.recordId}) : super(key: key);

  @override
  _EditDonationDetailsPageState createState() => _EditDonationDetailsPageState();
}

class _EditDonationDetailsPageState extends State<EditDonationDetailsPage> {
  TextEditingController _icNumberController = TextEditingController();
  TextEditingController _bloodIdController = TextEditingController();
  TextEditingController _placeController = TextEditingController();
  TextEditingController _haemoglobinController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  String bloodType = 'Select new blood type';
  String status = 'Select new status';

  @override
  void initState() {
    super.initState();
    fetchRecordDetails();
  }

  Future<void> fetchRecordDetails() async {
    try {
      // Fetch the details of the record using the recordId
      DocumentSnapshot<Map<String, dynamic>> recordSnapshot =
      await FirebaseFirestore.instance.collection('Donation Record').doc(widget.recordId).get();

      // Set the initial values of the text controllers
      setState(() {
        _icNumberController.text = recordSnapshot['icNumber'];
        _bloodIdController.text = recordSnapshot['bloodId'];
        bloodType = recordSnapshot['bloodType'];
        status = recordSnapshot['status'];
        _placeController.text = recordSnapshot['place'];
        _haemoglobinController.text = recordSnapshot['haemoglobin'];
        _dateController.text = recordSnapshot['date'] != null ? (recordSnapshot['date'] as Timestamp).toDate().toString().substring(0, 10) : '';
      });
    } catch (e) {
      print('Error fetching record details: $e');
    }
  }

  void updateRecord() async {
    try {
      // Update the record in Firebase with the new data
      await FirebaseFirestore.instance.collection('Donation Record').doc(widget.recordId).update({
        'icNumber': _icNumberController.text,
        'bloodId': _bloodIdController.text,
        'bloodType': bloodType,
        'status': status,
        'place': _placeController.text,
        'haemoglobin': _haemoglobinController.text,
        // Update other fields similarly
      });

      // Navigate back to the previous page after successful update
      Navigator.pop(context);
    } catch (e) {
      print('Error updating record: $e');
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Donation Details'),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _icNumberController,
              decoration: InputDecoration(labelText: 'IC Number',labelStyle: TextStyle(fontSize: 14),),
            ),
            TextField(
              controller: _bloodIdController,
              decoration: InputDecoration(labelText: 'Blood ID',labelStyle: TextStyle(fontSize: 14),),
            ),
            SizedBox(height: 10,),
            bloodTypeDropDownMenu(),
            TextField(
              controller: _placeController,
              decoration: InputDecoration(labelText: 'Place',labelStyle: TextStyle(fontSize: 14),),
            ),
            TextField(
              controller: _haemoglobinController,
              decoration: InputDecoration(labelText: 'Haemoglobin Level',labelStyle: TextStyle(fontSize: 14),),
            ),
            TextField(
              controller: _dateController,
              decoration: InputDecoration(labelText: 'Date',labelStyle: TextStyle(fontSize: 14),),
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 10,),
            StatusDropDownMenu(),
            SizedBox(height: 40),
            Center(
              child: Container(
                width: 250,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    // Call the function to update the record
                    updateRecord();
                  },
                  child: Text('Apply Update',style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column bloodTypeDropDownMenu() {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            "Blood Type",
            style: TextStyle(fontSize: 14),
          ),
        ),
        SizedBox(height: 5,),
        DropdownButtonFormField<String>(
          value: bloodType,
          onChanged: (newValue) {
            setState(() {
              bloodType = newValue!;
            });
          },
          validator: (val) => val!.isEmpty ? 'Select blood type' : null,
          items: <String>[
            'Select new blood type',
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
            floatingLabelBehavior: FloatingLabelBehavior.always,          ),
        ),
      ],
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
          child: DropdownButtonFormField<String>(
            value: status,
            onChanged: (newValue) {
              setState(() {
                status = newValue!;
              });
            },
            validator: (val) => val!.isEmpty ? 'Select status' : null,
            items: <String>[
              'Select new status',
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
            ),
          ),
        ),
      ],
    );
  }

}
