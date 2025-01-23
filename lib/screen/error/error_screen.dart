// error_screen.dart
import 'package:flutter/material.dart';
import 'package:contact_hub/components/widget/keypad_footer.dart';

class ErrorScreen extends StatefulWidget {
  @override
  _ErrorScreenState createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  int _currentIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    print('Selected Index: $index');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Center(child: Text('존재하지 않는 페이지입니다.')),
      bottomNavigationBar: Footer(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
