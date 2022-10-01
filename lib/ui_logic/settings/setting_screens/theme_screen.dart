import 'package:Markbase/dome/app_specific/common_logic.dart';
import 'package:Markbase/dome/widgets/screen.dart';
import 'package:Markbase/ui_logic/settings/settings_screen_logic.dart';
import 'package:Markbase/ui_logic/settings/widgets/setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ThemeScreen extends HookWidget {
  final SettingsScreenLogic logic;
  const ThemeScreen(this.logic, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Screen(
      title: 'Theme',
      child: Setting(
        type: SettingType.option,
        options: const ['Light', 'Dark', 'System'],
        selectedOption: CommonLogic.theme.get.name.characters.first.toUpperCase() + CommonLogic.theme.get.name.substring(1),
        onTap: (theme) => logic.changeTheme(theme),
      ),
    );
  }
}
