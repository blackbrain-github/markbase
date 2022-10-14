import 'package:Markbase/dome/app_specific/app.dart';
import 'package:Markbase/dome/app_specific/common_logic.dart';
import 'package:Markbase/dome/show.dart';
import 'package:Markbase/dome/widgets/custom_animated_widget.dart';
import 'package:Markbase/dome/widgets/custom_text.dart';
import 'package:Markbase/dome/widgets/listen.dart';
import 'package:Markbase/models/collection.dart';
import 'package:Markbase/dome/app_vibrate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CollectionWidget extends HookWidget {
  final Collection collection;
  final Function onPressed;
  final Function removeWidgetFromList;
  const CollectionWidget(this.collection, {required this.onPressed, required this.removeWidgetFromList, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String collectionLabel() {
      return '${collection.collectionCount} ${collection.collectionCount == 1 ? 'collection' : 'collections'}, ${collection.noteCount} ${collection.noteCount == 1 ? 'note' : 'notes'}';
    }

    return Listen(
      to: CommonLogic.theme,
      builder: (_) {
        return CustomAnimatedWidget(
          onPressed: () => onPressed(),
          onLongPress: () async {
            AppVibrate.impact();
            if (await Show(context).deleteCollection(collection) is Collection) {
              removeWidgetFromList();
            }
          },
          endSize: 0.99,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.getNoteColor(),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  blurRadius: 20,
                  color: AppColors.getShadowColor(),
                )
              ],
              border: Border.all(
                width: 0.5,
                color: AppColors.getInversePrimaryBackgroundColor().withOpacity(0.05),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: CustomText(
                    collection.title ?? 'collection_title',
                    size: 16,
                    fontWeight: FontWeight.w700,
                    maxLines: 1,
                  ),
                ),
                CustomText(
                  collectionLabel(),
                  size: 16,
                  maxLines: 1,
                  color: TextColorType.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
