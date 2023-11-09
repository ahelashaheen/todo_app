import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../my_theme.dart';
import '../../providers/app_config_provider.dart';

class LanguageButtonSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
            onTap: () {
              provider.ChangeLanguage('en');
            },
            child: provider.appLanguage == 'en'
                ? getSelectedItemWidget(
                context, AppLocalizations.of(context)!.english) //انجليزي
                : getUnSelectedItemWidget(
                context, AppLocalizations.of(context)!.english) //انجليزي
        ),
        InkWell(
            onTap: () {
              provider.ChangeLanguage('ar');
            },
            child: provider.appLanguage == 'ar'
                ? getSelectedItemWidget(
                context, AppLocalizations.of(context)!.arabic) //عربي
                : getUnSelectedItemWidget(
                context, AppLocalizations.of(context)!.arabic) //غربي
        )
      ],
    );
  }

  Widget getSelectedItemWidget(BuildContext context, String text) {
    var provider = Provider.of<AppConfigProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: Theme
                .of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: provider.isDarkMode()
                ? Mytheme.blackDark
                : Theme
                .of(context)
                .primaryColorDark),
          ),
          Icon(
            Icons.check,
            color: Theme
                .of(context)
                .primaryColor,
            size: 35,
          )
        ],
      ),
    );
  }

  Widget getUnSelectedItemWidget(BuildContext context, String text) {
    var provider = Provider.of<AppConfigProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: Theme
              .of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: provider.isDarkMode()
              ? Mytheme.blackDark
              : Theme
              .of(context)
              .primaryColor),),
          // Icon(Icons.check, color: Theme.of(context).primaryColor,size: 35,)
        ],
      ),
    );
  }
}





