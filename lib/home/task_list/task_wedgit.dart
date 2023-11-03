import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/firebase_utiles.dart';
import 'package:to_do_app/my_theme.dart';

import '../../model/task.dart';
import '../../providers/app_config_provider.dart';
import '../../providers/auth_provider.dart';

class TaskWedgitItem extends StatelessWidget {
  Task task;

  TaskWedgitItem({required this.task});

  @override
  Widget build(BuildContext context) {
    // var listProvider = Provider.of<ListProvider>(context);
    var provider = Provider.of<AppConfigProvider>(context);
    return Slidable(
      startActionPane: ActionPane(
        extentRatio: 0.23,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              var authProvider = Provider.of<AuthProvider>(
                  context, listen: false);
              FirebaseUtils.deleteTaskFromFireStore(
                  task, authProvider.currentUser?.id ?? '').timeout(
                  Duration(milliseconds: 500),
                  onTimeout: () {
                    // ListProvider.getAllTasksFromFireStore(authProvider.currentUser?.id??'');
                  }
              );
            },
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(13),
                topLeft: Radius.circular(13)
            ),
            backgroundColor: Mytheme.redColor,
            foregroundColor: Mytheme.whiteColor,
            icon: Icons.delete,
            label: AppLocalizations.of(context)!.delete,
          ),
        ],
      ),
      child: Container(
        margin: EdgeInsets.all(14),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Mytheme.whiteColor
        ),
        child:
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              color: Theme
                  .of(context)
                  .primaryColor,
              height: 90,
              width: 4,
            ),

            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(task.title ?? '',
                      style: Theme
                          .of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(
                          color: Theme
                              .of(context)
                              .primaryColor
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(task.description ?? '',
                      style: Theme
                          .of(context)
                          .textTheme
                          .titleSmall),
                ),
              ],
            )),
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: 7,
                  horizontal: 15
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme
                      .of(context)
                      .primaryColor
              ),
              child: Icon(Icons.check, color: Mytheme.whiteColor, size: 29,),
            ),
          ],
        ),
      ),
    );
  }
}
