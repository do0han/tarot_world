// v2_apis.js - V2.0 새로운 API 엔드포인트
const sqlite3 = require('sqlite3').verbose();
const path = require('path');

const DB_PATH = path.join(__dirname, 'tarot_constellation.db');

class V2ApiHandler {
  constructor() {
    this.db = new sqlite3.Database(DB_PATH);
  }

  // 표준 API 응답 래퍼
  createResponse(success, data, error = null, statusCode = 200) {
    return {
      success,
      data: success ? data : null,
      error: success ? null : error,
      timestamp: new Date().toISOString(),
      statusCode
    };
  }

  // 사용자 로그인 (간단한 형태)
  async loginUser(req, res) {
    try {
      const { username } = req.body;
      
      if (!username || username.trim().length < 2) {
        return res.status(400).json(
          this.createResponse(false, null, '사용자명은 2글자 이상이어야 합니다', 400)
        );
      }

      // 기존 사용자 확인 또는 새 사용자 생성
      const user = await this.findOrCreateUser(username.trim());
      
      // 로그인 시간 업데이트
      await this.updateLastLogin(user.id);
      
      console.log(`[${new Date().toLocaleTimeString()}] 사용자 로그인: ${username}`);
      
      res.json(this.createResponse(true, {
        user: {
          id: user.id,
          username: user.username,
          coinBalance: user.coinBalance,
          isNewUser: user.isNewUser || false
        }
      }));

    } catch (error) {
      console.error('로그인 오류:', error);
      res.status(500).json(
        this.createResponse(false, null, '로그인 처리 중 오류가 발생했습니다', 500)
      );
    }
  }

  // 사용자 프로필 조회
  async getUserProfile(req, res) {
    try {
      const { userId } = req.params;
      
      const user = await this.findUserById(userId);
      
      if (!user) {
        return res.status(404).json(
          this.createResponse(false, null, '사용자를 찾을 수 없습니다', 404)
        );
      }

      // 최근 리딩 개수 조회
      const recentReadings = await this.getRecentReadingCount(userId);
      
      res.json(this.createResponse(true, {
        user: {
          id: user.id,
          username: user.username,
          coinBalance: user.coinBalance,
          createdAt: user.createdAt,
          recentReadings: recentReadings
        }
      }));

    } catch (error) {
      console.error('프로필 조회 오류:', error);
      res.status(500).json(
        this.createResponse(false, null, '프로필 조회 중 오류가 발생했습니다', 500)
      );
    }
  }

  // 타로 리딩 실행 (핵심 API)
  async executeTarotReading(req, res) {
    try {
      const { userId, menuId, cardCount = 1 } = req.body;
      
      // 입력 검증
      if (!userId || !menuId) {
        return res.status(400).json(
          this.createResponse(false, null, '사용자 ID와 메뉴 ID가 필요합니다', 400)
        );
      }

      // 사용자 조회
      const user = await this.findUserById(userId);
      if (!user) {
        return res.status(404).json(
          this.createResponse(false, null, '사용자를 찾을 수 없습니다', 404)
        );
      }

      // 메뉴 정보 조회
      const menu = await this.findMenuById(menuId);
      if (!menu) {
        return res.status(404).json(
          this.createResponse(false, null, '메뉴를 찾을 수 없습니다', 404)
        );
      }

      // 유료 콘텐츠인 경우 코인 확인
      if (!menu.isFree) {
        if (user.coinBalance < menu.requiredCoins) {
          return res.status(402).json(
            this.createResponse(false, null, '코인이 부족합니다', 402)
          );
        }
        
        // 코인 차감
        await this.deductCoins(userId, menu.requiredCoins);
      }

      // 카드 뽑기 실행
      const drawnCards = await this.drawCardsForReading(cardCount, menu.spreadType);
      
      // 결과 데이터 구성
      const resultData = {
        menuId: menuId,
        menuTitle: menu.title,
        spreadType: menu.spreadType,
        cards: drawnCards,
        interpretation: this.generateInterpretation(drawnCards, menu.keyword),
        timestamp: new Date().toISOString()
      };

      // 결과 저장
      const historyId = await this.saveReadingHistory(
        userId, 
        menuId, 
        JSON.stringify(resultData), 
        menu.requiredCoins
      );

      // 업데이트된 사용자 정보 조회
      const updatedUser = await this.findUserById(userId);

      console.log(`[${new Date().toLocaleTimeString()}] 타로 리딩 완료: 사용자 ${userId}, 메뉴 ${menuId}`);

      res.json(this.createResponse(true, {
        reading: resultData,
        historyId: historyId,
        userCoinBalance: updatedUser.coinBalance,
        coinsUsed: menu.requiredCoins
      }));

    } catch (error) {
      console.error('타로 리딩 오류:', error);
      res.status(500).json(
        this.createResponse(false, null, '타로 리딩 처리 중 오류가 발생했습니다', 500)
      );
    }
  }

  // 광고 시청으로 코인 충전
  async watchAdReward(req, res) {
    try {
      const { userId } = req.body;
      const rewardCoins = 5; // 광고 1회당 5코인

      const user = await this.findUserById(userId);
      if (!user) {
        return res.status(404).json(
          this.createResponse(false, null, '사용자를 찾을 수 없습니다', 404)
        );
      }

      // 코인 충전
      await this.addCoins(userId, rewardCoins);
      
      // 업데이트된 잔액 조회
      const updatedUser = await this.findUserById(userId);

      console.log(`[${new Date().toLocaleTimeString()}] 광고 시청 보상: 사용자 ${userId}, +${rewardCoins} 코인`);

      res.json(this.createResponse(true, {
        rewardCoins: rewardCoins,
        newBalance: updatedUser.coinBalance
      }));

    } catch (error) {
      console.error('광고 보상 오류:', error);
      res.status(500).json(
        this.createResponse(false, null, '광고 보상 처리 중 오류가 발생했습니다', 500)
      );
    }
  }

  // 사용자 리딩 히스토리 조회
  async getUserHistory(req, res) {
    try {
      const { userId } = req.params;
      const { limit = 20, offset = 0 } = req.query;

      const user = await this.findUserById(userId);
      if (!user) {
        return res.status(404).json(
          this.createResponse(false, null, '사용자를 찾을 수 없습니다', 404)
        );
      }

      const history = await this.getReadingHistory(userId, parseInt(limit), parseInt(offset));

      res.json(this.createResponse(true, {
        history: history,
        total: history.length,
        hasMore: history.length === parseInt(limit)
      }));

    } catch (error) {
      console.error('히스토리 조회 오류:', error);
      res.status(500).json(
        this.createResponse(false, null, '히스토리 조회 중 오류가 발생했습니다', 500)
      );
    }
  }

  // 코인 관리 (충전/차감)
  async manageCoins(req, res) {
    try {
      const { userId, amount, operation } = req.body; // operation: 'add' or 'deduct'
      
      if (!userId || !amount || !operation) {
        return res.status(400).json(
          this.createResponse(false, null, '필수 파라미터가 누락되었습니다', 400)
        );
      }

      const user = await this.findUserById(userId);
      if (!user) {
        return res.status(404).json(
          this.createResponse(false, null, '사용자를 찾을 수 없습니다', 404)
        );
      }

      if (operation === 'add') {
        await this.addCoins(userId, amount);
      } else if (operation === 'deduct') {
        if (user.coinBalance < amount) {
          return res.status(402).json(
            this.createResponse(false, null, '코인이 부족합니다', 402)
          );
        }
        await this.deductCoins(userId, amount);
      } else {
        return res.status(400).json(
          this.createResponse(false, null, '잘못된 operation 값입니다', 400)
        );
      }

      const updatedUser = await this.findUserById(userId);

      res.json(this.createResponse(true, {
        operation: operation,
        amount: amount,
        newBalance: updatedUser.coinBalance
      }));

    } catch (error) {
      console.error('코인 관리 오류:', error);
      res.status(500).json(
        this.createResponse(false, null, '코인 관리 중 오류가 발생했습니다', 500)
      );
    }
  }

  // === 데이터베이스 헬퍼 메서드들 ===

  // 데이터베이스에서 메뉴 조회
  getMenusFromDatabase() {
    return new Promise((resolve, reject) => {
      this.db.all(
        "SELECT * FROM AppMenu WHERE appId = 1 ORDER BY position",
        [],
        (err, rows) => {
          if (err) {
            reject(err);
          } else {
            // 데이터베이스 결과를 API 형식으로 변환
            const menus = rows.map(row => ({
              id: row.id,
              title: row.title,
              position: row.position,
              category: row.category,
              uiType: row.uiType,
              keyword: row.keyword,
              description: row.description,
              isFree: Boolean(row.isFree),
              requiredCoins: row.requiredCoins,
              spreadType: row.spreadType
            }));
            resolve(menus);
          }
        }
      );
    });
  }

  // 사용자 검색 또는 생성
  findOrCreateUser(username) {
    return new Promise((resolve, reject) => {
      // 먼저 기존 사용자 검색
      this.db.get(
        "SELECT * FROM User WHERE username = ?",
        [username],
        (err, row) => {
          if (err) {
            reject(err);
            return;
          }

          if (row) {
            // 기존 사용자
            resolve(row);
          } else {
            // 새 사용자 생성
            const sql = `
              INSERT INTO User (username, coinBalance, createdAt, lastLoginAt) 
              VALUES (?, 50, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
            `;
            this.db.run(sql, [username], function(err) {
              if (err) {
                reject(err);
              } else {
                // 생성된 사용자 정보 반환
                resolve({
                  id: this.lastID,
                  username: username,
                  coinBalance: 50,
                  isNewUser: true
                });
              }
            });
          }
        }
      );
    });
  }

  // ID로 사용자 검색
  findUserById(userId) {
    return new Promise((resolve, reject) => {
      this.db.get(
        "SELECT * FROM User WHERE id = ?",
        [userId],
        (err, row) => {
          if (err) reject(err);
          else resolve(row);
        }
      );
    });
  }

  // ID로 메뉴 검색
  findMenuById(menuId) {
    return new Promise((resolve, reject) => {
      this.db.get(
        "SELECT * FROM AppMenu WHERE id = ?",
        [menuId],
        (err, row) => {
          if (err) reject(err);
          else resolve(row);
        }
      );
    });
  }

  // 마지막 로그인 시간 업데이트
  updateLastLogin(userId) {
    return new Promise((resolve, reject) => {
      this.db.run(
        "UPDATE User SET lastLoginAt = CURRENT_TIMESTAMP WHERE id = ?",
        [userId],
        (err) => {
          if (err) reject(err);
          else resolve();
        }
      );
    });
  }

  // 코인 차감
  deductCoins(userId, amount) {
    return new Promise((resolve, reject) => {
      this.db.run(
        "UPDATE User SET coinBalance = coinBalance - ? WHERE id = ?",
        [amount, userId],
        (err) => {
          if (err) reject(err);
          else resolve();
        }
      );
    });
  }

  // 코인 추가
  addCoins(userId, amount) {
    return new Promise((resolve, reject) => {
      this.db.run(
        "UPDATE User SET coinBalance = coinBalance + ? WHERE id = ?",
        [amount, userId],
        (err) => {
          if (err) reject(err);
          else resolve();
        }
      );
    });
  }

  // 리딩 결과 저장
  saveReadingHistory(userId, menuId, resultData, coinsUsed) {
    return new Promise((resolve, reject) => {
      const sql = `
        INSERT INTO ReadingHistory (userId, menuId, resultData, coinsUsed, createdAt)
        VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP)
      `;
      this.db.run(sql, [userId, menuId, resultData, coinsUsed], function(err) {
        if (err) reject(err);
        else resolve(this.lastID);
      });
    });
  }

  // 리딩 히스토리 조회
  getReadingHistory(userId, limit, offset) {
    return new Promise((resolve, reject) => {
      const sql = `
        SELECT rh.*, am.title as menuTitle
        FROM ReadingHistory rh
        JOIN AppMenu am ON rh.menuId = am.id
        WHERE rh.userId = ?
        ORDER BY rh.createdAt DESC
        LIMIT ? OFFSET ?
      `;
      this.db.all(sql, [userId, limit, offset], (err, rows) => {
        if (err) reject(err);
        else {
          // JSON 파싱
          const history = rows.map(row => ({
            ...row,
            resultData: JSON.parse(row.resultData)
          }));
          resolve(history);
        }
      });
    });
  }

  // 최근 리딩 개수 조회
  getRecentReadingCount(userId) {
    return new Promise((resolve, reject) => {
      const sql = `
        SELECT COUNT(*) as count 
        FROM ReadingHistory 
        WHERE userId = ? AND createdAt >= date('now', '-7 days')
      `;
      this.db.get(sql, [userId], (err, row) => {
        if (err) reject(err);
        else resolve(row.count);
      });
    });
  }

  // 타로 카드 뽑기 (기존 로직 재사용)
  async drawCardsForReading(count, spreadType) {
    const fullTarotDeck = require('./tarot_cards_data.js');
    
    // 카드 셔플 및 선택
    const shuffledCards = [...fullTarotDeck].sort(() => Math.random() - 0.5);
    const selectedCards = shuffledCards.slice(0, count);
    
    // 역방향 설정 (30% 확률)
    return selectedCards.map(card => ({
      ...card,
      isReversed: Math.random() < 0.3
    }));
  }

  // 간단한 해석 생성
  generateInterpretation(cards, keyword) {
    const interpretations = {
      'love': '사랑과 관련된 운세입니다.',
      'money': '재물과 관련된 운세입니다.',
      'work': '직업과 학업에 관련된 운세입니다.',
      'default': '오늘의 전체적인 운세입니다.'
    };
    
    return interpretations[keyword] || interpretations['default'];
  }

  // 연결 종료
  close() {
    this.db.close();
  }
}

module.exports = V2ApiHandler;