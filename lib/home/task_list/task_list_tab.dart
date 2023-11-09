import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/home/task_list/task_wedgit.dart';
import 'package:to_do_app/my_theme.dart';
import 'package:to_do_app/providers/list_provider.dart';

import '../../providers/app_config_provider.dart';
import '../../providers/auth_provider.dart';

class TaskListTab extends StatefulWidget {

  @override
  State<TaskListTab> createState() => _TaskListTabState();
}

class _TaskListTabState extends State<TaskListTab> {


  @override
  Widget build(BuildContext context) {
    var listProvider = Provider.of<ListProvider>(context);
    var authProvider = Provider.of<AuthProvider>(context);
    var provider = Provider.of<AppConfigProvider>(context);
    listProvider.getAllTasksFromFireStore(authProvider.currentUser?.id ?? '');

    return Column(
      children: [
        CalendarTimeline(
          initialDate: listProvider.selectDate,
          firstDate: DateTime.now().subtract(Duration(days: 365)),
          lastDate: DateTime.now().add(Duration(days: 365)),
          onDateSelected: (date) {
            listProvider.changeSelectedDate(
                date, authProvider.currentUser?.id ?? '');
          },
          leftMargin: 20,
          monthColor: provider.isDarkMode()
              ? Theme.of(context).primaryColor
              : Mytheme.blackColor,
          dayColor: provider.isDarkMode()
              ? Theme.of(context).cardColor
              : Mytheme.blackColor,
          activeDayColor: provider.isDarkMode()
              ? Theme.of(context).primaryColor
              : Mytheme.whiteColor,
          activeBackgroundDayColor: provider.isDarkMode()
              ? Theme.of(context).cardColor
              : Mytheme.PrimaryLight,
          dotsColor: provider.isDarkMode()
              ? Theme.of(context).primaryColor
              : Mytheme.whiteColor,
          selectableDayPredicate: (date) => true,
          locale: 'en_ISO',
        ),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return TaskWedgitItem(task: listProvider.tasksList[index],);
            },
            itemCount: listProvider.tasksList.length,
          ),)
      ]
      ,);
  }


}
