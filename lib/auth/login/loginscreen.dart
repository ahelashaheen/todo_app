//import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/auth/login/loginscreen.dart';
import 'package:to_do_app/auth/register/register_screen.dart';
import 'package:to_do_app/firebase_utiles.dart';
import 'package:to_do_app/home/home_screen.dart';

import '../../componts/custom_textform_filed.dart';
import '../../dialog_utils.dart';
import '../../providers/auth_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailAddressController = TextEditingController();

  var passwordController = TextEditingController();

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

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(onPressed: () {
                        login();
                      }, child: Text(AppLocalizations.of(context)!.login,
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
                    SizedBox(height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.05)
                    , Row(
                      children: [
                        SizedBox(width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.1)
                        ,
                        Text(AppLocalizations.of(context)!
                            .do_not_you_have_an_account,
                          style: Theme
                              .of(context)
                              .textTheme
                              .titleSmall,),
                        TextButton(onPressed: () {
                          Navigator.of(context).pushNamed(
                              RegisterScreen.routeName);
                        }, child: Text(AppLocalizations.of(context)!.sign_up,
                          style: TextStyle(
                              fontSize: 18
                          ),))

                      ],
                    )


                  ],
                ),
              ))
        ],
      ),
    );
  }

  void login() async {
    if (formkey.currentState?.validate() == true) {
      DialogUtils.showLoading(context, AppLocalizations.of(context)!.loading);

      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
            email: emailAddressController.text,
            password: passwordController.text
        );
        var user = await FirebaseUtils.readUserToFireStore(
            credential.user?.uid ?? '');
        if (user == null) {
          return;
        }
        var authProvider = Provider.of<AuthProvider>(context, listen: false);
        authProvider.UpdateUser(user);

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

        print('Login Sucuessfully');
        print(credential.user?.uid ?? '');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        } else if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
          DialogUtils.hideLoading(context);
          DialogUtils.showMessage(context, AppLocalizations.of(context)!
              .wrong_password_or_no_user_found_for_that_email,
              title: AppLocalizations.of(context)!.error,
              posActionName: AppLocalizations.of(context)!.ok,
              barrierDismissible: false
          );

          print('wrong password or no user found for that email');
        }
      }
      catch (e) {
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
