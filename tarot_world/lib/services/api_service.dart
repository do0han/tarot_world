// lib/services/api_service.dart
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

  // 공통 HTTP 요청 처리
  static Future<Map<String, dynamic>> _makeRequest(String endpoint,
      {Map<String, String>? queryParams}) async {
    try {
      Uri uri = Uri.parse('$_baseUrl$endpoint');
      if (queryParams != null) {
        uri = uri.replace(queryParameters: queryParams);
      }

      final response = await _httpClient.get(uri).timeout(_timeout);
      final String responseBody = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> jsonData = jsonDecode(responseBody);

      if (response.statusCode == 200) {
        if (jsonData['success'] == true) {
          return jsonData;
        } else {
          throw NetworkException(
            jsonData['error'] ?? 'Unknown server error',
            statusCode: jsonData['statusCode'],
            details: jsonData['details'],
          );
        }
      } else {
        throw NetworkException(
          'HTTP ${response.statusCode}: ${response.reasonPhrase}',
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      throw NetworkException('인터넷 연결을 확인해주세요.');
    } on http.ClientException {
      throw NetworkException('서버에 연결할 수 없습니다.');
    } on FormatException {
      throw NetworkException('서버 응답 형식이 올바르지 않습니다.');
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw NetworkException('예상치 못한 오류가 발생했습니다: $e');
    }
  }

  // 앱 설정 및 메뉴 데이터 가져오기
  Future<AppConfig> getAppConfig([String? packageName]) async {
    final Map<String, String>? queryParams =
        packageName != null ? {'packageName': packageName} : null;
    final jsonData =
        await _makeRequest('/app-config', queryParams: queryParams);
    return AppConfig.fromJson(jsonData['data']);
  }

  // 전체 타로 카드 데이터 가져오기
  Future<List<TarotCard>> getTarotCards() async {
    final jsonData = await _makeRequest('/tarot-cards');
    var cardList = jsonData['data']['cards'] as List;
    return cardList.map((i) => TarotCard.fromJson(i)).toList();
  }

  // 랜덤 카드 뽑기
  Future<DrawCardsResponse> drawCards(int count, String style) async {
    final queryParams = {
      'count': count.toString(),
      'style': style,
    };
    final jsonData =
        await _makeRequest('/draw-cards', queryParams: queryParams);
    return DrawCardsResponse.fromJson(jsonData['data']);
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