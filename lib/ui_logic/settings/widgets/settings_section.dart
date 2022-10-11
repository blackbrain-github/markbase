import 'package:Markbase/dome/widgets/column_with_spacing.dart';
import 'package:Markbase/dome/widgets/custom_text.dart';
import 'package:Markbase/ui_logic/settings/widgets/setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SettingsSection extends HookWidget {
  final String title;
  final List<Setting> settings;
  final double settingSpacing;
  const SettingsSection({required this.title, required this.settings, this.settingSpacing = 0, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          title,
          size: 20,
          fontWeight: FontWeight.w600,
        ),
        ColumnWithSpacing(
          d: settingSpacing,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: settings,
        )
      ],
    );
  }
}
