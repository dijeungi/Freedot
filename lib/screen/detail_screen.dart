// lib/screen/detail_screen.dart

import 'package:flutter/material.dart';

import 'package:contact_hub/services/user.dart';
import 'package:contact_hub/services/api_service.dart';

import 'package:contact_hub/screen/home_screen.dart';
import 'package:contact_hub/components/widget/bottom_navigation_bar.dart';

class DetailScreen extends StatelessWidget {
  final int userId;
  const DetailScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Detail(userId: userId),
    );
  }
}

class Detail extends StatefulWidget {
  final int userId;
  const Detail({required this.userId});

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();

    return FutureBuilder<User?>(
      future: apiService.fetchContactById(widget.userId), // API 호출로 유저 정보 가져옴
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("에러가 발생했습니다."));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text("연락처 정보를 찾을 수 없습니다."));
        } else {
          final user = snapshot.data!;
          return Scaffold(
            body: ListView(
              children: [
                // 화면 상단 뒤로 가기 버튼
                Container(
                  padding: EdgeInsets.only(top: 40, left: 16),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.black, size: 28),
                        onPressed: () {
                          Navigator.pushNamed(context, '/home');
                        },
                      ),
                    ],
                  ),
                ),
                // 메인 카드와 상세 정보
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 800,
                  decoration: BoxDecoration(color: const Color(0xFFF5F5F5)),
                  child: Stack(
                    children: [
                      // 상단 카드
                      Positioned(
                        left: 0,
                        top: 30,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 150,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                      // 상세 정보 카드
                      Positioned(
                        left: 0,
                        top: 210,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 225,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                      // 이름
                      Positioned(
                        left: 30,
                        top: 80,
                        child: Text(
                          user.name,
                          style: TextStyle(
                            color: Color(0xFF222222),
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      // 전화번호
                      Positioned(
                        left: 30,
                        top: 110,
                        child: Text(
                          '휴대전화',
                          style: TextStyle(
                            color: Color(0xFFA5A5A5),
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 100,
                        top: 110,
                        child: Text(
                          user.phoneNumber,
                          style: TextStyle(
                            color: Color(0xFF222222),
                            fontSize: 14,
                          ),
                        ),
                      ),
                      // 프로필 아이콘
                      Positioned(
                        right: 53,
                        top: 70,
                        child: Icon(
                          Icons.account_circle,
                          size: 70,
                          color: Colors.blue,
                        ),
                      ),
                      // 닉네임
                      Positioned(
                        left: 30,
                        top: 245,
                        child: Icon(
                          Icons.person,
                          size: 30,
                          color: Colors.grey,
                        ),
                      ),
                      Positioned(
                        left: 80,
                        top: 247.5,
                        child: Text(
                          user.nickname != null && user.nickname!.isNotEmpty
                              ? user.nickname!
                              : '별명',
                          style: TextStyle(
                            color: Color(0xFF222222),
                            fontSize: 16,
                          ),
                        ),
                      ),
                      // 이메일
                      Positioned(
                        left: 30,
                        top: 307.5,
                        child: Icon(
                          Icons.email,
                          size: 30,
                          color: Colors.grey,
                        ),
                      ),
                      Positioned(
                        left: 80,
                        top: 310,
                        child: Text(
                          user.email ?? '이메일',
                          style: TextStyle(
                            color: Color(0xFF222222),
                            fontSize: 16,
                          ),
                        ),
                      ),
                      // 주소
                      Positioned(
                        left: 30,
                        top: 370,
                        child: Icon(
                          Icons.location_on,
                          size: 30,
                          color: Colors.grey,
                        ),
                      ),
                      Positioned(
                        left: 80,
                        top: 373,
                        child: Text(
                          user.address ?? '주소',
                          style: TextStyle(
                            color: Color(0xFF222222),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: DetailFooter(
                contactId: widget.userId,
                currentIndex: _currentIndex,
                onTap: _onItemTapped,
                onDelete: (int deletedContactId) {
                  Navigator.pushNamed(context, '/home');
                }
            ),
          );
        }
      },
    );
  }
}
