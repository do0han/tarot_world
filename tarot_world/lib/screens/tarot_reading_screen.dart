// lib/screens/tarot_reading_screen.dart
import 'package:flutter/material.dart';
import 'dart:math';
import '../models/app_config.dart';
import 'result_screen.dart';

class TarotReadingScreen extends StatefulWidget {
  final String uiType; // 'single_card' 또는 'three_card_spread'
  final String? keyword; // 'love', 'money', 'work' 등
  final String title; // 메뉴 제목

  const TarotReadingScreen({
    super.key,
    required this.uiType,
    this.keyword,
    required this.title,
  });

  @override
  State<TarotReadingScreen> createState() => _TarotReadingScreenState();
}

class _TarotReadingScreenState extends State<TarotReadingScreen>
    with TickerProviderStateMixin {
  bool _isShuffling = false;
  bool _cardsReady = false;
  final List<int> _selectedCardIndices = [];
  late AnimationController _shuffleController;
  late AnimationController _cardFlipController;

  // 더미 카드 데이터 (실제로는 서버에서 받아옴)
  final List<TarotCard> _dummyCards = [
    TarotCard(
      id: 1,
      nameKo: "바보",
      nameEn: "The Fool",
      keywords: "새로운 시작, 순수함, 모험",
      descriptionUpright: "새로운 여행의 시작을 의미합니다. 순수한 마음으로 도전하세요.",
      descriptionReversed: "경솔한 결정을 조심하세요. 더 신중하게 접근이 필요합니다.",
      images: {
        'vintage': 'https://example.com/vintage/fool.png',
        'cartoon': 'https://example.com/cartoon/fool.png'
      },
    ),
    TarotCard(
      id: 2,
      nameKo: "마법사",
      nameEn: "The Magician",
      keywords: "의지력, 창조력, 실행력",
      descriptionUpright: "강한 의지력으로 목표를 달성할 수 있는 시기입니다.",
      descriptionReversed: "능력을 잘못된 방향으로 사용하고 있을지 모릅니다.",
      images: {
        'vintage': 'https://example.com/vintage/magician.png',
        'cartoon': 'https://example.com/cartoon/magician.png'
      },
    ),
    TarotCard(
      id: 3,
      nameKo: "여사제",
      nameEn: "The High Priestess",
      keywords: "직감, 신비, 내면의 지혜",
      descriptionUpright: "직감과 내면의 목소리에 귀를 기울이세요.",
      descriptionReversed: "감정에 휩쓸려 올바른 판단을 못하고 있습니다.",
      images: {
        'vintage': 'https://example.com/vintage/high_priestess.png',
        'cartoon': 'https://example.com/cartoon/high_priestess.png'
      },
    ),
  ];

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
    setState(() {
      _isShuffling = true;
      _cardsReady = false;
      _selectedCardIndices.clear();
    });

    // 셔플 애니메이션 실행
    await _shuffleController.forward();

    // 잠시 대기
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _isShuffling = false;
      _cardsReady = true;
    });

    _shuffleController.reset();
  }

  void _selectCard(int index) {
    if (_selectedCardIndices.length >= _cardCount) return;

    setState(() {
      _selectedCardIndices.add(index);
    });

    // 모든 카드가 선택되면 결과 화면으로 이동
    if (_selectedCardIndices.length == _cardCount) {
      _goToResult();
    }
  }

  void _goToResult() {
    final selectedCards = _selectedCardIndices
        .map((index) => _dummyCards[index % _dummyCards.length])
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
                    : _isShuffling
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
      child: AnimatedBuilder(
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
    );
  }

  Widget _buildCardSelection() {
    return Center(
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        alignment: WrapAlignment.center,
        children: List.generate(
          6, // 6장의 카드를 펼쳐놓음
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
              ? Text(
                  '${_selectedCardIndices.indexOf(index) + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : const Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 30,
                ),
        ),
      ),
    );
  }
}
