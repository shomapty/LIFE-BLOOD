import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../routes/app_routes.dart';


class StaffDrawer extends StatefulWidget {
  @override
  State<StaffDrawer> createState() => _StaffDrawerState();
}

class _StaffDrawerState extends State<StaffDrawer> {
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
                    child: Text("STAFF PROFILE",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 25),),
                  )
                ],
              )),
            ),


            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView(physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  // SizedBox(height: 20,), SizedBox(height: 20,),

                  // SizedBox(height: 20,), SizedBox(height: 20,),
                  Row(children: [

                  ],),
                  ListTile(
                    title: Text('HOME', style: TextStyle(color: Colors.black, fontFamily: "Gotham", fontSize: 16.0 ),),
                    leading: Icon(Icons.home, color: Colors.red,),
                    onTap: () {
                      onTapScreenTitle(AppRoutes.campaignPostSceen);
                    },
                  ),
                  ListTile(
                    title: Text('DONATION HISTORY', style: TextStyle(color: Colors.black, fontFamily: "Gotham", fontSize: 16.0 ),),
                    leading: Icon(Icons.select_all, color: Colors.red,),
                    onTap: () {
                      onTapScreenTitle(AppRoutes.editAllDonationHistory);
                    },
                  ),
                  ListTile(
                    title: Text('READY TO DONATE', style: TextStyle(color: Colors.black, fontFamily: "Gotham", fontSize: 16.0 ),),
                    leading: Icon(Icons.bloodtype_outlined, color: Colors.red,),
                    onTap: () {
                      onTapScreenTitle(AppRoutes.readyToDonate);
                    },
                  ),
                  ListTile(
                    title: Text('ADD BLOOD STORAGE', style: TextStyle(color: Colors.black, fontFamily: "Gotham", fontSize: 16.0 ),),
                    leading: Icon(Icons.add_circle_outline, color: Colors.red,),
                    onTap: () {
                      onTapScreenTitle(AppRoutes.addBloodStorage);
                    },
                  ),
                  ListTile(
                    title: Text('EDIT BLOOD STORAGE', style: TextStyle(color: Colors.black, fontFamily: "Gotham", fontSize: 16.0 ),),
                    leading: Icon(Icons.edit, color: Colors.red,),
                    onTap: () {
                      onTapScreenTitle(AppRoutes.editBloodStorage);
                    },
                  ),
                  ListTile(
                    title: Text('SIGN OUT', style: TextStyle(color: Colors.black, fontFamily: "Gotham", fontSize: 16.0 ),),
                    leading: Icon(Icons.lock_open_sharp, color: Colors.red,),
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      onTapScreenTitle(AppRoutes.loginScreen);
                    },
                  ),
                ],),
            )

          ],
        )
    );
  }
  void onTapScreenTitle(String routeName) {
    Get.toNamed(routeName);
  }
}