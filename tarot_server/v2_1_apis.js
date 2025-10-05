// v2_1_apis.js - V2.1 프리미엄 수익화 모델 API 핸들러
const sqlite3 = require('sqlite3').verbose();
const path = require('path');

const DB_PATH = path.join(__dirname, 'tarot_constellation.db');

class V21APIHandler {
  constructor() {
    this.db = new sqlite3.Database(DB_PATH);
  }

  // ===================
  // 코인 관리 API
  // ===================

  // 코인 트랜잭션 추가 및 잔액 업데이트
  async addCoinTransaction(userId, amount, type, description, relatedId = null) {
    const db = this.db;
    return new Promise((resolve, reject) => {
      db.serialize(() => {
        db.run('BEGIN TRANSACTION');

        // 1. 코인 트랜잭션 기록
        db.run(
          `INSERT INTO CoinTransactions (userId, amount, type, description, relatedId, createdAt)
           VALUES (?, ?, ?, ?, ?, CURRENT_TIMESTAMP)`,
          [userId, amount, type, description, relatedId],
          function(err) {
            if (err) {
              console.error('코인 트랜잭션 기록 실패:', err);
              reject(err);
              return;
            }

            const transactionId = this.lastID;

            // 2. 사용자 코인 잔액 업데이트
            db.run(
              `UPDATE User SET 
                 coinBalance = coinBalance + ?,
                 totalCoinsSpent = CASE WHEN ? < 0 THEN totalCoinsSpent + ABS(?) ELSE totalCoinsSpent END
               WHERE id = ?`,
              [amount, amount, amount, userId],
              (err) => {
                if (err) {
                  console.error('코인 잔액 업데이트 실패:', err);
                  db.run('ROLLBACK');
                  reject(err);
                  return;
                }

                db.run('COMMIT');
                resolve({ transactionId, newBalance: null }); // 잔액은 별도 조회
              }
            );
          }
        );
      });
    });
  }

  // 광고 시청 보상
  async watchAdReward(req, res) {
    try {
      const { userId } = req.body;

      if (!userId) {
        return res.status(400).json({
          success: false,
          message: '사용자 ID가 필요합니다'
        });
      }

      // 일일 광고 시청 제한 확인 (5회)
      const today = new Date().toISOString().split('T')[0];
      const todayAdCount = await this.getTodayAdCount(userId, today);

      if (todayAdCount >= 5) {
        return res.status(400).json({
          success: false,
          message: '오늘 광고 시청 한도를 초과했습니다 (5회)',
          data: { todayAdCount, maxDaily: 5 }
        });
      }

      // 코인 지급 (5코인)
      const result = await this.addCoinTransaction(
        userId, 
        5, 
        'ad_reward', 
        `광고 시청 보상 (${todayAdCount + 1}/5)`
      );

      // 업데이트된 잔액 조회
      const newBalance = await this.getUserCoinBalance(userId);

      res.json({
        success: true,
        message: '광고 시청 보상이 지급되었습니다!',
        data: {
          coinsRewarded: 5,
          newBalance: newBalance,
          todayAdCount: todayAdCount + 1,
          remainingAds: 4 - todayAdCount
        }
      });

    } catch (error) {
      console.error('광고 시청 보상 처리 오류:', error);
      res.status(500).json({
        success: false,
        message: '서버 오류가 발생했습니다'
      });
    }
  }

  // 일일 출석 보상
  async dailyBonus(req, res) {
    try {
      const { userId } = req.body;

      if (!userId) {
        return res.status(400).json({
          success: false,
          message: '사용자 ID가 필요합니다'
        });
      }

      // 오늘 이미 출석 체크했는지 확인
      const today = new Date().toISOString().split('T')[0];
      const alreadyClaimed = await this.checkDailyBonusClaimed(userId, today);

      if (alreadyClaimed) {
        return res.status(400).json({
          success: false,
          message: '오늘 이미 출석 보상을 받았습니다',
          data: { nextClaimDate: this.getNextDayISO() }
        });
      }

      // 연속 출석일 계산
      const streakInfo = await this.calculateStreakDays(userId);
      const bonusCoins = this.calculateDailyBonus(streakInfo.streakDays);

      // 출석 보상 기록
      await this.recordDailyReward(userId, today, bonusCoins, streakInfo.streakDays);

      // 코인 지급
      await this.addCoinTransaction(
        userId,
        bonusCoins,
        'daily_bonus',
        `일일 출석 보상 (${streakInfo.streakDays}일 연속)`
      );

      // 사용자 연속 출석일 업데이트
      await this.updateUserStreak(userId, streakInfo.streakDays, today);

      const newBalance = await this.getUserCoinBalance(userId);

      res.json({
        success: true,
        message: `${streakInfo.streakDays}일 연속 출석! ${bonusCoins}코인 지급`,
        data: {
          coinsRewarded: bonusCoins,
          newBalance: newBalance,
          streakDays: streakInfo.streakDays,
          nextBonusCoins: this.calculateDailyBonus(streakInfo.streakDays + 1)
        }
      });

    } catch (error) {
      console.error('일일 출석 보상 처리 오류:', error);
      res.status(500).json({
        success: false,
        message: '서버 오류가 발생했습니다'
      });
    }
  }

  // ===================
  // 타로 리딩 실행 API
  // ===================

  // 타로 리딩 실행 (코인 차감 포함)
  async executeReading(req, res) {
    try {
      console.log(`[${new Date().toLocaleTimeString('ko-KR')}] V2.1 executeReading 호출:`, req.body);
      const { userId, menuId, questionType, spreadType = 'single' } = req.body;
      
      console.log(`[${new Date().toLocaleTimeString('ko-KR')}] 파라미터 검증 시작...`);

      if (!userId || !menuId) {
        return res.status(400).json({
          success: false,
          message: '사용자 ID와 메뉴 ID가 필요합니다'
        });
      }

      // 메뉴 정보 조회 (코인 비용 확인)
      console.log(`[${new Date().toLocaleTimeString('ko-KR')}] 메뉴 정보 조회 중... menuId: ${menuId}`);
      const menuInfo = await this.getMenuInfo(menuId);
      console.log(`[${new Date().toLocaleTimeString('ko-KR')}] 메뉴 정보:`, menuInfo);
      
      if (!menuInfo) {
        console.log(`[${new Date().toLocaleTimeString('ko-KR')}] 메뉴를 찾을 수 없음: ${menuId}`);
        return res.status(404).json({
          success: false,
          message: '존재하지 않는 메뉴입니다'
        });
      }

      // 사용자 코인 잔액 확인
      const userBalance = await this.getUserCoinBalance(userId);
      if (userBalance < menuInfo.requiredCoins) {
        return res.status(400).json({
          success: false,
          message: '코인이 부족합니다',
          data: {
            required: menuInfo.requiredCoins,
            current: userBalance,
            needed: menuInfo.requiredCoins - userBalance
          }
        });
      }

      // 프리미엄 전용 메뉴 확인
      if (menuInfo.premiumOnly) {
        const isPremium = await this.checkUserPremium(userId);
        if (!isPremium) {
          return res.status(403).json({
            success: false,
            message: '프리미엄 전용 메뉴입니다',
            data: { menuTitle: menuInfo.title, premiumRequired: true }
          });
        }
      }

      // 카드 뽑기 실행
      const cardCount = this.getCardCountBySpread(spreadType);
      const drawnCards = await this.drawCards(cardCount);

      // 해석 생성
      const interpretation = await this.generateInterpretation(
        drawnCards, 
        questionType, 
        spreadType,
        await this.checkUserPremium(userId)
      );

      // 코인 차감 (무료가 아닌 경우)
      if (menuInfo.requiredCoins > 0) {
        await this.addCoinTransaction(
          userId,
          -menuInfo.requiredCoins,
          'reading_cost',
          `${menuInfo.title} 타로 리딩`,
          menuId
        );
      }

      // 리딩 히스토리 저장
      const historyId = await this.saveReadingHistory({
        userId,
        menuId,
        questionType,
        spreadType,
        cardData: JSON.stringify(drawnCards),
        interpretation: interpretation.basic,
        detailedInterpretation: interpretation.detailed,
        coinsUsed: menuInfo.requiredCoins
      });

      // 사용자 통계 업데이트
      await this.updateUserStats(userId);

      const newBalance = await this.getUserCoinBalance(userId);

      res.json({
        success: true,
        message: '타로 리딩이 완료되었습니다',
        data: {
          historyId,
          cards: drawnCards,
          interpretation: interpretation,
          coinsUsed: menuInfo.requiredCoins,
          newBalance: newBalance,
          spreadType,
          questionType
        }
      });

    } catch (error) {
      console.error('타로 리딩 실행 오류:', error);
      res.status(500).json({
        success: false,
        message: '서버 오류가 발생했습니다'
      });
    }
  }

  // ===================
  // 프리미엄 및 구독 API
  // ===================

  // 프리미엄 구독
  async subscribePremium(req, res) {
    try {
      const { userId, planType, duration } = req.body; // 'monthly', 'yearly'

      if (!userId || !planType) {
        return res.status(400).json({
          success: false,
          message: '사용자 ID와 플랜 타입이 필요합니다'
        });
      }

      // 구독 플랜 정보
      const plans = {
        monthly: { price: 4900, duration: 30, name: '월간 프리미엄' },
        yearly: { price: 49000, duration: 365, name: '연간 프리미엄' }
      };

      const plan = plans[planType];
      if (!plan) {
        return res.status(400).json({
          success: false,
          message: '유효하지 않은 플랜입니다'
        });
      }

      // 현재 프리미엄 상태 확인
      const currentPremium = await this.getUserPremiumStatus(userId);
      
      // 프리미엄 만료일 계산
      const now = new Date();
      const baseDate = currentPremium.isPremium && currentPremium.premiumExpiresAt > now 
        ? new Date(currentPremium.premiumExpiresAt) 
        : now;
      
      const expiresAt = new Date(baseDate.getTime() + (plan.duration * 24 * 60 * 60 * 1000));

      // 프리미엄 상태 업데이트
      await this.updateUserPremium(userId, true, expiresAt);

      // 구독 기록 (코인 트랜잭션으로)
      await this.addCoinTransaction(
        userId,
        0, // 실제 결제는 외부 시스템
        'premium_subscription',
        `${plan.name} 구독 (${plan.duration}일)`
      );

      res.json({
        success: true,
        message: `${plan.name} 구독이 완료되었습니다!`,
        data: {
          planType,
          planName: plan.name,
          duration: plan.duration,
          expiresAt: expiresAt.toISOString(),
          benefits: [
            '무제한 타로 리딩',
            '상세 해석 및 조언',
            '히스토리 무제한 보관',
            '매일 운세 푸시 알림',
            '광고 제거'
          ]
        }
      });

    } catch (error) {
      console.error('프리미엄 구독 처리 오류:', error);
      res.status(500).json({
        success: false,
        message: '서버 오류가 발생했습니다'
      });
    }
  }

  // 사용자 히스토리 조회
  async getReadingHistory(req, res) {
    try {
      const { userId } = req.params;
      const { page = 1, limit = 10, category } = req.query;

      if (!userId) {
        return res.status(400).json({
          success: false,
          message: '사용자 ID가 필요합니다'
        });
      }

      const isPremium = await this.checkUserPremium(userId);
      const actualLimit = isPremium ? parseInt(limit) : Math.min(parseInt(limit), 5);

      const history = await this.getUserReadingHistory(userId, page, actualLimit, category);
      const total = await this.getUserReadingCount(userId, category);

      res.json({
        success: true,
        data: {
          history: history,
          pagination: {
            page: parseInt(page),
            limit: actualLimit,
            total: total,
            totalPages: Math.ceil(total / actualLimit)
          },
          isPremium,
          limitations: isPremium ? null : {
            message: '무료 사용자는 최근 5개 기록만 조회 가능',
            upgradePrompt: '프리미엄으로 업그레이드하면 무제한 히스토리 이용 가능'
          }
        }
      });

    } catch (error) {
      console.error('히스토리 조회 오류:', error);
      res.status(500).json({
        success: false,
        message: '서버 오류가 발생했습니다'
      });
    }
  }

  // ===================
  // 헬퍼 메서드들
  // ===================

  // 오늘 광고 시청 횟수 조회
  async getTodayAdCount(userId, today) {
    return new Promise((resolve, reject) => {
      this.db.get(
        `SELECT COUNT(*) as count FROM CoinTransactions 
         WHERE userId = ? AND type = 'ad_reward' 
         AND DATE(createdAt) = ?`,
        [userId, today],
        (err, row) => {
          if (err) reject(err);
          else resolve(row.count);
        }
      );
    });
  }

  // 사용자 코인 잔액 조회
  async getUserCoinBalance(userId) {
    return new Promise((resolve, reject) => {
      this.db.get(
        'SELECT coinBalance FROM User WHERE id = ?',
        [userId],
        (err, row) => {
          if (err) reject(err);
          else resolve(row ? row.coinBalance : 0);
        }
      );
    });
  }

  // 일일 보상 이미 받았는지 확인
  async checkDailyBonusClaimed(userId, today) {
    return new Promise((resolve, reject) => {
      this.db.get(
        'SELECT id FROM DailyRewards WHERE userId = ? AND rewardDate = ?',
        [userId, today],
        (err, row) => {
          if (err) reject(err);
          else resolve(!!row);
        }
      );
    });
  }

  // 연속 출석일 계산
  async calculateStreakDays(userId) {
    return new Promise((resolve, reject) => {
      this.db.get(
        'SELECT streakDays, lastDailyBonus FROM User WHERE id = ?',
        [userId],
        (err, row) => {
          if (err) {
            reject(err);
            return;
          }

          if (!row) {
            resolve({ streakDays: 1, isConsecutive: false });
            return;
          }

          const today = new Date();
          const yesterday = new Date(today.getTime() - 24 * 60 * 60 * 1000);
          
          let streakDays = 1;
          
          if (row.lastDailyBonus) {
            const lastBonusDate = new Date(row.lastDailyBonus);
            const lastBonusDateStr = lastBonusDate.toISOString().split('T')[0];
            const yesterdayStr = yesterday.toISOString().split('T')[0];
            
            if (lastBonusDateStr === yesterdayStr) {
              // 어제도 출석했으면 연속 출석일 증가
              streakDays = (row.streakDays || 0) + 1;
            }
            // 그렇지 않으면 연속 출석 끊김 (1일부터 다시 시작)
          }

          resolve({ streakDays, isConsecutive: streakDays > 1 });
        }
      );
    });
  }

  // 출석일에 따른 보너스 코인 계산
  calculateDailyBonus(streakDays) {
    if (streakDays <= 3) return 2;
    if (streakDays <= 7) return 3;
    if (streakDays <= 14) return 5;
    if (streakDays <= 30) return 7;
    return 10; // 30일 이상
  }

  // 일일 보상 기록
  async recordDailyReward(userId, rewardDate, coinsRewarded, streakDay) {
    return new Promise((resolve, reject) => {
      this.db.run(
        `INSERT INTO DailyRewards (userId, rewardDate, rewardType, coinsRewarded, streakDay)
         VALUES (?, ?, 'daily_login', ?, ?)`,
        [userId, rewardDate, coinsRewarded, streakDay],
        function(err) {
          if (err) reject(err);
          else resolve(this.lastID);
        }
      );
    });
  }

  // 사용자 연속 출석일 업데이트
  async updateUserStreak(userId, streakDays, today) {
    return new Promise((resolve, reject) => {
      this.db.run(
        `UPDATE User SET streakDays = ?, lastDailyBonus = ? WHERE id = ?`,
        [streakDays, today, userId],
        (err) => {
          if (err) reject(err);
          else resolve();
        }
      );
    });
  }

  // 메뉴 정보 조회
  async getMenuInfo(menuId) {
    return new Promise((resolve, reject) => {
      console.log(`[${new Date().toLocaleTimeString('ko-KR')}] getMenuInfo SQL 실행 중... menuId: ${menuId}`);
      this.db.get(
        `SELECT id, title, requiredCoins, premiumOnly, category, difficulty 
         FROM AppMenu WHERE id = ?`,
        [menuId],
        (err, row) => {
          if (err) {
            console.error(`[${new Date().toLocaleTimeString('ko-KR')}] getMenuInfo SQL 오류:`, err);
            reject(err);
          } else {
            console.log(`[${new Date().toLocaleTimeString('ko-KR')}] getMenuInfo 결과:`, row);
            resolve(row);
          }
        }
      );
    });
  }

  // 사용자 프리미엄 상태 확인
  async checkUserPremium(userId) {
    return new Promise((resolve, reject) => {
      this.db.get(
        `SELECT isPremium, premiumExpiresAt FROM User WHERE id = ?`,
        [userId],
        (err, row) => {
          if (err) {
            reject(err);
            return;
          }

          if (!row) {
            resolve(false);
            return;
          }

          // 프리미엄이고 만료일이 현재보다 미래인 경우
          const now = new Date();
          const isActive = row.isPremium && 
            (!row.premiumExpiresAt || new Date(row.premiumExpiresAt) > now);
          
          resolve(isActive);
        }
      );
    });
  }

  // 스프레드 타입에 따른 카드 수 결정
  getCardCountBySpread(spreadType) {
    const counts = {
      'single': 1,
      'three_card': 3,
      'five_card': 5,
      'celtic_cross': 7
    };
    return counts[spreadType] || 1;
  }

  // 카드 뽑기 (기존 로직 활용)
  async drawCards(count) {
    // 기존 tarot_cards_data.js의 카드 데이터 활용
    const cards = require('./tarot_cards_data.js');
    const shuffled = [...cards].sort(() => Math.random() - 0.5);
    
    return shuffled.slice(0, count).map((card, index) => ({
      ...card,
      position: index + 1,
      isReversed: Math.random() < 0.3 // 30% 확률로 역방향
    }));
  }

  // 해석 생성
  async generateInterpretation(cards, questionType, spreadType, isPremium) {
    const basic = cards.map(card => {
      const meaning = card.isReversed ? 
        (card.description_reversed || card.reversedMeaning || '역방향의 의미') : 
        (card.description_upright || card.uprightMeaning || '정방향의 의미');
      const cardName = card.name_ko || card.koreanName || card.name_en || '타로 카드';
      return `${cardName}: ${meaning}`;
    }).join('\n\n');

    let detailed = null;
    if (isPremium) {
      detailed = `상세 해석:\n${basic}\n\n종합 메시지: 현재 상황을 차분히 받아들이고 내면의 지혜를 믿으세요.`;
    }

    return { basic, detailed };
  }

  // 리딩 히스토리 저장
  async saveReadingHistory(data) {
    return new Promise((resolve, reject) => {
      // V2.0 호환성을 위해 resultData도 함께 저장
      const resultData = JSON.stringify({
        cards: JSON.parse(data.cardData),
        interpretation: data.interpretation,
        detailedInterpretation: data.detailedInterpretation,
        questionType: data.questionType,
        spreadType: data.spreadType
      });

      this.db.run(
        `INSERT INTO ReadingHistory 
         (userId, menuId, resultData, questionType, spreadType, cardData, interpretation, detailedInterpretation, coinsUsed)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`,
        [data.userId, data.menuId, resultData, data.questionType, data.spreadType, 
         data.cardData, data.interpretation, data.detailedInterpretation, data.coinsUsed],
        function(err) {
          if (err) reject(err);
          else resolve(this.lastID);
        }
      );
    });
  }

  // 사용자 통계 업데이트
  async updateUserStats(userId) {
    return new Promise((resolve, reject) => {
      this.db.run(
        'UPDATE User SET totalReadings = totalReadings + 1 WHERE id = ?',
        [userId],
        (err) => {
          if (err) reject(err);
          else resolve();
        }
      );
    });
  }

  // 사용자 프리미엄 상태 업데이트
  async updateUserPremium(userId, isPremium, expiresAt) {
    return new Promise((resolve, reject) => {
      this.db.run(
        'UPDATE User SET isPremium = ?, premiumExpiresAt = ? WHERE id = ?',
        [isPremium, expiresAt.toISOString(), userId],
        (err) => {
          if (err) reject(err);
          else resolve();
        }
      );
    });
  }

  // 사용자 프리미엄 상태 조회
  async getUserPremiumStatus(userId) {
    return new Promise((resolve, reject) => {
      this.db.get(
        'SELECT isPremium, premiumExpiresAt FROM User WHERE id = ?',
        [userId],
        (err, row) => {
          if (err) reject(err);
          else resolve(row || { isPremium: false, premiumExpiresAt: null });
        }
      );
    });
  }

  // 사용자 리딩 히스토리 조회
  async getUserReadingHistory(userId, page, limit, category) {
    return new Promise((resolve, reject) => {
      const offset = (page - 1) * limit;
      let whereClause = 'WHERE rh.userId = ?';
      let params = [userId];

      if (category) {
        whereClause += ' AND rh.questionType = ?';
        params.push(category);
      }

      this.db.all(
        `SELECT rh.*, am.title as menuTitle 
         FROM ReadingHistory rh 
         LEFT JOIN AppMenu am ON rh.menuId = am.id 
         ${whereClause}
         ORDER BY rh.createdAt DESC 
         LIMIT ? OFFSET ?`,
        [...params, limit, offset],
        (err, rows) => {
          if (err) reject(err);
          else resolve(rows || []);
        }
      );
    });
  }

  // 사용자 리딩 총 개수
  async getUserReadingCount(userId, category) {
    return new Promise((resolve, reject) => {
      let whereClause = 'WHERE userId = ?';
      let params = [userId];

      if (category) {
        whereClause += ' AND questionType = ?';
        params.push(category);
      }

      this.db.get(
        `SELECT COUNT(*) as count FROM ReadingHistory ${whereClause}`,
        params,
        (err, row) => {
          if (err) reject(err);
          else resolve(row.count);
        }
      );
    });
  }

  // 다음 날 ISO 문자열
  getNextDayISO() {
    const tomorrow = new Date();
    tomorrow.setDate(tomorrow.getDate() + 1);
    return tomorrow.toISOString().split('T')[0];
  }

  // 데이터베이스 연결 종료
  close() {
    this.db.close();
  }
}

module.exports = V21APIHandler;