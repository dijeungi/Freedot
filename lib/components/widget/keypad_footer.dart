import 'package:contact_hub/screen/keypad_screen.dart';
import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const Footer({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      child: BottomNavigationBar(
        items: _buildBottomNavigationBarItems(),
        currentIndex: currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey[700],
        backgroundColor: Color(0xFFF5F5F5),
        onTap: (index) {
          onTap(index);
          _navigateToPage(context, index);
        },
      ),
    );
  }

  List<BottomNavigationBarItem> _buildBottomNavigationBarItems() {
    return const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.dialpad),
        label: '키패드',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.contacts),
        label: '연락처',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.star),
        label: '즐겨찾기',
      ),
    ];
  }

  void _navigateToPage(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.push(context, MaterialPageRoute(builder: (context) => KeypadScreen()));
        break;
      case 1:
        Navigator.of(context).pushNamed('/home');
        break;
      case 2:
        Navigator.of(context).pushNamed('/detail');
        break;
    }
  }
}