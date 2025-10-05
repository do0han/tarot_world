// lib/screens/reading_history_screen.dart - 리딩 히스토리 화면

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../models/app_config.dart';
import '../providers/app_provider.dart';
import '../services/auth_service.dart';
import 'result_screen.dart';

class ReadingHistoryScreen extends StatefulWidget {
  const ReadingHistoryScreen({super.key});

  @override
  State<ReadingHistoryScreen> createState() => _ReadingHistoryScreenState();
}

class _ReadingHistoryScreenState extends State<ReadingHistoryScreen> {
  List<ReadingHistoryItem> _historyItems = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    
    if (!appProvider.isLoggedIn) {
      setState(() {
        _errorMessage = '로그인이 필요합니다';
        _isLoading = false;
      });
      return;
    }

    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final historyData = await AuthService.getUserReadingHistory(appProvider.currentUser!.id);
      final history = historyData.map((item) => ReadingHistoryItem.fromJson(item)).toList();
      
      setState(() {
        _historyItems = history;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = '히스토리를 불러올 수 없습니다: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0E3D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D1B69),
        foregroundColor: Colors.white,
        title: const Text(
          '리딩 히스토리',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: _loadHistory,
            icon: const Icon(Icons.refresh),
            tooltip: '새로고침',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFF9966CC)),
            SizedBox(height: 16),
            Text(
              '히스토리를 불러오는 중...',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadHistory,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9966CC),
                foregroundColor: Colors.white,
              ),
              child: const Text('다시 시도'),
            ),
          ],
        ),
      );
    }

    if (_historyItems.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              color: Colors.white30,
              size: 64,
            ),
            SizedBox(height: 16),
            Text(
              '아직 타로 리딩 기록이 없습니다',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '첫 타로 리딩을 시작해보세요!',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadHistory,
      backgroundColor: const Color(0xFF2D1B69),
      color: const Color(0xFF9966CC),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _historyItems.length,
        itemBuilder: (context, index) {
          final item = _historyItems[index];
          return _buildHistoryCard(item);
        },
      ),
    );
  }

  Widget _buildHistoryCard(ReadingHistoryItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: const Color(0xFF2D1B69),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showReadingDetail(item),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 헤더 (제목과 날짜)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item.menuTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    _formatDate(item.createdAt),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // 카드 미리보기
              Row(
                children: [
                  ...item.cards.take(3).map((card) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _buildMiniCard(card),
                  )),
                  if (item.cards.length > 3)
                    Container(
                      width: 40,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '+${item.cards.length - 3}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              
              // 하단 정보 (코인 사용량과 더보기)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.monetization_on,
                        color: item.coinsUsed > 0 ? Colors.amber : Colors.green,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.coinsUsed > 0 ? '${item.coinsUsed} 코인' : '무료',
                        style: TextStyle(
                          color: item.coinsUsed > 0 ? Colors.amber : Colors.green,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        '자세히 보기',
                        style: TextStyle(
                          color: Color(0xFF9966CC),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Color(0xFF9966CC),
                        size: 14,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniCard(TarotCard card) {
    return Container(
      width: 40,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFF4A3B7A),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            card.isReversed ? Icons.flip : Icons.auto_awesome,
            color: card.isReversed ? Colors.red : Colors.white,
            size: 16,
          ),
          const SizedBox(height: 2),
          Text(
            card.nameKo.length > 4 
                ? '${card.nameKo.substring(0, 4)}...'
                : card.nameKo,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 8,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showReadingDetail(ReadingHistoryItem item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          cards: item.cards,
          readingType: item.menuTitle,
          keyword: null, // 히스토리에서는 keyword가 없음
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return '오늘 ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
      } else if (difference.inDays == 1) {
        return '어제';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}일 전';
      } else {
        return '${date.month}/${date.day}';
      }
    } catch (e) {
      return dateString;
    }
  }
}

// 리딩 히스토리 아이템 모델
class ReadingHistoryItem {
  final int id;
  final int userId;
  final int menuId;
  final String menuTitle;
  final List<TarotCard> cards;
  final String interpretation;
  final int coinsUsed;
  final String createdAt;

  ReadingHistoryItem({
    required this.id,
    required this.userId,
    required this.menuId,
    required this.menuTitle,
    required this.cards,
    required this.interpretation,
    required this.coinsUsed,
    required this.createdAt,
  });

  factory ReadingHistoryItem.fromJson(Map<String, dynamic> json) {
    // resultData에서 카드 정보 추출
    final resultData = json['resultData'] is String 
        ? jsonDecode(json['resultData'])
        : json['resultData'];
    
    final cardList = resultData['cards'] as List;
    final cards = cardList.map((cardData) => TarotCard.fromJson(cardData)).toList();

    return ReadingHistoryItem(
      id: json['id'],
      userId: json['userId'],
      menuId: json['menuId'],
      menuTitle: json['menuTitle'],
      cards: cards,
      interpretation: resultData['interpretation'] ?? '',
      coinsUsed: json['coinsUsed'] ?? 0,
      createdAt: json['createdAt'],
    );
  }
}