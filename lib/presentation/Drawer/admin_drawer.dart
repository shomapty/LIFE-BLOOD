import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../routes/app_routes.dart';

class AdminDrawer extends StatefulWidget {
  @override
  State<AdminDrawer> createState() => _AdminDrawerState();
}

class _AdminDrawerState extends State<AdminDrawer> {
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
                    child: Text("ADMIN PROFILE",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 25),),
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
                    title: Text('HOME', style: TextStyle(color: Colors.black, fontFamily: "Gotham", fontSize: 16.0 ),),
                    leading: Icon(Icons.home, color: Colors.red,),
                    onTap: () {
                      onTapScreenTitle(AppRoutes.campaignPostSceen);
                    },
                  ),
                  ListTile(
                    title: Text('POST CAMPAIGN', style: TextStyle(color: Colors.black, fontFamily: "Gotham", fontSize: 16.0 ),),
                    leading: Icon(Icons.local_hospital_outlined, color: Colors.red,),
                    onTap: () {
                      onTapScreenTitle(AppRoutes.campaign_information_Screen);
                    },
                  ),
                  ListTile(
                    title: Text('ADD STAFF', style: TextStyle(color: Colors.black, fontFamily: "Gotham", fontSize: 16.0 ),),
                    leading: Icon(Icons.verified_user, color: Colors.red,),
                    onTap: () {
                      onTapScreenTitle(AppRoutes.addStaff);
                    },
                  ),
                  ListTile(
                    title: Text('MANAGE ACCOUNT', style: TextStyle(color: Colors.black, fontFamily: "Gotham", fontSize: 16.0 ),),
                    leading: Icon(Icons.settings, color: Colors.red,),
                    onTap: () {
                      onTapScreenTitle(AppRoutes.userManagement);
                    },
                  ),
                  ListTile(
                    title: Text('SIGN OUT', style: TextStyle(color: Colors.black, fontFamily: "Gotham", fontSize: 16.0 ),),
                    leading: Icon(Icons.lock_open_sharp, color: Colors.red,),
                    onTap: () async{
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