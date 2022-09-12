import 'dart:io';

import 'package:Markbase/dome/navigate.dart';
import 'package:Markbase/dome/show.dart';
import 'package:Markbase/dome/variable_notifier.dart';
import 'package:Markbase/services/database.dart';
import 'package:Markbase/services/functions.dart';
import 'package:Markbase/ui_logic/common/constants.dart';
import 'package:Markbase/ui_logic/master.dart';
import 'package:flutter/material.dart';

class CompleteProfileScreenLogic {
  final BuildContext context;
  final VariableNotifier<File?> profileImage;
  final VariableNotifier<String?> username;
  final VariableNotifier<bool> loading;
  GlobalKey<FormState> usernameKey = GlobalKey<FormState>();

  CompleteProfileScreenLogic(
    this.context, {
    required this.profileImage,
    required this.username,
    required this.loading,
  });

  String? validUsername(String s) {
    if (s.isEmpty) {
      return "This field cannot be empty";
    } else if (s.length > 21) {
      return "Username cannot be longer than 21 characters";
    } else if (!s.contains(RegExp(r'^[a-zA-Z0-9.]*$'))) {
      return "Username can only have letters, numbers and periods";
    } else {
      return null;
    }
  }

  Future<void> updateUsernameAndProfileImage() async {
    if (usernameKey.currentState?.validate() ?? false) {
      usernameKey.currentState?.save();
      if (username.get != null) {
        if (await Functions.isUsernameAvailable(username.get!) == false) {
          Show(context).errorMessage(message: "Username not available");
        } else {
          try {
            await Database.create.user(username.get!, "full name waaat");
            if (profileImage.get != null) await Database.modify.userProfileImage(profileImage.get!);
            FirebaseConstants.auth.currentUser?.reload();
            Navigate(context).to(const Master());
          } catch (e) {
            print(e);
            Show(context).errorMessage(message: "Something went wrong");
            profileImage.set(null);
          }
        }
      } else {
        throw "Username is null";
      }
    }
  }
}
