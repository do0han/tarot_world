// test_success.dart - 성공적인 서버 연동 테스트
import 'dart:io';
import 'dart:convert';

void main() async {
  print('✅ Tarot Constellation 정상 연동 테스트 시작');

  final testCases = [
    {
      'name': 'App Config API 테스트',
      'url': 'http://localhost:3000/app-config',
      'checkFields': ['name', 'menus', 'onboardingData', 'availableStyles']
    },
    {
      'name': 'Tarot Cards API 테스트',
      'url': 'http://localhost:3000/tarot-cards',
      'checkFields': ['total', 'cards', 'availableStyles']
    },
    {
      'name': 'Draw Cards API 테스트',
      'url': 'http://localhost:3000/draw-cards?count=3&style=vintage',
      'checkFields': ['drawnCards', 'sessionId', 'requestedCount']
    },
  ];

  for (var testCase in testCases) {
    await testApiCall(testCase['name']! as String, testCase['url']! as String,
        testCase['checkFields']! as List<String>);
    print('');
  }

  print('🎉 모든 API 연동 테스트 완료!');
  print('📱 Flutter 앱에서도 동일한 응답을 받을 수 있습니다.');
}

Future<void> testApiCall(
    String testName, String url, List<String> checkFields) async {
  print('📋 $testName');
  print('🌐 $url');

  try {
    final client = HttpClient();
    client.connectionTimeout = Duration(seconds: 10);

    final request = await client.getUrl(Uri.parse(url));
    final response = await request.close();

    if (response.statusCode == 200) {
      final responseBody = await response.transform(utf8.decoder).join();
      final jsonData = jsonDecode(responseBody);

      print('✅ HTTP 200 OK');
      print('✅ success: ${jsonData['success']}');
      print('📄 timestamp: ${jsonData['timestamp']}');

      if (jsonData['data'] != null) {
        final data = jsonData['data'];
        for (String field in checkFields) {
          if (data.containsKey(field)) {
            final value = data[field];
            if (value is List) {
              print('✅ $field: ${value.length} items');
            } else if (value is Map) {
              print('✅ $field: ${value.keys.length} properties');
            } else {
              print('✅ $field: $value');
            }
          } else {
            print('❌ $field: Missing');
          }
        }
      }
    } else {
      print('❌ HTTP ${response.statusCode}');
    }

    client.close();
  } catch (e) {
    print('❌ Error: $e');
  }
}
