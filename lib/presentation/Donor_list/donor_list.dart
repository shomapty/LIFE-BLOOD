import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DonationFormsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('Donation Form').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return DonationFormItem(data: data, documentId: document.id);
          }).toList(),
        );
      },
    );
  }
}

class DonationFormItem extends StatelessWidget {
  final Map<String, dynamic> data;
  final String documentId;

  DonationFormItem({required this.data, required this.documentId});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(data['name']),
      subtitle: Text('IC Number: ${data['icNumber']}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Navigate to the edit screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditDonationFormScreen(data: data, documentId: documentId)),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              try {
                // Delete document using documentId
                await FirebaseFirestore.instance.collection('Donation Form').doc(documentId).delete();
              } catch (e) {
                // Handle errors
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error deleting donation form: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class EditDonationFormScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  final String documentId;

  EditDonationFormScreen({required this.data, required this.documentId});

  @override
  Widget build(BuildContext context) {
    // Implement UI for editing the donation form using data
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Donation Form'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Edit Donation Form for ${data['name']}'),
            // Add form fields to edit the donation form data
          ],
        ),
      ),
    );
  }
}
