import 'package:Markbase/dome/app_specific/common_logic.dart';
import 'package:Markbase/ui_logic/common_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MarkbaseDetails extends HookWidget {
  const MarkbaseDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText(
            'Markbase is ${(DateTime.now().difference(DateTime(2022, 9, 20, 00, 00)).inDays / 30).ceil().toString()} months old',
            color: TextColorType.secondary,
            fontWeight: FontWeight.w500,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CustomText(
                'version ',
                color: TextColorType.secondary,
                fontWeight: FontWeight.w500,
              ),
              CustomText(
                CommonLogic.localVersion.get ?? '',
                color: TextColorType.secondary,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
