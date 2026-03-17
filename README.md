# 도하준 — AI 캐릭터 챗

> 《나 혼자만 레벨업》 세계관 기반 AI 롤플레이 채팅 서비스
> 모바일 앱 스타일 UI · iOS PWA 지원 · Cloudflare Pages 배포

## 프로젝트 개요

- **캐릭터**: 도하준 — 그림자 군단의 군주, 츤데레 남자친구
- **목표**: 여성 유저 몰입 극대화를 위한 심리 유도형 AI 롤플레이 채팅
- **스타일**: max-width 420px 다크모드, 네이티브 앱 UX

## 기능 목록

### ✅ 구현 완료
| 기능 | 설명 |
|------|------|
| **모바일 앱 UI** | 420px 중앙 정렬, iOS Safe Area, 다크모드 |
| **PWA 지원** | `manifest.json`, `apple-mobile-web-app-capable`, 홈화면 추가 |
| **히어로 랜딩** | 전체너비 프로필 이미지, 해시태그 오버레이, 캐릭터 소개·스펙·세계관 섹션 |
| **게스트/회원 이중 구조** | 게스트(10회 무료) → 회원가입(100회) 전환 |
| **3단계 온보딩** | 닉네임 → 장르 선택 → 캐릭터 호칭 설정 |
| **대화 영속 저장** | D1 DB에 회원별 대화 히스토리 저장, 재접속 시 복원 |
| **장기 기억 요약** | 30턴 초과 시 AI 자동 요약 압축 |
| **채팅 UI** | *상황묘사* + "대사" 2세트 파싱, AI/유저 말풍선 |
| **상황 이미지** | 트리거 키워드 매칭 시 이미지 자동 표시 |
| **관리자 패널** | `/admin` — 캐릭터 전체 설정 UI 편집, API 키 관리 |
| **도하준 프롬프트** | 츤데레 성격·말투·심리유도 규칙 완전 통합 |

### 🔲 미구현 / 향후 개발
- DomoAI 영상 생성 연동
- 프로필 이미지 업로드 (현재 URL 방식만)
- 이메일 인증
- 소셜 로그인 (카카오/구글)
- 다중 캐릭터 지원

## URL 및 엔드포인트

### 사용자 페이지
| 경로 | 설명 |
|------|------|
| `/` | 메인 랜딩 + 채팅 SPA |
| `/admin` | 관리자 패널 |

### 공개 API
| Method | Path | 설명 |
|--------|------|------|
| `GET` | `/api/character` | 캐릭터 공개 정보 |
| `POST` | `/api/guest/init` | 게스트 세션 생성 |
| `GET` | `/api/status` | 서버 상태 확인 |

### 사용자 API (Bearer JWT)
| Method | Path | 설명 |
|--------|------|------|
| `POST` | `/api/user/register` | 회원가입 (3단계) |
| `POST` | `/api/user/login` | 로그인 + 대화 병합 |
| `POST` | `/api/user/profile` | 프로필 업데이트 |
| `POST` | `/api/chat` | 채팅 메시지 전송 |
| `GET` | `/api/chat/history` | 대화 히스토리 조회 |
| `DELETE` | `/api/chat/history` | 대화 초기화 |

### 관리자 API (Bearer adminJWT)
| Method | Path | 설명 |
|--------|------|------|
| `POST` | `/api/admin/login` | 관리자 로그인 |
| `GET` | `/api/admin/character` | 전체 설정 조회 |
| `POST` | `/api/admin/character/update` | 설정 업데이트 |
| `POST` | `/api/admin/keys` | API 키 저장 |
| `POST` | `/api/admin/reset-sessions` | 전체 세션 초기화 |

## 기술 스택

- **프레임워크**: Hono (Cloudflare Workers)
- **프론트엔드**: Vanilla HTML/CSS/JS (인라인 SPA)
- **데이터베이스**: Cloudflare D1 (SQLite)
- **KV 저장소**: Cloudflare KV (캐릭터 설정, API 키)
- **인증**: Custom JWT (HMAC-SHA256)
- **비밀번호**: PBKDF2 (100,000 iterations)
- **LLM**: OpenAI 호환 API (GPT-4o)
- **배포**: Cloudflare Pages

## 데이터 모델

### users 테이블
```
id, email, password_hash, nickname, char_name, genres, token_used, token_limit, is_guest, created_at
```

### sessions 테이블
```
id, user_id, history (JSON), updated_at
```

### KV 저장소
- `character_config` — 캐릭터 전체 설정 JSON
- `openai_api_key` — LLM API 키
- `openai_base_url` — LLM Base URL

## 환경 설정

### .dev.vars (로컬 개발)
```
JWT_SECRET=your-secret
ADMIN_PASSWORD=admin1234
OPENAI_API_KEY=sk-...
OPENAI_BASE_URL=https://api.openai.com/v1
GUEST_TOKEN_LIMIT=10
MEMBER_TOKEN_LIMIT=100
```

## 사용법

### iOS에서 홈화면 추가 (PWA)
1. Safari에서 사이트 접속
2. 공유 버튼 → "홈 화면에 추가"
3. 네이티브 앱처럼 사용

### 대화하기
1. 랜딩 페이지에서 "대화 시작하기" 탭
2. 게스트로 10회 무료 대화
3. 회원가입 시 100회로 확장
4. 3단계 온보딩: 닉네임 → 장르 → 도하준이 부를 호칭

### 관리자 설정
1. `/admin` 접속
2. 비밀번호: `admin1234` (기본값)
3. API 키 설정 → 캐릭터 프롬프트 편집 가능

## 배포

- **플랫폼**: Cloudflare Pages
- **상태**: ✅ 개발 서버 구동 중
- **기술**: Hono + TypeScript + D1 + KV
