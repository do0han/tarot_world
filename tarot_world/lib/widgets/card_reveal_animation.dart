// lib/widgets/card_reveal_animation.dart
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/app_config.dart';

class CardRevealAnimation extends StatefulWidget {
  final TarotCard card;
  final String cardLabel;
  final bool isActive;
  final VoidCallback? onTap;
  final String selectedStyle;

  const CardRevealAnimation({
    super.key,
    required this.card,
    required this.cardLabel,
    required this.isActive,
    this.onTap,
    required this.selectedStyle,
  });

  @override
  State<CardRevealAnimation> createState() => _CardRevealAnimationState();
}

class _CardRevealAnimationState extends State<CardRevealAnimation>
    with TickerProviderStateMixin {
  late AnimationController _revealController;
  late AnimationController _pulseController;
  late AnimationController _glowController;
  
  late Animation<double> _revealAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _revealController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _revealAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _revealController,
      curve: Curves.easeOutBack,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _revealController,
      curve: Curves.elasticOut,
    ));

    // 활성 카드일 때 애니메이션 시작
    if (widget.isActive) {
      _startAnimations();
    }
  }

  @override
  void didUpdateWidget(CardRevealAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _startAnimations();
    } else if (!widget.isActive && oldWidget.isActive) {
      _stopAnimations();
    }
  }

  void _startAnimations() {
    _revealController.forward();
    _pulseController.repeat(reverse: true);
    _glowController.repeat(reverse: true);
  }

  void _stopAnimations() {
    _pulseController.stop();
    _glowController.stop();
  }

  @override
  void dispose() {
    _revealController.dispose();
    _pulseController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _revealAnimation,
          _pulseAnimation,
          _glowAnimation,
        ]),
        builder: (context, child) {
          final isRevealed = _revealAnimation.value > 0.7;
          
          return Transform.scale(
            scale: widget.isActive 
                ? _scaleAnimation.value * _pulseAnimation.value 
                : 0.85,
            child: Container(
              height: 420,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 글로우 효과
                  if (widget.isActive)
                    Container(
                      width: 280,
                      height: 380,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF9966CC).withOpacity(
                              _glowAnimation.value * 0.6,
                            ),
                            blurRadius: 30 + _glowAnimation.value * 20,
                            spreadRadius: 8 + _glowAnimation.value * 4,
                          ),
                        ],
                      ),
                    ),
                  
                  // 메인 카드
                  Hero(
                    tag: 'card_${widget.card.id}',
                    child: Container(
                      width: 260,
                      height: 360,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: widget.card.isReversed
                              ? [
                                  const Color(0xFF6B46C1),
                                  const Color(0xFF4C1D95),
                                ]
                              : [
                                  const Color(0xFF9966CC),
                                  const Color(0xFF7A4CAE),
                                ],
                        ),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Column(
                          children: [
                            // 카드 이미지 영역
                            Expanded(
                              flex: 7,
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.white.withOpacity(0.1),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    // 카드 번호 및 이름
                                    Positioned(
                                      top: 16,
                                      left: 16,
                                      right: 16,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.2),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              widget.cardLabel,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            widget.card.nameKo,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            widget.card.nameEn,
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(0.8),
                                              fontSize: 12,
                                              fontStyle: FontStyle.italic,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    
                                    // 중앙 아이콘
                                    Center(
                                      child: Transform.rotate(
                                        angle: widget.card.isReversed ? pi : 0,
                                        child: Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.2),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white.withOpacity(0.4),
                                              width: 2,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.auto_awesome,
                                            color: Colors.white,
                                            size: 40,
                                          ),
                                        ),
                                      ),
                                    ),
                                    
                                    // 역방향 표시
                                    if (widget.card.isReversed)
                                      Positioned(
                                        top: 16,
                                        right: 16,
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: Colors.red.withOpacity(0.8),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: const Icon(
                                            Icons.rotate_left,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            
                            // 하단 키워드 영역
                            Container(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  Text(
                                    widget.card.isReversed ? '역방향' : '정방향',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    widget.card.keywords,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
}