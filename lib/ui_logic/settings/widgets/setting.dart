import 'package:Markbase/ui_logic/common/app.dart';
import 'package:Markbase/ui_logic/common/common_logic.dart';
import 'package:Markbase/ui_logic/common/widgets/buttons/important_button.dart';
import 'package:Markbase/ui_logic/common/widgets/custom_animated_widget.dart';
import 'package:Markbase/ui_logic/common/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Setting extends HookWidget {
  final SettingType type;
  final String title;

  // for option type
  final List<String>? options;
  String? selectedOption;
  final Function? onTap;

  // for seperateScreen type
  final Function()? action;

  Setting({
    required this.type,
    this.title = '',
    this.options,
    this.selectedOption,
    this.onTap,
    this.action,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case SettingType.option:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (title != '')
              CustomText(
                title + ':',
                textAlign: TextAlign.start,
                fontWeight: FontWeight.w600,
                size: 16,
              ),
            const SizedBox(height: 5),
            SizedBox(
              height: 30,
              child: StatefulBuilder(
                builder: (context, setState) {
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: options!.length,
                    itemBuilder: (_, i) {
                      return ImportantButton(
                        onPressed: () async {
                          await onTap!(options![i]);
                          setState(() {
                            selectedOption = options![i];
                          });
                        },
                        title: options![i],
                        selected: selectedOption == options![i],
                      );
                    },
                    separatorBuilder: (_, i) => const SizedBox(width: 5),
                  );
                },
              ),
            ),
          ],
        );

      case SettingType.action:
        return CustomAnimatedWidget(
          onPressed: () => action!(),
          child: Container(
            color: Colors.white.withOpacity(0),
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  title,
                  size: 16,
                  fontWeight: FontWeight.w600,
                  color: TextColorType.accent,
                ),
                Icon(
                  Icons.arrow_right_rounded,
                  color: CommonLogic.theme.get.name == 'light' ? Colors.black.withOpacity(0.15) : AppColors.getInversePrimaryBackgroundColor().withOpacity(0.2),
                ),
              ],
            ),
          ),
        );
      default:
        return Container();
    }
  }
}

enum SettingType { option, action }
