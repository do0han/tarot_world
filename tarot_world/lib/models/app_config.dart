// lib/models/app_config.dart

// 카드 스타일 정보
class CardStyle {
  final String id;
  final String name;
  final String description;

  CardStyle({
    required this.id,
    required this.name,
    required this.description,
  });

  factory CardStyle.fromJson(Map<String, dynamic> json) {
    return CardStyle(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}

// 메인 설계도 (Tarot Constellation용 확장)
class AppConfig {
  final String name;
  final String packageName;
  final AdsStatus adsStatus;
  final AppStyle style;
  final AppToolbar toolbar;
  final List<MenuItem> menus;
  final List<OnboardingPage> onboardingData;

  AppConfig({
    required this.name,
    required this.packageName,
    required this.adsStatus,
    required this.style,
    required this.toolbar,
    required this.menus,
    required this.onboardingData,
  });

  // JSON 데이터를 AppConfig 객체로 변환하는 팩토리 생성자
  factory AppConfig.fromJson(Map<String, dynamic> json) {
    var menuList = json['menus'] as List;
    List<MenuItem> menus = menuList.map((i) => MenuItem.fromJson(i)).toList();

    var onboardingList = json['onboardingData'] as List? ?? [];
    List<OnboardingPage> onboardingPages =
        onboardingList.map((i) => OnboardingPage.fromJson(i)).toList();

    return AppConfig(
      name: json['name'],
      packageName: json['packageName'],
      adsStatus: AdsStatus.fromJson(json['adsStatus']),
      style: AppStyle.fromJson(json['style']),
      toolbar: AppToolbar.fromJson(json['toolbar']),
      menus: menus,
      onboardingData: onboardingPages,
    );
  }
}

// 스타일 정보
class AppStyle {
  final String menuType;
  final String toolbarColor;

  AppStyle({required this.menuType, required this.toolbarColor});

  factory AppStyle.fromJson(Map<String, dynamic> json) {
    return AppStyle(
      menuType: json['menuType'],
      toolbarColor: json['toolbarColor'],
    );
  }
}

// 광고 상태 정보
class AdsStatus {
  final bool banner;
  final bool interstitial;

  AdsStatus({required this.banner, required this.interstitial});

  factory AdsStatus.fromJson(Map<String, dynamic> json) {
    return AdsStatus(
      banner: json['banner'] ?? false,
      interstitial: json['interstitial'] ?? false,
    );
  }
}

// 툴바 정보
class AppToolbar {
  final List<ToolbarItem> items;

  AppToolbar({required this.items});

  factory AppToolbar.fromJson(Map<String, dynamic> json) {
    var itemList = json['items'] as List? ?? [];
    List<ToolbarItem> items =
        itemList.map((i) => ToolbarItem.fromJson(i)).toList();

    return AppToolbar(items: items);
  }
}

// 툴바 아이템 정보
class ToolbarItem {
  final String icon;
  final String action;
  final int position;

  ToolbarItem(
      {required this.icon, required this.action, required this.position});

  factory ToolbarItem.fromJson(Map<String, dynamic> json) {
    return ToolbarItem(
      icon: json['icon'],
      action: json['action'],
      position: json['position'],
    );
  }
}

// 메뉴 아이템 정보 (V2.0 확장됨)
class MenuItem {
  final String title;
  final String category;
  final String uiType;
  final String? keyword;
  final String? description;
  final int position;
  final bool? isFree;
  final int? requiredCoins;
  final String? spreadType;

  MenuItem({
    required this.title,
    required this.category,
    required this.uiType,
    this.keyword,
    this.description,
    required this.position,
    this.isFree,
    this.requiredCoins,
    this.spreadType,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      title: json['title'],
      category: json['category'],
      uiType: json['uiType'],
      keyword: json['keyword'],
      description: json['description'],
      position: json['position'],
      isFree: json['isFree'],
      requiredCoins: json['requiredCoins'],
      spreadType: json['spreadType'],
    );
  }
}

// 온보딩 페이지 정보
class OnboardingPage {
  final int page;
  final String title;
  final String description;
  final String imageUrl;

  OnboardingPage({
    required this.page,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  factory OnboardingPage.fromJson(Map<String, dynamic> json) {
    return OnboardingPage(
      page: json['page'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }
}

// 타로 카드 정보
class TarotCard {
  final int id;
  final String nameKo;
  final String nameEn;
  final String keywords;
  final String descriptionUpright;
  final String descriptionReversed;
  final Map<String, String> images; // 스타일별 이미지 URL
  final bool isReversed;

  TarotCard({
    required this.id,
    required this.nameKo,
    required this.nameEn,
    required this.keywords,
    required this.descriptionUpright,
    required this.descriptionReversed,
    required this.images,
    this.isReversed = false,
  });

  factory TarotCard.fromJson(Map<String, dynamic> json) {
    Map<String, String> imageMap = {};
    if (json['images'] != null) {
      if (json['images'] is Map) {
        // /tarot-cards API 응답 형식
        imageMap = Map<String, String>.from(json['images']);
      } else if (json['images'] is List) {
        // 다른 형식 지원
        for (var img in json['images']) {
          imageMap[img['styleName']] = img['imageUrl'];
        }
      }
    }

    return TarotCard(
      id: json['id'],
      nameKo: json['name_ko'],
      nameEn: json['name_en'],
      keywords: json['keywords'],
      descriptionUpright: json['description_upright'],
      descriptionReversed: json['description_reversed'],
      images: imageMap,
      isReversed: json['isReversed'] ?? false,
    );
  }

  // 현재 선택된 스타일의 이미지 URL 반환
  String getImageUrl(String style) {
    return images[style] ?? images.values.first;
  }

  // 현재 상태에 맞는 설명 반환
  String getCurrentDescription() {
    return isReversed ? descriptionReversed : descriptionUpright;
  }
}

// 타로 카드 뽑기 응답
class DrawCardsResponse {
  final List<TarotCard> drawnCards;
  final String timestamp;

  DrawCardsResponse({required this.drawnCards, required this.timestamp});

  factory DrawCardsResponse.fromJson(Map<String, dynamic> json) {
    var cardList = json['drawnCards'] as List;
    List<TarotCard> cards = cardList.map((i) => TarotCard.fromJson(i)).toList();

    return DrawCardsResponse(
      drawnCards: cards,
      timestamp: json['timestamp'],
    );
  }
}
