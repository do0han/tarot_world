// lib/screens/card_deck_screen.dart

import 'package:flutter/material.dart';

// 카드 백과를 위한 더 많은 가짜 데이터
const List<Map<String, String>> mockDeckData = [
  {
    'name': 'The Fool',
    'imageUrl':
        'https://www.shitsuren-tarot.com/wp-content/uploads/2019/12/tarot_0_fool.png'
  },
  {
    'name': 'The Magician',
    'imageUrl':
        'https://www.shitsuren-tarot.com/wp-content/uploads/2019/12/tarot_1_magician.png'
  },
  {
    'name': 'The High Priestess',
    'imageUrl':
        'https://www.shitsuren-tarot.com/wp-content/uploads/2019/12/tarot_2_high-priestess.png'
  },
  {
    'name': 'The Empress',
    'imageUrl':
        'https://www.shitsuren-tarot.com/wp-content/uploads/2019/12/tarot_3_empress.png'
  },
  {
    'name': 'The Emperor',
    'imageUrl':
        'https://www.shitsuren-tarot.com/wp-content/uploads/2019/12/tarot_4_emperor.png'
  },
  {
    'name': 'The Hierophant',
    'imageUrl':
        'https://www.shitsuren-tarot.com/wp-content/uploads/2019/12/tarot_5_hierophant.png'
  },
];

class CardDeckScreen extends StatelessWidget {
  const CardDeckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // GridView.builder를 사용하여 카드 목록을 격자 형태로 만듭니다.
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 한 줄에 2개씩
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 0.7, // 카드 비율
      ),
      itemCount: mockDeckData.length,
      itemBuilder: (context, index) {
        final card = mockDeckData[index];
        return Card(
          elevation: 4.0,
          child: Column(
            children: [
              Expanded(
                child: Image.network(
                  card['imageUrl']!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(card['name']!),
              ),
            ],
          ),
        );
      },
    );
  }
}
