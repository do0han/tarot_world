// database_upgrade.js - V2.0 데이터베이스 스키마 업그레이드
const sqlite3 = require('sqlite3').verbose();
const path = require('path');

const DB_PATH = path.join(__dirname, 'tarot_constellation.db');

class DatabaseUpgrader {
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

  // User 테이블 생성
  async createUserTable() {
    const sql = `
      CREATE TABLE IF NOT EXISTS User (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username VARCHAR(50) UNIQUE NOT NULL,
        email VARCHAR(100),
        coinBalance INTEGER DEFAULT 50,
        createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
        lastLoginAt DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    `;

    return new Promise((resolve, reject) => {
      this.db.run(sql, (err) => {
        if (err) {
          console.error('User 테이블 생성 실패:', err);
          reject(err);
        } else {
          console.log('✅ User 테이블 생성 완료');
          resolve();
        }
      });
    });
  }

  // AppMenu 테이블 확장 (새 컬럼 추가)
  async upgradeAppMenuTable() {
    const columns = [
      { name: 'isFree', type: 'BOOLEAN DEFAULT TRUE' },
      { name: 'requiredCoins', type: 'INTEGER DEFAULT 0' },
      { name: 'spreadType', type: 'VARCHAR(50) DEFAULT "single_card"' },
      { name: 'description', type: 'TEXT' }
    ];

    for (const column of columns) {
      try {
        await this.addColumnIfNotExists('AppMenu', column.name, column.type);
      } catch (err) {
        console.log(`컬럼 ${column.name}은 이미 존재합니다.`);
      }
    }
    console.log('✅ AppMenu 테이블 확장 완료');
  }

  // 컬럼 존재 여부 확인 후 추가
  async addColumnIfNotExists(tableName, columnName, columnType) {
    return new Promise((resolve, reject) => {
      // 먼저 컬럼이 존재하는지 확인
      this.db.all(`PRAGMA table_info(${tableName})`, (err, rows) => {
        if (err) {
          reject(err);
          return;
        }

        const columnExists = rows.some(row => row.name === columnName);
        
        if (!columnExists) {
          // 컬럼이 없으면 추가
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

  // ReadingHistory 테이블 생성
  async createReadingHistoryTable() {
    const sql = `
      CREATE TABLE IF NOT EXISTS ReadingHistory (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        menuId INTEGER NOT NULL,
        resultData TEXT NOT NULL, -- JSON 형태로 저장
        coinsUsed INTEGER DEFAULT 0,
        createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (userId) REFERENCES User(id),
        FOREIGN KEY (menuId) REFERENCES AppMenu(id)
      )
    `;

    return new Promise((resolve, reject) => {
      this.db.run(sql, (err) => {
        if (err) {
          console.error('ReadingHistory 테이블 생성 실패:', err);
          reject(err);
        } else {
          console.log('✅ ReadingHistory 테이블 생성 완료');
          resolve();
        }
      });
    });
  }

  // 기본 사용자 데이터 삽입
  async insertDefaultUsers() {
    const users = [
      { username: 'testuser1', email: 'test1@example.com', coinBalance: 100 },
      { username: 'testuser2', email: 'test2@example.com', coinBalance: 50 },
      { username: 'guest', email: null, coinBalance: 30 }
    ];

    for (const user of users) {
      await this.insertUserIfNotExists(user);
    }
    console.log('✅ 기본 사용자 데이터 삽입 완료');
  }

  // 사용자가 존재하지 않으면 삽입
  async insertUserIfNotExists(userData) {
    return new Promise((resolve, reject) => {
      // 먼저 사용자가 존재하는지 확인
      this.db.get(
        "SELECT id FROM User WHERE username = ?",
        [userData.username],
        (err, row) => {
          if (err) {
            reject(err);
            return;
          }

          if (!row) {
            // 사용자가 없으면 삽입
            const sql = `
              INSERT INTO User (username, email, coinBalance, createdAt, lastLoginAt)
              VALUES (?, ?, ?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
            `;
            this.db.run(sql, [userData.username, userData.email, userData.coinBalance], (err) => {
              if (err) {
                reject(err);
              } else {
                console.log(`✅ 사용자 ${userData.username} 생성 완료`);
                resolve();
              }
            });
          } else {
            resolve();
          }
        }
      );
    });
  }

  // 전체 업그레이드 실행
  async upgrade() {
    try {
      console.log('🚀 데이터베이스 V2.0 업그레이드 시작...');
      
      const currentVersion = await this.checkDatabaseVersion();
      console.log(`현재 데이터베이스 버전: ${currentVersion}`);

      if (currentVersion >= 2) {
        console.log('✅ 데이터베이스가 이미 V2.0으로 업그레이드되어 있습니다.');
        return;
      }

      // 1. User 테이블 생성
      await this.createUserTable();

      // 2. AppMenu 테이블 확장
      await this.upgradeAppMenuTable();

      // 3. ReadingHistory 테이블 생성
      await this.createReadingHistoryTable();

      // 4. 기본 사용자 데이터 삽입
      await this.insertDefaultUsers();

      // 5. 데이터베이스 버전 업데이트
      await this.setDatabaseVersion(2);

      console.log('🎉 데이터베이스 V2.0 업그레이드 완료!');
      
    } catch (error) {
      console.error('❌ 데이터베이스 업그레이드 실패:', error);
      throw error;
    }
  }

  // 업그레이드 상태 확인
  async verifyUpgrade() {
    try {
      console.log('\n📊 업그레이드 결과 확인...');
      
      // User 테이블 확인
      const userCount = await this.getTableCount('User');
      console.log(`User 테이블: ${userCount}개 레코드`);

      // AppMenu 테이블 컬럼 확인
      const menuColumns = await this.getTableColumns('AppMenu');
      console.log(`AppMenu 테이블 컬럼: ${menuColumns.length}개`);
      console.log('새 컬럼:', menuColumns.filter(col => 
        ['isFree', 'requiredCoins', 'spreadType', 'description'].includes(col.name)
      ).map(col => col.name));

      // ReadingHistory 테이블 확인
      const historyCount = await this.getTableCount('ReadingHistory');
      console.log(`ReadingHistory 테이블: ${historyCount}개 레코드`);

      const version = await this.checkDatabaseVersion();
      console.log(`최종 데이터베이스 버전: ${version}`);

    } catch (error) {
      console.error('업그레이드 확인 중 오류:', error);
    }
  }

  // 헬퍼 메서드들
  async getTableCount(tableName) {
    return new Promise((resolve, reject) => {
      this.db.get(`SELECT COUNT(*) as count FROM ${tableName}`, (err, row) => {
        if (err) reject(err);
        else resolve(row.count);
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
  const upgrader = new DatabaseUpgrader();
  
  upgrader.upgrade()
    .then(() => upgrader.verifyUpgrade())
    .finally(() => upgrader.close());
}

module.exports = DatabaseUpgrader;