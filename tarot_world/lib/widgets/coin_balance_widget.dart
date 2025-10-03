// lib/widgets/coin_balance_widget.dart - 코인 잔액 표시 위젯

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class CoinBalanceWidget extends StatelessWidget {
  final bool showLabel;
  final double? fontSize;
  
  const CoinBalanceWidget({
    super.key,
    this.showLabel = true,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        final user = appProvider.currentUser;
        
        if (user == null) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.amber.shade100,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.amber.shade300),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.monetization_on,
                color: Colors.amber.shade700,
                size: fontSize != null ? fontSize! + 2 : 18,
              ),
              const SizedBox(width: 4),
              Text(
                showLabel ? '${user.coinBalance} 코인' : '${user.coinBalance}',
                style: TextStyle(
                  color: Colors.amber.shade800,
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize ?? 14,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CoinBalanceAppBarWidget extends StatelessWidget {
  const CoinBalanceAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        final user = appProvider.currentUser;
        
        if (user == null) {
          return const SizedBox.shrink();
        }

        return GestureDetector(
          onTap: () {
            _showCoinDialog(context, appProvider);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.monetization_on,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  '${user.coinBalance}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.add_circle_outline,
                  color: Colors.white,
                  size: 14,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCoinDialog(BuildContext context, AppProvider appProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.monetization_on, color: Colors.amber),
              SizedBox(width: 8),
              Text('코인 관리'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.monetization_on, color: Colors.amber.shade700),
                    const SizedBox(width: 8),
                    Text(
                      '현재 잔액: ${appProvider.currentUser?.coinBalance ?? 0} 코인',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '코인 충전 방법:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                '• 광고 시청: +5 코인\n'
                '• 무료 질문으로 체험 후 유료 질문 이용\n'
                '• 프리미엄 질문으로 더 정확한 운세 확인',
                style: TextStyle(fontSize: 13),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('확인'),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.of(context).pop();
                await _watchAd(context, appProvider);
              },
              icon: const Icon(Icons.play_circle_filled),
              label: const Text('광고 시청'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _watchAd(BuildContext context, AppProvider appProvider) async {
    // 광고 시청 시뮬레이션
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('광고를 재생 중입니다...'),
          ],
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('광고 시청 완료! +5 코인을 받았습니다'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
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
}