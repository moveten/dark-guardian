캐릭터/몹 이미지를 PNG(투명 배경)로 이 폴더에 올리면 게임이 자동으로 사용합니다. 없으면 기본 그림이 나옵니다.
오른쪽을 바라보는 모습, 발이 이미지 아래쪽에 닿게, 세로 420px 안팎 권장.

영웅:  hero_war.png (전사)  hero_pal.png (팔라딘)  hero_sorc.png (마법사)   [적용 완료]
       hero_necro.png (강령술사)   [적용 완료] 프롬프트: img/hero_necro_prompt.txt
       hero_druid.png / hero_druid_bear.png (드루이드 인간·곰, 각각 _walk.png 6프레임 시트도 가능) [인간 대기·걷기(hero_druid, _walk) 적용 완료 · 영웅 공격 시트 hero_<형태>_atk.png(4칸) 지원 — 곰인간 대기·걷기(hero_druid_bear, _walk) 적용 완료 · 곰 공격(_atk) 적용 완료 · 까마귀 소환수 그림(mn_raven / _atk)도 적용 완료]
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

[강령술사 소환수 이미지 — 적용 완료 (없으면 기본 그림)]
  mn_guard.png / mn_guard_atk.png (수호 영혼), mn_caster(.png/_atk) (포격 영혼), mn_colossus(.png/_atk) (고대 거인), mn_dragon(.png/_atk) (영혼 용령)
  mn_raven.png / mn_raven_atk.png (드루이드 까마귀 — 3마리 공용, 대기/공격) [적용 완료]
  mn_fusion.png / mn_fusion_atk.png (영혼 융합 — 수호+포격 합체 일러스트, 없으면 두 그림을 겹쳐 그림)
  프롬프트: img/minion_prompt_necro.txt (4행×2열 → 행마다 잘라 대기/공격으로 저장, 같은 행은 같은 크기·같은 발 위치)

[영웅 걷기 시트 — 전사·팔라딘·마법사·강령술사 적용 완료] hero_war_walk.png / hero_pal_walk.png / hero_sorc_walk.png / hero_necro_walk.png = 6프레임 가로 시트 (칸 크기 동일, 발이 아래에 닿음, 오른쪽 바라봄)
  다른 직업도 hero_<직업>_walk.png 로 올리고 index.html의 WALKS 목록에 한 줄 추가하면 같은 방식으로 적용돼요.
  시트 제작 방법: 대기 그림을 기준으로 ChatGPT에서 3칸×2줄 6프레임을 뽑은 뒤 배경 제거·균일 정렬(시트 마젠타 배경).

[보스 걷기·준비 동작 프롬프트] img/boss_walk_prompt.txt (스테이지 1 보스 5종: 걷기 6프레임 + 준비 자세 _wu, 참고 이미지 첨부해서 요청)
[보스 걷기 시트 — 적용 완료] mob_grak_walk.png (6프레임 가로 시트, 저장 배율 .75). 새 보스는 index.html 의 BWALKS 에 이름 추가.
[보스 걷기 시트 — 적용 완료] mob_malek_walk.png
[보스 걷기 시트 — 적용 완료] mob_morg_walk.png
[보스 준비 자세 — 적용 완료] mob_morg_wu.png (대기 그림과 같은 배율·발 위치로 정렬된 한 장. 새 보스는 index.html 의 BWU 에 이름 추가)
[보스 걷기 시트·준비 자세 — 적용 완료] mob_kargon_walk.png / mob_kargon_wu.png


[4스테이지 삼남매] field_4_1.jpg = 전용 배경 적용 완료(검은 화산암 바닥 + 옅은 보라 잔금, 1000×1000). 보스 그림은 hero_war/hero_sorc(어두운 톤)·hero_necro(검은 실루엣)를 코드에서 색만 입혀 씀. 전용 그림을 만들면 교체 가능.
[4스테이지 삼남매] boss_shadow.png = 검은 그림자 전용 그림(적용 완료, 프롬프트 img/boss_shadow_prompt.txt). 걷기 시트가 생기면 boss_shadow_walk.png 로 올리고 index.html 의 BWALKS 에 boss_shadow 한 줄 추가.
[4스테이지 삼남매] boss_shadow_walk.png = 검은 그림자 걷기 6프레임 시트(적용 완료, 칸마다 얼굴 위치는 index.html 의 SHD_MOUTH). 프롬프트 img/boss_shadow_walk_prompt.txt
[영웅 아이템 아이콘 — 적용 완료] item_hero_dagger/helm/armor/amulet/ring/horn/shield/orb/lantern/totem.png (192×192) — index.html 의 UNQIMG(이름 → 파일). 프롬프트 img/hero_item_prompt.txt
[4스테이지 카드 용 테두리 — 적용 완료] dragon_frame.png = 흰색 실루엣(알파), index.html 의 .drg 마스크로 카드 테두리 색을 입힘. 프롬프트 img/dragon_frame_prompt.txt

[랭킹 직업 아이콘 — 적용 완료] cls_war/sorc/pal/necro/druid.png (160×160, 투명 배경) — 랭킹 목록(.rke)·랭킹 프로필 제목(.rkh)에서 사용. 원본 시트에서 잘라 배경 제거.
