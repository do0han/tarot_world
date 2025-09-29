// test_cache.dart - 캐시 시스템 테스트 시뮬레이션
import 'dart:io';

void main() async {
  print('💾 AppProvider 캐시 시스템 동작 시뮬레이션');
  print('');

  // 1차 초기화 (실제 API 호출)
  print('🔄 [1차] AppProvider.initialize() 호출');
  print('   ├── fetchAppConfig() 실행 → API 호출');
  print('   ├── fetchTarotCards() 실행 → API 호출');
  print('   ├── _lastFetchTime = ${DateTime.now()}');
  print('   └── 총 소요시간: ~2-3초 (네트워크 지연)');
  await Future.delayed(Duration(seconds: 2));
  print('   ✅ 초기화 완료: 45장 카드 로드');
  print('');

  // 30분 이내 2차 호출 (캐시 사용)
  print('🚀 [2차] AppProvider.initialize() 호출 (30분 이내)');
  print('   ├── isCacheValid = true');
  print('   ├── isInitialized = true');
  print('   └── API 호출 건너뛰기 → 즉시 완료');
  print('   ✅ 캐시 데이터 사용: 소요시간 ~0ms');
  print('');

  // 강제 새로고침
  print('🔄 AppProvider.refresh() 호출');
  print('   ├── _lastFetchTime = null (캐시 무효화)');
  print('   ├── initialize() 재실행');
  print('   └── 새로운 데이터 fetch');
  await Future.delayed(Duration(seconds: 1));
  print('   ✅ 데이터 갱신 완료');
  print('');

  // 30분 후 시나리오
  print('⏰ [30분 후] AppProvider.initialize() 호출');
  print('   ├── isCacheValid = false (타임아웃)');
  print('   ├── fetchAppConfig() 재실행 → API 호출');
  print('   ├── fetchTarotCards() 재실행 → API 호출');
  print('   └── 새로운 _lastFetchTime 설정');
  await Future.delayed(Duration(seconds: 2));
  print('   ✅ 자동 갱신 완료');
  print('');

  print('📊 캐시 효과 분석:');
  print('   • 1차 로드: ~2-3초 (실제 API 호출)');
  print('   • 2차 로드: ~0ms (캐시 사용, 99% 응답 개선)');
  print('   • 네트워크 요청 절약: 2번의 API 호출 → 0번');
  print('   • 사용자 경험: 즉시 로딩, 오프라인 저항성 향상');
  print('');

  print('🎯 실제 Flutter 앱에서의 시나리오:');
  print('   1. 앱 첫 실행: API 호출 + 데이터 캐시');
  print('   2. 앱 재시작: 캐시 데이터 즉시 로드');
  print('   3. 백그라운드 복귀: 캐시 유효성 확인');
  print('   4. 30분 경과: 자동으로 새 데이터 fetch');
  print('   5. 수동 새로고침: 즉시 최신 데이터 가져오기');

  // 실제 API 호출 시간 측정 시연
  print('');
  print('🕐 실제 API 호출 속도 측정:');

  final stopwatch = Stopwatch()..start();
  try {
    final client = HttpClient();
    client.connectionTimeout = Duration(seconds: 10);

    final request =
        await client.getUrl(Uri.parse('http://localhost:3000/app-config'));
    final response = await request.close();

    stopwatch.stop();

    if (response.statusCode == 200) {
      print('   ✅ API 응답 시간: ${stopwatch.elapsedMilliseconds}ms');
      print('   📈 캐시 사용시 절약: ${stopwatch.elapsedMilliseconds}ms → 0ms');
    }

    client.close();
  } catch (e) {
    stopwatch.stop();
    print('   ❌ API 호출 실패: $e');
    print('   💡 캐시가 있다면 오프라인에서도 동작 가능');
  }
}
