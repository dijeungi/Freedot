// lib/screen/edit_screen.dart

import 'package:flutter/material.dart';

import 'package:contact_hub/services/user.dart';
import 'package:contact_hub/services/api_service.dart';

class EditScreen extends StatefulWidget {
  final int contactId;

  const EditScreen({Key? key, required this.contactId}) : super(key: key);

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _phoneNumber = '';
  String? _nickname;
  String? _email;
  String? _address;
  bool _isExpanded = false;
  bool _isLoading = true;
  late ApiService apiService;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    _fetchContactData();
  }

  Future<void> _fetchContactData() async {
    final contact = await apiService.fetchContactById(widget.contactId);
    if (contact != null) {
      setState(() {
        _name = contact.name;
        _phoneNumber = contact.phoneNumber;
        _nickname = contact.nickname;
        _email = contact.email;
        _address = contact.address;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('수정 페이지')),
        body: Center(child: CircularProgressIndicator()),
        backgroundColor: Colors.white,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('수정 페이지'),
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
                                  backgroundColor: Colors.blue[200],
                                  child: Icon(
                                    Icons.person,
                                    size: 45,
                                    color: Colors.white,
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: CircleAvatar(
                                    radius: 13,
                                    backgroundColor: Colors.black,
                                    child: Icon(Icons.edit,
                                        size: 15, color: Colors.white),
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
                        initialValue: _name,
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
                        initialValue: _phoneNumber,
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
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.black),
                          child: Text('▲ 항목 숨기기'),
                        )
                      else
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isExpanded = true;
                            });
                          },
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.black),
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    child: Text(
                      '취소',
                      style: TextStyle(
                        color: Color(0xFF222222),
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(width: 100),
                  TextButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        final updatedContact = User(
                          id: widget.contactId,
                          name: _name,
                          phoneNumber: _phoneNumber,
                          nickname:
                              _nickname?.isNotEmpty == true ? _nickname : null,
                          email: _email?.isNotEmpty == true ? _email : null,
                          address:
                              _address?.isNotEmpty == true ? _address : null,
                        );

                        final success = await apiService.updateContact(
                            widget.contactId, updatedContact);

                        if (success != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('연락처가 수정되었습니다.')),
                          );

                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/home',
                            (Route<dynamic> route) => false,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('연락처 수정에 실패했습니다.')),
                          );
                        }
                      }
                    },
                    style: TextButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    child: Text(
                      '저장',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF222222),
                      ),
                    ),
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
    required String initialValue,
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
        initialValue: initialValue,
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
          initialValue: _nickname ?? '',
          onSaved: (value) {
            _nickname = value;
          },
          validator: (value) {
            return null;
          },
        ),
        SizedBox(height: 20),
        _buildRoundedTextFormField(
          labelText: '이메일',
          icon: Icons.email,
          initialValue: _email ?? '',
          onSaved: (value) {
            _email = value;
          },
          validator: (value) {
            return null;
          },
        ),
        SizedBox(height: 20),
        _buildRoundedTextFormField(
          labelText: '주소',
          icon: Icons.home,
          initialValue: _address ?? '',
          onSaved: (value) {
            _address = value;
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
