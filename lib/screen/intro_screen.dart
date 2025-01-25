import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {
            SystemNavigator.pop();
          },
        ),
      ),
      body: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed('/home');
        },
        child: Container(
          color: Colors.transparent,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.account_circle,
                  size: 100.0,
                  color: Colors.blue,
                ),
                SizedBox(height: 20),
                Text(
                  '화면을 터치하세요',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
