// lib/widgets/card_shuffle_animation.dart - 안전한 임시 버전
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

  @override
  void initState() {
    super.initState();
    widget.controller.addStatusListener(_onShuffleStatusChanged);
  }

  @override
  void dispose() {
    widget.controller.removeStatusListener(_onShuffleStatusChanged);
    super.dispose();
  }

  void _onShuffleStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      widget.onComplete?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 간단한 메인 카드만 표시 (애니메이션 비활성화)
          Container(
            width: 140,
            height: 200,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF9966CC),
                  Color(0xFF7A4CAE),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.auto_awesome,
                    size: 50,
                    color: Colors.white,
                  ),
                  SizedBox(height: 16),
                  Text(
                    '타로',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          if (widget.showMessage && widget.message != null) ...[
            const SizedBox(height: 50),
            Container(
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
          ],
        ],
      ),
    );
  }
}