// lib/components/widget/bottom_navigation_bar.dart

import 'package:flutter/material.dart';

import 'package:contact_hub/services/api_service.dart';
import 'package:contact_hub/screen/edit_screen.dart';

class DetailFooter extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final int contactId;
  final Function(int) onDelete;

  const DetailFooter({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.contactId,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ApiService apiService = ApiService();

    return Container(
      height: 100.0,
      color: const Color(0xFFF5F5F5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildActionButton(
            context: context,
            icon: Icons.edit,
            label: '편집',
            isActive: currentIndex == 0,
            onTap: () async {
              onTap(0);
              final newContact = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditScreen(contactId: contactId),
                ),
              );
              if (newContact != null) {
                // 편집 후 추가 작업 필요시 여기에 작성
              }
            },
          ),
          _buildActionButton(
            context: context,
            icon: Icons.delete,
            label: '삭제',
            isActive: currentIndex == 1,
            onTap: () async {
              onTap(1);

              final shouldDelete = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("삭제 확인"),
                  content: Text('이 연락처를 삭제하시겠습니까?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('취소'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text('삭제'),
                    ),
                  ],
                ),
              );

              if (shouldDelete == true) {
                try {
                  final success = await apiService.deleteContact(contactId);
                  if (success) {
                    onDelete(contactId);
                    _showSnackBar(context, '연락처가 삭제되었습니다.');
                    Navigator.pop(context);
                  } else {
                    _showSnackBar(context, '연락처 삭제에 실패했습니다.');
                  }
                } catch (error) {
                  _showSnackBar(context, '에러가 발생했습니다: $error');
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive ? Colors.black : Colors.grey,
          ),
          const SizedBox(height: 4.0),
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.black : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
