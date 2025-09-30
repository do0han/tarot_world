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

  // ===== MINOR ARCANA - SWORDS (검, 공기) 나머지 카드들 =====
  {
    "id": 41,
    "name_ko": "검 6",
    "name_en": "Six of Swords",
    "type": "minor",
    "suit": "swords",
    "number": 6,
    "keywords": "여행, 전환, 평화, 회복",
    "description_upright": "어려운 시기를 벗어나 평화로운 곳으로 이동하는 시기입니다.",
    "description_reversed": "과거에 얽매여 앞으로 나아가지 못하고 있습니다."
  },
  {
    "id": 42,
    "name_ko": "검 7",
    "name_en": "Seven of Swords",
    "type": "minor",
    "suit": "swords",
    "number": 7,
    "keywords": "기만, 도피, 전략, 독립",
    "description_upright": "신중한 전략이나 독립적인 행동이 필요합니다.",
    "description_reversed": "기만이나 도피 대신 정직한 대면이 필요합니다."
  },
  {
    "id": 43,
    "name_ko": "검 8",
    "name_en": "Eight of Swords",
    "type": "minor",
    "suit": "swords",
    "number": 8,
    "keywords": "속박, 제한, 자기 의심, 혼란",
    "description_upright": "스스로 만든 제약에 갇혀 있습니다. 해방이 필요합니다.",
    "description_reversed": "제약에서 벗어나 자유를 되찾을 수 있습니다."
  },
  {
    "id": 44,
    "name_ko": "검 9",
    "name_en": "Nine of Swords",
    "type": "minor",
    "suit": "swords",
    "number": 9,
    "keywords": "불안, 악몽, 걱정, 절망",
    "description_upright": "깊은 불안과 걱정에 시달리고 있습니다. 도움을 구하세요.",
    "description_reversed": "불안에서 벗어나 희망을 되찾을 수 있습니다."
  },
  {
    "id": 45,
    "name_ko": "검 10",
    "name_en": "Ten of Swords",
    "type": "minor",
    "suit": "swords",
    "number": 10,
    "keywords": "종료, 배신, 고통, 재시작",
    "description_upright": "고통스러운 끝이지만 새로운 시작의 기회입니다.",
    "description_reversed": "최악의 상황에서 벗어나 회복이 시작됩니다."
  },
  {
    "id": 46,
    "name_ko": "검 페이지",
    "name_en": "Page of Swords",
    "type": "minor",
    "suit": "swords",
    "number": 11,
    "keywords": "호기심, 감시, 새로운 아이디어, 소식",
    "description_upright": "새로운 아이디어나 정보가 들어올 것입니다.",
    "description_reversed": "정보가 불완전하거나 소문에 주의해야 합니다."
  },
  {
    "id": 47,
    "name_ko": "검 나이트",
    "name_en": "Knight of Swords",
    "type": "minor",
    "suit": "swords",
    "number": 12,
    "keywords": "행동, 충동, 용기, 성급함",
    "description_upright": "빠른 행동과 결단력이 필요한 시기입니다.",
    "description_reversed": "성급한 행동이나 무모함을 조심해야 합니다."
  },
  {
    "id": 48,
    "name_ko": "검 퀸",
    "name_en": "Queen of Swords",
    "type": "minor",
    "suit": "swords",
    "number": 13,
    "keywords": "명확성, 독립, 지성, 직설적",
    "description_upright": "명확하고 직설적인 의사소통이 필요합니다.",
    "description_reversed": "냉정함이 지나쳐 상처를 줄 수 있습니다."
  },
  {
    "id": 49,
    "name_ko": "검 킹",
    "name_en": "King of Swords",
    "type": "minor",
    "suit": "swords",
    "number": 14,
    "keywords": "권위, 지성, 공정함, 결단력",
    "description_upright": "공정하고 논리적인 판단력으로 결정을 내리세요.",
    "description_reversed": "독단적이거나 냉혹한 결정을 경계해야 합니다."
  },

  // ===== MINOR ARCANA - CUPS (컵, 물) 나머지 카드들 =====
  {
    "id": 50,
    "name_ko": "컵 페이지",
    "name_en": "Page of Cups",
    "type": "minor",
    "suit": "cups",
    "number": 11,
    "keywords": "직감, 창의성, 감정적 메시지, 예술",
    "description_upright": "창의적 영감이나 감정적 메시지가 전해질 것입니다.",
    "description_reversed": "감정적 미숙함이나 창의적 막힘이 있을 수 있습니다."
  },
  {
    "id": 51,
    "name_ko": "컵 나이트",
    "name_en": "Knight of Cups",
    "type": "minor",
    "suit": "cups",
    "number": 12,
    "keywords": "로맨스, 매력, 감정, 이상주의",
    "description_upright": "로맨틱하고 감정적인 접근이 필요한 시기입니다.",
    "description_reversed": "감정에 치우쳐 현실을 보지 못할 수 있습니다."
  },
  {
    "id": 52,
    "name_ko": "컵 퀸",
    "name_en": "Queen of Cups",
    "type": "minor",
    "suit": "cups",
    "number": 13,
    "keywords": "직감, 연민, 감정적 지원, 영성",
    "description_upright": "직감과 연민으로 다른 사람을 도울 수 있습니다.",
    "description_reversed": "감정적으로 불안정하거나 의존적이 될 수 있습니다."
  },
  {
    "id": 53,
    "name_ko": "컵 킹",
    "name_en": "King of Cups",
    "type": "minor",
    "suit": "cups",
    "number": 14,
    "keywords": "감정 조절, 연민, 지혜, 균형",
    "description_upright": "감정과 이성의 균형을 이루며 지혜롭게 행동하세요.",
    "description_reversed": "감정 조절이 어렵거나 변덕스러울 수 있습니다."
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
  {
    "id": 56,
    "name_ko": "지팡이 3",
    "name_en": "Three of Wands",
    "type": "minor",
    "suit": "wands",
    "number": 3,
    "keywords": "확장, 미래 계획, 탐험, 기회",
    "description_upright": "사업이나 계획이 확장되고 있습니다. 새로운 기회를 탐색하세요.",
    "description_reversed": "확장이 지연되거나 계획에 차질이 생길 수 있습니다."
  },
  {
    "id": 57,
    "name_ko": "지팡이 4",
    "name_en": "Four of Wands",
    "type": "minor",
    "suit": "wands",
    "number": 4,
    "keywords": "축하, 안정, 성취, 화합",
    "description_upright": "목표를 달성하고 축하할 일이 생깁니다. 안정적인 기반이 마련됩니다.",
    "description_reversed": "불안정하거나 축하가 연기될 수 있습니다."
  },
  {
    "id": 58,
    "name_ko": "지팡이 5",
    "name_en": "Five of Wands",
    "type": "minor",
    "suit": "wands",
    "number": 5,
    "keywords": "경쟁, 갈등, 투쟁, 도전",
    "description_upright": "경쟁이나 갈등 상황에 처해있습니다. 건설적인 해결책을 찾으세요.",
    "description_reversed": "갈등이 해결되거나 경쟁에서 벗어날 수 있습니다."
  },
  {
    "id": 59,
    "name_ko": "지팡이 6",
    "name_en": "Six of Wands",
    "type": "minor",
    "suit": "wands",
    "number": 6,
    "keywords": "승리, 성공, 인정, 자신감",
    "description_upright": "성공과 승리를 거두며 인정받는 시기입니다. 자신감을 가지세요.",
    "description_reversed": "성공이 지연되거나 인정받지 못할 수 있습니다."
  },
  {
    "id": 60,
    "name_ko": "지팡이 7",
    "name_en": "Seven of Wands",
    "type": "minor",
    "suit": "wands",
    "number": 7,
    "keywords": "방어, 도전, 경쟁, 용기",
    "description_upright": "도전을 받고 있지만 용기를 내어 맞서야 합니다. 당신의 입장을 지키세요.",
    "description_reversed": "압박에 굴복하거나 포기하고 싶은 마음이 들 수 있습니다."
  },
  {
    "id": 61,
    "name_ko": "지팡이 8",
    "name_en": "Eight of Wands",
    "type": "minor",
    "suit": "wands",
    "number": 8,
    "keywords": "속도, 빠른 변화, 진전, 소식",
    "description_upright": "상황이 빠르게 진전되고 있습니다. 좋은 소식이 들려올 것입니다.",
    "description_reversed": "지연이나 좌절, 계획의 차질이 있을 수 있습니다."
  },
  {
    "id": 62,
    "name_ko": "지팡이 9",
    "name_en": "Nine of Wands",
    "type": "minor",
    "suit": "wands",
    "number": 9,
    "keywords": "인내, 방어, 경계, 지구력",
    "description_upright": "거의 목표에 도달했습니다. 마지막까지 인내하며 경계를 늦추지 마세요.",
    "description_reversed": "지쳐서 포기하고 싶거나 마지막 순간에 실수할 수 있습니다."
  },
  {
    "id": 63,
    "name_ko": "지팡이 10",
    "name_en": "Ten of Wands",
    "type": "minor",
    "suit": "wands",
    "number": 10,
    "keywords": "부담, 책임, 과로, 완성",
    "description_upright": "많은 책임과 부담을 지고 있습니다. 완성이 가까워졌으니 조금만 더 견디세요.",
    "description_reversed": "부담을 덜거나 책임을 나누어 가질 필요가 있습니다."
  },
  {
    "id": 64,
    "name_ko": "지팡이 페이지",
    "name_en": "Page of Wands",
    "type": "minor",
    "suit": "wands",
    "number": 11,
    "keywords": "새로운 소식, 창의성, 모험, 학습",
    "description_upright": "새로운 프로젝트나 모험적인 아이디어가 떠오릅니다.",
    "description_reversed": "불안정하거나 계획이 미숙할 수 있습니다."
  },
  {
    "id": 65,
    "name_ko": "지팡이 나이트",
    "name_en": "Knight of Wands",
    "type": "minor",
    "suit": "wands",
    "number": 12,
    "keywords": "행동, 충동, 모험, 급진적",
    "description_upright": "행동력이 넘치고 모험적인 시기입니다. 과감하게 도전하세요.",
    "description_reversed": "성급하거나 무모한 행동을 조심해야 합니다."
  },
  {
    "id": 66,
    "name_ko": "지팡이 퀸",
    "name_en": "Queen of Wands",
    "type": "minor",
    "suit": "wands",
    "number": 13,
    "keywords": "자신감, 독립, 매력, 리더십",
    "description_upright": "자신감과 카리스마로 주변을 이끌어 가는 시기입니다.",
    "description_reversed": "독선적이거나 질투심이 강해질 수 있습니다."
  },
  {
    "id": 67,
    "name_ko": "지팡이 킹",
    "name_en": "King of Wands",
    "type": "minor",
    "suit": "wands",
    "number": 14,
    "keywords": "리더십, 비전, 기업가 정신, 성취",
    "description_upright": "강력한 리더십으로 큰 성취를 이룰 수 있습니다.",
    "description_reversed": "권위적이거나 성급한 결정을 조심해야 합니다."
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
  },
  {
    "id": 70,
    "name_ko": "오각별 3",
    "name_en": "Three of Pentacles",
    "type": "minor",
    "suit": "pentacles",
    "number": 3,
    "keywords": "협력, 팀워크, 기술, 학습",
    "description_upright": "팀워크와 협력을 통해 좋은 결과를 얻을 수 있습니다.",
    "description_reversed": "협력이 부족하거나 갈등이 생길 수 있습니다."
  },
  {
    "id": 71,
    "name_ko": "오각별 4",
    "name_en": "Four of Pentacles",
    "type": "minor",
    "suit": "pentacles",
    "number": 4,
    "keywords": "절약, 보수, 안정, 인색",
    "description_upright": "안정을 추구하며 신중하게 관리하는 시기입니다.",
    "description_reversed": "과도한 절약이나 인색함을 경계해야 합니다."
  },
  {
    "id": 72,
    "name_ko": "오각별 5",
    "name_en": "Five of Pentacles",
    "type": "minor",
    "suit": "pentacles",
    "number": 5,
    "keywords": "곤궁, 고난, 불안, 고립",
    "description_upright": "경제적 어려움이나 고립감을 경험할 수 있습니다. 도움을 요청하세요.",
    "description_reversed": "어려움에서 벗어나거나 도움을 받을 수 있습니다."
  },
  {
    "id": 73,
    "name_ko": "오각별 6",
    "name_en": "Six of Pentacles",
    "type": "minor",
    "suit": "pentacles",
    "number": 6,
    "keywords": "관대함, 나눔, 균형, 호혜",
    "description_upright": "나누고 베푸는 마음으로 균형을 이루는 시기입니다.",
    "description_reversed": "불평등하거나 일방적인 관계에 주의하세요."
  },
  {
    "id": 74,
    "name_ko": "오각별 7",
    "name_en": "Seven of Pentacles",
    "type": "minor",
    "suit": "pentacles",
    "number": 7,
    "keywords": "평가, 인내, 재고, 성과",
    "description_upright": "지금까지의 노력을 점검하고 성과를 평가하는 시기입니다.",
    "description_reversed": "참을성이 부족하거나 조급해할 수 있습니다."
  },
  {
    "id": 75,
    "name_ko": "오각별 8",
    "name_en": "Eight of Pentacles",
    "type": "minor",
    "suit": "pentacles",
    "number": 8,
    "keywords": "기술, 숙련, 노력, 완성",
    "description_upright": "기술을 연마하고 완성도를 높이는 시기입니다. 노력이 결실을 맺습니다.",
    "description_reversed": "기술 부족이나 완성도가 떨어질 수 있습니다."
  },
  {
    "id": 76,
    "name_ko": "오각별 9",
    "name_en": "Nine of Pentacles",
    "type": "minor",
    "suit": "pentacles",
    "number": 9,
    "keywords": "풍요, 독립, 성취, 여유",
    "description_upright": "물질적 풍요와 독립적인 성취를 누리는 시기입니다.",
    "description_reversed": "재정적 불안정이나 의존적인 상황이 될 수 있습니다."
  },
  {
    "id": 77,
    "name_ko": "오각별 10",
    "name_en": "Ten of Pentacles",
    "type": "minor",
    "suit": "pentacles",
    "number": 10,
    "keywords": "유산, 가족, 안정, 전통",
    "description_upright": "가족과 함께 안정적인 기반을 구축하는 시기입니다.",
    "description_reversed": "가족 갈등이나 재정적 불안정이 있을 수 있습니다."
  },
  {
    "id": 78,
    "name_ko": "오각별 페이지",
    "name_en": "Page of Pentacles",
    "type": "minor",
    "suit": "pentacles",
    "number": 11,
    "keywords": "학습, 새로운 기회, 실용성, 시작",
    "description_upright": "새로운 학습이나 실용적인 기회가 주어집니다.",
    "description_reversed": "계획이 불충분하거나 실행력이 부족할 수 있습니다."
  },
  {
    "id": 79,
    "name_ko": "오각별 나이트",
    "name_en": "Knight of Pentacles",
    "type": "minor",
    "suit": "pentacles",
    "number": 12,
    "keywords": "인내, 책임감, 신뢰성, 근면",
    "description_upright": "꾸준하고 신뢰할 수 있는 접근으로 목표를 달성합니다.",
    "description_reversed": "게으르거나 너무 보수적일 수 있습니다."
  },
  {
    "id": 80,
    "name_ko": "오각별 퀸",
    "name_en": "Queen of Pentacles",
    "type": "minor",
    "suit": "pentacles",
    "number": 13,
    "keywords": "풍요, 실용성, 보살핌, 안정",
    "description_upright": "실용적이고 풍요로운 환경을 만들어가는 시기입니다.",
    "description_reversed": "물질주의에 치우치거나 소홀함이 있을 수 있습니다."
  },
  {
    "id": 81,
    "name_ko": "오각별 킹",
    "name_en": "King of Pentacles",
    "type": "minor",
    "suit": "pentacles",
    "number": 14,
    "keywords": "성공, 풍요, 관대함, 사업가",
    "description_upright": "사업적 성공과 물질적 풍요를 달성하는 시기입니다.",
    "description_reversed": "탐욕이나 부정직한 방법을 경계해야 합니다."
  }
];

module.exports = fullTarotDeck;
