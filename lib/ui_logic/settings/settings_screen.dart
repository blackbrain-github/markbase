import 'package:Markbase/dome/navigate.dart';
import 'package:Markbase/dome/widgets/column_with_spacing.dart';
import 'package:Markbase/dome/widgets/screen.dart';
import 'package:Markbase/ui_logic/settings/setting_screens/theme_screen.dart';
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
      title: 'Settings',
      child: SingleChildScrollView(
        child: ColumnWithSpacing(
          d: 40,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingsSection(
              title: 'Look',
              settingSpacing: 0,
              settings: [
                Setting(
                  type: SettingType.action,
                  title: 'theme',
                  action: () => Navigate(context).to(ThemeScreen(logic)), // logic.suggestANewFeature(),
                ),
              ],
            ),
            SettingsSection(
              title: 'Need help with something?',
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
            SettingsSection(
              title: 'Account',
              settings: [
                Setting(
                  type: SettingType.action,
                  title: 'profile',
                  action: () => logic.accountDetails(context),
                ),
                Setting(
                  type: SettingType.action,
                  title: 'log out',
                  action: () => logic.logOut(context),
                ),
                Setting(
                  type: SettingType.action,
                  title: 'delete account',
                  action: () => logic.deleteAccount(context),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const MarkbaseDetails(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
