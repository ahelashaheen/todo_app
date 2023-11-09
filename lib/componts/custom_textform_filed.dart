import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../my_theme.dart';
import '../providers/app_config_provider.dart';

class customTextFormFiled extends StatelessWidget {
  String label;
  TextInputType keyboardType;
  TextEditingController controller;
  String? Function(String?) validator;
  bool ispassword;

  customTextFormFiled({required this.label,
    this.keyboardType = TextInputType.text,
    required this.controller,
    required this.validator,
    this.ispassword = false});


  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(11.0),
      child: TextFormField(
        decoration: InputDecoration(
          label: Text(label, style: Theme
              .of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: provider.isDarkMode()
              ? Mytheme.whiteColor
              : Theme
              .of(context)
              .primaryColorDark),),
          hintStyle: Theme
              .of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: provider.isDarkMode()
              ? Mytheme.whiteColor
              : Theme
              .of(context)
              .primaryColorDark),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
                width: 3,
                color: Theme
                    .of(context)
                    .primaryColor
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
                width: 3,
                color: Theme
                    .of(context)
                    .primaryColor
            ),
          ),
        ),
        keyboardType: keyboardType,
        controller: controller,
        validator: validator,
        obscureText: ispassword,
      ),
    );
  }
}
