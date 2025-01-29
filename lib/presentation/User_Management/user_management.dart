import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Drawer/admin_drawer.dart';

class UserManagement extends StatefulWidget {
  @override
  State<UserManagement> createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {


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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
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
              child: Text('No users found.'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var user = snapshot.data!.docs[index];
              return Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.grey[200], // Customize as needed
                  ),
                  child: ListTile(
                    title: Text('Type: ${user['type']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email: ${user['email']}'),
                        // Add other user details as needed
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // Implement edit functionality
                            // You can navigate to another screen to edit user information
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EditUserScreen(user: user)),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            // Implement delete functionality
                            FirebaseFirestore.instance.collection('users').doc(user.id).delete();
                          },
                        ),
                      ],
                    ),
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

class EditUserScreen extends StatefulWidget {
  final DocumentSnapshot user;

  EditUserScreen({required this.user});

  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController typeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.user['name'];
    emailController.text = widget.user['email'];
    typeController.text = widget.user['type'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name'),
            TextFormField(
              controller: nameController,
            ),
            SizedBox(height: 10.0),
            Text('Email'),
            TextFormField(
              controller: emailController,
            ),
            SizedBox(height: 10.0),
            Text('Type'),
            TextFormField(
              controller: typeController,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Update user information in Firestore
                FirebaseFirestore.instance.collection('users').doc(widget.user.id).update({
                  'name': nameController.text,
                  'email': emailController.text,
                  'type': typeController.text,
                }).then((value) {
                  Navigator.pop(context); // Close the edit screen
                }).catchError((error) {
                  print("Failed to update user: $error");
                });
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
