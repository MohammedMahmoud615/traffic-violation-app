import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:untitled5/all/Login.dart';


void main() {
  runApp(
    MaterialApp(
      
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
    useMaterial3: true,
    fontFamily: 'MyCustomFont', 
  ),
      home: LoginPage(),
    ),
  );
}
