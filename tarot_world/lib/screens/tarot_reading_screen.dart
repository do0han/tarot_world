// lib/screens/tarot_reading_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../models/app_config.dart';
import '../providers/app_provider.dart';
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
    
    setState(() {
      _isShuffling = true;
      _cardsReady = false;
      _isDrawingCards = false;
      _selectedCardIndices.clear();
      _drawnCardsResponse = null;
    });

    // 셔플 애니메이션 실행
    await _shuffleController.forward();

    // 서버에서 실제 카드 뽑기
    setState(() {
      _isDrawingCards = true;
    });

    try {
      _drawnCardsResponse = await appProvider.drawCards(
        _cardCount, 
        style: appProvider.selectedCardStyle,
      );
      
      if (_drawnCardsResponse != null) {
        // 잠시 대기 후 카드 선택 화면 표시
        await Future.delayed(const Duration(milliseconds: 500));
        
        setState(() {
          _isShuffling = false;
          _isDrawingCards = false;
          _cardsReady = true;
        });
      } else {
        // 에러 처리
        _showErrorDialog('카드를 뽑을 수 없습니다. 다시 시도해주세요.');
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

  void _goToResult() {
    if (_drawnCardsResponse == null) return;
    
    final selectedCards = _selectedCardIndices
        .map((index) => _drawnCardsResponse!.drawnCards[index % _drawnCardsResponse!.drawnCards.length])
        .toList();

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
          AnimatedBuilder(
            animation: _shuffleController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _shuffleController.value * 4 * pi,
                child: Transform.scale(
                  scale: 1.0 + _shuffleController.value * 0.2,
                  child: Container(
                    width: 150,
                    height: 220,
                    decoration: BoxDecoration(
                      color: Color.lerp(
                        const Color(0xFF9966CC),
                        Colors.amber,
                        _shuffleController.value,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10 + _shuffleController.value * 20,
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
                ),
              );
            },
          ),
          const SizedBox(height: 30),
          Text(
            _isDrawingCards ? '카드를 뽑고 있습니다...' : '카드를 섞고 있습니다...',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
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

    return GestureDetector(
      onTap: canSelect ? () => _selectCard(index) : null,
      child: AnimatedBuilder(
        animation: _cardFlipController,
        builder: (context, child) {
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(isSelected ? _cardFlipController.value * 3.14159 : 0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 80,
              height: 120,
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.amber
                    : canSelect
                        ? const Color(0xFF9966CC)
                        : Colors.grey,
                borderRadius: BorderRadius.circular(8),
                border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: isSelected ? 15 : 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: isSelected
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${_selectedCardIndices.indexOf(index) + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 16,
                          ),
                        ],
                      )
                    : const Icon(
                        Icons.auto_awesome,
                        color: Colors.white,
                        size: 30,
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
