// lib/models/user.dart - 사용자 모델 V2.1

class User {
  final int id;
  final String username;
  final String? email;
  final int coinBalance;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final bool isNewUser;
  
  // V2.1 프리미엄 기능 필드
  final bool isPremium;
  final DateTime? premiumExpiresAt;
  final int streakDays;
  final DateTime? lastDailyBonus;
  final int totalReadings;
  final int totalCoinsSpent;
  final String? referralCode;
  final int? referredBy;

  User({
    required this.id,
    required this.username,
    this.email,
    required this.coinBalance,
    required this.createdAt,
    this.lastLoginAt,
    this.isNewUser = false,
    // V2.1 기본값
    this.isPremium = false,
    this.premiumExpiresAt,
    this.streakDays = 0,
    this.lastDailyBonus,
    this.totalReadings = 0,
    this.totalCoinsSpent = 0,
    this.referralCode,
    this.referredBy,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      coinBalance: json['coinBalance'],
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(), // 기본값으로 현재 시간 사용
      lastLoginAt: json['lastLoginAt'] != null 
          ? DateTime.parse(json['lastLoginAt']) 
          : null,
      isNewUser: (json['isNewUser'] is int ? json['isNewUser'] == 1 : json['isNewUser']) ?? false,
      // V2.1 필드들 (기본값 제공)
      isPremium: (json['isPremium'] is int ? json['isPremium'] == 1 : json['isPremium']) ?? false,
      premiumExpiresAt: json['premiumExpiresAt'] != null 
          ? DateTime.parse(json['premiumExpiresAt']) 
          : null,
      streakDays: json['streakDays'] ?? 0,
      lastDailyBonus: json['lastDailyBonus'] != null 
          ? DateTime.parse(json['lastDailyBonus']) 
          : null,
      totalReadings: json['totalReadings'] ?? 0,
      totalCoinsSpent: json['totalCoinsSpent'] ?? 0,
      referralCode: json['referralCode'],
      referredBy: json['referredBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'coinBalance': coinBalance,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'isNewUser': isNewUser,
      // V2.1 필드들
      'isPremium': isPremium,
      'premiumExpiresAt': premiumExpiresAt?.toIso8601String(),
      'streakDays': streakDays,
      'lastDailyBonus': lastDailyBonus?.toIso8601String(),
      'totalReadings': totalReadings,
      'totalCoinsSpent': totalCoinsSpent,
      'referralCode': referralCode,
      'referredBy': referredBy,
    };
  }

  User copyWith({
    int? id,
    String? username,
    String? email,
    int? coinBalance,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    bool? isNewUser,
    // V2.1 필드들
    bool? isPremium,
    DateTime? premiumExpiresAt,
    int? streakDays,
    DateTime? lastDailyBonus,
    int? totalReadings,
    int? totalCoinsSpent,
    String? referralCode,
    int? referredBy,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      coinBalance: coinBalance ?? this.coinBalance,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      isNewUser: isNewUser ?? this.isNewUser,
      // V2.1 필드들
      isPremium: isPremium ?? this.isPremium,
      premiumExpiresAt: premiumExpiresAt ?? this.premiumExpiresAt,
      streakDays: streakDays ?? this.streakDays,
      lastDailyBonus: lastDailyBonus ?? this.lastDailyBonus,
      totalReadings: totalReadings ?? this.totalReadings,
      totalCoinsSpent: totalCoinsSpent ?? this.totalCoinsSpent,
      referralCode: referralCode ?? this.referralCode,
      referredBy: referredBy ?? this.referredBy,
    );
  }

  @override
  String toString() {
    return 'User{id: $id, username: $username, coinBalance: $coinBalance}';
  }
}