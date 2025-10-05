// lib/screens/tarot_reading_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_config.dart';
import '../providers/app_provider.dart';
import '../widgets/card_shuffle_animation.dart';
import '../widgets/coin_insufficient_dialog.dart';
import '../widgets/payment_success_dialog.dart';
import 'result_screen.dart';

class TarotReadingScreen extends StatefulWidget {
  final String uiType; // 'single_card' 또는 'three_card_spread'
  final String? keyword; // 'love', 'money', 'work' 등
  final String title; // 메뉴 제목
  final MenuItem? menuItem; // 결제 정보를 위한 메뉴 아이템

  const TarotReadingScreen({
    super.key,
    required this.uiType,
    this.keyword,
    required this.title,
    this.menuItem,
  });

  @override
  State<TarotReadingScreen> createState() => _TarotReadingScreenState();
}

class _TarotReadingScreenState extends State<TarotReadingScreen>
    with TickerProviderStateMixin {
  bool _isShuffling = false;
  bool _cardsReady = false;
  bool _isDrawingCards = false;
  final List<int> _selectedCardIndices = [];
  late AnimationController _shuffleController;
  late AnimationController _cardFlipController;
  DrawCardsResponse? _drawnCardsResponse;

  @override
  void initState() {
    super.initState();
    _shuffleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _cardFlipController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _shuffleController.dispose();
    _cardFlipController.dispose();
    super.dispose();
  }

  int get _cardCount => widget.uiType == 'single_card' ? 1 : 3;

  String get _readingDescription {
    switch (widget.keyword) {
      case 'love':
        return '사랑과 관계에 대한 운세를 확인해보세요';
      case 'money':
        return '재정과 물질적 풍요에 대한 조언을 받아보세요';
      case 'work':
        return '커리어와 학업에 대한 방향성을 찾아보세요';
      default:
        return '오늘 하루의 운세를 확인해보세요';
    }
  }

  Future<void> _startShuffle() async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    
    // 로그인 확인
    if (!appProvider.isLoggedIn) {
      _showErrorDialog('로그인이 필요한 서비스입니다.');
      return;
    }

    // 메뉴 ID 결정 (keyword 기반으로 추정)
    int menuId = _getMenuIdFromKeyword(widget.keyword);
    
    setState(() {
      _isShuffling = true;
      _cardsReady = false;
      _isDrawingCards = false;
      _selectedCardIndices.clear();
      _drawnCardsResponse = null;
    });

    // 셔플 애니메이션 실행
    await _shuffleController.forward();

    // V2.0 타로 리딩 실행 (코인 차감 포함)
    setState(() {
      _isDrawingCards = true;
    });

    try {
      final result = await appProvider.executePaidTarotReading(menuId, _cardCount);
      
      if (result['success'] == true) {
        // 성공: 결과 데이터를 DrawCardsResponse 형태로 변환
        final readingData = result['reading'];
        final cards = (readingData['cards'] as List)
            .map((cardData) => TarotCard.fromJson(cardData))
            .toList();
        
        _drawnCardsResponse = DrawCardsResponse(
          drawnCards: cards,
          timestamp: DateTime.now().toIso8601String(),
        );
        
        // 잠시 대기 후 카드 선택 화면 표시
        await Future.delayed(const Duration(milliseconds: 500));
        
        setState(() {
          _isShuffling = false;
          _isDrawingCards = false;
          _cardsReady = true;
        });

        // 코인 사용 알림
        _showPaymentSuccessDialog(result['coinsUsed']);
        
      } else if (result['error'] == 'insufficient_coins') {
        // 코인 부족: 충전 옵션 제공
        _showInsufficientCoinsDialog();
        setState(() {
          _isShuffling = false;
          _isDrawingCards = false;
        });
      } else {
        // 기타 오류
        _showErrorDialog(result['message'] ?? '타로 리딩을 실행할 수 없습니다.');
        setState(() {
          _isShuffling = false;
          _isDrawingCards = false;
        });
      }
    } catch (e) {
      _showErrorDialog('네트워크 오류가 발생했습니다. 다시 시도해주세요.');
      setState(() {
        _isShuffling = false;
        _isDrawingCards = false;
      });
    }

    _shuffleController.reset();
  }

  // 키워드 기반으로 메뉴 ID 추정
  int _getMenuIdFromKeyword(String? keyword) {
    switch (keyword) {
      case 'love':
        return 2; // 애정운
      case 'money':
        return 3; // 재물운
      case 'work':
        return 4; // 직업/학업운
      default:
        return 1; // 오늘의 운세
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2D1B69),
          title: const Text(
            '알림',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            message,
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                '확인',
                style: TextStyle(color: Color(0xFF9966CC)),
              ),
            ),
          ],
        );
      },
    );
  }

  // 결제 성공 다이얼로그
  void _showPaymentSuccessDialog(int coinsUsed) {
    final actionName = widget.uiType == 'single_card' ? '단일 카드 리딩' : '3장 카드 리딩';
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PaymentSuccessDialog(
          coinsUsed: coinsUsed,
          actionName: actionName,
        );
      },
    );
  }

  // 코인 부족 다이얼로그
  void _showInsufficientCoinsDialog() {
    final requiredCoins = widget.uiType == 'single_card' ? 10 : 20; // 단일 카드: 10코인, 3장: 20코인
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CoinInsufficientDialog(
          requiredCoins: requiredCoins,
          actionName: widget.uiType == 'single_card' ? '단일 카드 리딩' : '3장 카드 리딩',
          onSuccess: () {
            // 광고 시청 후 코인이 충분하면 자동으로 리딩 재시작
            final appProvider = Provider.of<AppProvider>(context, listen: false);
            final currentCoins = appProvider.currentUser?.coinBalance ?? 0;
            if (currentCoins >= requiredCoins) {
              _startShuffle();
            }
          },
        );
      },
    );
  }

  // 광고 시청 처리
  Future<void> _watchAd() async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    
    // 광고 시청 시뮬레이션
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        backgroundColor: Color(0xFF2D1B69),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Color(0xFF9966CC)),
            SizedBox(height: 16),
            Text(
              '광고를 재생 중입니다...',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );

    // 2초 대기 (광고 시청 시뮬레이션)
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      Navigator.of(context).pop(); // 로딩 다이얼로그 닫기
    }

    // 실제 광고 보상 처리
    final success = await appProvider.watchAdReward();
    
    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('광고 시청 완료! +5 코인을 받았습니다'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 8),
                Text('광고 보상 처리에 실패했습니다'),
              ],
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _selectCard(int index) async {
    if (_selectedCardIndices.length >= _cardCount) return;

    setState(() {
      _selectedCardIndices.add(index);
    });

    // 카드 선택 애니메이션
    await _cardFlipController.forward();
    _cardFlipController.reset();

    // 모든 카드가 선택되면 결과 화면으로 이동
    if (_selectedCardIndices.length == _cardCount) {
      await Future.delayed(const Duration(milliseconds: 500));
      _goToResult();
    }
  }

  void _goToResult() async {
    if (_drawnCardsResponse == null) return;
    
    final selectedCards = _selectedCardIndices
        .map((index) => _drawnCardsResponse!.drawnCards[index % _drawnCardsResponse!.drawnCards.length])
        .toList();

    // 결제는 이미 _startShuffle에서 처리했으므로 바로 결과 화면으로 이동
    if (mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            cards: selectedCards,
            readingType: widget.title,
            keyword: widget.keyword,
          ),
        ),
      );
    }
  }

  Future<void> _processPremiumPayment() async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final requiredCoins = widget.menuItem?.requiredCoins ?? 0;
    
    try {
      // 코인 차감 API 호출
      final newBalance = await appProvider.deductCoins(requiredCoins);
      
      // 사용자 코인 잔액 업데이트
      appProvider.updateUserCoins(newBalance);
      
      // 성공 메시지 표시
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$requiredCoins코인이 차감되었습니다. (잔액: $newBalance코인)'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // 결제 실패 처리
      if (mounted) {
        _showErrorDialog('결제 처리 중 오류가 발생했습니다: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D1B69),
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: const Color(0xFF2D1B69),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 상단 설명
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      _readingDescription,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _cardCount == 1
                          ? '카드 1장을 선택해주세요'
                          : '카드 3장을 차례로 선택해주세요 (과거-현재-미래)',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // 메인 컨텐츠
              Expanded(
                child: !_isShuffling && !_cardsReady
                    ? _buildShuffleButton()
                    : _isShuffling || _isDrawingCards
                        ? _buildShuffleAnimation()
                        : _buildCardSelection(),
              ),

              // 하단 상태 표시
              if (_cardsReady)
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    '선택된 카드: ${_selectedCardIndices.length}/$_cardCount',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShuffleButton() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 카드 뒷면 이미지 (Placeholder)
          Container(
            width: 150,
            height: 220,
            decoration: BoxDecoration(
              color: const Color(0xFF9966CC),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.auto_awesome,
                size: 50,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 40),

          // 셔플 버튼
          ElevatedButton(
            onPressed: _startShuffle,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9966CC),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text(
              'SHUFFLE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShuffleAnimation() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 향상된 카드 셔플 애니메이션
          CardShuffleAnimation(
            controller: _shuffleController,
            message: _isDrawingCards ? '카드를 뽑고 있습니다...' : '카드를 섞고 있습니다...',
            showMessage: true,
          ),
        ],
      ),
    );
  }

  Widget _buildCardSelection() {
    if (_drawnCardsResponse == null) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF9966CC),
        ),
      );
    }

    final availableCards = _drawnCardsResponse!.drawnCards.length;
    final displayCount = availableCards > 6 ? 6 : availableCards;

    return Center(
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        alignment: WrapAlignment.center,
        children: List.generate(
          displayCount,
          (index) => _buildSelectableCard(index),
        ),
      ),
    );
  }

  Widget _buildSelectableCard(int index) {
    final isSelected = _selectedCardIndices.contains(index);
    final canSelect = _selectedCardIndices.length < _cardCount && !isSelected;
    final selectedOrder = isSelected ? _selectedCardIndices.indexOf(index) + 1 : 0;

    return GestureDetector(
      onTap: canSelect ? () => _selectCard(index) : null,
      child: AnimatedBuilder(
        animation: _cardFlipController,
        builder: (context, child) {
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(isSelected ? _cardFlipController.value * 3.14159 : 0)
              ..scale(isSelected ? 1.1 : canSelect ? 1.0 : 0.9),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              width: 80,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isSelected
                      ? [Colors.amber.shade300, Colors.amber.shade600]
                      : canSelect
                          ? [const Color(0xFF9966CC), const Color(0xFF7A4CAE)]
                          : [Colors.grey.shade400, Colors.grey.shade600],
                ),
                borderRadius: BorderRadius.circular(12),
                border: isSelected 
                    ? Border.all(color: Colors.white, width: 3) 
                    : canSelect
                        ? Border.all(color: Colors.white.withOpacity(0.3), width: 1)
                        : null,
                boxShadow: [
                  BoxShadow(
                    color: isSelected 
                        ? Colors.amber.withOpacity(0.6)
                        : Colors.black.withOpacity(0.3),
                    blurRadius: isSelected ? 20 : 8,
                    offset: Offset(0, isSelected ? 8 : 4),
                    spreadRadius: isSelected ? 2 : 0,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // 배경 패턴
                  if (canSelect)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.1),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  
                  // 메인 콘텐츠
                  Center(
                    child: isSelected
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    '$selectedOrder',
                                    style: const TextStyle(
                                      color: Color(0xFF9966CC),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _getPositionLabel(selectedOrder - 1),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        : AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            child: Icon(
                              Icons.auto_awesome,
                              color: canSelect ? Colors.white : Colors.white54,
                              size: canSelect ? 32 : 24,
                            ),
                          ),
                  ),
                  
                  // 선택 불가능한 경우 오버레이
                  if (!canSelect && !isSelected)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.black.withOpacity(0.4),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _getPositionLabel(int position) {
    if (_cardCount == 1) return '현재';
    switch (position) {
      case 0: return '과거';
      case 1: return '현재';
      case 2: return '미래';
      default: return '';
    }
  }
}
