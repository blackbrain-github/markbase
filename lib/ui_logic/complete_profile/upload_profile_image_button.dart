import 'dart:io';

import 'package:Markbase/dome/widgets/listen.dart';
import 'package:Markbase/ui_logic/common/app.dart';
import 'package:Markbase/ui_logic/common/widgets/custom_animated_widget.dart';
import 'package:Markbase/ui_logic/complete_profile/complete_profile_screen_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';

class UploadProfileImageButton extends HookWidget {
  final CompleteProfileScreenLogic logic;
  const UploadProfileImageButton(this.logic, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomAnimatedWidget(
      child: Listen(
        to: logic.profileImage,
        builder: (File? image) {
          return Container(
            height: 100,
            width: 100,
            color: AppColors.getSecondaryTextColor(),
            alignment: Alignment.center,
            child: Stack(
              children: [
                Icon(
                  Icons.edit_rounded,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 26,
                ),
                if (image != null)
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: Image.file(
                      File(image.path),
                      fit: BoxFit.cover,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
      onPressed: () async {
        final ImagePicker _picker = ImagePicker();
        await _picker.pickImage(source: ImageSource.gallery, maxHeight: 500, maxWidth: 500).then((XFile? imageFile) async {
          if (imageFile != null) {
            logic.profileImage.set(File(imageFile.path));
          }
        });
      },
    );
  }
}
