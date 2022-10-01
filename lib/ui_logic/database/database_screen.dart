import 'package:Markbase/dome/app_specific/app.dart';
import 'package:Markbase/dome/widgets/listen.dart';
import 'package:Markbase/models/collection.dart';
import 'package:Markbase/ui_logic/database/database_screen_logic.dart';
import 'package:Markbase/ui_logic/database/widgets/bottom_bar.dart';
import 'package:Markbase/ui_logic/database/widgets/collections.dart';
import 'package:Markbase/ui_logic/database/widgets/notes.dart';
import 'package:flutter/material.dart';

class DatabaseScreen extends StatefulWidget {
  const DatabaseScreen({Key? key}) : super(key: key);

  @override
  State<DatabaseScreen> createState() => _DatabaseScreenState();
}

class _DatabaseScreenState extends State<DatabaseScreen> with AutomaticKeepAliveClientMixin {
  DatabaseScreenLogic logic = DatabaseScreenLogic();

  @override
  void initState() {
    super.initState();
    logic.loadCollectionsAndNotesInRoot();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                  builder: (Collection collection) {
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
