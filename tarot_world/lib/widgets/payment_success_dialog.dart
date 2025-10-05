// lib/widgets/payment_success_dialog.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class PaymentSuccessDialog extends StatefulWidget {
  final int coinsUsed;
  final String actionName;

  const PaymentSuccessDialog({
    super.key,
    required this.coinsUsed,
    required this.actionName,
  });

  @override
  State<PaymentSuccessDialog> createState() => _PaymentSuccessDialogState();
}

class _PaymentSuccessDialogState extends State<PaymentSuccessDialog>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _sparkleController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _sparkleAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _sparkleController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _sparkleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _sparkleController,
      curve: Curves.easeInOut,
    ));

    _scaleController.forward();
    _sparkleController.repeat();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _sparkleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        final currentCoins = appProvider.currentUser?.coinBalance ?? 0;

        return Dialog(
          backgroundColor: Colors.transparent,
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF4CAF50),
                        Color(0xFF2E7D32),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.green.shade200,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 성공 아이콘 with 반짝임 효과
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            // 반짝임 효과
                            AnimatedBuilder(
                              animation: _sparkleAnimation,
                              builder: (context, child) {
                                return Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white.withOpacity(
                                          _sparkleAnimation.value * 0.6,
                                        ),
                                        blurRadius: 30,
                                        spreadRadius: 5,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            // 메인 아이콘
                            Container(
                              width: 80,
                              height: 80,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check_circle,
                                color: Color(0xFF4CAF50),
                                size: 50,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // 제목
                        const Text(
                          '결제 완료! 🎉',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 12),

                        // 액션 설명
                        Text(
                          '${widget.actionName}이(가) 성공적으로 시작됩니다',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 20),

                        // 코인 사용 정보
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    '사용된 코인:',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.monetization_on,
                                        color: Colors.amber.shade300,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '-${widget.coinsUsed}',
                                        style: TextStyle(
                                          color: Colors.red.shade200,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    '남은 코인:',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.monetization_on,
                                        color: Colors.amber,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '$currentCoins',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // 코인 부족 경고 (10개 미만)
                        if (currentCoins < 10) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.orange.withOpacity(0.4),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.warning_amber_rounded,
                                  color: Colors.orange.shade300,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '코인이 부족합니다. 광고 시청으로 충전하세요!',
                                    style: TextStyle(
                                      color: Colors.orange.shade100,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        const SizedBox(height: 24),

                        // 확인 버튼
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF4CAF50),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 2,
                            ),
                            child: const Text(
                              '확인',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}