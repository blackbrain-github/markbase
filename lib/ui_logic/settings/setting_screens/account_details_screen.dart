import 'dart:io';

import 'package:Markbase/dome/app_specific/common_logic.dart';
import 'package:Markbase/dome/show.dart';
import 'package:Markbase/dome/widgets/buttons/custom_small_button.dart';
import 'package:Markbase/dome/widgets/custom_animated_widget.dart';
import 'package:Markbase/dome/widgets/custom_text.dart';
import 'package:Markbase/dome/widgets/listen.dart';
import 'package:Markbase/dome/widgets/screen.dart';
import 'package:Markbase/models/user.dart';
import 'package:Markbase/services/database.dart';
import 'package:Markbase/ui_logic/settings/settings_screen_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AccountDetailsScreen extends HookWidget {
  final SettingsScreenLogic logic;
  const AccountDetailsScreen(this.logic, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Listen(
      to: CommonLogic.appUser,
      builder: (UserModel? user) {
        return Screen(
          title: "Account details",
          child: (user == null)
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CustomText('Something went wrong'),
                      const SizedBox(height: 10),
                      CustomSmallButton(onPressed: () => CommonLogic.getAppUser(notify: true), title: 'Refresh'),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async => await CommonLogic.getAppUser(notify: true),
                  child: ListView(
                    children: [
                      const SizedBox(height: 20),
                      Builder(
                        builder: (context) {
                          File? profileImageTemp;
                          var x = false;
                          var y = false;
                          var s = false;
                          var t1 = 0.0;
                          var t2 = 0.0;

                          return StatefulBuilder(
                            builder: (context, setState) {
                              return CustomAnimatedWidget(
                                onPressed: () async {
                                  void pickImage() async {
                                    final ImagePicker _picker = ImagePicker();
                                    await _picker.pickImage(source: ImageSource.gallery, maxHeight: 500, maxWidth: 500).then((XFile? imageFile) async {
                                      if (imageFile != null) {
                                        setState(() {
                                          profileImageTemp = File(imageFile.path);
                                        });
                                        await Database.modify.userProfileImage(File(imageFile.path));
                                        await CommonLogic.getAppUser();
                                      }
                                    });
                                  }

                                  var status = await Permission.photos.status;
                                  if (status.isGranted) {
                                    pickImage();
                                  } else {
                                    var request = await Permission.photos.request();
                                    if (request.isGranted) {
                                      pickImage();
                                    } else {
                                      if (request.isPermanentlyDenied) {
                                        Show(context).errorMessage(message: 'We cannot pick a new profile photo without access to photos. Please go to settings to allows access to photos');
                                      } else {
                                        Show(context).errorMessage(message: 'We cannot pick a new profile photo without access to photos');
                                      }
                                    }
                                  }
                                },
                                child: SizedBox(
                                  height: MediaQuery.of(context).size.width * 0.3,
                                  width: MediaQuery.of(context).size.width * 0.3,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Stack(
                                      children: [
                                        Positioned.fill(
                                          child: profileImageTemp != null
                                              ? Image.file(
                                                  File(profileImageTemp!.path),
                                                  fit: BoxFit.cover,
                                                )
                                              : user.profileImageUrl != ''
                                                  ? Image.network(
                                                      user.profileImageUrl,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Container(color: Colors.grey),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          child: Container(
                                            color: Colors.black.withOpacity(0.4),
                                            width: MediaQuery.of(context).size.width * 0.3,
                                            padding: const EdgeInsets.symmetric(vertical: 7),
                                            alignment: Alignment.center,
                                            child: const CustomText(
                                              'Edit',
                                              customColor: Colors.white,
                                            ),
                                          ),
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
                      const SizedBox(height: 20),
                      const CustomText(
                        'Username:',
                        size: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      CustomText(user.username),
                      const SizedBox(height: 20),
                      const CustomText(
                        'Email:',
                        size: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      CustomText(user.email),
                      const SizedBox(height: 20),
                      const CustomText(
                        'Full name:',
                        size: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      CustomText(user.fullName),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        alignment: Alignment.centerLeft,
                        child: CustomAnimatedWidget(
                          onPressed: () => logic.logOut(context),
                          child: const CustomText(
                            'log out',
                            size: 16,
                            fontWeight: FontWeight.w600,
                            color: TextColorType.accent,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        alignment: Alignment.centerLeft,
                        child: CustomAnimatedWidget(
                          onPressed: () async {
                            await Show(context).areYouSureYouWantToDeleteAccount();
                          },
                          child: const CustomText(
                            'delete account',
                            size: 16,
                            fontWeight: FontWeight.w600,
                            color: TextColorType.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
