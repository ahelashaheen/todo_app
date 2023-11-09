import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/dialog_utils.dart';
import 'package:to_do_app/firebase_utiles.dart';

import '../../model/task.dart';
import '../../my_theme.dart';
import '../../providers/app_config_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/list_provider.dart';

class AddTaskBottomSheet extends StatefulWidget {

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  DateTime selectedDate = DateTime.now();
  var formkey = GlobalKey<FormState>();
  String title = '';
  String description = '';
  late ListProvider listProvider;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    listProvider = Provider.of<ListProvider>(context);
    return Container(
      color: provider.isDarkMode()
          ? Mytheme.blackDark
          : Theme.of(context).cardColor,
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context)!.add_new_task,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: provider.isDarkMode()
                    ? Mytheme.whiteColor
                    : Theme.of(context).primaryColorDark),
          ),
          Form(
              key: formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      onChanged: (text) {
                        title = text;
                      },
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return AppLocalizations.of(context)!
                              .please_enter_task_title;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          hintText:
                              AppLocalizations.of(context)!.enter_your_task,
                          hintStyle: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  color: provider.isDarkMode()
                                      ? Mytheme.whiteColor
                                      : Theme.of(context).primaryColorDark)),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: provider.isDarkMode()
                                ? Mytheme.whiteColor
                                : Theme.of(context).primaryColorDark,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      onChanged: (text) {
                        description = text;
                      },
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return AppLocalizations.of(context)!
                              .please_enter_task_description;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.description,
                          hintStyle:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: provider.isDarkMode()
                                        ? Mytheme.whiteColor
                                        : Theme.of(context).primaryColorDark,
                                  )),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: provider.isDarkMode()
                                ? Mytheme.whiteColor
                                : Theme.of(context).primaryColorDark,
                          ),
                      maxLines: 3,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(AppLocalizations.of(context)!.select_date,
                        style: Theme
                            .of(context)
                            .textTheme
                            .titleSmall),
                  ),

                  InkWell(
                    onTap: () {
                      ShowCalender();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${selectedDate.day}/${selectedDate
                          .month}/${selectedDate.year}',
                        style: Theme
                            .of(context)
                            .textTheme
                            .titleSmall
                        , textAlign: TextAlign.center,),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        addTask();
                      },
                      child: Text(AppLocalizations.of(context)!.add,
                        style: Theme
                            .of(context)
                            .textTheme
                            .titleLarge,))
                ],
              ))
        ],
      ),
    );
  }

  void ShowCalender() async {
    var choosenDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365))
    );
    if (choosenDate != null) {
      selectedDate = choosenDate;
      setState(() {});
    }
  }

  void addTask() {
    if (formkey.currentState?.validate() == true) {
      Task task = Task(
        title: title,
        description: description,
        dateTime: selectedDate,
      );
      var authProvider = Provider.of<AuthProvider>(context, listen: false);
      DialogUtils.showLoading(context, AppLocalizations.of(context)!.watting);
      FirebaseUtils.addTaskToFireStore(task, authProvider.currentUser?.id ?? '')
          .then((value) {
        DialogUtils.hideLoading(context);
      })
          .timeout(
          Duration(milliseconds: 500),
          onTimeout: () {
            Fluttertoast.showToast(
                msg: AppLocalizations.of(context)!.done,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.blue,
                textColor: Colors.white,
                fontSize: 16.0
            );
            print('sucuess');
            listProvider.getAllTasksFromFireStore(
                authProvider.currentUser?.id ?? '');
            Navigator.pop(context);
          }
      );
    }
  }

}
