import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/my_theme.dart';

import '../../dialog_utils.dart';
import '../../firebase_utiles.dart';
import '../../model/task.dart';
import '../../providers/app_config_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/list_provider.dart';

class EditTaskScreen extends StatefulWidget {
  static const String routName = 'EditTaskScreen';

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  DateTime selectedDate = DateTime.now();
  var formkey = GlobalKey<FormState>();
  late ListProvider listProvider;
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();
  Task? task;

  @override
  Widget build(BuildContext context) {
    if (task == null) {
      var task = ModalRoute.of(context)!.settings.arguments as Task;
      titleController.text = task!.title ?? '';
      descriptionController.text = task!.description ?? '';
      selectedDate = task!.dateTime!;
    }
    var screenSize = MediaQuery.of(context).size;
    var provider = Provider.of<AppConfigProvider>(context);
    listProvider = Provider.of<ListProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('To Do List'),
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: screenSize.height * 0.1,
                color: Mytheme.PrimaryLight,
              ),
              Center(
                child: Container(
                  height: screenSize.height * .7,
                  width: screenSize.width * .8,
                  margin: EdgeInsets.only(top: screenSize.height * .05),
                  decoration: BoxDecoration(
                      color: provider.isDarkMode()
                          ? Mytheme.blackDark
                          : Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(20)),
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.edittask,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
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
                                  controller: titleController,
                                  validator: (text) {
                                    if (text == null || text.isEmpty) {
                                      return AppLocalizations.of(context)!
                                          .please_enter_task_title;
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      hintText: AppLocalizations.of(context)!
                                          .enter_your_task,
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                              color: provider.isDarkMode()
                                                  ? Mytheme.whiteColor
                                                  : Theme.of(context)
                                                      .primaryColorDark)),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: provider.isDarkMode()
                                            ? Mytheme.whiteColor
                                            : Theme.of(context)
                                                .primaryColorDark,
                                      ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: descriptionController,
                                  validator: (text) {
                                    if (text == null || text.isEmpty) {
                                      return AppLocalizations.of(context)!
                                          .please_enter_task_description;
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      hintText: AppLocalizations.of(context)!
                                          .description,
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            color: provider.isDarkMode()
                                                ? Mytheme.whiteColor
                                                : Theme.of(context)
                                                    .primaryColorDark,
                                          )),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: provider.isDarkMode()
                                            ? Mytheme.whiteColor
                                            : Theme.of(context)
                                                .primaryColorDark,
                                      ),
                                  maxLines: 3,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    AppLocalizations.of(context)!.select_date,
                                    style:
                                        Theme.of(context).textTheme.titleSmall),
                              ),
                              InkWell(
                                onTap: () {
                                  ShowCalender();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    editTask();
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.save_changes,
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ))
                            ],
                          ))
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void ShowCalender() async {
    var choosenDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365)));
    if (choosenDate != null) {
      selectedDate = choosenDate;
      setState(() {});
    }
  }

  void editTask() {
    if (formkey.currentState?.validate() == true) {
      task!.title = titleController.text;
      task!.description = descriptionController.text;
      task!.dateTime = selectedDate;

      var authProvider = Provider.of<AuthProvider>(context, listen: false);
      DialogUtils.showLoading(context, AppLocalizations.of(context)!.watting);
      FirebaseUtils.editTaskFromFireStore(
              task!, authProvider.currentUser?.id ?? '')
          .then((value) {
        DialogUtils.hideLoading(context);
      }).timeout(Duration(milliseconds: 500), onTimeout: () {
        Fluttertoast.showToast(
            msg: AppLocalizations.of(context)!.done,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            fontSize: 16.0);
        print('sucuess');
        listProvider
            .getAllTasksFromFireStore(authProvider.currentUser?.id ?? '');
        Navigator.pop(context);
      });
    }
  }
}
