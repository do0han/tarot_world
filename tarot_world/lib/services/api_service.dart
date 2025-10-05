// lib/services/api_service.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/app_config.dart';

// API 응답 표준 포맷
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? error;
  final String timestamp;
  final int statusCode;

  ApiResponse({
    required this.success,
    this.data,
    this.error,
    required this.timestamp,
    required this.statusCode,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      error: json['error'],
      timestamp: json['timestamp'] ?? DateTime.now().toIso8601String(),
      statusCode: json['statusCode'] ?? 200,
    );
  }
}

// 네트워크 예외 처리
class NetworkException implements Exception {
  final String message;
  final int? statusCode;
  final String? details;

  NetworkException(this.message, {this.statusCode, this.details});

  @override
  String toString() => 'NetworkException: $message';
}

class ApiService {
  // Android 에뮬레이터에서 localhost 접근을 위한 주소
  static const String _baseUrl = "http://10.0.2.2:3000";
  static const Duration _timeout = Duration(seconds: 10);

  // HTTP 클라이언트 설정
  static final http.Client _httpClient = http.Client();

  // 공통 HTTP 요청 처리 - 응답 검증 강화
  static Future<Map<String, dynamic>> _makeRequest(String endpoint,
      {Map<String, String>? queryParams}) async {
    try {
      Uri uri = Uri.parse('$_baseUrl$endpoint');
      if (queryParams != null) {
        uri = uri.replace(queryParameters: queryParams);
      }

      print('API 요청: $uri');

      final response = await _httpClient.get(uri).timeout(_timeout);
      
      // 응답 상태 코드 검증
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw NetworkException(
          'HTTP ${response.statusCode}: ${response.reasonPhrase}',
          statusCode: response.statusCode,
        );
      }

      // 응답 본문 검증
      if (response.body.isEmpty) {
        throw NetworkException('서버 응답이 비어있습니다', statusCode: response.statusCode);
      }

      final String responseBody = utf8.decode(response.bodyBytes);
      
      // JSON 파싱 및 검증
      late Map<String, dynamic> jsonData;
      try {
        jsonData = jsonDecode(responseBody);
      } catch (e) {
        throw NetworkException('서버 응답을 JSON으로 파싱할 수 없습니다: $e');
      }

      // API 응답 구조 검증
      if (!jsonData.containsKey('success')) {
        throw NetworkException('서버 응답에 success 필드가 없습니다');
      }

      if (!jsonData.containsKey('timestamp')) {
        throw NetworkException('서버 응답에 timestamp 필드가 없습니다');
      }

      // 성공 응답 검증
      if (jsonData['success'] == true) {
        if (!jsonData.containsKey('data')) {
          throw NetworkException('성공 응답에 data 필드가 없습니다');
        }
        
        if (jsonData['data'] == null) {
          throw NetworkException('응답 데이터가 null입니다');
        }

        print('API 응답 성공: $endpoint');
        return jsonData;
      } else {
        // 실패 응답 처리
        final errorMessage = jsonData['error'] ?? 'Unknown server error';
        final statusCode = jsonData['statusCode'] ?? response.statusCode;
        
        throw NetworkException(
          errorMessage,
          statusCode: statusCode,
          details: jsonData['details'],
        );
      }
    } on SocketException catch (e) {
      throw NetworkException('인터넷 연결을 확인해주세요: ${e.message}');
    } on http.ClientException catch (e) {
      throw NetworkException('서버에 연결할 수 없습니다: ${e.message}');
    } on FormatException catch (e) {
      throw NetworkException('서버 응답 형식이 올바르지 않습니다: ${e.message}');
    } on TimeoutException {
      throw NetworkException('요청 시간이 초과되었습니다. 잠시 후 다시 시도해주세요.');
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw NetworkException('예상치 못한 오류가 발생했습니다: $e');
    }
  }

  // 앱 설정 및 메뉴 데이터 가져오기 - 응답 검증 강화
  Future<AppConfig> getAppConfig([String? packageName]) async {
    final Map<String, String>? queryParams =
        packageName != null ? {'packageName': packageName} : null;
    
    final jsonData = await _makeRequest('/app-config', queryParams: queryParams);
    
    // 응답 데이터 구조 검증
    final data = jsonData['data'];
    if (data == null) {
      throw NetworkException('앱 설정 데이터가 없습니다');
    }

    // 필수 필드 검증
    if (data['name'] == null || data['name'].toString().isEmpty) {
      throw NetworkException('앱 이름이 없습니다');
    }

    if (data['menus'] == null || !(data['menus'] is List)) {
      throw NetworkException('메뉴 데이터가 없거나 올바르지 않습니다');
    }

    try {
      return AppConfig.fromJson(data);
    } catch (e) {
      throw NetworkException('앱 설정 데이터 파싱 실패: $e');
    }
  }

  // 전체 타로 카드 데이터 가져오기 - 응답 검증 강화
  Future<List<TarotCard>> getTarotCards() async {
    final jsonData = await _makeRequest('/tarot-cards');
    
    // 응답 데이터 구조 검증
    final data = jsonData['data'];
    if (data == null) {
      throw NetworkException('타로 카드 데이터가 없습니다');
    }

    if (data['cards'] == null || !(data['cards'] is List)) {
      throw NetworkException('카드 목록이 없거나 올바르지 않습니다');
    }

    final cardList = data['cards'] as List;
    if (cardList.isEmpty) {
      throw NetworkException('타로 카드 목록이 비어있습니다');
    }

    try {
      return cardList.map((i) => TarotCard.fromJson(i)).toList();
    } catch (e) {
      throw NetworkException('타로 카드 데이터 파싱 실패: $e');
    }
  }

  // 랜덤 카드 뽑기 - 입력 및 응답 검증 강화
  Future<DrawCardsResponse> drawCards(int count, String style) async {
    // 입력 검증
    if (count <= 0 || count > 10) {
      throw NetworkException('카드 개수는 1-10장 사이여야 합니다');
    }

    if (style.isEmpty) {
      throw NetworkException('카드 스타일을 선택해주세요');
    }

    final queryParams = {
      'count': count.toString(),
      'style': style,
    };
    
    final jsonData = await _makeRequest('/draw-cards', queryParams: queryParams);
    
    // 응답 데이터 구조 검증
    final data = jsonData['data'];
    if (data == null) {
      throw NetworkException('카드 뽑기 데이터가 없습니다');
    }

    if (data['drawnCards'] == null || !(data['drawnCards'] is List)) {
      throw NetworkException('뽑힌 카드 목록이 없거나 올바르지 않습니다');
    }

    final drawnCards = data['drawnCards'] as List;
    if (drawnCards.isEmpty) {
      throw NetworkException('뽑힌 카드가 없습니다');
    }

    if (drawnCards.length != count) {
      throw NetworkException('요청한 카드 개수와 응답 개수가 다릅니다');
    }

    try {
      return DrawCardsResponse.fromJson(data);
    } catch (e) {
      throw NetworkException('카드 뽑기 데이터 파싱 실패: $e');
    }
  }

  // 사용 가능한 카드 스타일 목록 가져오기
  Future<List<CardStyle>> getAvailableStyles() async {
    final jsonData = await _makeRequest('/tarot-cards');
    List<dynamic> styles = jsonData['data']['availableStyles'] ?? [];
    return styles.map((style) => CardStyle.fromJson(style)).toList();
  }

  // 연결 상태 확인
  Future<bool> checkConnection() async {
    try {
      await _makeRequest('/app-config');
      return true;
    } catch (e) {
      return false;
    }
  }

  // 리소스 정리
  static void dispose() {
    _httpClient.close();
  }
}