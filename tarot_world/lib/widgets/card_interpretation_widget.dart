// lib/widgets/card_interpretation_widget.dart
import 'package:flutter/material.dart';
import '../models/app_config.dart';

class CardInterpretationWidget extends StatefulWidget {
  final TarotCard card;
  final String cardLabel;
  final String? keyword;

  const CardInterpretationWidget({
    super.key,
    required this.card,
    required this.cardLabel,
    this.keyword,
  });

  @override
  State<CardInterpretationWidget> createState() => _CardInterpretationWidgetState();
}

class _CardInterpretationWidgetState extends State<CardInterpretationWidget>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // 애니메이션 시작
    Future.delayed(const Duration(milliseconds: 300), () {
      _fadeController.forward();
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  String get _contextualInterpretation {
    final baseText = widget.card.isReversed 
        ? widget.card.descriptionReversed 
        : widget.card.descriptionUpright;
    
    String contextPrefix = '';
    switch (widget.keyword) {
      case 'love':
        contextPrefix = '사랑과 관계에서 ';
        break;
      case 'money':
        contextPrefix = '재정과 물질적 측면에서 ';
        break;
      case 'work':
        contextPrefix = '직업과 학업에서 ';
        break;
      default:
        contextPrefix = '전반적으로 ';
    }
    
    return '$contextPrefix$baseText';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_fadeAnimation, _slideAnimation]),
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.15),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 헤더 섹션
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF9966CC).withOpacity(0.8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${widget.cardLabel} 해석',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        widget.card.isReversed 
                            ? Icons.rotate_left 
                            : Icons.auto_awesome,
                        color: Colors.white.withOpacity(0.7),
                        size: 20,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // 카드 이름
                  Text(
                    widget.card.nameKo,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // 방향 및 키워드
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: widget.card.isReversed 
                              ? Colors.orange.withOpacity(0.8)
                              : Colors.green.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          widget.card.isReversed ? '역방향' : '정방향',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.card.keywords,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // 구분선
                  Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.2),
                          Colors.white.withOpacity(0.6),
                          Colors.white.withOpacity(0.2),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // 해석 내용
                  Text(
                    '💫 카드의 메시지',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  Text(
                    _contextualInterpretation,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      height: 1.6,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // 조언 섹션
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF9966CC).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF9966CC).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.lightbulb_outline,
                              color: Colors.amber,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '조언',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _getAdviceText(),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _getAdviceText() {
    if (widget.card.isReversed) {
      switch (widget.keyword) {
        case 'love':
          return '관계에서 균형을 찾고, 소통을 통해 오해를 풀어나가는 것이 중요합니다.';
        case 'money':
          return '금전 관리에 더욱 신중하게 접근하고, 계획적인 소비를 하시기 바랍니다.';
        case 'work':
          return '현재의 어려움은 일시적입니다. 인내심을 갖고 꾸준히 노력하세요.';
        default:
          return '현재 상황을 다른 관점에서 바라보고, 새로운 접근 방식을 시도해보세요.';
      }
    } else {
      switch (widget.keyword) {
        case 'love':
          return '긍정적인 에너지가 흐르고 있습니다. 마음을 열고 진실한 감정을 표현하세요.';
        case 'money':
          return '재정적 기회가 다가오고 있습니다. 현명한 판단으로 안정을 추구하세요.';
        case 'work':
          return '목표를 향한 길이 열려있습니다. 자신감을 갖고 적극적으로 행동하세요.';
        default:
          return '좋은 흐름 속에 있습니다. 현재의 방향을 유지하며 꾸준히 나아가세요.';
      }
    }
  }
}