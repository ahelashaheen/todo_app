import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/auth/login/loginscreen.dart';
import 'package:to_do_app/auth/register/register_screen.dart';
import 'package:to_do_app/home/task_list/edit_screen.dart';
import 'package:to_do_app/my_theme.dart';
import 'package:to_do_app/providers/app_config_provider.dart';
import 'package:to_do_app/providers/auth_provider.dart';
import 'package:to_do_app/providers/list_provider.dart';

import 'firebase_options.dart';
import 'home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //await FirebaseFirestore.instance.disableNetwork();
  // FirebaseFirestore.instance.settings =
  // Settings(cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => ListProvider()),
    ChangeNotifierProvider(create: (context) => AuthProvider()),
    ChangeNotifierProvider(create: (context) => AppConfigProvider()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  late AppConfigProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AppConfigProvider>(context);
    initSharedPrf();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: LoginScreen.routeName,
      routes: {
        HomeScreen.routeName: (context) => HomeScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
        RegisterScreen.routeName: (context) => RegisterScreen(),
        EditTaskScreen.routName: (context) => EditTaskScreen(),
      },
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(provider.appLanguage),
      theme: Mytheme.LightTheme,
      darkTheme: Mytheme.DarkTheme,
      themeMode: provider.appTheme,
    );
  }

  Future<void> initSharedPrf() async {
    final prefs = await SharedPreferences.getInstance();
    var languge = prefs.getString('languge');
    if (languge != null) {
      provider.ChangeLanguage(languge);
    }
    var isDark = prefs.getBool('isDark');
    if (isDark == true) {
      provider.ChangeTheme(ThemeMode.dark);
    } else if (isDark == false) {
      provider.ChangeTheme(ThemeMode.light);
    }
  }
}
