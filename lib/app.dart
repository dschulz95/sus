import 'package:flutter/material.dart';

import 'l10n/app_localizations.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

/// Root widget. Owns the app-wide locale so the language can be switched
/// at runtime from the home screen.
class ImposterApp extends StatefulWidget {
  const ImposterApp({super.key});

  @override
  State<ImposterApp> createState() => _ImposterAppState();
}

class _ImposterAppState extends State<ImposterApp> {
  Locale _locale = const Locale('de');

  void _setLocale(Locale locale) {
    setState(() => _locale = locale);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Imposter',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: HomeScreen(onLocaleChanged: _setLocale),
    );
  }
}
