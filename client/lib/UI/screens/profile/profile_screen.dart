import 'package:auto_size_text/auto_size_text.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:client/UI/support/constants.dart';
import 'package:client/UI/support/size_config.dart';
import 'package:client/model/Model.dart';
import 'package:client/model/objects/user.dart';
import 'package:client/model/support/extensions/string_capitalization.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  User currentUser = Model.sharedInstance.currentUser;

  Widget CustomText(String title, String text) {
    return Material(
      elevation: 4,
      shadowColor: kPrimaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: TextStyle(
                  letterSpacing: 2,
                  color: kTextLightColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 5),
            Align(
              alignment: Alignment.centerLeft,
              child: AutoSizeText(
                text,
                style: TextStyle(
                  fontSize: 20,
                  letterSpacing: 2,
                  color: kTextLightColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget ProfileHeader(BuildContext context) {
    return Container(
        height: SizeConfig.screenHeight * 0.1,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              spreadRadius: 5,
              color: kPrimaryColor.withOpacity(0.2),
            ),
          ],
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "PROFILE",
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                ),
              )
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(children: [
        ProfileHeader(context),
        SizedBox(height: 1),
        Container(
          height: SizeConfig.screenHeight * 0.83,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10.0),
                  width: SizeConfig.screenWidth / 2,
                  height: SizeConfig.screenWidth / 2,
                  child: CircularProfileAvatar(
                    "",
                    initialsText: Text(
                        currentUser.firstName.characters.first +
                            currentUser.lastName.characters.first,
                        style: TextStyle(fontSize: 50, color: Colors.white)),
                    backgroundColor: kSecondaryColor,
                    radius: 100,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 450,
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomText('EMAIL', currentUser.email.toLowerCase()),
                          CustomText(
                              'FULL NAME',
                              currentUser.firstName +
                                  " " +
                                  currentUser.lastName),
                          CustomText('PHONE', currentUser.phone),
                          CustomText('CITY', currentUser.city.capitalize),
                        ],
                      ),
                    )
                  ],
                ),
                // Padding(
                //   padding: EdgeInsets.only(bottom: 270, left: 184),
                //   child: CircleAvatar(
                //     backgroundColor: Colors.black54,
                //     child: IconButton(
                //       icon: Icon(
                //         Icons.edit,
                //         color: Colors.white,
                //       ),
                //       onPressed: () {},
                //     ),
                //   ),
                // )
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
