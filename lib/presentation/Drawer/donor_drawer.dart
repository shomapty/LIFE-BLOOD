import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../routes/app_routes.dart';

class DonorDrawer extends StatefulWidget {
  @override
  State<DonorDrawer> createState() => _DonorDrawerState();
}

class _DonorDrawerState extends State<DonorDrawer> {
  @override
  Widget build(BuildContext context) {

    return Drawer(
        elevation: 0,
        child:Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40)),
                  color: Colors.red),
              child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Image.asset("assets/images/logo.png",height: 130,width: 150,),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text("DONOR PROFILE",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 25),),
                  )
                ],
              )),
            ),


            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView(physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  ListTile(
                    title: Text('HOME', style: TextStyle(color: Colors.black, fontFamily: "Gotham", fontSize: 18.0 ),),
                    leading: Icon(Icons.home, color: Colors.red,),
                    onTap: () {
                      onTapScreenTitle(AppRoutes.campaignPostSceen);
                    },
                  ),
                  ListTile(
                    title: Text('DONATION HISTORY', style: TextStyle(color: Colors.black, fontFamily: "Gotham", fontSize: 16.0 ),),
                    leading: Icon(Icons.handshake_outlined, color: Colors.red,),
                    onTap: () {
                      onTapScreenTitle(AppRoutes.userDonationHistory);
                    },
                  ),
                  ListTile(
                    title: Text('FIND BLOOD BANK', style: TextStyle(color: Colors.black, fontFamily: "Gotham", fontSize: 16.0 ),),
                    leading: Icon(Icons.hotel_sharp, color: Colors.red,),
                    onTap: () {
                      onTapScreenTitle(AppRoutes.googleMap);
                    },
                  ),
                  ListTile(
                    title: Text('DONATION FORM', style: TextStyle(color: Colors.black, fontFamily: "Gotham", fontSize: 16.0 ),),
                    leading: Icon(Icons.font_download, color: Colors.red,),
                    onTap: () {
                      onTapScreenTitle(AppRoutes.donationFormScreen);
                    },
                  ),
                  ListTile(
                    title: Text('BLOOD STORAGE', style: TextStyle(color: Colors.black, fontFamily: "Gotham", fontSize: 16.0 ),),
                    leading: Icon(Icons.sd_storage_outlined, color: Colors.red,),
                    onTap: () {
                      onTapScreenTitle(AppRoutes.bloodStoragePage);
                    },
                  ),
                  ListTile(
                    title: Text('SIGN OUT', style: TextStyle(color: Colors.black, fontFamily: "Gotham", fontSize: 16.0 ),),
                    leading: Icon(Icons.lock_open_sharp, color: Colors.red,),
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      GoogleSignIn().signOut();
                      onTapScreenTitle(AppRoutes.loginScreen);
                      },
                  ),
                ],
    ),
            )

          ],
        )
    );
  }
  void onTapScreenTitle(String routeName) {
    Get.toNamed(routeName);
  }
}
