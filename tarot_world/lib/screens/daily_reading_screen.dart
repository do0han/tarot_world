// lib/screens/daily_reading_screen.dart

import 'package:flutter/material.dart';
import 'dart:math';

// 가짜 카드 데이터
const List<Map<String, String>> mockCardData = [
  {
    'name': 'The Fool',
    'meaning': '새로운 시작, 모험, 순수함',
    'imageUrl':
        'https://www.shitsuren-tarot.com/wp-content/uploads/2019/12/tarot_0_fool.png'
  },
  {
    'name': 'The Magician',
    'meaning': '창조력, 의지, 잠재력',
    'imageUrl':
        'https://www.shitsuren-tarot.com/wp-content/uploads/2019/12/tarot_1_magician.png'
  },
  {
    'name': 'The High Priestess',
    'meaning': '직관, 비밀, 지혜',
    'imageUrl':
        'https://www.shitsuren-tarot.com/wp-content/uploads/2019/12/tarot_2_high-priestess.png'
  },
];

class DailyReadingScreen extends StatefulWidget {
  const DailyReadingScreen({super.key});

  @override
  State<DailyReadingScreen> createState() => _DailyReadingScreenState();
}

class _DailyReadingScreenState extends State<DailyReadingScreen> {
  Map<String, String>? _drawnCard; // 뽑힌 카드를 저장할 변수

  void _drawCard() {
    setState(() {
      // 가짜 데이터 중에서 랜덤으로 카드 하나를 뽑습니다.
      _drawnCard = mockCardData[Random().nextInt(mockCardData.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      // 뽑힌 카드가 없으면 버튼을, 있으면 카드 정보를 보여줍니다.
      child: _drawnCard == null
          ? ElevatedButton(
              onPressed: _drawCard,
              child: const Text('오늘의 카드 뽑기'),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('오늘의 카드는...',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 20),
                Image.network(_drawnCard!['imageUrl']!, height: 300),
                const SizedBox(height: 20),
                Text(_drawnCard!['name']!,
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 10),
                Text(_drawnCard!['meaning']!,
                    style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
    );
  }
}
