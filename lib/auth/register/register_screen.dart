//import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/auth/login/loginscreen.dart';
import 'package:to_do_app/dialog_utils.dart';
import 'package:to_do_app/providers/auth_provider.dart';

import '../../componts/custom_textform_filed.dart';
import '../../firebase_utiles.dart';
import '../../home/home_screen.dart';
import '../../model/myuser.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = 'register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var nameController = TextEditingController();

  var emailAddressController = TextEditingController();

  var passwordController = TextEditingController();

  var confirmationpasswordController = TextEditingController();

  var formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset('assets/images/Group 179.png',
            width: double.infinity,
            fit: BoxFit.fill,
          ),

          Form(
              key: formkey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.4,
                    ),
                    customTextFormFiled(
                      label: AppLocalizations.of(context)!.user_name,
                      controller: nameController,
                      validator: (text) {
                        if (text == null || text
                            .trim()
                            .isEmpty) {
                          return AppLocalizations.of(context)!
                              .please_enter_user_name;
                        }
                        return null;
                      },),

                    customTextFormFiled(
                        label: AppLocalizations.of(context)!.email_address,
                        keyboardType: TextInputType.emailAddress,
                        controller: emailAddressController,
                        validator: (text) {
                          if (text == null || text
                              .trim()
                              .isEmpty) {
                            return AppLocalizations.of(context)!
                                .please_enter_email_address;
                          }
                          bool emailValid =
                          RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(text);
                          if (!emailValid) {
                            return AppLocalizations.of(context)!
                                .please_enter_valid_email;
                          }
                          return null;
                        }
                    ),

                    customTextFormFiled(
                      label: AppLocalizations.of(context)!.password,
                      keyboardType: TextInputType.number,
                      controller: passwordController,
                      validator: (text) {
                        if (text == null || text
                            .trim()
                            .isEmpty) {
                          return AppLocalizations.of(context)!
                              .please_enter_password;
                        }
                        if (text.length < 6) {
                          return AppLocalizations.of(context)!
                              .password_should_be_at_least_six_chars;
                        }
                        return null;
                      },
                      ispassword: true,),

                    customTextFormFiled(
                      label: AppLocalizations.of(context)!.confimation_password,
                      keyboardType: TextInputType.number,
                      controller: confirmationpasswordController,
                      validator: (text) {
                        if (text == null || text
                            .trim()
                            .isEmpty) {
                          return AppLocalizations.of(context)!
                              .please_enter_confirmation_password;
                        }
                        if (text != passwordController.text) {
                          return AppLocalizations.of(context)!
                              .password_does_not_match;
                        }
                        return null;
                      },
                      ispassword: true,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(onPressed: () {
                        register();
                      }, child: Text(AppLocalizations.of(context)!.register,
                        style: Theme
                            .of(context)
                            .textTheme
                            .titleLarge,)
                        , style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: 8
                            )
                        ),
                      ),
                    ),
                    TextButton(onPressed: () {
                      Navigator.of(context).pushNamed(LoginScreen.routeName);
                    },
                        child: Text(AppLocalizations.of(context)!
                            .already_have_an_account))


                  ],
                ),
              ))
        ],
      ),
    );
  }

  void register() async {
    if (formkey.currentState?.validate() == true) {
      DialogUtils.showLoading(context, AppLocalizations.of(context)!.loading);
      try {
        final credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: emailAddressController.text,
          password: passwordController.text,
        );

        MyUser myUser = MyUser(
            id: credential.user?.uid ?? '',
            name: nameController.text,
            email: emailAddressController.text);
        var authProvider = Provider.of<AuthProvider>(context, listen: false);
        authProvider.UpdateUser(myUser);


        await FirebaseUtils.addUserToFireStore(myUser);

        DialogUtils.hideLoading(context);
        DialogUtils.showMessage(
            context, AppLocalizations.of(context)!.login_succuessfully,
            title: AppLocalizations.of(context)!.succuess,
            posActionName: AppLocalizations.of(context)!.ok,
            barrierDismissible: false,
            posAction: () {
              Navigator.pushReplacementNamed(context, HomeScreen.routeName);
            }
        );

        print('Register Sucuessfully');
        print(credential.user?.uid ?? '');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          DialogUtils.hideLoading(context);
          DialogUtils.showMessage(context,
              AppLocalizations.of(context)!.the_password_provided_is_too_weak,
              title: AppLocalizations.of(context)!.error,
              posActionName: AppLocalizations.of(context)!.ok,
              barrierDismissible: false
          );

          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          DialogUtils.hideLoading(context);
          DialogUtils.showMessage(context, AppLocalizations.of(context)!
              .the_account_already_exists_for_that_email,
              title: AppLocalizations.of(context)!.error,
              posActionName: AppLocalizations.of(context)!.ok,
              barrierDismissible: false
          );

          print('The account already exists for that email.');
        }
      } catch (e) {
        DialogUtils.hideLoading(context);
        DialogUtils.showMessage(context, e.toString(),
            title: AppLocalizations.of(context)!.error,
            posActionName: AppLocalizations.of(context)!.ok,
            barrierDismissible: false
        );
        print(e);
      }
    }
  }
}


