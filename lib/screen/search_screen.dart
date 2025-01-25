// lib/screen/search_screen.dart

import 'package:flutter/material.dart';

import 'package:contact_hub/services/user.dart';
import 'package:contact_hub/screen/detail_screen.dart';

class SearchScreen extends StatefulWidget {
  final Future<List<User>?> contactsFuture;

  const SearchScreen({Key? key, required this.contactsFuture})
      : super(key: key);

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
        preferredSize: Size.fromHeight(0),
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
            final filteredItems = items
                .where((item) =>
                    searchText.isEmpty ||
                    item.name
                        .toLowerCase()
                        .contains(searchText.toLowerCase()) ||
                    item.phoneNumber.contains(searchText))
                .toList();

            final filteredCount = filteredItems.length;

            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          padding: const EdgeInsets.only(left: 20.0),
                          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
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
                                searchText = value.trim();
                              });
                            },
                          ),
                        ),
                        IconButton(
                          padding: const EdgeInsets.only(right: 20.0),
                          icon: Icon(Icons.search, color: Colors.black),
                          onPressed: () {
                            print("검색어: $searchText");
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                if (searchText.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "연락처",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.normal),
                        ),
                        Text(
                          "$filteredCount 개 검색됨",
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                ],
                Expanded(
                  child: filteredCount == 0
                      ? Center(child: Text("검색 결과가 없습니다."))
                      : ListView.builder(
                          itemCount: filteredCount,
                          itemBuilder: (BuildContext context, int index) {
                            final item = filteredItems[index];

                            return Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.blue[200],
                                  child:
                                      Icon(Icons.person, color: Colors.white),
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
