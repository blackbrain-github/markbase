import 'package:Markbase/dome/app_specific/app.dart';
import 'package:Markbase/dome/app_specific/common_logic.dart';
import 'package:Markbase/dome/widgets/listen.dart';
import 'package:Markbase/models/collection.dart';
import 'package:Markbase/ui_logic/common_widgets/custom_text.dart';
import 'package:Markbase/ui_logic/database/database_screen_logic.dart';
import 'package:Markbase/ui_logic/database/widgets/navigation_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class BottomBar extends HookWidget {
  final DatabaseScreenLogic logic;
  const BottomBar(this.logic, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Listen(
        to: CommonLogic.theme,
        builder: (_) {
          return Container(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewPadding.bottom),
            color: AppColors.getNoteColor(),
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                color: AppColors.getNoteColor(),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.getShadowColor(),
                    blurRadius: 20,
                    offset: const Offset(0, -20),
                  )
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Listen(
                      to: logic.currentCollection,
                      builder: (Collection collection) {
                        String path = '';
                        String title = '';

                        if (collection.isRoot()) {
                          path = '/';
                          title = '';
                        } else {
                          path = collection.path.replaceAll(collection.title!, "");
                          title = collection.title!;
                        }

                        return Row(
                          children: [
                            NavigationButton(logic),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                height: 40,
                                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: AppColors.getPrimaryBackgroundColor(),
                                ),
                                alignment: Alignment.centerLeft,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  reverse: true,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        path,
                                        size: 16,
                                        color: TextColorType.secondary,
                                        fontWeight: FontWeight.w600,
                                        maxLines: 1,
                                        textAlign: TextAlign.end,
                                      ),
                                      CustomText(
                                        title,
                                        size: 16,
                                        color: TextColorType.primary,
                                        fontWeight: FontWeight.w600,
                                        maxLines: 1,
                                        textAlign: TextAlign.end,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
