import 'package:flutter/material.dart';
import '../models/app_config.dart';
import '../services/api_service.dart';

enum LoadingState {
  idle,
  loading,
  success,
  error,
}

class AppProvider with ChangeNotifier {
  // 앱 설정 데이터
  AppConfig? _appConfig;
  AppConfig? get appConfig => _appConfig;

  // 타로 카드 데이터
  List<TarotCard> _tarotCards = [];
  List<TarotCard> get tarotCards => _tarotCards;

  // 사용 가능한 카드 스타일
  List<CardStyle> _availableStyles = [];
  List<CardStyle> get availableStyles => _availableStyles;

  // 로딩 상태 관리
  LoadingState _loadingState = LoadingState.idle;
  LoadingState get loadingState => _loadingState;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool get isLoading => _loadingState == LoadingState.loading;
  bool get hasError => _loadingState == LoadingState.error;
  bool get isInitialized => _appConfig != null && _tarotCards.isNotEmpty;

  // 현재 선택된 카드 스타일
  String _selectedCardStyle = 'vintage';
  String get selectedCardStyle => _selectedCardStyle;

  // 온보딩 완료 상태 (앱 재시작 시 리셋됨 - 간단한 구현)
  bool _onboardingCompleted = false;
  bool get onboardingCompleted => _onboardingCompleted;

  // 캐시 관리
  DateTime? _lastFetchTime;
  static const Duration _cacheTimeout = Duration(minutes: 30);

  bool get isCacheValid =>
      _lastFetchTime != null &&
      DateTime.now().difference(_lastFetchTime!) < _cacheTimeout;

  // API 서비스 인스턴스
  final ApiService _apiService = ApiService();

  // 초기 데이터 로드
  Future<void> initialize() async {
    if (isCacheValid && isInitialized) {
      print('캐시된 데이터 사용');
      return;
    }

    await fetchAppConfig();
    await fetchTarotCards();
  }

  // 앱 설정 가져오기
  Future<void> fetchAppConfig() async {
    try {
      _setLoadingState(LoadingState.loading);
      _clearError();

      _appConfig = await _apiService.getAppConfig();
      _lastFetchTime = DateTime.now();

      _setLoadingState(LoadingState.success);
      print('앱 설정 로드 완료: ${_appConfig?.name}');
    } catch (e) {
      _handleError('앱 설정을 불러올 수 없습니다', e);
    }
  }

  // 타로 카드 데이터 가져오기
  Future<void> fetchTarotCards() async {
    try {
      if (_loadingState != LoadingState.loading) {
        _setLoadingState(LoadingState.loading);
      }

      _tarotCards = await _apiService.getTarotCards();
      _availableStyles = await _apiService.getAvailableStyles();

      if (_loadingState == LoadingState.loading) {
        _setLoadingState(LoadingState.success);
      }

      print('타로 카드 로드 완료: ${_tarotCards.length}장');
      print('사용 가능한 스타일: ${_availableStyles.length}개');
    } catch (e) {
      _handleError('타로 카드 데이터를 불러올 수 없습니다', e);
    }
  }

  // 카드 뽑기
  Future<DrawCardsResponse?> drawCards(int count, {String? style}) async {
    try {
      _clearError();
      final selectedStyle = style ?? _selectedCardStyle;
      return await _apiService.drawCards(count, selectedStyle);
    } catch (e) {
      _handleError('카드를 뽑을 수 없습니다', e);
      return null;
    }
  }

  // 카드 스타일 변경
  void setCardStyle(String styleId) {
    if (_selectedCardStyle != styleId) {
      _selectedCardStyle = styleId;
      notifyListeners();
      print('카드 스타일 변경: $styleId');
    }
  }

  // 온보딩 완료 설정
  void markOnboardingCompleted() {
    if (!_onboardingCompleted) {
      _onboardingCompleted = true;
      notifyListeners();
      print('온보딩 완료 표시');
    }
  }

  // 연결 상태 확인
  Future<bool> checkConnection() async {
    try {
      return await _apiService.checkConnection();
    } catch (e) {
      return false;
    }
  }

  // 데이터 새로고침
  Future<void> refresh() async {
    _lastFetchTime = null; // 캐시 무효화
    await initialize();
  }

  // 로딩 상태 설정
  void _setLoadingState(LoadingState state) {
    if (_loadingState != state) {
      _loadingState = state;
      notifyListeners();
    }
  }

  // 에러 처리
  void _handleError(String message, dynamic error) {
    print('Error: $message - $error');

    String errorMsg = message;
    if (error is NetworkException) {
      errorMsg = error.message;
    }

    _errorMessage = errorMsg;
    _setLoadingState(LoadingState.error);
  }

  // 에러 클리어
  void _clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  // 에러 해제 (사용자가 확인했을 때)
  void clearError() {
    _clearError();
    if (_loadingState == LoadingState.error) {
      _setLoadingState(LoadingState.idle);
    }
  }

  // 특정 카드 검색
  TarotCard? findCardById(int cardId) {
    try {
      return _tarotCards.firstWhere((card) => card.id == cardId);
    } catch (e) {
      return null;
    }
  }

  // 카드 스타일 정보 가져오기
  CardStyle? getStyleInfo(String styleId) {
    try {
      return _availableStyles.firstWhere((style) => style.id == styleId);
    } catch (e) {
      return null;
    }
  }

  // 리소스 정리
  @override
  void dispose() {
    ApiService.dispose();
    super.dispose();
  }
}