// lib/screens/result_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_config.dart';
import '../providers/app_provider.dart';

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

            // 카드 이미지
            _buildCardImage(card),

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

  Widget _buildCardImage(TarotCard card) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final currentStyle = appProvider.selectedCardStyle;
    
    return Container(
      width: 200,
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 배경 그라데이션
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _getStyleColor(currentStyle).withOpacity(0.9),
                    _getStyleColor(currentStyle).withOpacity(0.7),
                  ],
                ),
              ),
            ),
            
            // 카드 내용
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 카드 아이콘
                  Icon(
                    _getCardIcon(card.nameEn),
                    size: 80,
                    color: Colors.white,
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // 카드 이름
                  Text(
                    card.nameKo,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    card.nameEn,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  // 역방향 표시
                  if (card.isReversed) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'REVERSED',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            // 스타일 인디케이터
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _getStyleName(currentStyle),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStyleColor(String style) {
    switch (style) {
      case 'vintage':
        return const Color(0xFF8B4513); // 브라운
      case 'cartoon':
        return const Color(0xFF9966CC); // 퍼플
      case 'modern':
        return const Color(0xFF2D1B69); // 다크 퍼플
      default:
        return const Color(0xFF9966CC);
    }
  }

  String _getStyleName(String style) {
    switch (style) {
      case 'vintage':
        return '빈티지';
      case 'cartoon':
        return '카툰';
      case 'modern':
        return '모던';
      default:
        return '기본';
    }
  }

  IconData _getCardIcon(String cardName) {
    // 카드 이름에 따른 아이콘 매핑
    final name = cardName.toLowerCase();
    if (name.contains('fool')) return Icons.child_friendly;
    if (name.contains('magician')) return Icons.auto_fix_high;
    if (name.contains('priestess')) return Icons.psychology;
    if (name.contains('empress')) return Icons.nature;
    if (name.contains('emperor')) return Icons.shield;
    if (name.contains('hierophant')) return Icons.menu_book;
    if (name.contains('lovers')) return Icons.favorite;
    if (name.contains('chariot')) return Icons.directions_car;
    if (name.contains('strength')) return Icons.fitness_center;
    if (name.contains('hermit')) return Icons.lightbulb;
    if (name.contains('fortune')) return Icons.casino;
    if (name.contains('justice')) return Icons.balance;
    if (name.contains('hanged')) return Icons.accessibility;
    if (name.contains('death')) return Icons.refresh;
    if (name.contains('temperance')) return Icons.water_drop;
    if (name.contains('devil')) return Icons.warning;
    if (name.contains('tower')) return Icons.flash_on;
    if (name.contains('star')) return Icons.star;
    if (name.contains('moon')) return Icons.nightlight;
    if (name.contains('sun')) return Icons.wb_sunny;
    if (name.contains('judgement')) return Icons.gavel;
    if (name.contains('world')) return Icons.public;
    
    // 수트별 아이콘
    if (name.contains('wands') || name.contains('rods')) return Icons.whatshot;
    if (name.contains('cups') || name.contains('chalices')) return Icons.local_drink;
    if (name.contains('swords')) return Icons.flash_on;
    if (name.contains('pentacles') || name.contains('coins')) return Icons.monetization_on;
    
    return Icons.auto_awesome; // 기본 아이콘
  }
}
