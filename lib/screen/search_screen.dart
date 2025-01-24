// lib/screen/search_screen.dart

import 'package:flutter/material.dart';

import 'package:contact_hub/services/user.dart';
import 'package:contact_hub/screen/detail_screen.dart';

class SearchScreen extends StatefulWidget {
  final Future<List<User>?> contactsFuture;

  const SearchScreen({Key? key, required this.contactsFuture}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0), // AppBar 숨기기
        child: Container(),
      ),
      body: FutureBuilder<List<User>?>(
        future: widget.contactsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("에러가 발생했습니다: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("연락처가 없습니다."));
          } else {
            final items = snapshot.data!;
            // 검색된 항목 필터링
            final filteredItems = items.where((item) =>
            searchText.isEmpty ||
                item.name.toLowerCase().contains(searchText.toLowerCase()) ||
                item.phoneNumber.contains(searchText)) // 전화번호 검색도 가능
                .toList();

            final filteredCount = filteredItems.length;

            return Column(
              children: <Widget>[
                // 검색 입력 필드
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        // 뒤로가기 버튼
                        IconButton(
                          padding: const EdgeInsets.only(left: 20.0),
                          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        // 검색 입력 필드
                        Expanded(
                          child: TextField(
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              hintText: '검색어를 입력해주세요.',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                              isDense: true,
                            ),
                            onChanged: (value) {
                              setState(() {
                                searchText = value.trim(); // 검색어 업데이트 및 공백 제거
                              });
                            },
                          ),
                        ),
                        // 돋보기 아이콘
                        IconButton(
                          padding: const EdgeInsets.only(right: 20.0),
                          icon: Icon(Icons.search, color: Colors.black),
                          onPressed: () {
                            print("검색어: $searchText"); // 검색어 출력
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20), // 검색창과 결과 리스트 사이의 여백

                // 검색어가 있는 경우에만 연락처 제목 및 검색 결과 수 표시
                if (searchText.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "연락처",
                          style: TextStyle(
                              fontSize: 18, color: Colors.grey[600], fontWeight: FontWeight.normal),
                        ),
                        Text(
                          "$filteredCount 개 검색됨",
                          style: TextStyle(
                              fontSize: 16, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10), // 제목과 결과 리스트 사이의 여백
                ],

                // 연락처 리스트를 감싸는 Expanded
                Expanded(
                  child: filteredCount == 0
                      ? Center(
                      child: Text("검색 결과가 없습니다.")) // 검색 결과가 없을 때 텍스트 표시
                      : ListView.builder(
                    itemCount: filteredCount,
                    itemBuilder: (BuildContext context, int index) {
                      final item = filteredItems[index];

                      // 리스트 항목 렌더링
                      return Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16), // 항목 간격 조정
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3), // 그림자 위치 조정
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue[200],
                            child: Icon(
                                Icons.person, color: Colors.white), // 아이콘 추가
                          ),
                          title: Text(
                            item.name,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            item.phoneNumber,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          onTap: () {
                            // 연락처 상세 페이지로 이동
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailScreen(userId: item.id!),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}