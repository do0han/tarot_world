// lib/models/user.dart - 사용자 모델

class User {
  final int id;
  final String username;
  final String? email;
  final int coinBalance;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final bool isNewUser;

  User({
    required this.id,
    required this.username,
    this.email,
    required this.coinBalance,
    required this.createdAt,
    this.lastLoginAt,
    this.isNewUser = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      coinBalance: json['coinBalance'],
      createdAt: DateTime.parse(json['createdAt']),
      lastLoginAt: json['lastLoginAt'] != null 
          ? DateTime.parse(json['lastLoginAt']) 
          : null,
      isNewUser: json['isNewUser'] ?? false,
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
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      coinBalance: coinBalance ?? this.coinBalance,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      isNewUser: isNewUser ?? this.isNewUser,
    );
  }

  @override
  String toString() {
    return 'User{id: $id, username: $username, coinBalance: $coinBalance}';
  }
}