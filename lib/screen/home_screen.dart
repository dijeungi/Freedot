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
    // 약간의 딜레이 추가 ( 연락처 추가 후 ㄴ 카테고리를 추가하면 맨 상단에 올라와 있음 방지 )
    contactsFuture = Future.delayed(Duration(seconds: 1), () => apiService.fetchAllContacts());
    // contactsFuture = apiService.fetchAllContacts();
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
        backgroundColor: Colors.grey[100],
        flexibleSpace: Container(
          color: Colors.grey[100],
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.15),
              _buildHeader(),
              SizedBox(height: 35),
              _buildContactActions(),
              Expanded(child: _buildContactList()),
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
                color: Colors.black,
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
                    color: Colors.grey,
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // 아이콘 간 간격을 조정
      children: [
        // 왼쪽에 햄버거 아이콘
        IconButton(
          icon: Icon(Icons.menu),
          color: Colors.black,
          padding: EdgeInsets.only(left: 16),
          onPressed: () {
            // 햄버거 버튼 클릭 시 동작 정의
          },
        ),
        Row(
          children: [
            // 연락처 추가 버튼
            IconButton(
              icon: Icon(Icons.add),
              color: Colors.black,
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
              color: Colors.black,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SearchScreen(contactsFuture: contactsFuture),
                  ),
                );
              },
            ),
            // 메뉴 버튼
            IconButton(
              icon: Icon(Icons.more_vert),
              color: Colors.black,
              onPressed: () {
                // 메뉴 버튼 액션
                print("Menu icon pressed");
              },
            ),
          ],
        ),
      ],
    );
  }


  // 연락처 리스트를 보여주는 위젯
  Widget _buildContactList() {
    return Padding(
      padding: const EdgeInsets.only(top: 3.0),
      child: FutureBuilder<List<User>?>(
        future: contactsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("데이터를 불러오는데 실패하였습니다.", style: TextStyle(color: Colors.grey[400])));
          } else {
            final contacts = snapshot.data!;
            // 초성으로 그룹화
            Map<String, List<User>> groupedContacts = {};
            for (var contact in contacts) {
              String initialSound = getInitialSound(contact.name);
              if (!groupedContacts.containsKey(initialSound)) {
                groupedContacts[initialSound] = [];
              }
              groupedContacts[initialSound]!.add(contact);
            }

            return ListView.separated(
              itemCount: groupedContacts.keys.length,
              separatorBuilder: (context, index) => SizedBox(height: 10), // 그룹 간격
              itemBuilder: (context, index) {
                String key = groupedContacts.keys.elementAt(index);
                List<User> group = groupedContacts[key]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 카테고리 제목
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                      child: Text(
                        key, // 초성 제목
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    // 각 카테고리 그룹을 감싸는 컨테이너
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(40), bottom: Radius.circular(40)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(10.0), // 내부 여백
                      child: Column(
                        children: group.map((contact) {
                          bool isLastContact = group.last == contact; // 마지막 프로필 확인

                          return Column(
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.blue[200],
                                  child: Icon(Icons.person, color: Colors.white), // 프로필 아이콘
                                ),
                                title: Text(
                                  contact.name,
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
                                        userId: contact.id!,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              // 마지막 프로필이 아닐 경우에만 구분선 추가
                              if (!isLastContact)
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 20.0), // 좌우 여백 설정
                                  child: Divider( // 구분선 추가
                                    color: Colors.grey.shade400,
                                    height: 1,
                                    thickness: 1,
                                  ),
                                ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }



  // 초성을 반환하는 함수
  String getInitialSound(String name) {
    if (name.isEmpty) return '';
    // 한글 초성 표
    const initialSounds = [
      'ㄱ',
      'ㄲ',
      'ㄴ',
      'ㄷ',
      'ㄸ',
      'ㄹ',
      'ㅁ',
      'ㅂ',
      'ㅃ',
      'ㅅ',
      'ㅆ',
      'ㅇ',
      'ㅈ',
      'ㅉ',
      'ㅊ',
      'ㅋ',
      'ㅌ',
      'ㅍ',
      'ㅎ'
    ];

    int code = name.codeUnitAt(0);
    if (code < 0xAC00 || code > 0xD7A3) return name[0]; // 한글이 아닌 경우 원래 문자 반환

    int initialIndex = (code - 0xAC00) ~/ 588; // 초성 인덱스 계산
    return initialSounds[initialIndex];
  }
}
