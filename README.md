# Tarot Constellation ✨

별자리처럼 펼쳐진 타로의 신비한 세계 - 완전한 타로 리딩 앱

## 🎯 프로젝트 개요

Tarot Constellation은 서버 UI 드리븐 아키텍처를 기반으로 한 모바일 타로 앱입니다. 
사용자는 다양한 주제의 타로 리딩을 통해 운세를 확인하고, 개인화된 카드 스타일로 
타로의 신비로운 세계를 경험할 수 있습니다.

## ✨ 주요 기능

### 🔮 타로 리딩
- **오늘의 운세**: 1장 카드로 하루 운세 확인
- **애정운**: 과거-현재-미래 3장 카드 스프레드
- **재물운**: 재정과 물질적 풍요에 대한 조언
- **직업/학업운**: 커리어와 학업 방향성 제시

### 🎨 카드 스타일
- **빈티지**: 클래식하고 우아한 전통적인 디자인
- **카툰**: 귀엽고 친근한 현대적인 일러스트
- **모던**: 세련되고 미니멀한 현대적 스타일

### 🌟 사용자 경험
- **온보딩**: 앱 사용법 안내 및 타로 소개
- **카드 셔플**: 실감나는 셔플 애니메이션
- **결과 해석**: 상세한 카드 의미 및 조언
- **설정**: 개인화된 카드 스타일 선택

## 🏗️ 아키텍처

### 서버 UI 드리븐 설계
- **백엔드**: Node.js + Express
- **프론트엔드**: Flutter (크로스플랫폼)
- **데이터**: 78장 완전한 타로 덱
- **확장성**: DB 레시피만 변경하면 다양한 앱 생성 가능

### 폴더 구조
```
tarot_world/
├── tarot_server/           # Node.js 백엔드
│   ├── server.js          # 메인 서버 파일
│   ├── tarot_cards_data.js # 78장 타로 카드 데이터
│   └── package.json       # 서버 의존성
└── tarot_world/           # Flutter 앱
    ├── lib/
    │   ├── models/        # 데이터 모델
    │   ├── services/      # API 서비스
    │   ├── screens/       # UI 화면들
    │   └── providers/     # 상태 관리
    ├── docs/              # 프로젝트 문서
    └── pubspec.yaml       # Flutter 의존성
```

## 🚀 시작하기

### 필요 조건
- Node.js 16.0+
- Flutter 3.5.4+
- Dart 3.0+

### 설치 및 실행

1. **저장소 클론**
```bash
git clone https://github.com/do0han/tarot_world.git
cd tarot_world
```

2. **백엔드 서버 실행**
```bash
cd tarot_server
npm install
node server.js
```

3. **Flutter 앱 실행**
```bash
cd tarot_world
flutter pub get
flutter run
```

## 📱 주요 화면

### 메인 화면
- 4가지 타로점 메뉴를 그리드로 표시
- 그라디언트 배경과 카드 스타일 UI

### 타로 리딩 화면
- 카드 셔플 애니메이션
- 1장/3장 카드 선택 인터페이스
- 선택된 카드 순서 표시

### 결과 화면
- 과거/현재/미래 탭 인터페이스
- 카드별 상세 해석 및 조언
- 스와이프로 카드 간 이동

### 설정 화면
- 카드 스타일 선택 (빈티지/카툰/모던)
- 선택 상태 시각적 피드백

## 🛠️ 기술 스택

### 백엔드
- **Node.js**: 서버 런타임
- **Express**: 웹 프레임워크
- **RESTful API**: 표준화된 API 설계

### 프론트엔드
- **Flutter**: 크로스플랫폼 모바일 개발
- **Provider**: 상태 관리
- **HTTP**: API 통신

### 데이터
- **78장 타로 덱**: 완전한 메이저/마이너 아르카나
- **JSON 구조**: 구조화된 카드 데이터
- **이미지 URL**: 동적 이미지 로딩

## 📋 개발 진행 상황

### ✅ 완료된 기능
- [x] Phase 1: 백엔드 확장 및 78장 카드 데이터
- [x] Phase 2: Flutter 클라이언트 업그레이드
- [x] Phase 3: 신규 타로 기능 화면 개발
- [x] 온보딩 시스템
- [x] 설정 관리
- [x] 카드 스타일 시스템

### 🔄 진행 중
- [ ] 네트워크 오류 처리 강화
- [ ] 카드 히스토리 기능
- [ ] 실제 카드 이미지 연동

### 📈 향후 계획
- [ ] 사운드 효과 및 햅틱 피드백
- [ ] 프리미엄 카드 덱
- [ ] 일일 알림 기능
- [ ] 앱스토어 배포

## 🎨 디자인 철학

### 사용자 중심 설계
- 직관적이고 쉬운 인터페이스
- 3-4단계 이내 간결한 플로우
- 가독성 높은 타이포그래피

### 신비로운 분위기
- 깊은 보라색 그라디언트 배경
- 별자리를 연상시키는 UI 요소
- 부드러운 애니메이션과 전환 효과

## 🤝 기여하기

1. Fork this repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 라이선스

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 개발자

**do0han**
- GitHub: [@do0han](https://github.com/do0han)
- 프로젝트 링크: [https://github.com/do0han/tarot_world](https://github.com/do0han/tarot_world)

## 🙏 감사 인사

- 타로 카드 해석 자료 제공에 감사드립니다
- Flutter 커뮤니티의 지속적인 지원
- 사용자 피드백과 제안사항

---

⭐ **별자리처럼 펼쳐진 타로의 신비한 세계에 오신 것을 환영합니다!** ⭐
