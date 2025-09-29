# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Tarot Constellation** is a Flutter-based mobile tarot reading application with a Node.js backend. The project implements a client-server architecture where the Flutter app consumes REST APIs to provide dynamic tarot card readings across multiple themes (daily fortune, love, money, career).

## Architecture

### Client-Server Structure
- **Frontend**: Flutter app (`tarot_world/`) with Provider state management
- **Backend**: Node.js Express server (`tarot_server/`) serving REST APIs
- **Data Flow**: Server provides app configuration, card data, and random card drawing APIs

### Key Components

#### Flutter App (`tarot_world/`)
- **Provider Pattern**: Centralized state management via `AppProvider`
- **Screen Navigation**: Splash → Onboarding → Main → Settings/Reading screens
- **API Integration**: HTTP client consuming server APIs with error handling
- **Theming**: Dynamic card style selection (vintage/cartoon/modern)

#### Node.js Server (`tarot_server/`)
- **Express Framework**: RESTful API endpoints
- **Tarot Database**: 78-card complete tarot deck with Korean/English names
- **Dynamic Configuration**: App menus and styling served from server
- **Card Drawing Logic**: Random selection with duplicate prevention

### State Management Architecture
```
AppProvider (ChangeNotifier)
├── AppConfig (app settings & menus)  
├── TarotCard[] (complete card database)
├── LoadingState (idle/loading/success/error)
├── CardStyle selection (vintage/cartoon/modern)
└── Cache management (30min timeout)
```

## Development Commands

### Backend Development
```bash
# Navigate to server directory
cd tarot_server

# Install dependencies
npm install

# Start development server
node server.js
# Server runs on http://localhost:3000

# Test API endpoints
curl http://localhost:3000/app-config
curl http://localhost:3000/tarot-cards  
curl "http://localhost:3000/draw-cards?count=3&style=vintage"
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
2. **Start Flutter**: `cd tarot_world && flutter run`
3. **API Testing**: Use curl commands or test with Flutter app

## API Integration

### Server Endpoints
- `GET /app-config`: App configuration, menus, and onboarding data
- `GET /tarot-cards`: Complete 78-card tarot database with styled images
- `GET /draw-cards?count=N&style=STYLE`: Random card selection

### Client API Service
- **Base URL**: `http://localhost:3000` (development)
- **Error Handling**: Network exceptions with user-friendly messages
- **Caching**: 30-minute cache with manual refresh capability
- **Response Format**: Standardized JSON with success/error states

## Current Implementation Status

### ✅ Phase 2 Complete - Server-Client Integration
- Complete Flutter app structure with navigation
- Node.js backend with 3 REST endpoints
- Provider-based state management
- 45 tarot cards implemented (Major 22 + Minor 23)
- 3 card styles with dynamic switching
- Error handling and loading states
- Onboarding system (3 pages)
- Settings screen with style selection

### 🔧 Phase 3 Pending - Tarot Reading Implementation  
- Card shuffle animations
- Card selection interface
- Result display screens
- Past-Present-Future card layouts

## Project Structure

### Flutter App Layout
```
tarot_world/lib/
├── main.dart                    # App entry point
├── models/app_config.dart       # Data models (AppConfig, TarotCard, etc.)
├── providers/app_provider.dart  # State management
├── services/api_service.dart    # HTTP client for server APIs
├── screens/                     # UI screens
│   ├── splash_screen.dart       # Initial loading screen
│   ├── onboarding_screen.dart   # 3-page introduction
│   ├── main_screen.dart         # Menu selection
│   ├── settings_screen.dart     # Card style selection
│   └── tarot_reading_screen.dart # Card reading (in development)
└── widgets/                     # Reusable UI components
    ├── loading_widget.dart      # Loading indicators
    └── error_widget.dart        # Error display
```

### Server Structure
```
tarot_server/
├── server.js              # Express server with API endpoints
├── tarot_cards_data.js     # 78-card tarot database
└── package.json           # Node.js dependencies
```

## Key Dependencies

### Flutter Dependencies
- `http: ^1.2.1` - HTTP client for API calls
- `provider: ^6.1.2` - State management
- `flutter_lints: ^4.0.0` - Code quality

### Server Dependencies  
- `express: ^5.1.0` - Web framework

## Development Notes

### Server Dependency
The Flutter app requires the Node.js server to be running for full functionality. The app will show loading/error states if server is unavailable.

### Card Data Structure
Each tarot card includes:
- ID, Korean/English names
- Keywords and descriptions (upright/reversed)  
- Multiple image URLs for different styles
- Reversed state (30% probability)

### Style System
3 card styles supported:
- `vintage`: Classic traditional design
- `cartoon`: Modern friendly illustration  
- `modern`: Minimal contemporary design

User selection persists via Provider state (session-based).