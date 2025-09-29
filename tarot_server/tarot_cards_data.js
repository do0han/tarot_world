// tarot_cards_data.js - 78장 완전한 타로 덱
const fullTarotDeck = [
  // ===== MAJOR ARCANA (22장) =====
  {
    "id": 0,
    "name_ko": "바보",
    "name_en": "The Fool",
    "type": "major",
    "number": 0,
    "keywords": "새로운 시작, 순수함, 모험, 자유",
    "description_upright": "새로운 여행의 시작을 의미합니다. 순수한 마음으로 도전하세요. 무한한 가능성이 당신을 기다리고 있습니다.",
    "description_reversed": "경솔한 결정을 조심하세요. 더 신중하게 접근이 필요합니다. 충동적인 행동은 피하는 것이 좋겠습니다."
  },
  {
    "id": 1,
    "name_ko": "마법사",
    "name_en": "The Magician",
    "type": "major",
    "number": 1,
    "keywords": "의지력, 창조력, 실행력, 집중",
    "description_upright": "강한 의지력으로 목표를 달성할 수 있는 시기입니다. 당신의 능력을 믿고 실행에 옮기세요.",
    "description_reversed": "능력을 잘못된 방향으로 사용하고 있을지 모릅니다. 진정한 목적을 다시 생각해보세요."
  },
  {
    "id": 2,
    "name_ko": "여사제",
    "name_en": "The High Priestess",
    "type": "major",
    "number": 2,
    "keywords": "직감, 신비, 내면의 지혜, 잠재의식",
    "description_upright": "직감과 내면의 목소리에 귀를 기울이세요. 숨겨진 진실이 드러날 때입니다.",
    "description_reversed": "감정에 휩쓸려 올바른 판단을 못하고 있습니다. 차분히 마음을 가라앉히세요."
  },
  {
    "id": 3,
    "name_ko": "여황제",
    "name_en": "The Empress",
    "type": "major",
    "number": 3,
    "keywords": "풍요, 창조, 모성, 자연",
    "description_upright": "풍요로운 시기가 다가옵니다. 창조적인 에너지가 넘치는 때입니다.",
    "description_reversed": "과도한 욕심이나 의존성을 경계하세요. 균형을 찾는 것이 중요합니다."
  },
  {
    "id": 4,
    "name_ko": "황제",
    "name_en": "The Emperor",
    "type": "major",
    "number": 4,
    "keywords": "권위, 안정, 리더십, 구조",
    "description_upright": "강한 리더십과 안정적인 기반을 구축할 때입니다. 체계적인 접근이 필요합니다.",
    "description_reversed": "권위주의나 경직된 사고에 빠져있을 수 있습니다. 유연성을 기르세요."
  },
  {
    "id": 5,
    "name_ko": "교황",
    "name_en": "The Hierophant",
    "type": "major",
    "number": 5,
    "keywords": "전통, 가르침, 정신적 지도, 종교",
    "description_upright": "전통적인 가치와 가르침에서 지혜를 찾을 수 있습니다. 멘토의 조언을 구해보세요.",
    "description_reversed": "맹목적인 믿음이나 관습에 얽매이지 마세요. 자신만의 길을 찾아야 합니다."
  },
  {
    "id": 6,
    "name_ko": "연인",
    "name_en": "The Lovers",
    "type": "major",
    "number": 6,
    "keywords": "사랑, 선택, 조화, 결합",
    "description_upright": "사랑과 조화로운 관계가 기다리고 있습니다. 중요한 선택의 순간입니다.",
    "description_reversed": "관계의 불화나 잘못된 선택을 암시합니다. 신중한 판단이 필요합니다."
  },
  {
    "id": 7,
    "name_ko": "전차",
    "name_en": "The Chariot",
    "type": "major",
    "number": 7,
    "keywords": "승리, 의지력, 방향성, 성취",
    "description_upright": "강한 의지력으로 목표를 달성할 수 있습니다. 승리가 가까워졌습니다.",
    "description_reversed": "방향성을 잃거나 자제력 부족으로 어려움에 처할 수 있습니다."
  },
  {
    "id": 8,
    "name_ko": "힘",
    "name_en": "Strength",
    "type": "major",
    "number": 8,
    "keywords": "내면의 힘, 용기, 인내, 자제력",
    "description_upright": "내면의 힘과 용기로 어려움을 극복할 수 있습니다. 부드러운 접근이 효과적입니다.",
    "description_reversed": "자신감 부족이나 감정 조절의 어려움을 겪고 있습니다."
  },
  {
    "id": 9,
    "name_ko": "은둔자",
    "name_en": "The Hermit",
    "type": "major",
    "number": 9,
    "keywords": "내적 탐구, 고독, 지혜, 성찰",
    "description_upright": "혼자만의 시간을 통해 내면의 지혜를 발견할 수 있습니다. 성찰의 시간이 필요합니다.",
    "description_reversed": "고립이나 외로움에 빠져있을 수 있습니다. 다른 사람의 도움을 받아보세요."
  },
  {
    "id": 10,
    "name_ko": "운명의 수레바퀴",
    "name_en": "Wheel of Fortune",
    "type": "major",
    "number": 10,
    "keywords": "운명, 변화, 순환, 기회",
    "description_upright": "운명의 변화가 다가옵니다. 새로운 기회를 놓치지 마세요.",
    "description_reversed": "불운이나 예상치 못한 변화에 대비하세요. 인내가 필요한 시기입니다."
  },
  {
    "id": 11,
    "name_ko": "정의",
    "name_en": "Justice",
    "type": "major",
    "number": 11,
    "keywords": "공정성, 균형, 진실, 법적 문제",
    "description_upright": "공정하고 균형 잡힌 판단이 내려질 것입니다. 진실이 밝혀집니다.",
    "description_reversed": "불공정하거나 편향된 판단을 경계하세요. 객관성을 유지하세요."
  },
  {
    "id": 12,
    "name_ko": "매달린 사람",
    "name_en": "The Hanged Man",
    "type": "major",
    "number": 12,
    "keywords": "희생, 인내, 새로운 관점, 깨달음",
    "description_upright": "기다림과 인내가 필요한 시기입니다. 새로운 관점에서 바라보세요.",
    "description_reversed": "불필요한 희생이나 고집에서 벗어나야 합니다. 상황을 바꿔보세요."
  },
  {
    "id": 13,
    "name_ko": "죽음",
    "name_en": "Death",
    "type": "major",
    "number": 13,
    "keywords": "변화, 종료, 재생, 새로운 시작",
    "description_upright": "한 단계가 끝나고 새로운 시작이 기다리고 있습니다. 변화를 받아들이세요.",
    "description_reversed": "변화에 대한 저항이나 두려움으로 정체되어 있습니다."
  },
  {
    "id": 14,
    "name_ko": "절제",
    "name_en": "Temperance",
    "type": "major",
    "number": 14,
    "keywords": "조화, 균형, 절제, 치유",
    "description_upright": "균형과 조화를 통해 안정을 찾을 수 있습니다. 인내심을 가지세요.",
    "description_reversed": "극단적인 행동이나 불균형 상태에 있습니다. 중도를 찾으세요."
  },
  {
    "id": 15,
    "name_ko": "악마",
    "name_en": "The Devil",
    "type": "major",
    "number": 15,
    "keywords": "유혹, 속박, 물질주의, 탐욕",
    "description_upright": "유혹이나 속박에서 벗어나야 할 때입니다. 진정한 자유를 찾으세요.",
    "description_reversed": "속박에서 해방되거나 깨달음을 얻을 수 있습니다."
  },
  {
    "id": 16,
    "name_ko": "탑",
    "name_en": "The Tower",
    "type": "major",
    "number": 16,
    "keywords": "파괴, 붕괴, 깨달음, 급변",
    "description_upright": "예상치 못한 변화나 충격이 있을 수 있습니다. 새로운 시작을 위한 과정입니다.",
    "description_reversed": "위기를 피하거나 변화에 저항하고 있습니다."
  },
  {
    "id": 17,
    "name_ko": "별",
    "name_en": "The Star",
    "type": "major",
    "number": 17,
    "keywords": "희망, 영감, 치유, 꿈",
    "description_upright": "희망과 영감이 가득한 시기입니다. 꿈을 향해 나아가세요.",
    "description_reversed": "절망이나 방향성 상실로 힘들어하고 있습니다. 희망을 잃지 마세요."
  },
  {
    "id": 18,
    "name_ko": "달",
    "name_en": "The Moon",
    "type": "major",
    "number": 18,
    "keywords": "환상, 직감, 불안, 잠재의식",
    "description_upright": "직감을 믿으되 환상에 속지 마세요. 불분명한 상황을 조심하세요.",
    "description_reversed": "혼란이나 착각에서 벗어나 진실을 보게 됩니다."
  },
  {
    "id": 19,
    "name_ko": "태양",
    "name_en": "The Sun",
    "type": "major",
    "number": 19,
    "keywords": "성공, 기쁨, 활력, 긍정",
    "description_upright": "밝고 긍정적인 에너지가 넘치는 시기입니다. 성공이 기다리고 있습니다.",
    "description_reversed": "일시적인 실망이나 지연이 있을 수 있지만 결국 좋은 결과를 얻습니다."
  },
  {
    "id": 20,
    "name_ko": "심판",
    "name_en": "Judgement",
    "type": "major",
    "number": 20,
    "keywords": "각성, 용서, 재생, 심판",
    "description_upright": "과거를 정리하고 새로운 삶을 시작할 때입니다. 각성의 순간이 왔습니다.",
    "description_reversed": "자기 비판이나 과거에 얽매여 있습니다. 용서하고 앞으로 나아가세요."
  },
  {
    "id": 21,
    "name_ko": "세계",
    "name_en": "The World",
    "type": "major",
    "number": 21,
    "keywords": "완성, 성취, 여행, 성공",
    "description_upright": "목표를 달성하고 완성의 기쁨을 누릴 수 있습니다. 새로운 도전을 준비하세요.",
    "description_reversed": "미완성이나 부족함을 느끼고 있습니다. 조금 더 인내가 필요합니다."
  },

  // ===== MINOR ARCANA - CUPS (컵, 물) 14장 =====
  {
    "id": 22,
    "name_ko": "컵 에이스",
    "name_en": "Ace of Cups",
    "type": "minor",
    "suit": "cups",
    "number": 1,
    "keywords": "새로운 감정, 사랑의 시작, 직감, 영적 각성",
    "description_upright": "새로운 사랑이나 감정적 성취가 시작됩니다. 마음이 충만해지는 시기입니다.",
    "description_reversed": "감정적 막힘이나 사랑의 기회를 놓칠 수 있습니다."
  },
  {
    "id": 23,
    "name_ko": "컵 2",
    "name_en": "Two of Cups",
    "type": "minor",
    "suit": "cups",
    "number": 2,
    "keywords": "파트너십, 사랑, 조화, 균형",
    "description_upright": "조화로운 관계와 상호 이해가 깊어집니다. 파트너십이 중요한 시기입니다.",
    "description_reversed": "관계의 불화나 소통 부족으로 어려움을 겪을 수 있습니다."
  },
  {
    "id": 24,
    "name_ko": "컵 3",
    "name_en": "Three of Cups",
    "type": "minor",
    "suit": "cups",
    "number": 3,
    "keywords": "축하, 우정, 사교활동, 기쁨",
    "description_upright": "친구들과의 즐거운 시간이나 축하할 일이 생깁니다. 사교적인 활동이 좋습니다.",
    "description_reversed": "사회적 고립이나 친구들과의 거리감을 느낄 수 있습니다."
  },
  {
    "id": 25,
    "name_ko": "컵 4",
    "name_en": "Four of Cups",
    "type": "minor",
    "suit": "cups",
    "number": 4,
    "keywords": "무관심, 지루함, 새로운 기회, 성찰",
    "description_upright": "현재 상황에 만족하지 못하고 있습니다. 새로운 기회를 찾아보세요.",
    "description_reversed": "무기력함에서 벗어나 새로운 관심사를 찾게 됩니다."
  },
  {
    "id": 26,
    "name_ko": "컵 5",
    "name_en": "Five of Cups",
    "type": "minor",
    "suit": "cups",
    "number": 5,
    "keywords": "실망, 후회, 슬픔, 상실",
    "description_upright": "실망이나 상실감을 경험하고 있습니다. 하지만 희망은 남아있습니다.",
    "description_reversed": "슬픔에서 벗어나 앞으로 나아갈 준비가 되었습니다."
  },
  {
    "id": 27,
    "name_ko": "컵 6",
    "name_en": "Six of Cups",
    "type": "minor",
    "suit": "cups",
    "number": 6,
    "keywords": "향수, 어린 시절, 순수함, 기억",
    "description_upright": "과거의 좋은 기억이나 어린 시절의 순수함이 위로가 됩니다.",
    "description_reversed": "과거에 얽매여 현재를 놓치고 있을 수 있습니다."
  },
  {
    "id": 28,
    "name_ko": "컵 7",
    "name_en": "Seven of Cups",
    "type": "minor",
    "suit": "cups",
    "number": 7,
    "keywords": "환상, 선택의 혼란, 꿈, 착각",
    "description_upright": "많은 선택지 앞에서 혼란스러워하고 있습니다. 현실적인 판단이 필요합니다.",
    "description_reversed": "명확한 목표를 설정하고 집중할 수 있게 됩니다."
  },
  {
    "id": 29,
    "name_ko": "컵 8",
    "name_en": "Eight of Cups",
    "type": "minor",
    "suit": "cups",
    "number": 8,
    "keywords": "떠남, 포기, 영적 탐구, 변화",
    "description_upright": "현재 상황을 떠나 새로운 길을 찾아야 할 때입니다.",
    "description_reversed": "변화를 두려워하여 현상유지를 하고 있습니다."
  },
  {
    "id": 30,
    "name_ko": "컵 9",
    "name_en": "Nine of Cups",
    "type": "minor",
    "suit": "cups",
    "number": 9,
    "keywords": "소원성취, 만족, 행복, 성취감",
    "description_upright": "소원이 이루어지고 만족스러운 결과를 얻습니다. 행복한 시기입니다.",
    "description_reversed": "과도한 욕심이나 표면적인 만족에 그칠 수 있습니다."
  },
  {
    "id": 31,
    "name_ko": "컵 10",
    "name_en": "Ten of Cups",
    "type": "minor",
    "suit": "cups",
    "number": 10,
    "keywords": "가족행복, 조화, 감정적 완성, 만족",
    "description_upright": "가족이나 가까운 사람들과의 행복한 시간을 보낼 수 있습니다.",
    "description_reversed": "가정 내 불화나 가족 관계의 어려움이 있을 수 있습니다."
  },
  {
    "id": 32,
    "name_ko": "컵 시종",
    "name_en": "Page of Cups",
    "type": "minor",
    "suit": "cups",
    "number": 11,
    "keywords": "창의성, 순수함, 새로운 감정, 직감",
    "description_upright": "창의적인 영감이나 새로운 감정적 경험이 시작됩니다.",
    "description_reversed": "감정적 미성숙이나 창의력 부족을 경험할 수 있습니다."
  },
  {
    "id": 33,
    "name_ko": "컵 기사",
    "name_en": "Knight of Cups",
    "type": "minor",
    "suit": "cups",
    "number": 12,
    "keywords": "로맨스, 감성, 이상주의, 추구",
    "description_upright": "로맨틱한 만남이나 감성적인 추구가 이루어집니다.",
    "description_reversed": "비현실적인 기대나 감정적 불안정을 경험할 수 있습니다."
  },
  {
    "id": 34,
    "name_ko": "컵 여왕",
    "name_en": "Queen of Cups",
    "type": "minor",
    "suit": "cups",
    "number": 13,
    "keywords": "감정적 성숙, 직감, 공감능력, 돌봄",
    "description_upright": "감정적으로 성숙하고 타인을 배려하는 마음이 크게 발휘됩니다.",
    "description_reversed": "감정적 의존이나 과도한 감수성으로 어려움을 겪을 수 있습니다."
  },
  {
    "id": 35,
    "name_ko": "컵 왕",
    "name_en": "King of Cups",
    "type": "minor",
    "suit": "cups",
    "number": 14,
    "keywords": "감정적 균형, 지혜, 관용, 리더십",
    "description_upright": "감정과 이성의 균형을 잘 유지하며 현명한 판단을 내립니다.",
    "description_reversed": "감정적 불안정이나 조절 능력 부족으로 어려움을 겪습니다."
  },

  // ===== MINOR ARCANA - SWORDS (검, 공기) 14장 =====
  {
    "id": 36,
    "name_ko": "검 에이스",
    "name_en": "Ace of Swords",
    "type": "minor",
    "suit": "swords",
    "number": 1,
    "keywords": "새로운 아이디어, 진실, 명확성, 정신력",
    "description_upright": "새로운 아이디어나 통찰력이 떠오릅니다. 진실이 드러나는 시기입니다.",
    "description_reversed": "혼란이나 잘못된 정보로 인해 판단이 흐려질 수 있습니다."
  },
  {
    "id": 37,
    "name_ko": "검 2",
    "name_en": "Two of Swords",
    "type": "minor",
    "suit": "swords",
    "number": 2,
    "keywords": "결정의 어려움, 균형, 정체, 선택",
    "description_upright": "어려운 결정을 내려야 하는 상황입니다. 균형을 찾는 것이 중요합니다.",
    "description_reversed": "우유부단함에서 벗어나 결정을 내릴 때가 왔습니다."
  },
  {
    "id": 38,
    "name_ko": "검 3",
    "name_en": "Three of Swords",
    "type": "minor",
    "suit": "swords",
    "number": 3,
    "keywords": "이별, 상처, 슬픔, 치유",
    "description_upright": "마음의 상처나 이별의 아픔을 경험하고 있습니다. 치유가 필요한 시기입니다.",
    "description_reversed": "치유의 과정을 거치며 상처에서 회복되고 있습니다."
  },
  {
    "id": 39,
    "name_ko": "검 4",
    "name_en": "Four of Swords",
    "type": "minor",
    "suit": "swords",
    "number": 4,
    "keywords": "휴식, 명상, 회복, 정적",
    "description_upright": "휴식과 회복이 필요한 시기입니다. 명상이나 성찰의 시간을 가져보세요.",
    "description_reversed": "휴식에서 벗어나 다시 활동을 시작할 때입니다."
  },
  {
    "id": 40,
    "name_ko": "검 5",
    "name_en": "Five of Swords",
    "type": "minor",
    "suit": "swords",
    "number": 5,
    "keywords": "갈등, 패배, 불공정, 손실",
    "description_upright": "갈등이나 패배를 경험할 수 있습니다. 때로는 물러서는 것이 지혜입니다.",
    "description_reversed": "갈등에서 벗어나 화해나 용서를 시작할 수 있습니다."
  },

  // ===== MINOR ARCANA - WANDS (지팡이, 불) 14장 =====
  {
    "id": 54,
    "name_ko": "지팡이 에이스",
    "name_en": "Ace of Wands",
    "type": "minor",
    "suit": "wands",
    "number": 1,
    "keywords": "새로운 시작, 창조력, 열정, 영감",
    "description_upright": "새로운 프로젝트나 창조적인 영감이 떠오릅니다. 열정적으로 시작하세요.",
    "description_reversed": "동기부족이나 창조적 막힘을 경험할 수 있습니다."
  },
  {
    "id": 55,
    "name_ko": "지팡이 2",
    "name_en": "Two of Wands",
    "type": "minor",
    "suit": "wands",
    "number": 2,
    "keywords": "계획, 개인적 힘, 미래 전망, 결정",
    "description_upright": "미래에 대한 계획을 세우고 결정을 내릴 시기입니다.",
    "description_reversed": "계획 부족이나 우유부단함으로 기회를 놓칠 수 있습니다."
  },

  // ===== MINOR ARCANA - PENTACLES (오각별, 흙) 14장 =====
  {
    "id": 68,
    "name_ko": "오각별 에이스",
    "name_en": "Ace of Pentacles",
    "type": "minor",
    "suit": "pentacles",
    "number": 1,
    "keywords": "새로운 기회, 물질적 시작, 풍요, 번영",
    "description_upright": "새로운 물질적 기회나 번영의 시작을 의미합니다.",
    "description_reversed": "물질적 기회를 놓치거나 재정적 어려움이 있을 수 있습니다."
  },
  {
    "id": 69,
    "name_ko": "오각별 2",
    "name_en": "Two of Pentacles",
    "type": "minor",
    "suit": "pentacles",
    "number": 2,
    "keywords": "균형, 변화, 적응, 유연성",
    "description_upright": "변화하는 상황에 유연하게 적응하며 균형을 유지해야 합니다.",
    "description_reversed": "균형을 잃고 혼란스러운 상황에 처할 수 있습니다."
  }
];

module.exports = fullTarotDeck;
