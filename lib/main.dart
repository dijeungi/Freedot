// lib/main.dart

import 'package:contact_hub/screen/add_screen.dart';
import 'package:contact_hub/screen/detail_screen.dart';
import 'package:contact_hub/screen/edit_screen.dart';
import 'package:flutter/material.dart';

import 'package:contact_hub/screen/intro_screen.dart';
import 'package:contact_hub/screen/error/error_screen.dart';
import 'package:contact_hub/screen/home_screen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '프리닷',
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      initialRoute: '/intro',
      routes: {
        '/intro': (context) => IntroScreen(),
        '/home': (context) => HomeScreen(),
        '/add': (context) => AddContactScreen(),
        '/edit': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as int;
          return EditScreen(contactId: args);
        },
        '/detail': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as int;
          return DetailScreen(userId: args);
        },
      },
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => ErrorScreen(),
      ),
    );
  }
}
