import 'dart:convert';
import 'package:contact_hub/services/user.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://10.0.2.2:8080/api/contact";

  /// 모든 연락처 조회
  Future<List<User>?> fetchAllContacts() async {
    try {
      final url = Uri.parse(baseUrl);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        List<User> contacts = data.map((json) => User.fromJson(json)).toList();

        // 한글 이름 기준으로 정렬
        contacts.sort((a, b) => a.name.compareTo(b.name));

        return contacts;
      } else {
        print("Error fetching contacts: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  /// 특정 연락처 조회
  Future<User?> fetchContactById(int id) async {
    try {
      final url = Uri.parse("$baseUrl/$id");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      } else {
        print("Error fetching contact: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  /// 연락처 생성
  Future<User?> createContact(User user) async {
    try {
      final url = Uri.parse(baseUrl);
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 201) {
        return User.fromJson(jsonDecode(response.body));
      } else {
        print("Error creating contact: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  /// 연락처 수정
  Future<User?> updateContact(int id, User user) async {
    try {
      final url = Uri.parse("$baseUrl/$id");
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      } else {
        print("Error updating contact: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  /// 연락처 삭제
  Future<bool> deleteContact(int id) async {
    try {
      final url = Uri.parse("$baseUrl/$id");
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Error deleting contact: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }
}
