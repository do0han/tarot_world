// lib/widgets/coin_insufficient_dialog.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class CoinInsufficientDialog extends StatefulWidget {
  final int requiredCoins;
  final String actionName;
  final VoidCallback? onSuccess;

  const CoinInsufficientDialog({
    super.key,
    required this.requiredCoins,
    required this.actionName,
    this.onSuccess,
  });

  @override
  State<CoinInsufficientDialog> createState() => _CoinInsufficientDialogState();
}

class _CoinInsufficientDialogState extends State<CoinInsufficientDialog>
    with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late AnimationController _pulseController;
  late Animation<double> _bounceAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _bounceAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.elasticOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _bounceController.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        final currentCoins = appProvider.currentUser?.coinBalance ?? 0;
        final neededCoins = widget.requiredCoins - currentCoins;

        return Dialog(
          backgroundColor: Colors.transparent,
          child: AnimatedBuilder(
            animation: _bounceAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _bounceAnimation.value,
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF2D1B69),
                        Color(0xFF1A0E42),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.amber.withOpacity(0.3),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber.withOpacity(0.2),
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
                        // 코인 부족 아이콘
                        AnimatedBuilder(
                          animation: _pulseAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _pulseAnimation.value,
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.amber.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.amber,
                                    width: 3,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.monetization_on_outlined,
                                  color: Colors.amber,
                                  size: 40,
                                ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 20),

                        // 제목
                        const Text(
                          '코인이 부족합니다',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 12),

                        // 설명
                        Text(
                          '${widget.actionName}을(를) 이용하려면\n${widget.requiredCoins}개의 코인이 필요합니다',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 20),

                        // 현재 상태
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    '현재 보유:',
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
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    '필요한 양:',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.monetization_on,
                                        color: Colors.red.shade300,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '+$neededCoins',
                                        style: TextStyle(
                                          color: Colors.red.shade300,
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

                        const SizedBox(height: 24),

                        // 해결 방법들
                        const Text(
                          '💡 코인 충전 방법',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // 광고 시청 옵션
                        _buildOptionCard(
                          icon: Icons.play_circle_filled,
                          iconColor: Colors.green,
                          title: '광고 시청',
                          subtitle: '30초 광고 시청으로 +5 코인',
                          actionText: '광고 보기',
                          onTap: () => _watchAd(context, appProvider),
                        ),

                        const SizedBox(height: 12),

                        // 프리미엄 구매 옵션
                        _buildOptionCard(
                          icon: Icons.star,
                          iconColor: Colors.amber,
                          title: '프리미엄 코인팩',
                          subtitle: '100 코인 + 보너스 20 코인',
                          actionText: '구매하기',
                          onTap: () => _purchasePremium(context, appProvider),
                        ),

                        const SizedBox(height: 20),

                        // 하단 버튼들
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: const Text(
                                  '나중에',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => _watchAd(context, appProvider),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber,
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                icon: const Icon(Icons.play_circle_filled),
                                label: const Text(
                                  '광고 보기',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
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

  Widget _buildOptionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String actionText,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: iconColor.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: iconColor,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _watchAd(BuildContext context, AppProvider appProvider) async {
    Navigator.of(context).pop(); // 현재 다이얼로그 닫기

    // 광고 시청 시뮬레이션 다이얼로그
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF2D1B69),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
              ),
              const SizedBox(height: 16),
              const Text(
                '광고를 재생 중입니다...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '잠시만 기다려주세요 ⏱️',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // 2초 대기 (광고 시청 시뮬레이션)
    await Future.delayed(const Duration(seconds: 2));

    if (context.mounted) {
      Navigator.of(context).pop(); // 로딩 다이얼로그 닫기
    }

    // 실제 광고 보상 처리
    final success = await appProvider.watchAdReward();

    if (context.mounted) {
      if (success) {
        // 성공 다이얼로그
        showDialog(
          context: context,
          builder: (context) => Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.green, Colors.greenAccent],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '광고 시청 완료!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '+5 코인을 받았습니다 🎉',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      widget.onSuccess?.call();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.green,
                    ),
                    child: const Text('확인'),
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 8),
                Text('광고 보상 처리에 실패했습니다'),
              ],
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _purchasePremium(BuildContext context, AppProvider appProvider) async {
    Navigator.of(context).pop(); // 현재 다이얼로그 닫기

    // 프리미엄 구매 시뮬레이션 (실제로는 인앱결제 연동)
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('프리미엄 코인팩'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star, color: Colors.amber, size: 48),
            SizedBox(height: 16),
            Text(
              '100 코인 + 보너스 20 코인\n총 120 코인을 받습니다!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 12),
            Text(
              '₩2,900',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('프리미엄 구매 기능은 준비 중입니다'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            child: const Text('구매하기'),
          ),
        ],
      ),
    );
  }
}