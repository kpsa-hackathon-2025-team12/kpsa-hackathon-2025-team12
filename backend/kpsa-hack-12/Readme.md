# KPSA 해커톤 2025 - Team 12 프로젝트

## 📝 프로젝트 소개
본 프로젝트는 KPSA 해커톤 2025에 참가한 12팀의 백엔드 서비스입니다. 사용자의 일기(다이어리) 작성과 감정 관리, 그리고 알림 서비스 등을 제공하는 어플리케이션의 서버 측 구현입니다.


## 🛠️ 기술 스택
- **언어**: Java 17
- **프레임워크**: Spring Boot
- **데이터베이스**: MySQL (Docker 컨테이너로 실행)
- **ORM**: Spring Data JPA
- **의존성 주입**: Lombok
- **클라우드**: AWS EC2
- **컨테이너화**: Docker
- **인증**: 소셜 로그인 (외부 API 연동)
- **메시징**: Firebase Cloud Messaging (FCM)


## 📚 주요 기능
### 1. 사용자 관리 (User Management)
- 사용자 정보 관리
- 소셜 로그인 지원
- 회원 레벨 시스템

### 2. 일기 관리 (Diary Management)
- 일일 일기 작성 및 조회
- 감정 점수 전/후 기록
- 완료 항목 카운트

### 3. 데이터 분석 (Data Analysis)
- 사용자 행동 데이터 수집 및 분석
- 증상 관리
- 위치 정보 연동

### 4. 챗봇 서비스 (Chat Service)
- 사용자와 대화 기능
- 사용자 로그 저장

### 5. 알림 서비스 (Notification)
- Firebase Cloud Messaging을 통한 푸시 알림
- 토큰 관리


## 🗂️ 프로젝트 구조

```aiignore
src/main/java/com/hack/kpsahack12/
├── dialy/
│   ├── controller/
│   │   └── diaryController.java
│   └── service/
│       └── DiaryService.java
├── dataInfo/
│   ├── controller/
│   │   └── dataInfoController.java
│   └── service/
│       └── dataInfoService.java
├── fcm/
│   ├── FCMService.java
│   └── NotificationController.java
├── member/
│   ├── controller/
│   │   ├── UserController.java
│   │   └── UserChatController.java
│   └── service/
│       └── UserChatServiceImpl.java
├── model/
│   ├── dto/
│   │   └── dialyResponse.java
│   ├── entity/
│   │   └── member/
│   │       ├── dialy.java
│   │       ├── LocationSpot.java
│   │       ├── MemberLevel.java
│   │       └── Symptoms.java
│   └── repository/
│       ├── dialyRepository.java
│       ├── LocationSpotRepository.java
│       ├── MemberLevelRepository.java
│       └── MembersRepository.java
├── enums/
│   └── ErrorCode.java
└── exception/
    └── CustomException.java
```

## 📊 데이터베이스 구조
프로젝트는 다음과 같은 테이블로 구성되어 있습니다:
- **member**: 사용자 정보
- **member_level**: 사용자 레벨 정보
- **level_info**: 레벨별 정보
- **dialy**: 사용자 일기
- **location_spot**: 위치 정보
- **symptoms**: 증상 정보
- **member_llm_data**: 사용자 챗봇 대화 로그
- **fcm_token_manage**: FCM 토큰 관리


---
