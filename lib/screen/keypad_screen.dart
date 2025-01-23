import 'package:flutter/material.dart';
import 'package:contact_hub/components/widget/keypad_footer.dart';
import 'package:contact_hub/screen/search_screen.dart';
import 'package:contact_hub/services/api_service.dart';
import 'package:contact_hub/services/user.dart';

class KeypadScreen extends StatefulWidget {
  @override
  _KeypadScreenState createState() => _KeypadScreenState();
}

class _KeypadScreenState extends State<KeypadScreen> {
  final ApiService apiService = ApiService();
  late Future<List<User>?> contactsFuture;
  int _currentIndex = 0;
  String _inputText = '';
  bool _showIcons = false;

  @override
  void initState() {
    super.initState();
    contactsFuture = apiService.fetchAllContacts();
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _makeCall() {
    print('통화 버튼 클릭 인식');
  }

  void _addNumber(String number) {
    setState(() {
      _inputText += number;
      _showIcons = _inputText.isNotEmpty;
    });
  }

  void _removeLastCharacter() {
    setState(() {
      if (_inputText.isNotEmpty) {
        _inputText = _inputText.substring(0, _inputText.length - 1);
        _showIcons = _inputText.isNotEmpty;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF5F5F5),
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchScreen(contactsFuture: contactsFuture),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              print('More Vert 아이콘 클릭됨!');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 70),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Container()),
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                _inputText,
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ),
            buildKeypad(),
          ],
        ),
      ),
      bottomNavigationBar: Footer(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget buildKeypad() {
    return Column(
      children: [
        buildRow([
          {'number': '1', 'letters': ''},
          {'number': '2', 'letters': 'ABC'},
          {'number': '3', 'letters': 'DEF'},
        ]),
        buildRow([
          {'number': '4', 'letters': 'GHI'},
          {'number': '5', 'letters': 'JKL'},
          {'number': '6', 'letters': 'MNO'},
        ]),
        buildRow([
          {'number': '7', 'letters': 'PQRS'},
          {'number': '8', 'letters': 'TUV'},
          {'number': '9', 'letters': 'WXYZ'},
        ]),
        buildRow([
          {'number': '*', 'letters': ''},
          {'number': '0', 'letters': '+'},
          {'number': '#', 'letters': ''},
        ]),
        Container(
          height: 100,
          child: Stack(
            children: [
              Positioned(
                left: 60,
                top: 20,
                child: AnimatedOpacity(
                  opacity: _showIcons ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 300),
                  child: IconButton(
                    icon: Icon(Icons.videocam, size: 45, color: Colors.blue),
                    onPressed: () {
                      print('영상통화 버튼 클릭됨!');
                    },
                  ),
                ),
              ),
              Positioned(
                left: MediaQuery.of(context).size.width / 2 - 30,
                top: 15,
                child: ElevatedButton(
                  onPressed: _makeCall,
                  child: Icon(Icons.call, size: 30, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(20),
                    backgroundColor: Colors.green,
                  ),
                ),
              ),
              Positioned(
                right: 60,
                top: 25,
                child: AnimatedOpacity(
                  opacity: _showIcons ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 300),
                  child: IconButton(
                    icon: Icon(Icons.backspace, size: 35, color: Colors.red),
                    onPressed: _removeLastCharacter,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget buildRow(List<Map<String, String>> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: keys.map((key) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12, left: 30, right: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  _addNumber(key['number']!);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      key['number']!,
                      style: TextStyle(fontSize: 33, color: Colors.black, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: key['letters']!.isNotEmpty ? 0 : 15,
                    ),
                    if (key['letters']!.isNotEmpty)
                      Text(
                        key['letters'] ?? '',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(70, 70),
                  shape: CircleBorder(),
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
