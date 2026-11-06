/* 홈 화면 설치(PWA)용 최소 서비스 워커 — 캐시·가로채기 없이 그대로 통과시켜서 게임 동작에는 영향 없음 */
self.addEventListener('install',()=>self.skipWaiting());
self.addEventListener('activate',e=>e.waitUntil(self.clients.claim()));
self.addEventListener('fetch',()=>{});
