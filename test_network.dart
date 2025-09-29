// test_network.dart - 네트워크 연동 테스트
import 'dart:io';
import 'dart:convert';

void main() async {
  print('🔗 Tarot Constellation 네트워크 연동 테스트 시작');

  final testCases = [
    {'name': '서버 연결 실패 (서버 중지 상태)', 'url': 'http://localhost:3000/app-config'},
    {'name': '잘못된 엔드포인트', 'url': 'http://localhost:3000/wrong-endpoint'},
    {'name': '존재하지 않는 서버', 'url': 'http://nonexistent-server:3000/app-config'},
  ];

  for (var testCase in testCases) {
    await testNetworkCall(testCase['name']!, testCase['url']!);
    print('');
  }

  print('🔄 서버를 다시 시작하고 정상 연결 테스트...');
  print('(수동으로 "cd tarot_server && node server.js" 실행 후 다시 테스트)');
}

Future<void> testNetworkCall(String testName, String url) async {
  print('📋 테스트: $testName');
  print('🌐 URL: $url');

  try {
    final client = HttpClient();
    client.connectionTimeout = Duration(seconds: 5);

    final request = await client.getUrl(Uri.parse(url));
    final response = await request.close();

    if (response.statusCode == 200) {
      final responseBody = await response.transform(utf8.decoder).join();
      final jsonData = jsonDecode(responseBody);
      print(
          '✅ 성공: ${jsonData['success']} - ${jsonData['data']?['name'] ?? 'Unknown'}');
    } else {
      print('❌ HTTP 오류: ${response.statusCode}');
    }

    client.close();
  } on SocketException catch (e) {
    print('🔌 연결 오류: ${e.message}');
    print('   → ApiService 예상 처리: "인터넷 연결을 확인해주세요"');
  } on HttpException catch (e) {
    print('📡 HTTP 오류: ${e.message}');
    print('   → ApiService 예상 처리: "서버에 연결할 수 없습니다"');
  } on FormatException catch (e) {
    print('📄 응답 형식 오류: ${e.message}');
    print('   → ApiService 예상 처리: "서버 응답 형식이 올바르지 않습니다"');
  } catch (e) {
    print('❓ 예상치 못한 오류: $e');
    print('   → ApiService 예상 처리: "예상치 못한 오류가 발생했습니다"');
  }
}
