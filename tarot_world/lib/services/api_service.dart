// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/app_config.dart';

class ApiService {
  // 실제 서버 주소 또는 로컬 테스트 주소
  // ※주의: Android 에뮬레이터에서 localhost에 접근하려면 10.0.2.2를 사용해야 합니다.
  static const String _baseUrl = "http://10.0.2.2:3000";

  // 앱 설정 및 메뉴 데이터 가져오기
  Future<AppConfig> getAppConfig(String packageName) async {
    final response = await http
        .get(Uri.parse('$_baseUrl/app-config?packageName=$packageName'));

    if (response.statusCode == 200) {
      // UTF-8로 디코딩하여 한글 깨짐 방지
      final String responseBody = utf8.decode(response.bodyBytes);
      return AppConfig.fromJson(jsonDecode(responseBody));
    } else {
      throw Exception('Failed to load app config');
    }
  }

  // 전체 타로 카드 데이터 가져오기
  Future<List<TarotCard>> getTarotCards() async {
    final response = await http.get(Uri.parse('$_baseUrl/tarot-cards'));

    if (response.statusCode == 200) {
      final String responseBody = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> jsonData = jsonDecode(responseBody);

      var cardList = jsonData['cards'] as List;
      return cardList.map((i) => TarotCard.fromJson(i)).toList();
    } else {
      throw Exception('Failed to load tarot cards');
    }
  }

  // 랜덤 카드 뽑기
  Future<DrawCardsResponse> drawCards(int count, String style) async {
    final response = await http
        .get(Uri.parse('$_baseUrl/draw-cards?count=$count&style=$style'));

    if (response.statusCode == 200) {
      final String responseBody = utf8.decode(response.bodyBytes);
      return DrawCardsResponse.fromJson(jsonDecode(responseBody));
    } else {
      throw Exception('Failed to draw cards');
    }
  }

  // 사용 가능한 카드 스타일 목록 가져오기
  Future<List<String>> getAvailableStyles() async {
    final response = await http.get(Uri.parse('$_baseUrl/tarot-cards'));

    if (response.statusCode == 200) {
      final String responseBody = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> jsonData = jsonDecode(responseBody);

      List<dynamic> styles = jsonData['availableStyles'] ?? [];
      return styles.map((style) => style.toString()).toList();
    } else {
      throw Exception('Failed to load available styles');
    }
  }
}
