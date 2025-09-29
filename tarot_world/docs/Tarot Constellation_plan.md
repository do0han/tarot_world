
우리의 목표는 '신비한 타로 월드'를 만들었던 코드 베이스를 재사용하고 확장하여, 더 풍부한 기능을 가진 'Tarot Constellation' 앱을 효율적으로 개발하는 것입니다.

---

### **'Tarot Constellation' 서버 UI 드리븐 구현 계획**

'Tarot Constellation'은 기존 앱보다 기능이 많으므로, **'붕어빵틀' 자체를 더 정교하게 업그레이드**하는 과정이 포함됩니다.

#### **Phase 1: 백엔드 확장 및 'Tarot Constellation' 레시피 정의**

새로운 요구사항을 충족시키기 위해 기존 DB 스키마를 확장하고, 신규 API를 설계합니다.

**1. 데이터베이스(DB) 스키마 확장:**

*   **`App` 테이블 수정:**
    *   `adsStatus` 컬럼을 활용하여 배너 광고(`"banner": true`)를 활성화합니다.
    *   온보딩 데이터를 서버에서 내려주기 위해 `onboardingData` (JSON 타입) 컬럼을 추가합니다. 여기에는 온보딩에 필요한 이미지 URL과 텍스트가 들어갑니다.

*   **`AppMenu` 테이블 데이터 추가:**
    *   계획서의 4가지 타로점 종류를 메뉴로 정의합니다. 이때 `category`, `uiType`, `keyword`를 적극적으로 활용합니다.
        *   **오늘의 운세:** `title`: "오늘의 운세", `category`: "tarot_reading", `uiType`: "single_card"
        *   **애정운:** `title`: "애정운", `category`: "tarot_reading", `uiType`: "three_card_spread", `keyword`: "love"
        *   **재물운:** `title`: "재물운", `category`: "tarot_reading", `uiType`: "three_card_spread", `keyword`: "money"
        *   **직업/학업운:** `title`: "직업/학업운", `category`: "tarot_reading", `uiType`: "three_card_spread", `keyword`: "work"

*   **`AppToolbar` 테이블 활용:**
    *   '카드 스타일 선택' 기능으로 연결될 '설정' 아이콘을 툴바에 추가할 수 있도록 데이터를 정의합니다. `action`: "open_settings_page"

*   **신규 테이블 추가 (핵심):**
    *   78장의 타로 카드 정보와 여러 카드 스타일을 관리하기 위한 테이블이 필요합니다.
    *   **`TarotCard` 테이블:** 카드 자체의 정보를 저장합니다.
        *   `id`, `name_ko`, `name_en`, `keywords`, `description_upright` (정방향 해설), `description_reversed` (역방향 해설)
    *   **`CardImage` 테이블:** 카드 이미지와 스타일을 매핑합니다.
        *   `id`, `cardId` (TarotCard ID), `styleName` (예: 'vintage', 'cartoon'), `imageUrl`

**2. API 확장 및 신규 개발:**

*   **`GET /app-config` API 확장:**
    *   기존 응답에 `onboardingData`와 확장된 `toolbarItems` 정보를 포함하도록 수정합니다.
*   **신규 `GET /tarot-cards` API 개발:**
    *   클라이언트가 타로점 기능에 진입했을 때 호출할 API입니다.
    *   `TarotCard` 테이블과 `CardImage` 테이블을 조인하여, 78장 카드에 대한 모든 정보(이름, 해설, 스타일별 이미지 URL 등)를 한번에 내려줍니다.

---

#### **Phase 2: Flutter 클라이언트(붕어빵틀) 기능 업그레이드**

기존 Flutter 코드에 새로운 요구사항을 소화할 수 있는 기능들을 추가합니다.

**1. 모델(Model) 및 서비스 확장:**
    *   새로운 API 응답에 맞춰 `OnboardingPage`, `TarotCard`, `CardImage` 등의 Dart 모델 클래스를 추가합니다.
    *   `ApiService`에 `getTarotCards()` 함수를 추가합니다.

**2. 온보딩 화면 구현:**
    *   `lib/screens/onboarding_screen.dart` 파일을 새로 만듭니다. 이 화면은 `PageView` 위젯을 사용하여 스와이프로 넘길 수 있는 여러 페이지를 동적으로 생성합니다. (페이지 내용은 서버에서 받은 `onboardingData` 사용)
    *   `SplashScreen` 로직 수정:
        *   `app-config` 로딩 후, 앱 최초 실행 여부를 `SharedPreferences`로 확인합니다.
        *   최초 실행이고 서버에서 `onboardingData`를 받았다면 `OnboardingScreen`으로, 아니라면 `MainScreen`으로 이동시킵니다.

**3. 카드 스타일 선택 기능 구현:**
    *   `lib/screens/settings_screen.dart` 파일을 새로 만듭니다.
    *   `MainScreen`의 `AppBar`는 서버에서 받은 툴바 데이터를 기반으로 '설정' 아이콘을 동적으로 표시하고, 클릭 시 `SettingsScreen`으로 이동시킵니다.
    *   `SettingsScreen`에서는 사용자가 '빈티지', '카툰' 스타일을 선택할 수 있고, 선택된 값은 `SharedPreferences`에 저장됩니다.

**4. 광고 기능 연동:**
    *   `google_mobile_ads` 패키지를 `pubspec.yaml`에 추가합니다.
    *   앱 하단에 광고 배너를 표시할 `AdBannerWidget`을 만듭니다.
    *   `MainScreen`에서 `appConfig.adsStatus.banner` 값이 `true`일 경우에만 `AdBannerWidget`을 표시하도록 구현합니다.

---

#### **Phase 3: 신규 타로 기능 화면 개발 및 통합**

기존의 단순한 기능 화면들을 요구사항에 맞는 고도화된 화면으로 교체/개발합니다.

**1. 화면 분기(Router) 로직 개선:**
    *   `MainScreen`의 `_buildBody` 함수를 수정합니다. 이제 `category`가 'tarot_reading'인 경우, `uiType`과 `keyword` 값을 새로운 타로 리딩 화면에 파라미터로 전달해주는 역할을 합니다.

**2. 통합 타로 리딩 화면 (`TarotReadingScreen.dart`) 신규 개발:**
    *   이 화면은 `uiType`('single_card' 또는 'three_card_spread')과 `keyword`('love' 등)를 파라미터로 받아 동작하는 **재사용 가능한 핵심 컴포넌트**입니다.
    *   **카드 셔플 및 선택 UI:**
        *   `SHUFFLE` 버튼과 카드 뒷면 이미지를 보여줍니다.
        *   버튼 클릭 시, 카드들이 섞이는 듯한 멋진 애니메이션을 구현합니다. (`AnimationController`, `Transform` 위젯 활용)
        *   애니메이션 후, 파라미터로 받은 `uiType`에 따라 1개 또는 3개의 카드를 선택하도록 안내합니다.
    *   카드 선택이 완료되면, 선택된 카드 정보와 함께 `ResultScreen`으로 이동시킵니다.

**3. 결과 화면 (`ResultScreen.dart`) 신규 개발:**
    *   이 화면은 선택된 카드 목록을 파라미터로 받습니다.
    *   **`PageView` 또는 `TabController` 활용:** 3장 뽑기의 경우, '과거', '현재', '미래' 탭과 함께 스와이프로 결과를 넘겨볼 수 있는 UI를 구현합니다.
    *   **동적 카드 이미지 표시:** `SharedPreferences`에 저장된 사용자 카드 스타일 설정을 읽어와, 그에 맞는 스타일의 카드 이미지를 표시합니다.
    *   카드 이름, 키워드, 상세 해설 등 모든 텍스트 정보를 명확하고 가독성 좋게 표시합니다.

이 계획을 통해 우리는 기존 '붕어빵틀'의 핵심 구조(서버 기반 UI/메뉴 구성)는 그대로 유지하면서, 온보딩, 고급 타로 기능, 사용자 설정 등 새로운 요구사항들을 체계적으로 추가할 수 있습니다. 결과적으로, DB에 레시피만 바꾸면 '신비한 타로 월드' 같은 심플한 앱도, 'Tarot Constellation' 같은 복잡한 앱도 찍어낼 수 있는 **매우 강력하고 유연한 '만능 붕어빵틀'**을 갖게 됩니다.