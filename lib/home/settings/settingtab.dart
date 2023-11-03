import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/home/settings/theme_botton_sheet.dart';

import '../../my_theme.dart';
import '../../providers/app_config_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'languge_bottom_sheet.dart';

class SettingTab extends StatefulWidget {
  @override
  State<SettingTab> createState() => _SettingsState();
}

class _SettingsState extends State<SettingTab> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return Container(
      margin: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppLocalizations.of(context)!.language, ////اللغه
            style: Theme
                .of(context)
                .textTheme
                .titleMedium,
          ),
          SizedBox(
            height: 15,
          ),
          InkWell(
            onTap: () {
              ShowLanguageButtonSheet();
            },
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Theme
                      .of(context)
                      .primaryColor,
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    provider.appLanguage == 'en'
                        ? AppLocalizations.of(context)!.english ////الانجليزيه
                        : AppLocalizations.of(context)!.arabic ////العربيه
                    ,
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleMedium,

                  ),
                  Icon(Icons.arrow_drop_down,
                    color:
                    provider.isDarkMode()
                        ? Mytheme.PrimaryLight
                        : Theme
                        .of(context)
                        .shadowColor,)
                ],
              ),
            ),
          ),
          ///////////////
          SizedBox(
            height: 20,
          ),
          Text(
            AppLocalizations.of(context)!.theme, //theme//
            style: Theme
                .of(context)
                .textTheme
                .titleMedium,
          ),
          SizedBox(
            height: 15,
          ),
          InkWell(
            onTap: () {
              ShowThemeButtonSheet();
            },
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Theme
                      .of(context)
                      .primaryColor,
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    provider.isDarkMode()
                        ? AppLocalizations.of(context)!.dark //dark//
                        : AppLocalizations.of(context)!.light //light//

                    ,
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleMedium,
                  ),
                  Icon(Icons.arrow_drop_down,
                    color:
                    provider.isDarkMode()
                        ? Mytheme.PrimaryLight
                        : Theme
                        .of(context)
                        .shadowColor,)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void ShowLanguageButtonSheet() {
    showModalBottomSheet(
        context: context, builder: (context) => LanguageButtonSheet());
  }

  void ShowThemeButtonSheet() {
    showModalBottomSheet(
        context: context, builder: (context) => LanguageThemeSheet());
  }
}
