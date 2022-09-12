import 'package:Markbase/dome/variable_notifier.dart';
import 'package:Markbase/dome/widgets/listen.dart';
import 'package:Markbase/models/collection.dart';
import 'package:Markbase/models/note.dart';
import 'package:Markbase/ui_logic/common/app.dart';
import 'package:Markbase/ui_logic/database/database_screen_logic.dart';
import 'package:Markbase/ui_logic/database/widgets/bottom_bar.dart';
import 'package:Markbase/ui_logic/database/widgets/collections.dart';
import 'package:Markbase/ui_logic/database/widgets/notes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DatabaseScreen extends HookWidget {
  const DatabaseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    useAutomaticKeepAlive();

    DatabaseScreenLogic logic = DatabaseScreenLogic(
      context,
      currentCollection: VariableNotifier<Collection>(Collection.empty()),
      currentCollectionCollections: VariableNotifier<List<Collection>>([]),
      currentCollectionNotes: VariableNotifier<List<Note>>([]),
      collectionsLoading: VariableNotifier<bool>(false),
      notesLoading: VariableNotifier<bool>(false),
    );

    useEffect(() {
      logic.loadRootCachedCollectionsAndNotes();
      logic.loadRootCollectionsAndNotes();
      return null;
    });

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: RefreshIndicator(
              onRefresh: () async => await logic.refresh(),
              color: AppColors.accentColor,
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: Listen(
                  to: logic.currentCollection,
                  builder: (value) {
                    return ListView(
                      children: [
                        Collections(logic),
                        const SizedBox(height: 20),
                        Notes(logic),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        BottomBar(logic),
      ],
    );
  }
}
