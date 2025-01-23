import 'package:flutter/material.dart';
import 'package:contact_hub/screen/add_contact_screen.dart';
import 'package:contact_hub/screen/edit_contact_screen.dart';
import 'package:contact_hub/screen/main_contact_screen.dart';
import 'package:contact_hub/screen/intro_screen.dart';
import 'package:contact_hub/screen/keypad_screen.dart';
import 'package:contact_hub/screen/error/error_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '프리닷',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/intro',
      routes: {
        '/intro': (context) => IntroScreen(),
        '/home': (context) => HomeScreen(),
        '/add': (context) => AddContactScreen(),
        '/edit': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as int;
          return EditContact(contactId: args);
        },
        '/keypad': (context) => KeypadScreen(),
      },
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => ErrorScreen(),
      ),
    );
  }
}
