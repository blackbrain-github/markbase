import 'package:Markbase/dome/show.dart';
import 'package:Markbase/dome/widgets/column_with_spacing.dart';
import 'package:Markbase/dome/widgets/custom_animated_widget.dart';
import 'package:Markbase/dome/widgets/listen.dart';
import 'package:Markbase/models/collection.dart';
import 'package:Markbase/ui_logic/common_widgets/collection_widget.dart';
import 'package:Markbase/ui_logic/common_widgets/custom_text.dart';
import 'package:Markbase/ui_logic/database/database_screen_logic.dart';
import 'package:Markbase/ui_logic/database/widgets/new_collection_form.dart';
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
              onPressed: () async {
                Collection newCollection = await Show(context).bottomSheet(NewCollectionPopup(logic), useBase: false);
                List<Collection> _collections = logic.collections.get;
                _collections.add(newCollection);
                logic.collections.set(_collections);
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
          to: logic.collections,
          builder: (List<Collection> collections) {
            return collections.isNotEmpty
                ? StatefulBuilder(
                    builder: (context, setState) {
                      return ColumnWithSpacing(
                        d: 5,
                        children: List.generate(
                          collections.length,
                          (index) => CollectionWidget(
                            collections.elementAt(index),
                            onPressed: () {
                              logic.loadCollection(collections[index]);
                            },
                            removeWidgetFromList: () {
                              setState(() {
                                collections.remove(collections.elementAt(index));
                              });
                            },
                          ),
                        ),
                      );
                    },
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
