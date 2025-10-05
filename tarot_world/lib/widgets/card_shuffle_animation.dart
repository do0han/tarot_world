// lib/widgets/card_shuffle_animation.dart
import 'dart:math';
import 'package:flutter/material.dart';

class CardShuffleAnimation extends StatefulWidget {
  final AnimationController controller;
  final VoidCallback? onComplete;
  final String? message;
  final bool showMessage;

  const CardShuffleAnimation({
    super.key,
    required this.controller,
    this.onComplete,
    this.message,
    this.showMessage = true,
  });

  @override
  State<CardShuffleAnimation> createState() => _CardShuffleAnimationState();
}

class _CardShuffleAnimationState extends State<CardShuffleAnimation>
    with TickerProviderStateMixin {
  late AnimationController _particleController;
  late AnimationController _glowController;
  late AnimationController _textController;
  
  late Animation<double> _particleAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();
    
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _particleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _particleController,
      curve: Curves.easeInOut,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    _textAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.elasticOut,
    ));

    // 애니메이션 컨트롤러 리스너
    widget.controller.addStatusListener(_onShuffleStatusChanged);
    _startSequentialAnimations();
  }

  @override
  void dispose() {
    widget.controller.removeStatusListener(_onShuffleStatusChanged);
    _particleController.dispose();
    _glowController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _onShuffleStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      widget.onComplete?.call();
    }
  }

  void _startSequentialAnimations() {
    _particleController.repeat();
    _glowController.repeat(reverse: true);
    _textController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // 파티클 효과
        AnimatedBuilder(
          animation: _particleAnimation,
          builder: (context, child) {
            return CustomPaint(
              size: const Size(300, 300),
              painter: _ParticlePainter(_particleAnimation.value),
            );
          },
        ),
        
        // 메인 카드 스택
        _buildCardStack(),
        
        // 글로우 효과
        AnimatedBuilder(
          animation: _glowAnimation,
          builder: (context, child) {
            return Container(
              width: 200,
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF9966CC).withOpacity(_glowAnimation.value * 0.6),
                    blurRadius: 50 + _glowAnimation.value * 30,
                    spreadRadius: 10 + _glowAnimation.value * 5,
                  ),
                ],
              ),
            );
          },
        ),
        
        // 메시지 텍스트
        if (widget.showMessage && widget.message != null)
          Positioned(
            bottom: 50,
            child: AnimatedBuilder(
              animation: _textAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _textAnimation.value,
                  child: Opacity(
                    opacity: _textAnimation.value,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: const Color(0xFF9966CC).withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        widget.message!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildCardStack() {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // 배경 카드들 (향상된 효과)
            for (int i = 0; i < 7; i++)
              _buildBackgroundCard(i),
            
            // 메인 카드
            _buildMainCard(),
          ],
        );
      },
    );
  }

  Widget _buildBackgroundCard(int index) {
    final offset = (index - 3) * 12.0;
    final animationPhase = widget.controller.value * 2 * pi + (index * 0.8);
    
    return Transform.translate(
      offset: Offset(
        offset * sin(animationPhase) * (1.0 + widget.controller.value * 0.5),
        offset * cos(animationPhase) * (0.8 + widget.controller.value * 0.3),
      ),
      child: Transform.rotate(
        angle: animationPhase,
        child: Transform.scale(
          scale: 0.85 + (index * 0.02) + sin(widget.controller.value * 4 * pi) * 0.05,
          child: Opacity(
            opacity: 0.2 + (index * 0.08) + sin(widget.controller.value * 6 * pi + index) * 0.1,
            child: Container(
              width: 130,
              height: 180,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.lerp(
                      const Color(0xFF9966CC),
                      const Color(0xFF6B46C1),
                      widget.controller.value + (index * 0.15),
                    )!,
                    Color.lerp(
                      const Color(0xFF7A4CAE),
                      const Color(0xFF4C1D95),
                      widget.controller.value + (index * 0.15),
                    )!,
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainCard() {
    return Transform.rotate(
      angle: widget.controller.value * 8 * pi,
      child: Transform.scale(
        scale: 1.0 + sin(widget.controller.value * 6 * pi) * 0.15,
        child: Container(
          width: 140,
          height: 200,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.lerp(
                  const Color(0xFF9966CC),
                  Colors.amber,
                  widget.controller.value,
                )!,
                Color.lerp(
                  const Color(0xFF7A4CAE),
                  Colors.deepOrange,
                  widget.controller.value,
                )!,
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Color.lerp(
                  const Color(0xFF9966CC),
                  Colors.amber,
                  widget.controller.value,
                )!.withOpacity(0.6),
                blurRadius: 25 + widget.controller.value * 25,
                offset: const Offset(0, 10),
                spreadRadius: 3,
              ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.rotate(
                  angle: -widget.controller.value * 4 * pi,
                  child: Icon(
                    Icons.auto_awesome,
                    size: 50 + sin(widget.controller.value * 10 * pi) * 15,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '타로',
                    style: TextStyle(
                      fontSize: 14 + sin(widget.controller.value * 8 * pi) * 2,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final double animationValue;
  
  _ParticlePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF9966CC).withOpacity(0.6)
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 회전하는 파티클들
    for (int i = 0; i < 12; i++) {
      final angle = (i * 2 * pi / 12) + (animationValue * 2 * pi);
      final particleRadius = radius * 0.7 + sin(animationValue * 4 * pi + i) * 20;
      
      final x = center.dx + particleRadius * cos(angle);
      final y = center.dy + particleRadius * sin(angle);
      
      final particleSize = 3 + sin(animationValue * 6 * pi + i) * 2;
      final opacity = 0.3 + sin(animationValue * 8 * pi + i) * 0.4;
      
      paint.color = Color.lerp(
        const Color(0xFF9966CC),
        Colors.amber,
        (animationValue + i * 0.1) % 1.0,
      )!.withOpacity(opacity);
      
      canvas.drawCircle(Offset(x, y), particleSize, paint);
    }

    // 중앙 글로우 효과
    final glowPaint = Paint()
      ..color = const Color(0xFF9966CC).withOpacity(0.1)
      ..style = PaintingStyle.fill;
    
    for (int i = 0; i < 5; i++) {
      final glowRadius = 20 + (i * 15) + sin(animationValue * 3 * pi) * 10;
      final glowOpacity = 0.1 - (i * 0.02);
      
      glowPaint.color = const Color(0xFF9966CC).withOpacity(glowOpacity);
      canvas.drawCircle(center, glowRadius, glowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}