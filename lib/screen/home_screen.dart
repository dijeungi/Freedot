// lib/screen/home_screen.dart

import 'package:flutter/material.dart';

import 'package:contact_hub/services/api_service.dart';
import 'package:contact_hub/services/user.dart';

import 'package:contact_hub/screen/add_screen.dart';
import 'package:contact_hub/screen/search_screen.dart';
import 'package:contact_hub/screen/detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();
  late Future<List<User>?> contactsFuture;
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    // 연락처 데이터를 비동기적으로 가져오는 초기화
    contactsFuture = apiService.fetchAllContacts();
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _addContactLocally(User newContact) {
    setState(() {
      // 새로운 연락처를 로컬 데이터에 추가
      contactsFuture = contactsFuture.then((existingContacts) {
        final updatedContacts = existingContacts ?? [];
        updatedContacts.add(newContact);
        return updatedContacts;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(''),
        backgroundColor: Color(0xFFF5F5F5),
      ),
      backgroundColor: Color(0xFFF5F5F5),
      body: Stack(
        children: [
          Column(
            children: [
              // 화면 상단 여백
              SizedBox(height: MediaQuery.of(context).size.height * 0.15),
              _buildHeader(), // 헤더 위젯
              SizedBox(height: 35),
              _buildContactActions(), // 연락처 관련 액션 버튼
              Expanded(child: _buildContactList()), // 연락처 리스트
            ],
          ),
        ],
      ),
    );
  }

  // 헤더 위젯
  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 화면 상단 텍스트
          Transform.translate(
            offset: Offset(0, -70),
            child: Text(
              '연락처',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.normal,
                color: Color(0xFF222222),
              ),
            ),
          ),
          SizedBox(height: 10),
          // 연락처 수를 보여주는 FutureBuilder
          FutureBuilder<List<User>?>(
            future: contactsFuture,
            builder: (context, snapshot) {
              String contactsText;

              if (snapshot.connectionState == ConnectionState.waiting) {
                contactsText = "전화번호가 저장된 연락처를 불러오는 중...";
              } else if (snapshot.hasError) {
                contactsText = "에러가 발생했습니다.";
              } else if (snapshot.hasData) {
                contactsText = "전화번호가 저장된 연락처 ${snapshot.data!.length}개";
              } else {
                contactsText = "연락처가 없습니다.";
              }

              return Transform.translate(
                offset: Offset(0, -80),
                child: Text(
                  contactsText,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFFA5A5A5),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // 연락처 관련 액션 버튼들
  Widget _buildContactActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // 연락처 추가 버튼
        IconButton(
          icon: Icon(Icons.add),
          color: Color(0xFF222222),
          onPressed: () async {
            final newContact = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddContactScreen()),
            );

            if (newContact != null) {
              _addContactLocally(newContact); // 새로운 연락처 추가
            }
          },
        ),
        // 연락처 검색 버튼
        IconButton(
          icon: Icon(Icons.search),
          color: Color(0xFF222222),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchScreen(contactsFuture: contactsFuture),
              ),
            );
          },
        ),
        // 메뉴 버튼
        IconButton(
          icon: Icon(Icons.more_vert),
          color: Color(0xFF222222),
          onPressed: () {
            // 메뉴 버튼 액션
          },
        ),
      ],
    );
  }

  // 연락처 리스트를 보여주는 위젯
  Widget _buildContactList() {
    return Padding(
      padding: const EdgeInsets.only(top: 3.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 25.0, left: 20.0),
          child: FutureBuilder<List<User>?>(
            future: contactsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text("데이터를 불러오는데 실패하였습니다.", style: TextStyle(color: Colors.grey[400]),));
              } else {
                final contacts = snapshot.data!;
                return ListView.separated(
                  itemCount: contacts.length,
                  separatorBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 70.0),
                    child: Divider(
                      color: Colors.grey.shade300,
                      height: 1,
                      thickness: 1,
                    ),
                  ),
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue[300],
                        child: Icon(Icons.person, color: Colors.white), // 프로필 아이콘
                      ),
                      title: Text(
                        contacts[index].name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF222222),
                        ),
                      ),
                      onTap: () {
                        // 상세 페이지로 이동
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(
                              userId: contacts[index].id!,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
