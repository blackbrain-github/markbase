import 'package:Markbase/ui_logic/common/widgets/column_with_spacing.dart';
import 'package:Markbase/ui_logic/common/widgets/screen.dart';
import 'package:Markbase/ui_logic/settings/settings_screen_logic.dart';
import 'package:Markbase/ui_logic/settings/widgets/markbase_details.dart';
import 'package:Markbase/ui_logic/settings/widgets/setting.dart';
import 'package:Markbase/ui_logic/settings/widgets/settings_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SettingsScreen extends HookWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SettingsScreenLogic logic = SettingsScreenLogic();

    return Screen(
      child: SingleChildScrollView(
        child: ColumnWithSpacing(
          d: 30,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingsSection(
              title: 'Look',
              settings: [
                Setting(
                  type: SettingType.option,
                  title: 'Theme',
                  options: const ['Light', 'Dark'],
                  selectedOption: logic.theme.characters.first.toUpperCase() + logic.theme.substring(1),
                  onTap: (theme) => logic.changeTheme(theme),
                ),
                Setting(
                  type: SettingType.option,
                  title: 'Database look',
                  options: const ['Markbase', 'Tree'],
                  selectedOption: 'Markbase',
                  onTap: (databaseLook) => logic.changeDatabaseLook(databaseLook),
                ),
                Setting(
                  type: SettingType.option,
                  title: 'Initial view',
                  options: const ['Home', 'Database'],
                  selectedOption: 'Home',
                  onTap: (initialView) => logic.changeInitialView(initialView),
                ),
              ],
            ),
            SettingsSection(
              title: 'Account',
              settingSpacing: 10,
              settings: [
                Setting(
                  type: SettingType.action,
                  title: 'see account details',
                  action: () => logic.seeAccountDetails(context),
                ),
                Setting(
                  type: SettingType.action,
                  title: 'switch account',
                  action: () => logic.switchAccount(),
                ),
                Setting(
                  type: SettingType.action,
                  title: 'log out',
                  action: () => logic.logOut(context),
                ),
              ],
            ),
            SettingsSection(
              title: 'Need help with something?',
              settingSpacing: 10,
              settings: [
                Setting(
                  type: SettingType.action,
                  title: 'contact support',
                  action: () => logic.contactSupport(),
                ),
              ],
            ),
            SettingsSection(
              title: 'Help make Markbase better',
              settingSpacing: 10,
              settings: [
                Setting(
                  type: SettingType.action,
                  title: 'give feedback',
                  action: () => logic.giveFeedback(),
                ),
                Setting(
                  type: SettingType.action,
                  title: 'rate us',
                  action: () => logic.rateUs(),
                ),
                Setting(
                  type: SettingType.action,
                  title: 'suggest a new feature',
                  action: () => logic.suggestANewFeature(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const MarkbaseDetails(),
          ],
        ),
      ),
    );
  }
}
