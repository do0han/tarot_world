# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Tarot Constellation** is a Flutter-based mobile tarot reading application with a Node.js backend implementing a full-stack monetization model. The project features user authentication, coin-based payments, SQLite database integration, and a comprehensive V2.0 architecture supporting multiple tarot reading types with premium content.

## Architecture

### Full-Stack Monetization Architecture
- **Frontend**: Flutter app (`tarot_world/`) with Provider state management and user authentication
- **Backend**: Node.js Express server (`tarot_server/`) with SQLite database and V2.0 API architecture
- **Database**: SQLite (`tarot_constellation.db`) storing users, transactions, and card readings
- **Monetization**: Coin-based payment system with ad rewards and premium content
- **Data Flow**: Server provides authentication, user management, coin transactions, and tarot readings

### Key Components

#### Flutter App (`tarot_world/`)
- **Provider Pattern**: Centralized state management via `AppProvider` with user authentication
- **Screen Navigation**: Splash → Login → Onboarding → Main → Reading/Settings screens
- **Authentication**: Login system with username validation and persistent sessions
- **Monetization UI**: Coin balance display, ad reward system, payment dialogs
- **API Integration**: HTTP client with authentication headers and error handling
- **Theming**: Dynamic card style selection (vintage/cartoon/modern)

#### Node.js Server (`tarot_server/`)
- **Express Framework**: RESTful API endpoints with V2.0 architecture
- **SQLite Database**: User management, coin transactions, and reading history
- **Authentication API**: User login, profile management, and session handling
- **Monetization API**: Coin management, ad rewards, and payment processing
- **Tarot Database**: 78-card complete tarot deck with Korean/English names
- **Dynamic Configuration**: App menus and styling served from server

### State Management Architecture
```
AppProvider (ChangeNotifier)
├── User Authentication (currentUser, login state)
├── AppConfig (app settings & menus)  
├── TarotCard[] (complete card database)
├── LoadingState (idle/loading/success/error)
├── CardStyle selection (vintage/cartoon/modern)
├── Coin Balance Management (balance, transactions)
├── Ad Reward System (watch ads, claim rewards)
└── Cache management (30min timeout)
```

### Database Schema (SQLite)
```
users table:
├── id (PRIMARY KEY)
├── username (UNIQUE)
├── coinBalance (INTEGER, default: 10)
├── createdAt (TIMESTAMP)
├── lastLoginAt (TIMESTAMP)
└── isNewUser (BOOLEAN)

Additional tables for transactions, readings, and analytics
```

## Development Commands

### Backend Development
```bash
# Navigate to server directory
cd tarot_server

# Install dependencies (includes sqlite3)
npm install

# Start development server
node server.js
# Server runs on http://localhost:3000

# Test Legacy API endpoints
curl http://localhost:3000/app-config
curl http://localhost:3000/tarot-cards  
curl "http://localhost:3000/draw-cards?count=3&style=vintage"

# Test V2.0 Authentication API
curl -X POST http://localhost:3000/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username": "testuser"}'

# Test User Management API
curl http://localhost:3000/user/profile/1
curl -X POST http://localhost:3000/user/watch-ad \
  -H "Content-Type: application/json" \
  -d '{"userId": 1}'

# Database management
sqlite3 tarot_constellation.db ".tables"  # List tables
sqlite3 tarot_constellation.db "SELECT * FROM users;"  # View users
```

### Flutter Development
```bash
# Navigate to Flutter app directory
cd tarot_world

# Install dependencies
flutter pub get

# Run app (ensure server is running first)
flutter run

# Build for different platforms
flutter build apk --debug          # Android debug build
flutter build apk --release        # Android release build  
flutter build ios                  # iOS build
flutter build web                  # Web build

# Run tests
flutter test

# Analyze code
flutter analyze
```

### Development Workflow
1. **Start Backend**: `cd tarot_server && node server.js`
2. **Verify Database**: Check SQLite database is created and accessible
3. **Start Flutter**: `cd tarot_world && flutter run`
4. **API Testing**: Use curl commands or test authentication through Flutter app
5. **User Testing**: Create test user through login screen, verify coin system

## API Integration

### Server Endpoints

#### Legacy V1.0 API
- `GET /app-config`: App configuration, menus, and onboarding data
- `GET /tarot-cards`: Complete 78-card tarot database with styled images
- `GET /draw-cards?count=N&style=STYLE`: Random card selection

#### V2.0 Authentication & User Management API
- `POST /auth/login`: User login with username validation
- `GET /user/profile/:userId`: Get user profile and coin balance
- `POST /user/watch-ad`: Ad reward system (+5 coins)
- `PUT /user/coins`: Manage user coins (add/deduct)

### Client API Services
- **Base URL**: Auto-detection (localhost for iOS/Web, 10.0.2.2 for Android emulator)
- **Authentication**: `AuthService` for user management and session handling
- **API Client**: `ApiService` for legacy endpoints with caching
- **Error Handling**: Network exceptions with user-friendly messages
- **Response Format**: Standardized JSON with success/error states and timestamps

## Current Implementation Status

### ✅ V2.0 Complete - Full-Stack Monetization App
- **Authentication System**: Login screen with username validation
- **User Management**: SQLite database with user profiles and session handling
- **Monetization**: Coin-based payment system with 10 free coins per user
- **Ad Reward System**: Watch ads for +5 coins with simulation
- **Complete Backend**: V2.0 API architecture with database integration
- **Enhanced UI**: Coin balance display, payment dialogs, and user feedback
- **Multi-Screen Navigation**: Login → Onboarding → Main → Reading/Settings
- **78 Tarot Cards**: Complete Major and Minor Arcana with 3 styles
- **Reading Types**: Daily, Love, Money, Career spreads with coin costs
- **Data Persistence**: SQLite database for users, transactions, and readings

### 🔧 V2.1 Enhancements In Progress
- Enhanced reading result displays with detailed interpretations
- Card animation improvements and visual effects
- Premium content and expanded card meanings
- Analytics and user behavior tracking

## Project Structure

### Flutter App Layout
```
tarot_world/lib/
├── main.dart                    # App entry point with authentication routing
├── models/                      # Data models
│   ├── app_config.dart         # AppConfig, TarotCard, MenuPage models
│   └── user.dart               # User model with authentication data
├── providers/app_provider.dart  # State management with authentication & coins
├── services/                    # API services
│   ├── api_service.dart        # Legacy API client with caching
│   └── auth_service.dart       # V2.0 authentication and user management
├── screens/                     # UI screens
│   ├── splash_screen.dart      # Initial loading and connection testing
│   ├── login_screen.dart       # User authentication
│   ├── onboarding_screen.dart  # 3-page introduction for new users
│   ├── main_screen.dart        # Menu selection with coin balance
│   ├── settings_screen.dart    # Card style and user settings
│   ├── tarot_reading_screen.dart # Card selection and reading flow
│   ├── result_screen.dart      # Reading results with detailed interpretations
│   ├── daily_reading_screen.dart # Single card daily readings
│   ├── love_spread_screen.dart # 3-card love spread
│   └── card_deck_screen.dart   # Full deck browsing
└── widgets/                     # Reusable UI components
    ├── loading_widget.dart     # Loading indicators
    ├── error_widget.dart       # Error display
    └── coin_balance_widget.dart # Coin balance and ad reward UI
```

### Server Structure
```
tarot_server/
├── server.js                   # Main Express server with V2.0 integration
├── v2_apis.js                  # V2.0 API handler class with database methods
├── tarot_cards_data.js         # 78-card tarot database
├── expanded_menus.js           # Extended menu configurations
├── database_upgrade.js         # Database schema and migration scripts
├── tarot_constellation.db      # SQLite database (created at runtime)
└── package.json               # Node.js dependencies including sqlite3
```

## Key Dependencies

### Flutter Dependencies
- `http: ^1.2.1` - HTTP client for API calls and authentication
- `provider: ^6.1.2` - State management for user authentication and app state
- `cupertino_icons: ^1.0.8` - iOS-style icons
- `flutter_lints: ^4.0.0` - Code quality analysis
- **Note**: `shared_preferences` temporarily disabled due to Android build issues

### Server Dependencies  
- `express: ^5.1.0` - Web framework for REST APIs
- `sqlite3: ^5.x` - Database driver for user management and transactions
- **Note**: No additional authentication libraries - uses simple username-based auth

## Development Notes

### Critical Dependencies
- **Database**: SQLite database automatically created at server startup
- **Authentication**: App requires successful login before accessing main features
- **Server Connection**: Flutter app tests server connectivity at splash screen
- **Platform URLs**: Auto-detection for different platforms (localhost vs 10.0.2.2)

### User Flow & Authentication
- **New Users**: Receive 10 free coins on first login
- **Session Management**: Currently session-based (shared_preferences disabled)
- **Coin System**: Each reading costs coins, users can earn more through ads
- **Ad Rewards**: +5 coins per ad view (simulated in development)

### Data Architecture
**User Model**:
- Authentication data (id, username, email)
- Coin balance tracking with transaction history
- Session management and new user detection

**Card Data Structure**:
- 78 complete tarot cards with Korean/English names
- Keywords and descriptions (upright/reversed meanings)
- Multiple image URLs for 3 different visual styles
- Reversed state calculation (30% probability)

**Monetization Model**:
- Coin-based payment system for readings
- Ad reward system for free coin generation
- Premium content and reading types
- Transaction logging for analytics

### Platform Considerations
- **Android Emulator**: Uses 10.0.2.2:3000 for server connection
- **iOS Simulator**: Uses localhost:3000 
- **Web**: Uses localhost:3000
- **Build Issues**: shared_preferences temporarily disabled for Android builds