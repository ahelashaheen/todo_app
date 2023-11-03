import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/auth/login/loginscreen.dart';
import 'package:to_do_app/home/settings/settingtab.dart';
import 'package:to_do_app/home/task_list/add_task_bottomsheet.dart';
import 'package:to_do_app/home/task_list/task_list_tab.dart';

import '../providers/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'HomeScreen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    // var listProvider = Provider.of<ListProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedIndex == 0 ?
        'To Do List ''${authProvider.currentUser!.name}'
            :
        'Settings ''${authProvider.currentUser!.name}',
            style: Theme
                .of(context)
                .textTheme
                .titleLarge),
        actions: [
          IconButton(onPressed: () {
            // listProvider.tasksList=[];
            //  authProvider.currentUser=null;
            Navigator.pushReplacementNamed(context, LoginScreen.routeName);
          }, icon: Icon(Icons.logout))
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8,
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) {
            selectedIndex = index;
            setState(() {

            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: AppLocalizations.of(context)!.task_list
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: AppLocalizations.of(context)!.settings
            ),
          ],),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ShowAddTaskBottomSheet();
        },
        child: Icon(Icons.add, size: 30,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: tabs[selectedIndex],


    );
  }

  List<Widget> tabs = [
    TaskListTab(), SettingTab()
  ];

  void ShowAddTaskBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: ((context) => AddTaskBottomSheet()
        )
    );
  }
}




