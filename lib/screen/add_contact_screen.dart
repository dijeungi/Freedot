// 연락처 추가 화면

import 'package:contact_hub/services/api_service.dart';
import 'package:contact_hub/services/user.dart';
import 'package:flutter/material.dart';

class AddContactScreen extends StatefulWidget {
  @override
  _AddContactScreenState createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _phoneNumber = '';
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // 뒤로가기 버튼 없애기
        backgroundColor: Colors.white,
        title: Container(
          padding: EdgeInsets.only(left: 16.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.smartphone,
                size: 24,
                color: Colors.black, // 아이콘 색상 설정
              ),
              SizedBox(width: 8),
              Text(
                '휴대전화',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      ),

      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: <Widget>[
                      Stack(
                        children: [
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image.asset(
                                'images/add_contact.png',
                                width: double.infinity,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 25,
                            bottom: 25,
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                CircleAvatar(
                                  radius: 35,
                                  child: Icon(Icons.person, size: 45),
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: CircleAvatar(
                                    radius: 13,
                                    backgroundColor: Colors.black,
                                    child: Icon(Icons.add, size: 20, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      _buildRoundedTextFormField(
                        labelText: '이름',
                        icon: Icons.person,
                        onSaved: (value) {
                          _name = value!;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '이름을 입력하세요.';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      _buildRoundedTextFormField(
                        labelText: '전화번호',
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        onSaved: (value) {
                          _phoneNumber = value!;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '전화번호를 입력하세요.';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      if (_isExpanded) _buildExpandedContent(),
                      if (_isExpanded)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isExpanded = false;
                            });
                          },
                          child: Text('▲ 항목 숨기기'),
                        )
                      else
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isExpanded = true;
                            });
                          },
                          child: Text('▼ 항목 더보기'),
                        ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    child: Text('취소',
                    style: TextStyle(
                      color: Color(0xFF222222),
                      fontSize: 20,
                    ),),
                  ),
                  SizedBox(width: 100), // 간격 추가
                  TextButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        final newContact = User(
                          name: _name,
                          phoneNumber: _phoneNumber,
                          nickname: null,
                          email: null,
                          address: null,
                        );

                        final ApiService apiService = ApiService();
                        final savedContact = await apiService.createContact(newContact);

                        if (savedContact != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('연락처가 저장되었습니다.')),
                          );

                          Navigator.pop(context, savedContact);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('연락처 저장에 실패했습니다.')),
                          );
                        }
                      }
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    child: Text('저장',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF222222),
                      ),),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoundedTextFormField({
    required String labelText,
    required IconData icon,
    TextInputType? keyboardType,
    required void Function(String?) onSaved,
    required String? Function(String?) validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: Colors.grey),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: TextFormField(
        style: TextStyle(
          color: Color(0xFF222222),
        ),
        decoration: InputDecoration(
          labelText: labelText,
          icon: Icon(icon),
          border: InputBorder.none,
        ),
        keyboardType: keyboardType,
        onSaved: onSaved,
        validator: validator,
      ),
    );
  }

  Widget _buildExpandedContent() {
    return Column(
      children: [
        _buildRoundedTextFormField(
          labelText: '별명',
          icon: Icons.star,
          onSaved: (value) {
            // 별명 저장 기능 추가
          },
          validator: (value) {
            return null;
          },
        ),
        SizedBox(height: 20),
        _buildRoundedTextFormField(
          labelText: '이메일',
          icon: Icons.email,
          onSaved: (value) {
            // 이메일 저장 기능 추가
          },
          validator: (value) {
            return null;
          },
        ),
        SizedBox(height: 20),
        _buildRoundedTextFormField(
          labelText: '주소',
          icon: Icons.home,
          onSaved: (value) {
            // 주소 저장 기능 추가
          },
          validator: (value) {
            return null;
          },
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
