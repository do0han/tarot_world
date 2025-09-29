// lib/screens/result_screen.dart
import 'package:flutter/material.dart';
import '../models/app_config.dart';

class ResultScreen extends StatefulWidget {
  final List<TarotCard> cards;
  final String readingType;
  final String? keyword;

  const ResultScreen({
    super.key,
    required this.cards,
    required this.readingType,
    this.keyword,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentCardIndex = 0;
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  List<String> get _cardLabels {
    if (widget.cards.length == 1) {
      return ['현재'];
    } else {
      return ['과거', '현재', '미래'];
    }
  }

  String get _currentCardLabel => _cardLabels[_currentCardIndex];

  String get _cardStyleDescription {
    switch (widget.keyword) {
      case 'love':
        return '사랑과 관계 운세';
      case 'money':
        return '재물과 금전 운세';
      case 'work':
        return '직업과 학업 운세';
      default:
        return '오늘의 운세';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D1B69),
      appBar: AppBar(
        title: Text(widget.readingType),
        backgroundColor: const Color(0xFF2D1B69),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: '다시 뽑기',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 상단 정보
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getIconForKeyword(),
                      color: Colors.white70,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _cardStyleDescription,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 카드 탭 인디케이터 (3장인 경우)
            if (widget.cards.length > 1)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.cards.length,
                    (index) => _buildTabIndicator(index),
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // 메인 카드 영역
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentCardIndex = index;
                  });
                },
                itemCount: widget.cards.length,
                itemBuilder: (context, index) {
                  return _buildCardResult(widget.cards[index], index);
                },
              ),
            ),

            // 하단 네비게이션
            if (widget.cards.length > 1)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: _currentCardIndex > 0
                          ? () {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          : null,
                      icon: Icon(
                        Icons.chevron_left,
                        color: _currentCardIndex > 0
                            ? Colors.white
                            : Colors.white30,
                        size: 30,
                      ),
                    ),
                    Text(
                      '${_currentCardIndex + 1} / ${widget.cards.length}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    IconButton(
                      onPressed: _currentCardIndex < widget.cards.length - 1
                          ? () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          : null,
                      icon: Icon(
                        Icons.chevron_right,
                        color: _currentCardIndex < widget.cards.length - 1
                            ? Colors.white
                            : Colors.white30,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabIndicator(int index) {
    final isActive = index == _currentCardIndex;

    return GestureDetector(
      onTap: () {
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF9966CC)
              : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          _cardLabels[index],
          style: TextStyle(
            color: isActive ? Colors.white : Colors.white70,
            fontSize: 14,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildCardResult(TarotCard card, int index) {
    return FadeTransition(
      opacity: _fadeController,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 카드 위치 라벨
            Text(
              _cardLabels[index],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // 카드 이미지 (Placeholder)
            Container(
              width: 200,
              height: 300,
              decoration: BoxDecoration(
                color: const Color(0xFF9966CC),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.auto_awesome,
                    size: 60,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    card.nameKo,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    card.nameEn,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 카드 정보
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 키워드
                  const Row(
                    children: [
                      Icon(
                        Icons.label,
                        color: Colors.amber,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        '키워드',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    card.keywords,
                    style: const TextStyle(
                      color: Colors.amber,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 의미
                  const Row(
                    children: [
                      Icon(
                        Icons.lightbulb,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        '의미',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    card.getCurrentDescription(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),

                  // 3장 뽑기일 때 특별 메시지
                  if (widget.cards.length == 3) ...[
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF9966CC).withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_cardLabels[index]} 시점의 조언',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _getAdviceForPosition(index),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForKeyword() {
    switch (widget.keyword) {
      case 'love':
        return Icons.favorite;
      case 'money':
        return Icons.attach_money;
      case 'work':
        return Icons.work;
      default:
        return Icons.today;
    }
  }

  String _getAdviceForPosition(int position) {
    switch (position) {
      case 0: // 과거
        return '과거의 경험이 현재 상황에 어떤 영향을 미치고 있는지 되돌아보세요.';
      case 1: // 현재
        return '현재 상황을 객관적으로 바라보고 지혜롭게 판단하세요.';
      case 2: // 미래
        return '앞으로 다가올 변화에 대비하여 마음의 준비를 하세요.';
      default:
        return '';
    }
  }
}
