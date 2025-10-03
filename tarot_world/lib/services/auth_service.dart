// lib/services/auth_service.dart - 인증 서비스

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  // 개발 환경에 따라 URL 자동 선택
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000'; // 웹에서는 localhost
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:3000'; // Android 에뮬레이터에서는 10.0.2.2
    } else {
      return 'http://localhost:3000'; // iOS 및 기타 플랫폼
    }
  }
  
  // 사용자 로그인
  static Future<User> login(String username) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          final user = User.fromJson(data['data']['user']);
          
          // 자동 로그인을 위해 로컬에 사용자 정보 저장
          await _saveUserToLocal(user);
          
          return user;
        } else {
          throw Exception(data['error'] ?? '로그인 실패');
        }
      } else {
        throw Exception('서버 오류: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('로그인 실패: $e');
    }
  }

  // 사용자 프로필 조회
  static Future<User> getUserProfile(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user/profile/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          return User.fromJson(data['data']['user']);
        } else {
          throw Exception(data['error'] ?? '프로필 조회 실패');
        }
      } else {
        throw Exception('서버 오류: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('프로필 조회 실패: $e');
    }
  }

  // 광고 시청 보상
  static Future<Map<String, dynamic>> watchAdReward(int userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user/watch-ad'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          return data['data'];
        } else {
          throw Exception(data['error'] ?? '보상 수령 실패');
        }
      } else {
        throw Exception('서버 오류: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('보상 수령 실패: $e');
    }
  }

  // 코인 관리 (충전/차감)
  static Future<int> manageCoins(int userId, int amount, String operation) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/user/coins'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'amount': amount,
          'operation': operation, // 'add' or 'deduct'
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          return data['data']['newBalance'];
        } else {
          throw Exception(data['error'] ?? '코인 처리 실패');
        }
      } else {
        throw Exception('서버 오류: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('코인 처리 실패: $e');
    }
  }

  // 로컬에 사용자 정보 저장 (자동 로그인용)
  static Future<void> _saveUserToLocal(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', jsonEncode(user.toJson()));
    await prefs.setInt('user_id', user.id);
    await prefs.setString('username', user.username);
  }

  // 로컬에서 사용자 정보 조회
  static Future<User?> getLocalUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user_data');
      
      if (userData != null) {
        final userJson = jsonDecode(userData);
        return User.fromJson(userJson);
      }
      return null;
    } catch (e) {
      print('로컬 사용자 정보 조회 오류: $e');
      return null;
    }
  }

  // 자동 로그인 체크
  static Future<bool> isLoggedIn() async {
    final user = await getLocalUser();
    return user != null;
  }

  // 로그아웃
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data');
    await prefs.remove('user_id');
    await prefs.remove('username');
  }

  // 서버 연결 테스트
  static Future<bool> testConnection() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/app-config'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}