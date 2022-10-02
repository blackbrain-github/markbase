import 'dart:io';

import 'package:Markbase/dome/widgets/custom_text.dart';
import 'package:Markbase/dome/widgets/screen.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:package_info_plus/package_info_plus.dart';

class UpdateRequired extends HookWidget {
  const UpdateRequired({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<String> getLocalVersion() async {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.version;
    }

    String getMinimumRequiredVersion() {
      if (Platform.isIOS) {
        return FirebaseRemoteConfig.instance.getString('minimum_required_version_ios');
      } else {
        return FirebaseRemoteConfig.instance.getString('minimum_required_version_android');
      }
    }

    return MaterialApp(
      home: Screen(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CustomText(
                'Markbase has been updated and some of its core functionalities have been altered. You are required to update the app before using it.',
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
              const SizedBox(height: 20),
              FutureBuilder(
                future: getLocalVersion(),
                builder: (context, AsyncSnapshot<String> localVersion) {
                  if (localVersion.hasData) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CustomText(
                          'Your current version is ',
                          textAlign: TextAlign.center,
                          softWrap: true,
                        ),
                        CustomText(
                          '${localVersion.data} ',
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.center,
                          softWrap: true,
                        ),
                        const CustomText(
                          'and ',
                          textAlign: TextAlign.center,
                          softWrap: true,
                        ),
                        CustomText(
                          '${getMinimumRequiredVersion()} ',
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.center,
                          softWrap: true,
                        ),
                        const CustomText(
                          'is required',
                          textAlign: TextAlign.center,
                          softWrap: true,
                        ),
                      ],
                    );
                  }
                  return Container();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
