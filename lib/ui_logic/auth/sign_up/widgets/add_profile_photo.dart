import 'dart:io';

import 'package:Markbase/dome/app_specific/app.dart';
import 'package:Markbase/dome/show.dart';
import 'package:Markbase/dome/widgets/custom_animated_widget.dart';
import 'package:Markbase/dome/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddProfilePhoto extends StatefulWidget {
  final Function(File file) getProfileImage;
  const AddProfilePhoto({required this.getProfileImage, Key? key}) : super(key: key);

  @override
  State<AddProfilePhoto> createState() => _AddProfilePhotoState();
}

class _AddProfilePhotoState extends State<AddProfilePhoto> {
  File? profileImageTemp;

  @override
  Widget build(BuildContext context) {
    return CustomAnimatedWidget(
      onPressed: () async {
        void pickImage() async {
          final ImagePicker _picker = ImagePicker();
          await _picker.pickImage(source: ImageSource.gallery, maxHeight: 500, maxWidth: 500).then((XFile? imageFile) async {
            if (imageFile != null) {
              widget.getProfileImage(File(imageFile.path));
              setState(() {
                profileImageTemp = File(imageFile.path);
              });
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
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: profileImageTemp != null
                    ? Image.file(
                        File(profileImageTemp!.path),
                        fit: BoxFit.cover,
                      )
                    : Container(color: AppColors.getInversePrimaryBackgroundColor().withOpacity(0.2)),
              ),
              Container(
                color: Colors.black.withOpacity(0.4),
                width: MediaQuery.of(context).size.width * 0.3,
                padding: const EdgeInsets.symmetric(vertical: 7),
                alignment: Alignment.center,
                child: const CustomText(
                  'Add photo',
                  customColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
