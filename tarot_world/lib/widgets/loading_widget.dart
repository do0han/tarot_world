// lib/widgets/loading_widget.dart
import 'dart:math';
import 'package:flutter/material.dart';

class LoadingWidget extends StatefulWidget {
  final String message;
  final bool showSpinner;
  final LoadingType type;

  const LoadingWidget({
    super.key,
    this.message = '로딩 중...',
    this.showSpinner = true,
    this.type = LoadingType.standard,
  });

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

enum LoadingType {
  standard,
  tarotCards,
  mystical,
  payment,
}

class _LoadingWidgetState extends State<LoadingWidget>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _scaleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Widget _buildLoadingIndicator() {
    switch (widget.type) {
      case LoadingType.tarotCards:
        return _buildTarotCardsLoader();
      case LoadingType.mystical:
        return _buildMysticalLoader();
      case LoadingType.payment:
        return _buildPaymentLoader();
      case LoadingType.standard:
      default:
        return _buildStandardLoader();
    }
  }

  Widget _buildStandardLoader() {
    return const CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9966CC)),
      strokeWidth: 3,
    );
  }

  Widget _buildTarotCardsLoader() {
    return AnimatedBuilder(
      animation: Listenable.merge([_rotationAnimation, _scaleAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value * 2 * pi,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: const RadialGradient(
                  colors: [
                    Color(0xFF9966CC),
                    Color(0xFF2D1B69),
                    Color(0xFF1A0E42),
                  ],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF9966CC).withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMysticalLoader() {
    return AnimatedBuilder(
      animation: Listenable.merge([_rotationAnimation, _fadeAnimation]),
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // 외부 원
            Transform.rotate(
              angle: _rotationAnimation.value * 2 * pi,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFF9966CC).withOpacity(_fadeAnimation.value),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: CustomPaint(
                  painter: _MysticalCirclePainter(_fadeAnimation.value),
                ),
              ),
            ),
            // 내부 원
            Transform.rotate(
              angle: -_rotationAnimation.value * 1.5 * pi,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      Color(0xFF9966CC).withOpacity(_fadeAnimation.value),
                      Colors.transparent,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Icon(
                  Icons.stars,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPaymentLoader() {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.amber.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: const Icon(
              Icons.monetization_on,
              color: Colors.white,
              size: 30,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.showSpinner) ...[
            _buildLoadingIndicator(),
            const SizedBox(height: 24),
          ],
          AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Text(
                  widget.message,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MysticalCirclePainter extends CustomPainter {
  final double opacity;

  _MysticalCirclePainter(this.opacity);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFF9966CC).withOpacity(opacity * 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 신비로운 원 패턴 그리기
    for (int i = 0; i < 8; i++) {
      final angle = (i * pi * 2) / 8;
      final startX = center.dx + (radius - 10) * 0.7 * cos(angle);
      final startY = center.dy + (radius - 10) * 0.7 * sin(angle);
      final endX = center.dx + (radius - 5) * 0.9 * cos(angle);
      final endY = center.dy + (radius - 5) * 0.9 * sin(angle);
      
      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX, endY),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class SkeletonLoader extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const SkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutSine,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: const [
                Color(0xFF2A2A3A),
                Color(0xFF3A3A4A),
                Color(0xFF2A2A3A),
              ],
              stops: [
                _animation.value - 1,
                _animation.value,
                _animation.value + 1,
              ],
            ),
          ),
        );
      },
    );
  }
}

class GridSkeletonLoader extends StatelessWidget {
  final int itemCount;
  final double itemWidth;
  final double itemHeight;

  const GridSkeletonLoader({
    super.key,
    this.itemCount = 4,
    this.itemWidth = 150,
    this.itemHeight = 80,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return SkeletonLoader(
          width: itemWidth,
          height: itemHeight,
          borderRadius: BorderRadius.circular(12),
        );
      },
    );
  }
}
