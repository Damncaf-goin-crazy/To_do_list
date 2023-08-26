import 'package:flutter/material.dart';
import 'package:todo_list/ui/home.dart';
import 'package:todo_list/Rotation_lock/rotation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/provider(for languages)/locale_provider.dart';

void main() => runApp(
  ChangeNotifierProvider(
    create: (context) => LocaleProvider(), // Provide an instance of your data model here
    child: MyApp(),
  ),
);

class MyApp extends StatelessWidget with PortraitModeMixin {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);
    super.build(context);
    return MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          AppLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'), // English
          Locale('ru'), // Russian
        ],
      locale: provider.locale,
      debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.indigo,
            canvasColor: Colors.transparent,
          primaryColorLight: const Color(0xFFF2DBFF),
          primaryColorDark: const Color(0xFFCCAADC),
        ),
        initialRoute: '/home',
        routes: {
          '/home': (context) => Home(title: 'My todo list'),
        }
    );
  }
}

