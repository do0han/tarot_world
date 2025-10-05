// database_v2_1_upgrade.js - V2.1 프리미엄 수익화 모델 데이터베이스 업그레이드
const sqlite3 = require('sqlite3').verbose();
const path = require('path');

const DB_PATH = path.join(__dirname, 'tarot_constellation.db');

class DatabaseV21Upgrader {
  constructor() {
    this.db = new sqlite3.Database(DB_PATH);
  }

  // 데이터베이스 버전 확인
  async checkDatabaseVersion() {
    return new Promise((resolve, reject) => {
      this.db.get("PRAGMA user_version", (err, row) => {
        if (err) reject(err);
        else resolve(row.user_version);
      });
    });
  }

  // 데이터베이스 버전 설정
  async setDatabaseVersion(version) {
    return new Promise((resolve, reject) => {
      this.db.run(`PRAGMA user_version = ${version}`, (err) => {
        if (err) reject(err);
        else resolve();
      });
    });
  }

  // CoinTransactions 테이블 생성
  async createCoinTransactionsTable() {
    const sql = `
      CREATE TABLE IF NOT EXISTS CoinTransactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        amount INTEGER NOT NULL, -- 양수: 충전, 음수: 소모
        type VARCHAR(20) NOT NULL, -- 'purchase', 'ad_reward', 'daily_bonus', 'reading_cost'
        description TEXT,
        relatedId INTEGER, -- 관련 리딩 ID 등
        metadata TEXT, -- JSON 형태 추가 정보
        createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (userId) REFERENCES User(id)
      )
    `;

    return new Promise((resolve, reject) => {
      this.db.run(sql, (err) => {
        if (err) {
          console.error('CoinTransactions 테이블 생성 실패:', err);
          reject(err);
        } else {
          console.log('✅ CoinTransactions 테이블 생성 완료');
          resolve();
        }
      });
    });
  }

  // Users 테이블 프리미엄 기능 확장
  async upgradeUsersTable() {
    const columns = [
      { name: 'isPremium', type: 'BOOLEAN DEFAULT FALSE' },
      { name: 'premiumExpiresAt', type: 'DATETIME' },
      { name: 'isNewUser', type: 'BOOLEAN DEFAULT TRUE' },
      { name: 'streakDays', type: 'INTEGER DEFAULT 0' },
      { name: 'lastDailyBonus', type: 'DATETIME' },
      { name: 'totalReadings', type: 'INTEGER DEFAULT 0' },
      { name: 'totalCoinsSpent', type: 'INTEGER DEFAULT 0' },
      { name: 'referralCode', type: 'VARCHAR(20)' },
      { name: 'referredBy', type: 'INTEGER' }
    ];

    for (const column of columns) {
      try {
        await this.addColumnIfNotExists('User', column.name, column.type);
      } catch (err) {
        console.log(`컬럼 ${column.name}은 이미 존재합니다.`);
      }
    }
    console.log('✅ Users 테이블 프리미엄 확장 완료');
  }

  // ReadingHistory 테이블 V2.1 확장
  async upgradeReadingHistoryTable() {
    const columns = [
      { name: 'questionType', type: 'VARCHAR(50)' }, // 'love', 'money', 'career', 'daily'
      { name: 'cardData', type: 'TEXT' }, // JSON으로 카드 정보 저장
      { name: 'interpretation', type: 'TEXT' }, // 기본 해석
      { name: 'detailedInterpretation', type: 'TEXT' }, // 프리미엄 상세 해석
      { name: 'spreadType', type: 'VARCHAR(20) DEFAULT "single"' }, // 'single', 'three_card', 'celtic_cross'
      { name: 'userRating', type: 'INTEGER' }, // 1-5 별점
      { name: 'isShared', type: 'BOOLEAN DEFAULT FALSE' },
      { name: 'shareCode', type: 'VARCHAR(20)' }
    ];

    for (const column of columns) {
      try {
        await this.addColumnIfNotExists('ReadingHistory', column.name, column.type);
      } catch (err) {
        console.log(`컬럼 ${column.name}은 이미 존재합니다.`);
      }
    }
    console.log('✅ ReadingHistory 테이블 V2.1 확장 완료');
  }

  // AppMenu 테이블 프리미엄 확장
  async upgradeAppMenuTable() {
    const columns = [
      { name: 'premiumOnly', type: 'BOOLEAN DEFAULT FALSE' },
      { name: 'detailedDescription', type: 'TEXT' },
      { name: 'category', type: 'VARCHAR(20)' }, // 'daily', 'love', 'money', 'career', 'spiritual'
      { name: 'difficulty', type: 'VARCHAR(20) DEFAULT "beginner"' }, // 'beginner', 'intermediate', 'advanced'
      { name: 'estimatedTime', type: 'INTEGER DEFAULT 5' }, // 예상 소요 시간(분)
      { name: 'popularityScore', type: 'INTEGER DEFAULT 0' },
      { name: 'isActive', type: 'BOOLEAN DEFAULT TRUE' }
    ];

    for (const column of columns) {
      try {
        await this.addColumnIfNotExists('AppMenu', column.name, column.type);
      } catch (err) {
        console.log(`컬럼 ${column.name}은 이미 존재합니다.`);
      }
    }
    console.log('✅ AppMenu 테이블 프리미엄 확장 완료');
  }

  // UserAchievements 테이블 생성 (게이미피케이션)
  async createUserAchievementsTable() {
    const sql = `
      CREATE TABLE IF NOT EXISTS UserAchievements (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        achievementId VARCHAR(50) NOT NULL, -- 'first_reading', 'week_streak', etc.
        achievementName VARCHAR(100) NOT NULL,
        description TEXT,
        reward INTEGER DEFAULT 0, -- 코인 보상
        unlockedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (userId) REFERENCES User(id),
        UNIQUE(userId, achievementId)
      )
    `;

    return new Promise((resolve, reject) => {
      this.db.run(sql, (err) => {
        if (err) {
          console.error('UserAchievements 테이블 생성 실패:', err);
          reject(err);
        } else {
          console.log('✅ UserAchievements 테이블 생성 완료');
          resolve();
        }
      });
    });
  }

  // DailyRewards 테이블 생성 (출석 보상)
  async createDailyRewardsTable() {
    const sql = `
      CREATE TABLE IF NOT EXISTS DailyRewards (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        rewardDate DATE NOT NULL,
        rewardType VARCHAR(20) NOT NULL, -- 'daily_login', 'streak_bonus', 'special_event'
        coinsRewarded INTEGER NOT NULL,
        streakDay INTEGER DEFAULT 1,
        claimedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (userId) REFERENCES User(id),
        UNIQUE(userId, rewardDate)
      )
    `;

    return new Promise((resolve, reject) => {
      this.db.run(sql, (err) => {
        if (err) {
          console.error('DailyRewards 테이블 생성 실패:', err);
          reject(err);
        } else {
          console.log('✅ DailyRewards 테이블 생성 완료');
          resolve();
        }
      });
    });
  }

  // 컬럼 존재 여부 확인 후 추가
  async addColumnIfNotExists(tableName, columnName, columnType) {
    return new Promise((resolve, reject) => {
      this.db.all(`PRAGMA table_info(${tableName})`, (err, rows) => {
        if (err) {
          reject(err);
          return;
        }

        const columnExists = rows.some(row => row.name === columnName);
        
        if (!columnExists) {
          const sql = `ALTER TABLE ${tableName} ADD COLUMN ${columnName} ${columnType}`;
          this.db.run(sql, (err) => {
            if (err) {
              reject(err);
            } else {
              console.log(`✅ ${tableName}.${columnName} 컬럼 추가 완료`);
              resolve();
            }
          });
        } else {
          resolve();
        }
      });
    });
  }

  // 기본 코인 거래 데이터 생성 (테스트용)
  async insertInitialCoinTransactions() {
    const transactions = [
      {
        userId: 1,
        amount: 10,
        type: 'initial_bonus',
        description: '신규 가입 보너스'
      },
      {
        userId: 1,
        amount: 5,
        type: 'ad_reward',
        description: '광고 시청 보상'
      }
    ];

    for (const transaction of transactions) {
      await this.insertCoinTransactionIfNotExists(transaction);
    }
    console.log('✅ 기본 코인 거래 데이터 생성 완료');
  }

  // 코인 거래 데이터 삽입 (중복 방지)
  async insertCoinTransactionIfNotExists(transactionData) {
    return new Promise((resolve, reject) => {
      const sql = `
        INSERT OR IGNORE INTO CoinTransactions (userId, amount, type, description, createdAt)
        VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP)
      `;
      this.db.run(sql, [
        transactionData.userId,
        transactionData.amount,
        transactionData.type,
        transactionData.description
      ], (err) => {
        if (err) {
          reject(err);
        } else {
          resolve();
        }
      });
    });
  }

  // 프리미엄 메뉴 데이터 업데이트
  async updateMenusForPremium() {
    const premiumMenuUpdates = [
      {
        id: 1,
        category: 'daily',
        premiumOnly: false,
        difficulty: 'beginner',
        estimatedTime: 3
      },
      {
        id: 2,
        category: 'love',
        premiumOnly: false,
        difficulty: 'intermediate',
        estimatedTime: 8,
        requiredCoins: 5
      },
      {
        id: 3,
        category: 'career',
        premiumOnly: false,
        difficulty: 'intermediate',
        estimatedTime: 10,
        requiredCoins: 3
      },
      {
        id: 4,
        category: 'money',
        premiumOnly: false,
        difficulty: 'intermediate',
        estimatedTime: 8,
        requiredCoins: 5
      }
    ];

    for (const menu of premiumMenuUpdates) {
      await this.updateMenuPremiumInfo(menu);
    }
    console.log('✅ 메뉴 프리미엄 정보 업데이트 완료');
  }

  // 개별 메뉴 프리미엄 정보 업데이트
  async updateMenuPremiumInfo(menuData) {
    return new Promise((resolve, reject) => {
      const sql = `
        UPDATE AppMenu SET 
          category = ?,
          premiumOnly = ?,
          difficulty = ?,
          estimatedTime = ?,
          requiredCoins = COALESCE(?, requiredCoins)
        WHERE id = ?
      `;
      this.db.run(sql, [
        menuData.category,
        menuData.premiumOnly,
        menuData.difficulty,
        menuData.estimatedTime,
        menuData.requiredCoins,
        menuData.id
      ], (err) => {
        if (err) {
          reject(err);
        } else {
          resolve();
        }
      });
    });
  }

  // 전체 V2.1 업그레이드 실행
  async upgrade() {
    try {
      console.log('🚀 데이터베이스 V2.1 업그레이드 시작...');
      
      const currentVersion = await this.checkDatabaseVersion();
      console.log(`현재 데이터베이스 버전: ${currentVersion}`);

      if (currentVersion >= 3) {
        console.log('✅ 데이터베이스가 이미 V2.1으로 업그레이드되어 있습니다.');
        return;
      }

      // 1. CoinTransactions 테이블 생성
      await this.createCoinTransactionsTable();

      // 2. Users 테이블 프리미엄 확장
      await this.upgradeUsersTable();

      // 3. ReadingHistory 테이블 V2.1 확장
      await this.upgradeReadingHistoryTable();

      // 4. AppMenu 테이블 프리미엄 확장
      await this.upgradeAppMenuTable();

      // 5. UserAchievements 테이블 생성
      await this.createUserAchievementsTable();

      // 6. DailyRewards 테이블 생성
      await this.createDailyRewardsTable();

      // 7. 기본 코인 거래 데이터 생성
      await this.insertInitialCoinTransactions();

      // 8. 메뉴 프리미엄 정보 업데이트
      await this.updateMenusForPremium();

      // 9. 데이터베이스 버전 업데이트
      await this.setDatabaseVersion(3);

      console.log('🎉 데이터베이스 V2.1 업그레이드 완료!');
      
    } catch (error) {
      console.error('❌ 데이터베이스 V2.1 업그레이드 실패:', error);
      throw error;
    }
  }

  // 업그레이드 상태 확인
  async verifyUpgrade() {
    try {
      console.log('\n📊 V2.1 업그레이드 결과 확인...');
      
      // 새 테이블들 확인
      const coinTransCount = await this.getTableCount('CoinTransactions');
      console.log(`CoinTransactions 테이블: ${coinTransCount}개 레코드`);

      const achievementsCount = await this.getTableCount('UserAchievements');
      console.log(`UserAchievements 테이블: ${achievementsCount}개 레코드`);

      const dailyRewardsCount = await this.getTableCount('DailyRewards');
      console.log(`DailyRewards 테이블: ${dailyRewardsCount}개 레코드`);

      // 확장된 테이블 컬럼 확인
      const userColumns = await this.getTableColumns('User');
      console.log(`User 테이블 컬럼: ${userColumns.length}개`);
      
      const readingColumns = await this.getTableColumns('ReadingHistory');
      console.log(`ReadingHistory 테이블 컬럼: ${readingColumns.length}개`);

      const menuColumns = await this.getTableColumns('AppMenu');
      console.log(`AppMenu 테이블 컬럼: ${menuColumns.length}개`);

      const version = await this.checkDatabaseVersion();
      console.log(`최종 데이터베이스 버전: ${version}`);

    } catch (error) {
      console.error('V2.1 업그레이드 확인 중 오류:', error);
    }
  }

  // 헬퍼 메서드들
  async getTableCount(tableName) {
    return new Promise((resolve, reject) => {
      this.db.get(`SELECT COUNT(*) as count FROM ${tableName}`, (err, row) => {
        if (err) {
          if (err.message.includes('no such table')) {
            resolve(0);
          } else {
            reject(err);
          }
        } else {
          resolve(row.count);
        }
      });
    });
  }

  async getTableColumns(tableName) {
    return new Promise((resolve, reject) => {
      this.db.all(`PRAGMA table_info(${tableName})`, (err, rows) => {
        if (err) reject(err);
        else resolve(rows);
      });
    });
  }

  // 데이터베이스 연결 종료
  close() {
    this.db.close((err) => {
      if (err) {
        console.error('데이터베이스 연결 종료 오류:', err);
      } else {
        console.log('데이터베이스 연결 종료');
      }
    });
  }
}

// 직접 실행시 업그레이드 수행
if (require.main === module) {
  const upgrader = new DatabaseV21Upgrader();
  
  upgrader.upgrade()
    .then(() => upgrader.verifyUpgrade())
    .finally(() => upgrader.close());
}

module.exports = DatabaseV21Upgrader;