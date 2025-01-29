import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Drawer/admin_drawer.dart';
import '../Drawer/donor_drawer.dart';
import '../Drawer/staff_drawer.dart';
import 'edit_page.dart';

class EditAllDonationHistory extends StatefulWidget {
  const EditAllDonationHistory({Key? key}) : super(key: key);

  @override
  State<EditAllDonationHistory> createState() => _EditAllDonationHistoryState();
}

class _EditAllDonationHistoryState extends State<EditAllDonationHistory> {

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
        stream: FirebaseFirestore.instance
            .collection('Donation Record')
            .snapshots(),
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

          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No blood donation records found.'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var record = snapshot.data!.docs[index];
              return Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.grey[200], // Change color as per your preference
                ),
                child: ListTile(
                  title: Row(
                    children: [
                      Text(
                        'Ic Number: ',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        record['icNumber'],
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Blood ID: ',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            record['bloodId'],
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Blood Type: ',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            record['bloodType'],
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Place: ',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            record['place'],
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Haemoglobin Level: ',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            record['haemoglobin'],
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Date: ',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            record['date'] != null ? (record['date'] as Timestamp).toDate().toString().substring(0, 10) : '',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Status: ',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            record['status'],
                            style: TextStyle(color: Colors.red),
                          ),
                          SizedBox(width: 80,),
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 30,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          // Navigate to a new page where users can edit details
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => EditDonationDetailsPage(recordId: record.id),
                                            ),
                                          );
                                        },
                                        child: Icon(Icons.edit,color: Colors.white,)
                                    ),
                                  ),
                                  SizedBox(width: 20,),
                                  Container(
                                    width: 50,
                                    height: 30,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // Delete the record from Firebase
                                        FirebaseFirestore.instance.collection('Donation Record').doc(record.id).delete();
                                      },
                                      child: Icon(Icons.delete,color: Colors.white,),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
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
