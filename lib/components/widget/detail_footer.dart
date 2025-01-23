import 'package:contact_hub/screen/edit_contact_screen.dart';
import 'package:flutter/material.dart';
import 'package:contact_hub/services/api_service.dart';

class DetailFooter extends StatelessWidget {
  final int? currentIndex;
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
          GestureDetector(
            onTap: () async {
              onTap(0);
              final newContact = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditContact(contactId: contactId)),
              );
              if (newContact != null) {
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.edit,
                  color: currentIndex == 0 ? Colors.black : Colors.grey,
                ),
                const SizedBox(height: 4.0),
                Text(
                  '편집',
                  style: TextStyle(
                    color: currentIndex == 0 ? Colors.black : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              onTap(1);

              final shouldDelete = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("삭제 확인"),
                  content: Text('이 연락처를 삭제하시겠습니까?'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context,false),
                        child: Text('취소'),
                    ),
                    TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text('삭제')
                    ),
                  ],
                )
              );

              if (shouldDelete == true) {
                final success = await apiService.deleteContact(contactId);

                if(success){
                  onDelete(contactId);
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('연락처가 삭제되었습니다.'))
                );

                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('연락처 삭제에 실패했습니다.')),
                );
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.delete,
                  color: currentIndex == 1 ? Colors.black : Colors.grey,
                ),
                const SizedBox(height: 4.0),
                Text(
                  '삭제',
                  style: TextStyle(
                    color: currentIndex == 1 ? Colors.black : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
