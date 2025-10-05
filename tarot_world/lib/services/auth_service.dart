// lib/services/auth_service.dart - 인증 서비스

import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart'; // 안드로이드 빌드 문제로 임시 제거
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
  
  // 사용자 로그인 - 입력 유효성 검사 강화
  static Future<User> login(String username) async {
    try {
      // 입력 유효성 검사
      if (username.isEmpty) {
        throw Exception('사용자명을 입력해주세요');
      }
      
      final trimmedUsername = username.trim();
      if (trimmedUsername.length < 2) {
        throw Exception('사용자명은 2글자 이상이어야 합니다');
      }
      
      if (trimmedUsername.length > 20) {
        throw Exception('사용자명은 20글자 이하여야 합니다');
      }
      
      // 특수문자 검사 (한글, 영문, 숫자, 언더스코어만 허용)
      final validPattern = RegExp(r'^[가-힣a-zA-Z0-9_]+$');
      if (!validPattern.hasMatch(trimmedUsername)) {
        throw Exception('사용자명은 한글, 영문, 숫자, 언더스코어(_)만 사용 가능합니다');
      }
      
      print('Attempting login to: $baseUrl/auth/login');
      print('Username: $trimmedUsername');
      
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': trimmedUsername}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          final user = User.fromJson(data['data']['user']);
          
          // 자동 로그인을 위해 로컬에 사용자 정보 저장 (임시 비활성화)
          // await _saveUserToLocal(user);
          
          return user;
        } else {
          throw Exception(data['error'] ?? '로그인 실패');
        }
      } else if (response.statusCode == 400) {
        final data = jsonDecode(response.body);
        throw Exception(data['error'] ?? '잘못된 요청입니다');
      } else {
        throw Exception('서버 오류: ${response.statusCode}');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
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

  // V2.0 타로 리딩 실행 (코인 차감 포함) - 입력 유효성 검사 강화
  static Future<Map<String, dynamic>> executeTarotReading(int userId, int menuId, int cardCount) async {
    try {
      // 입력 유효성 검사
      if (userId <= 0) {
        throw Exception('유효하지 않은 사용자 ID입니다');
      }
      
      if (menuId <= 0) {
        throw Exception('유효하지 않은 메뉴 ID입니다');
      }
      
      if (cardCount <= 0 || cardCount > 10) {
        throw Exception('카드 개수는 1장에서 10장 사이여야 합니다');
      }
      
      print('타로 리딩 시작: userId=$userId, menuId=$menuId, cardCount=$cardCount');
      
      final response = await http.post(
        Uri.parse('$baseUrl/tarot/read'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'menuId': menuId,
          'cardCount': cardCount,
        }),
      ).timeout(const Duration(seconds: 30));

      print('타로 리딩 응답: ${response.statusCode}');
      print('응답 내용: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          // 응답 데이터 검증
          if (data['data'] == null) {
            throw Exception('서버 응답 데이터가 없습니다');
          }
          
          final responseData = data['data'];
          if (responseData['reading'] == null || responseData['historyId'] == null) {
            throw Exception('서버 응답 데이터가 불완전합니다');
          }
          
          return {
            'success': true,
            'reading': responseData['reading'],
            'historyId': responseData['historyId'],
            'userCoinBalance': responseData['userCoinBalance'] ?? 0,
            'coinsUsed': responseData['coinsUsed'] ?? 0,
          };
        } else {
          throw Exception(data['error'] ?? '타로 리딩 실패');
        }
      } else if (response.statusCode == 402) {
        // 코인 부족
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'error': 'insufficient_coins',
          'message': data['error'] ?? '코인이 부족합니다',
        };
      } else if (response.statusCode == 400) {
        // 잘못된 요청
        final data = jsonDecode(response.body);
        throw Exception(data['error'] ?? '잘못된 요청입니다');
      } else if (response.statusCode == 404) {
        // 사용자 또는 메뉴 없음
        final data = jsonDecode(response.body);
        throw Exception(data['error'] ?? '요청한 데이터를 찾을 수 없습니다');
      } else {
        throw Exception('서버 오류: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('요청 시간이 초과되었습니다. 잠시 후 다시 시도해주세요');
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      print('타로 리딩 오류: $e');
      throw Exception('타로 리딩 실패: $e');
    }
  }

  // 사용자 리딩 히스토리 조회
  static Future<List<dynamic>> getUserReadingHistory(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user/history/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          // ReadingHistoryItem import를 피하기 위해 dynamic 리스트 반환
          return data['data']['history'] as List<dynamic>;
        } else {
          throw Exception(data['error'] ?? '히스토리 조회 실패');
        }
      } else {
        throw Exception('서버 오류: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('히스토리 조회 실패: $e');
    }
  }

  // 로컬에 사용자 정보 저장 (자동 로그인용) - 임시 비활성화
  // static Future<void> _saveUserToLocal(User user) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('user_data', jsonEncode(user.toJson()));
  //   await prefs.setInt('user_id', user.id);
  //   await prefs.setString('username', user.username);
  // }

  // 로컬에서 사용자 정보 조회 - 임시 비활성화
  static Future<User?> getLocalUser() async {
    try {
      // SharedPreferences 임시 비활성화
      // final prefs = await SharedPreferences.getInstance();
      // final userData = prefs.getString('user_data');
      
      // if (userData != null) {
      //   final userJson = jsonDecode(userData);
      //   return User.fromJson(userJson);
      // }
      return null;
    } catch (e) {
      print('로컬 사용자 정보 조회 오류: $e');
      return null;
    }
  }

  // 자동 로그인 체크 - 임시 비활성화
  static Future<bool> isLoggedIn() async {
    // final user = await getLocalUser();
    // return user != null;
    return false; // 임시로 항상 false 반환
  }

  // 로그아웃 - 임시 비활성화
  static Future<void> logout() async {
    // SharedPreferences 임시 비활성화
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.remove('user_data');
    // await prefs.remove('user_id');
    // await prefs.remove('username');
  }

  // 서버 연결 테스트 (강화된 버전)
  static Future<Map<String, dynamic>> testConnection() async {
    try {
      print('Testing connection to: $baseUrl/app-config');
      
      final response = await http.get(
        Uri.parse('$baseUrl/app-config'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      print('Response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'status': 'connected',
          'latency': DateTime.now().millisecondsSinceEpoch,
        };
      } else {
        return {
          'success': false,
          'status': 'server_error',
          'code': response.statusCode,
          'message': 'Server returned ${response.statusCode}',
        };
      }
    } on TimeoutException {
      return {
        'success': false,
        'status': 'timeout',
        'message': '서버 응답이 지연되고 있습니다. 잠시 후 다시 시도해주세요.',
      };
    } on SocketException {
      return {
        'success': false,
        'status': 'network_error',
        'message': '인터넷 연결을 확인해주세요.',
      };
    } catch (e) {
      print('Connection test failed: $e');
      return {
        'success': false,
        'status': 'unknown_error',
        'message': '알 수 없는 오류가 발생했습니다: $e',
      };
    }
  }

  // 네트워크 오류 복구 시도
  static Future<bool> attemptRecovery() async {
    const maxRetries = 3;
    const retryDelay = Duration(seconds: 2);
    
    for (int i = 0; i < maxRetries; i++) {
      print('네트워크 복구 시도 ${i + 1}/$maxRetries');
      
      final result = await testConnection();
      if (result['success'] == true) {
        print('네트워크 복구 성공');
        return true;
      }
      
      if (i < maxRetries - 1) {
        print('${retryDelay.inSeconds}초 후 재시도...');
        await Future.delayed(retryDelay);
      }
    }
    
    print('네트워크 복구 실패');
    return false;
  }
}