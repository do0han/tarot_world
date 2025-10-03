// expanded_menus.js - V2.0 세분화된 질문 메뉴 데이터
const sqlite3 = require('sqlite3').verbose();
const path = require('path');

const DB_PATH = path.join(__dirname, 'tarot_constellation.db');

// 세분화된 메뉴 데이터 (25개)
const expandedMenus = [
  // === 무료 콘텐츠 (5개) ===
  {
    title: "오늘의 운세",
    category: "tarot_reading",
    uiType: "single_card",
    keyword: "daily",
    description: "하루의 전체적인 운세를 한 장의 카드로 알아보세요",
    isFree: true,
    requiredCoins: 0,
    spreadType: "single_card",
    position: 1
  },
  {
    title: "오늘의 한 마디",
    category: "tarot_reading", 
    uiType: "single_card",
    keyword: "advice",
    description: "오늘 당신에게 필요한 조언을 받아보세요",
    isFree: true,
    requiredCoins: 0,
    spreadType: "single_card",
    position: 2
  },
  {
    title: "내 마음 상태",
    category: "tarot_reading",
    uiType: "single_card", 
    keyword: "mind",
    description: "현재 나의 내면 상태를 파악해보세요",
    isFree: true,
    requiredCoins: 0,
    spreadType: "single_card",
    position: 3
  },
  {
    title: "주간 운세",
    category: "tarot_reading",
    uiType: "three_card_spread",
    keyword: "weekly",
    description: "이번 주의 운세를 과거-현재-미래로 알아보세요",
    isFree: true,
    requiredCoins: 0,
    spreadType: "three_card_spread",
    position: 4
  },
  {
    title: "운세 체험하기",
    category: "tarot_reading",
    uiType: "single_card",
    keyword: "trial",
    description: "타로 카드의 신비로운 세계를 체험해보세요",
    isFree: true,
    requiredCoins: 0,
    spreadType: "single_card", 
    position: 5
  },

  // === 유료 콘텐츠 - 사랑/연애 (8개) ===
  {
    title: "헤어진 그 사람과 재회 가능성",
    category: "tarot_reading",
    uiType: "celtic_cross",
    keyword: "reunion",
    description: "과거 연인과의 재회 가능성과 미래를 알아보세요",
    isFree: false,
    requiredCoins: 12,
    spreadType: "celtic_cross",
    position: 6
  },
  {
    title: "이 사람, 내 운명일까?",
    category: "tarot_reading",
    uiType: "five_card_spread",
    keyword: "soulmate",
    description: "마음에 두고 있는 그 사람이 나의 운명인지 알아보세요",
    isFree: false,
    requiredCoins: 10,
    spreadType: "five_card_spread",
    position: 7
  },
  {
    title: "상대방의 마음 속 나의 모습",
    category: "tarot_reading",
    uiType: "three_card_spread",
    keyword: "feelings",
    description: "좋아하는 사람이 나를 어떻게 생각하는지 알아보세요",
    isFree: false,
    requiredCoins: 8,
    spreadType: "three_card_spread",
    position: 8
  },
  {
    title: "썸 탈 확률은 얼마나?",
    category: "tarot_reading",
    uiType: "three_card_spread",
    keyword: "dating",
    description: "관심 있는 사람과 연인으로 발전할 가능성을 알아보세요",
    isFree: false,
    requiredCoins: 7,
    spreadType: "three_card_spread",
    position: 9
  },
  {
    title: "우리 관계의 미래",
    category: "tarot_reading",
    uiType: "five_card_spread",
    keyword: "relationship_future",
    description: "현재 연인과의 관계가 어떻게 발전할지 알아보세요",
    isFree: false,
    requiredCoins: 9,
    spreadType: "five_card_spread",
    position: 10
  },
  {
    title: "첫사랑이 나를 그리워할까?",
    category: "tarot_reading",
    uiType: "three_card_spread",
    keyword: "first_love",
    description: "첫사랑의 현재 마음과 나에 대한 생각을 알아보세요",
    isFree: false,
    requiredCoins: 8,
    spreadType: "three_card_spread",
    position: 11
  },
  {
    title: "짝사랑을 이룰 방법",
    category: "tarot_reading",
    uiType: "five_card_spread",
    keyword: "unrequited_love",
    description: "짝사랑을 성공시키기 위한 방법과 조언을 받아보세요",
    isFree: false,
    requiredCoins: 10,
    spreadType: "five_card_spread",
    position: 12
  },
  {
    title: "올해 나의 연애운",
    category: "tarot_reading",
    uiType: "celtic_cross",
    keyword: "yearly_love",
    description: "올해 나의 전체적인 연애운과 만날 사람의 특징을 알아보세요",
    isFree: false,
    requiredCoins: 15,
    spreadType: "celtic_cross",
    position: 13
  },

  // === 유료 콘텐츠 - 재물/사업 (4개) ===
  {
    title: "투자 성공 가능성",
    category: "tarot_reading",
    uiType: "five_card_spread",
    keyword: "investment",
    description: "계획 중인 투자의 성공 가능성과 주의사항을 알아보세요",
    isFree: false,
    requiredCoins: 12,
    spreadType: "five_card_spread",
    position: 14
  },
  {
    title: "이직/창업 성공 운세",
    category: "tarot_reading",
    uiType: "celtic_cross",
    keyword: "career_change",
    description: "이직이나 창업의 성공 가능성과 최적 시기를 알아보세요",
    isFree: false,
    requiredCoins: 15,
    spreadType: "celtic_cross",
    position: 15
  },
  {
    title: "금전적 어려움 해결책",
    category: "tarot_reading",
    uiType: "five_card_spread",
    keyword: "financial_solution",
    description: "현재 금전적 어려움을 극복할 방법을 찾아보세요",
    isFree: false,
    requiredCoins: 10,
    spreadType: "five_card_spread",
    position: 16
  },
  {
    title: "올해 나의 재물운",
    category: "tarot_reading",
    uiType: "celtic_cross",
    keyword: "yearly_wealth",
    description: "올해 전체적인 재물운과 돈이 들어올 시기를 알아보세요",
    isFree: false,
    requiredCoins: 13,
    spreadType: "celtic_cross",
    position: 17
  },

  // === 유료 콘텐츠 - 진로/학업 (4개) ===
  {
    title: "시험 합격 가능성",
    category: "tarot_reading",
    uiType: "three_card_spread",
    keyword: "exam",
    description: "준비 중인 시험의 합격 가능성과 공부 방향을 알아보세요",
    isFree: false,
    requiredCoins: 8,
    spreadType: "three_card_spread",
    position: 18
  },
  {
    title: "나에게 맞는 진로",
    category: "tarot_reading",
    uiType: "celtic_cross",
    keyword: "career_path",
    description: "나의 재능과 적성에 맞는 진로를 찾아보세요",
    isFree: false,
    requiredCoins: 15,
    spreadType: "celtic_cross",
    position: 19
  },
  {
    title: "직장에서의 인간관계",
    category: "tarot_reading",
    uiType: "five_card_spread",
    keyword: "workplace",
    description: "직장 내 인간관계의 개선 방법과 주의점을 알아보세요",
    isFree: false,
    requiredCoins: 9,
    spreadType: "five_card_spread",
    position: 20
  },
  {
    title: "승진 가능성과 시기",
    category: "tarot_reading",
    uiType: "five_card_spread",
    keyword: "promotion",
    description: "승진 가능성과 최적의 시기, 필요한 노력을 알아보세요",
    isFree: false,
    requiredCoins: 11,
    spreadType: "five_card_spread",
    position: 21
  },

  // === 유료 콘텐츠 - 건강/가족 (4개) ===
  {
    title: "건강 상태와 주의사항",
    category: "tarot_reading",
    uiType: "three_card_spread",
    keyword: "health",
    description: "현재 건강 상태와 앞으로 주의해야 할 점을 알아보세요",
    isFree: false,
    requiredCoins: 8,
    spreadType: "three_card_spread",
    position: 22
  },
  {
    title: "가족과의 화해 방법",
    category: "tarot_reading",
    uiType: "five_card_spread",
    keyword: "family_reconciliation",
    description: "갈등 중인 가족과 화해할 수 있는 방법을 찾아보세요",
    isFree: false,
    requiredCoins: 10,
    spreadType: "five_card_spread",
    position: 23
  },
  {
    title: "부모님과의 관계 개선",
    category: "tarot_reading",
    uiType: "three_card_spread",
    keyword: "parent_relationship",
    description: "부모님과의 관계를 더 좋게 만드는 방법을 알아보세요",
    isFree: false,
    requiredCoins: 7,
    spreadType: "three_card_spread",
    position: 24
  },
  {
    title: "올해 나의 전체 운세",
    category: "tarot_reading",
    uiType: "yearly_spread",
    keyword: "yearly_fortune",
    description: "올해 전체적인 운세를 월별로 상세히 알아보세요",
    isFree: false,
    requiredCoins: 20,
    spreadType: "yearly_spread",
    position: 25
  }
];

class MenuUpdater {
  constructor() {
    this.db = new sqlite3.Database(DB_PATH);
  }

  // 기존 메뉴 데이터 백업 및 새 데이터로 교체
  async updateMenus() {
    try {
      console.log('🔄 기존 메뉴 데이터를 세분화된 질문으로 업데이트 중...');

      // 1. 기존 메뉴 데이터 백업 (선택사항)
      await this.backupExistingMenus();

      // 2. 기존 메뉴 삭제
      await this.clearExistingMenus();

      // 3. 새로운 확장된 메뉴 삽입
      await this.insertExpandedMenus();

      // 4. 메뉴 업데이트 확인
      await this.verifyMenuUpdate();

      console.log('✅ 메뉴 데이터 업데이트 완료!');

    } catch (error) {
      console.error('❌ 메뉴 업데이트 실패:', error);
      throw error;
    }
  }

  // 기존 메뉴 백업
  async backupExistingMenus() {
    return new Promise((resolve, reject) => {
      const sql = `
        CREATE TABLE IF NOT EXISTS AppMenu_backup AS 
        SELECT * FROM AppMenu WHERE 1=0
      `;
      this.db.run(sql, (err) => {
        if (err) {
          reject(err);
        } else {
          // 기존 데이터 복사
          this.db.run(
            "INSERT INTO AppMenu_backup SELECT * FROM AppMenu",
            (err) => {
              if (err) reject(err);
              else {
                console.log('📦 기존 메뉴 데이터 백업 완료');
                resolve();
              }
            }
          );
        }
      });
    });
  }

  // 기존 메뉴 삭제
  async clearExistingMenus() {
    return new Promise((resolve, reject) => {
      this.db.run("DELETE FROM AppMenu", (err) => {
        if (err) {
          reject(err);
        } else {
          console.log('🗑️ 기존 메뉴 데이터 삭제 완료');
          resolve();
        }
      });
    });
  }

  // 새로운 확장된 메뉴 삽입
  async insertExpandedMenus() {
    const sql = `
      INSERT INTO AppMenu (
        appId, title, category, uiType, keyword, description, 
        isFree, requiredCoins, spreadType, position
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    `;

    for (const menu of expandedMenus) {
      await new Promise((resolve, reject) => {
        this.db.run(sql, [
          1, // appId: 1 (Tarot Constellation)
          menu.title,
          menu.category,
          menu.uiType,
          menu.keyword,
          menu.description,
          menu.isFree,
          menu.requiredCoins,
          menu.spreadType,
          menu.position
        ], function(err) {
          if (err) {
            reject(err);
          } else {
            console.log(`✅ 메뉴 추가: ${menu.title} (${menu.isFree ? '무료' : menu.requiredCoins + '코인'})`);
            resolve();
          }
        });
      });
    }
  }

  // 메뉴 업데이트 확인
  async verifyMenuUpdate() {
    return new Promise((resolve, reject) => {
      this.db.all("SELECT COUNT(*) as total, SUM(CASE WHEN isFree = 1 THEN 1 ELSE 0 END) as free, SUM(CASE WHEN isFree = 0 THEN 1 ELSE 0 END) as paid FROM AppMenu", (err, rows) => {
        if (err) {
          reject(err);
        } else {
          const stats = rows[0];
          console.log('\n📊 메뉴 업데이트 결과:');
          console.log(`- 총 메뉴 개수: ${stats.total}개`);
          console.log(`- 무료 메뉴: ${stats.free}개`);
          console.log(`- 유료 메뉴: ${stats.paid}개`);
          
          // 카테고리별 통계
          this.db.all("SELECT keyword, COUNT(*) as count FROM AppMenu GROUP BY keyword ORDER BY count DESC", (err, categoryStats) => {
            if (!err) {
              console.log('\n📋 키워드별 분포:');
              categoryStats.forEach(stat => {
                console.log(`- ${stat.keyword}: ${stat.count}개`);
              });
            }
            resolve();
          });
        }
      });
    });
  }

  // 무료 vs 유료 메뉴 조회 테스트
  async testMenuQueries() {
    console.log('\n🧪 메뉴 조회 테스트...');

    // 무료 메뉴 조회
    const freeMenus = await new Promise((resolve, reject) => {
      this.db.all("SELECT title, requiredCoins FROM AppMenu WHERE isFree = 1 ORDER BY position", (err, rows) => {
        if (err) reject(err);
        else resolve(rows);
      });
    });

    console.log('\n🆓 무료 메뉴:');
    freeMenus.forEach((menu, index) => {
      console.log(`${index + 1}. ${menu.title}`);
    });

    // 유료 메뉴 조회 (코인 순)
    const paidMenus = await new Promise((resolve, reject) => {
      this.db.all("SELECT title, requiredCoins FROM AppMenu WHERE isFree = 0 ORDER BY requiredCoins", (err, rows) => {
        if (err) reject(err);
        else resolve(rows);
      });
    });

    console.log('\n💰 유료 메뉴 (코인별):');
    paidMenus.forEach((menu, index) => {
      console.log(`${index + 1}. ${menu.title} (${menu.requiredCoins}코인)`);
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

// 직접 실행시 메뉴 업데이트 수행
if (require.main === module) {
  const updater = new MenuUpdater();
  
  updater.updateMenus()
    .then(() => updater.testMenuQueries())
    .finally(() => updater.close());
}

module.exports = { expandedMenus, MenuUpdater };