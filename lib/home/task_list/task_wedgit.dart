import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/firebase_utiles.dart';
import 'package:to_do_app/home/task_list/edit_screen.dart';
import 'package:to_do_app/my_theme.dart';

import '../../model/task.dart';
import '../../providers/app_config_provider.dart';
import '../../providers/auth_provider.dart';

class TaskWedgitItem extends StatefulWidget {
  Task task;

  TaskWedgitItem({required this.task});

  @override
  State<TaskWedgitItem> createState() => _TaskWedgitItemState();
}

class _TaskWedgitItemState extends State<TaskWedgitItem> {
  @override
  Widget build(BuildContext context) {
    // var ListProvider = Provider.of<ListProvider>(context , listen: false);
    var uId =
        Provider.of<AuthProvider>(context, listen: false).currentUser?.id ?? '';
    var provider = Provider.of<AppConfigProvider>(context);
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(EditTaskScreen.routName, arguments: widget.task);
      },
      child: Container(
        margin: EdgeInsets.all(12),
        child: Slidable(
          startActionPane: ActionPane(
            extentRatio: 0.23,
            motion: const DrawerMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {
                  FirebaseUtils.deleteTaskFromFireStore(widget.task, uId)
                      .timeout(Duration(milliseconds: 500), onTimeout: () {
                    // ListProvider.getAllTasksFromFireStore(uId);
                  });
                },
                icon: Icons.delete,
                label: AppLocalizations.of(context)!.delete,
                backgroundColor: Colors.red,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    topRight: Radius.circular(20)),
              ),
            ],
          ),
          child: Container(
            margin: EdgeInsets.all(14),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Mytheme.whiteColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  color: widget.task.isDone!
                      ? Mytheme.greenColor
                      : Theme.of(context).primaryColor,
                  height: 90,
                  width: 4,
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.task.title ?? '',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  color: widget.task.isDone!
                                      ? Mytheme.greenColor
                                      : Theme.of(context).primaryColor)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.task.description ?? '',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                color: provider.isDarkMode()
                                    ? Mytheme.blackDark
                                    : Theme.of(context).primaryColorDark),
                      ),
                    )
                  ],
                )),
                InkWell(
                  onTap: () {
                    FirebaseUtils.updateTaskFromFireStore(widget.task, uId);
                    widget.task.isDone = !widget.task.isDone!;
                    setState(() {});
                  },
                  child: widget.task.isDone!
                      ? Text(
                          AppLocalizations.of(context)!.isdone,
                          style: TextStyle(
                              color: Mytheme.greenColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        )
                      : Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).primaryColor),
                          child: Icon(
                            Icons.check,
                            color: Mytheme.whiteColor,
                            size: 29,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
