캐릭터/몹 이미지를 PNG(투명 배경)로 이 폴더에 올리면 게임이 자동으로 사용합니다. 없으면 기본 그림이 나옵니다.
오른쪽을 바라보는 모습, 발이 이미지 아래쪽에 닿게, 세로 420px 안팎 권장.

영웅:  hero_war.png (전사)  hero_pal.png (팔라딘)  hero_sorc.png (마법사)   [적용 완료]
       hero_necro.png (강령술사)   [적용 완료] 프롬프트: img/hero_necro_prompt.txt
몹:    mob_imp.png (타락자)  mob_zombie.png (좀비)  mob_skeleton.png (해골 전사)  mob_bat.png (박쥐)
       mob_archer.png (궁수)  mob_bomber.png (폭탄병)  mob_healer.png (치유사)
보스:  mob_grak.png (묘지기 그라크)  mob_malek.png (역병 사제 말렉)  mob_morg.png (썩은 군주 모르그)
       mob_kargon.png (뼈의 군주 카르곤)  mob_izra.png (심연의 마녀 이즈라)
       (스테이지 2 보스: 스테이지마다 이름이 고정이에요)
       boss_2_1.png (빙결의 여왕 프로스티아)  boss_2_2.png (용암의 거인 이그니스)  boss_2_3.png (썩은 고목 트렌가)
       boss_2_4.png (모래의 파라오 세케르)  boss_2_5.png (혼돈의 군주 벨제르)
스테이지 1 보스는 위의 mob_grak(1-1) / mob_malek(1-2) / mob_morg(1-3) / mob_kargon(1-4) / mob_izra(1-5) 입니다.

스테이지 3 보스 (신규):
       boss_3_1.png (잿불의 장군 라그나)  boss_3_2.png (핏빛 여왕 사나리아)  boss_3_3.png (묵시록의 기사 데스락)
       boss_3_4.png (공허의 포식자 니아)  boss_3_5.png (지옥의 대공 아자젤)
스테이지 1 보스 일러스트 프롬프트 한 방: img/boss_prompt_stage1.txt (한 장에 5명 → 잘라서 mob_grak/malek/morg/kargon/izra.png 로 저장)


[스테이지 1 보스 동작 이미지 — 적용 완료]
  mob_grak / mob_malek / mob_morg / mob_kargon / mob_izra .png = 평소(대기) 포즈
  *_atk.png = 기본 공격 포즈, *_sk.png = 스킬 준비·돌진 포즈 (같은 크기·같은 발 위치로 잘려 있어 게임이 상황에 맞게 바꿔 보여줘요)
  스테이지 2·3 보스도 boss_2_1.png / boss_2_1_atk.png / boss_2_1_sk.png 처럼 _atk, _sk를 붙여 올리면 같은 방식으로 적용돼요.

스테이지 2 보스 일러스트 프롬프트: img/boss_prompt_stage2.txt (15컷 → boss_2_1~boss_2_5 + _atk/_sk 로 저장)

[스테이지 2 보스 동작 이미지 — 적용 완료] boss_2_1~boss_2_5 .png / _atk / _sk
스테이지 3 보스 일러스트 프롬프트: img/boss_prompt_stage3.txt

[스테이지 3 보스 동작 이미지 — 적용 완료] boss_3_1~boss_3_5 .png / _atk / _sk

스테이지 1 일반 몹 일러스트 프롬프트: img/mob_prompt_stage1.txt (7종×대기/공격 14컷 → mob_imp/zombie/skeleton/bat/archer/bomber/healer .png + _atk.png)
스테이지 2·3 일반 몹 프롬프트: img/mob_prompt_stage2.txt / mob_prompt_stage3.txt (각 7종×대기/공격 → mob_<이름>_s2.png, _s2_atk.png / _s3 ...)
스테이지 1·2·3 필드 배경 프롬프트: img/field_prompt_stage1~3.txt (각 5장 정사각 → field_1_1 ~ field_3_5.png)

[일반 몹 이미지 — 적용 완료] mob_imp/zombie/skeleton/bat/archer/bomber/healer .png + _atk (스테이지 1), _s2 / _s3 접미사는 스테이지 2·3 (없으면 스테이지 1 이미지로 대체)
[필드 배경 — 적용 완료] field_<스테이지>_<번호>.jpg (1000×1000, 15장). 이미지가 없으면 코드가 그리는 기본 바닥을 사용

[강령술사 소환수 이미지 — 코드 적용 완료, 이미지 올리면 자동 사용 / 없으면 기본 그림]
  mn_guard.png / mn_guard_atk.png (수호 영혼), mn_caster(.png/_atk) (포격 영혼), mn_colossus(.png/_atk) (고대 거인), mn_dragon(.png/_atk) (영혼 용령)
  프롬프트: img/minion_prompt_necro.txt (4행×2열 → 행마다 잘라 대기/공격으로 저장, 같은 행은 같은 크기·같은 발 위치)
