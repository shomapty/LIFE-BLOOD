import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart'; // Import the share package
import '../../Drawer/admin_drawer.dart';
import '../../Drawer/donor_drawer.dart';
import '../../Drawer/staff_drawer.dart';
import '../campaign_model.dart';
import 'carousel_images.dart';
import 'campaign_details.dart';

class DetailsScreen extends StatefulWidget {
  final CampaignModel camp;

  const DetailsScreen({Key? key, required this.camp}) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {

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
        title: Row(
          children: [
            Text(
              "Blood Donation",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Spacer(),
            // Wrap IconButton with Builder to ensure the correct context
            Builder(
              builder: (BuildContext context) {
                return IconButton(
                  onPressed: () {
                    // Share campaign details when share button is pressed
                    Share.share('Check out this blood donation campaign: ${widget.camp.name}\n\n${widget.camp.place}');
                  },
                  icon: Icon(Icons.share, color: Colors.black),
                );
              },
            ),
          ],
        ),
      ),
      drawer: _buildDrawer(context),
      body: Column(
        children: [
          Stack(
            children: [
              CarouselImages(widget.camp.moreImagesUrl),
            ],
          ),
          CampaignDetails(widget.camp),
        ],
      ),
    );
  }
}
