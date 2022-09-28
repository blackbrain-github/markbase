import 'package:Markbase/dome/show.dart';
import 'package:Markbase/dome/widgets/listen.dart';
import 'package:Markbase/models/collection.dart';
import 'package:Markbase/ui_logic/common/widgets/collection_widget.dart';
import 'package:Markbase/ui_logic/common/widgets/column_with_spacing.dart';
import 'package:Markbase/ui_logic/common/widgets/custom_animated_widget.dart';
import 'package:Markbase/ui_logic/common/widgets/custom_text.dart';
import 'package:Markbase/ui_logic/database/database_screen_logic.dart';
import 'package:Markbase/ui_logic/database/widgets/new_collection_form/new_collection_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Collections extends HookWidget {
  final DatabaseScreenLogic logic;
  const Collections(this.logic, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CustomText(
              "Collections:",
              size: 16,
              fontWeight: FontWeight.w600,
              color: TextColorType.secondary,
            ),
            CustomAnimatedWidget(
              onPressed: () {
                Show(context).bottomSheet(NewCollectionPopup(logic), useBase: false);
              },
              child: const CustomText(
                "New collection",
                size: 16,
                fontWeight: FontWeight.w600,
                color: TextColorType.accent,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Listen(
          to: logic.currentCollection,
          builder: (Collection currentCollection) {
            print("Current collection collectionCount: ${currentCollection.collections?.length}");
            return (currentCollection.collections?.isNotEmpty ?? false)
                ? ColumnWithSpacing(
                    d: 5,
                    children: List.generate(
                      currentCollection.collections?.length ?? 0,
                      (index) => CollectionWidget(
                        currentCollection.collections!.elementAt(index),
                        onPressed: () {
                          logic.goToCollection(currentCollection.collections![index]);
                        },
                      ),
                    ),
                  )
                : const SizedBox(
                    height: 30,
                    child: Center(
                      child: CustomText(
                        "No collections",
                        size: 16,
                        fontWeight: FontWeight.w600,
                        color: TextColorType.secondary,
                      ),
                    ),
                  );
          },
        )
      ],
    );
  }
}
