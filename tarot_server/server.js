// server.js - Tarot Constellation 백엔드
const express = require('express');
const app = express();
const port = 3000;

// CORS(Cross-Origin Resource Sharing) 헤더 추가 (에러 방지용)
app.use((req, res, next) => {
    res.header('Access-Control-Allow-Origin', '*');
    next();
});

// ===== 데이터베이스 스키마 시뮬레이션 =====

// App 테이블 데이터 (확장됨)
const appConfig = {
  "name": "Tarot Constellation",
  "packageName": "com.mystic.tarotconstellation",
  "adsStatus": { "banner": false, "interstitial": false }, // 광고 비활성화
  "style": {
    "menuType": "bottomTab",
    "toolbarColor": "#2D1B69",
    "buttonColor": "#9966CC",
    "textColor": "#FFFFFF"
  },
  "toolbar": { 
    "items": [
      { "icon": "settings", "action": "open_settings_page", "position": 1 }
    ]
  },
  "onboardingData": [
    {
      "page": 1,
      "title": "Welcome to Tarot Constellation",
      "description": "별자리처럼 펼쳐진 타로의 신비한 세계에 오신 것을 환영합니다",
      "imageUrl": "https://example.com/onboarding1.png"
    },
    {
      "page": 2,
      "title": "Choose Your Path",
      "description": "과거, 현재, 미래의 운명을 카드를 통해 엿보세요",
      "imageUrl": "https://example.com/onboarding2.png"
    },
    {
      "page": 3,
      "title": "Start Your Journey",
      "description": "지금 바로 당신만의 타로 여행을 시작해보세요",
      "imageUrl": "https://example.com/onboarding3.png"
    }
  ]
};

// AppMenu 테이블 데이터 (Tarot Constellation 메뉴)
const appMenus = [
  { 
    "id": 1,
    "title": "오늘의 운세", 
    "position": 1, 
    "category": "tarot_reading", 
    "uiType": "single_card",
    "keyword": null,
    "description": "하루의 운세를 한 장의 카드로 알아보세요"
  },
  { 
    "id": 2,
    "title": "애정운", 
    "position": 2, 
    "category": "tarot_reading", 
    "uiType": "three_card_spread",
    "keyword": "love",
    "description": "과거, 현재, 미래의 사랑 운세"
  },
  { 
    "id": 3,
    "title": "재물운", 
    "position": 3, 
    "category": "tarot_reading", 
    "uiType": "three_card_spread",
    "keyword": "money",
    "description": "재정과 물질적 풍요에 대한 운세"
  },
  { 
    "id": 4,
    "title": "직업/학업운", 
    "position": 4, 
    "category": "tarot_reading", 
    "uiType": "three_card_spread",
    "keyword": "work",
    "description": "커리어와 학업에 대한 조언"
  }
];

// 78장 완전한 타로 덱 임포트
const fullTarotDeck = require('./tarot_cards_data.js');

// 카드 이미지 URL 생성 함수
function generateCardImageUrl(cardId, styleName) {
  // 실제 운영에서는 CDN이나 실제 이미지 서버 URL 사용
  const baseUrl = "https://tarot-images.example.com";
  const cardFileName = fullTarotDeck.find(card => card.id === cardId)?.name_en
    ?.toLowerCase()
    .replace(/\s+/g, '_')
    .replace(/[^a-z0-9_]/g, '') || `card_${cardId}`;
  
  return `${baseUrl}/${styleName}/${cardFileName}.png`;
}

// 사용 가능한 카드 스타일
const availableStyles = [
  {
    "id": "vintage",
    "name": "빈티지",
    "description": "클래식하고 우아한 전통적인 타로 디자인"
  },
  {
    "id": "cartoon",
    "name": "카툰",
    "description": "귀엽고 친근한 현대적인 일러스트 스타일"
  },
  {
    "id": "modern",
    "name": "모던",
    "description": "세련되고 미니멀한 현대적 디자인"
  }
];

// ===== API 엔드포인트 =====

// 표준 API 응답 래퍼 함수
function createResponse(success, data, error = null, statusCode = 200) {
  return {
    success,
    data: success ? data : null,
    error: success ? null : error,
    timestamp: new Date().toISOString(),
    statusCode
  };
}

// /app-config 엔드포인트 (확장됨)
app.get('/app-config', (req, res) => {
  try {
    const responseData = {
      ...appConfig,
      "menus": appMenus,
      "fcmTopics": [],
      "availableStyles": availableStyles
    };

    console.log(`[${new Date().toLocaleTimeString()}] /app-config 요청 받음. "Tarot Constellation" 데이터 전송.`);
    res.json(createResponse(true, responseData));
  } catch (error) {
    console.error('App config 로딩 오류:', error);
    res.status(500).json(createResponse(false, null, 'Internal server error', 500));
  }
});

// /tarot-cards 엔드포인트 (개선됨)
app.get('/tarot-cards', (req, res) => {
  try {
    // 모든 카드에 스타일별 이미지 URL 추가
    const cardsWithImages = fullTarotDeck.map(card => {
      const images = {};
      availableStyles.forEach(style => {
        images[style.id] = generateCardImageUrl(card.id, style.id);
      });

      return {
        ...card,
        images: images
      };
    });

    const responseData = {
      total: cardsWithImages.length,
      cards: cardsWithImages,
      availableStyles: availableStyles,
      lastUpdated: new Date().toISOString()
    };

    console.log(`[${new Date().toLocaleTimeString()}] /tarot-cards 요청 받음. ${cardsWithImages.length}장 카드 데이터 전송.`);
    res.json(createResponse(true, responseData));
  } catch (error) {
    console.error('Tarot cards 로딩 오류:', error);
    res.status(500).json(createResponse(false, null, 'Failed to load tarot cards', 500));
  }
});

// 랜덤 카드 선택 API (개선됨)
app.get('/draw-cards', (req, res) => {
  try {
    const count = parseInt(req.query.count) || 1; // 기본 1장
    const style = req.query.style || 'vintage'; // 기본 빈티지 스타일
    
    // 입력 유효성 검사
    if (count < 1 || count > 10) {
      return res.status(400).json(createResponse(false, null, 'Card count must be between 1 and 10', 400));
    }
    
    const validStyles = availableStyles.map(s => s.id);
    if (!validStyles.includes(style)) {
      return res.status(400).json(createResponse(false, null, `Invalid style. Available: ${validStyles.join(', ')}`, 400));
    }
    
    // 랜덤으로 카드 선택 (중복 방지)
    const shuffledCards = [...fullTarotDeck].sort(() => Math.random() - 0.5);
    const drawnCards = shuffledCards.slice(0, count);
    
    // 선택된 카드에 이미지 정보 추가
    const cardsWithImages = drawnCards.map(card => {
      return {
        ...card,
        imageUrl: generateCardImageUrl(card.id, style),
        isReversed: Math.random() < 0.3, // 30% 확률로 역방향
        selectedStyle: style
      };
    });

    const responseData = {
      drawnCards: cardsWithImages,
      sessionId: `session_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`,
      requestedCount: count,
      requestedStyle: style,
      timestamp: new Date().toISOString()
    };

    console.log(`[${new Date().toLocaleTimeString()}] /draw-cards 요청 받음. ${count}장 추천, 스타일: ${style}`);
    res.json(createResponse(true, responseData));
  } catch (error) {
    console.error('Draw cards 오류:', error);
    res.status(500).json(createResponse(false, null, 'Failed to draw cards', 500));
  }
});

app.listen(port, () => {
  console.log(`Tarot Constellation 서버가 http://localhost:${port} 에서 실행 중입니다.`);
  console.log(`API 엔드포인트:`);
  console.log(`- GET /app-config : 앱 설정 및 메뉴 데이터`);
  console.log(`- GET /tarot-cards : 전체 타로 카드 데이터`);
  console.log(`- GET /draw-cards?count=3&style=vintage : 랜덤 카드 뽑기`);
});