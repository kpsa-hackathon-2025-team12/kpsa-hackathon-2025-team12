# Tomate 앱 - 기술 문서 및 프로젝트 아키텍처

> **해커톤 12팀 프론트엔드 프로젝트**  
> 멘탈 헬스케어를 위한 종합 모바일 애플리케이션

---

## 프로젝트 개요

**Tomate**는 현대인의 정신건강 관리를 돕는 종합 헬스케어 모바일 애플리케이션입니다. 사용자 맞춤형 설문을 통한 심리 상태 분석, 개인화된 운동 및 산책 추천, 호흡 명상, 일기 작성 등의 기능을 통해 사용자의 멘탈 웰빙을 종합적으로 지원합니다.

### 핵심 가치 제안
- **개인화된 멘탈 케어**: 설문 기반 맞춤형 콘텐츠 제공
- **홀리스틱 접근**: 운동, 명상, 기록을 통한 종합적 케어
- **접근성**: 직관적 UI/UX와 소셜 로그인을 통한 편리한 접근
- **지속적 관리**: 단계별 진행 시스템과 푸시 알림을 통한 지속성 확보

---

## 기술 스택 및 아키텍처

### 플랫폼 및 프레임워크
**Flutter Framework**
- **언어**: Dart 3.8.1+
- **플랫폼**: iOS, Android, Web 크로스 플랫폼 지원
- **UI 철학**: Material Design 3 + Custom Design System

### 아키텍처 패턴
**Clean Architecture 기반 구조**
```
lib/
├── core/
│   ├── api/              # API 통신 레이어
│   ├── providers/        # 공통 Provider들
│   ├── routes/          # 라우팅 설정
│   └── utils/           # 유틸리티 함수들
├── features/            # 기능별 모듈화
│   ├── home/           # 홈 기능들
│   └── survey/         # 설문조사 시스템
├── navigation/         # 네비게이션 화면들
└── common/            # 공통 컴포넌트
    ├── constants/     # 상수 정의
    └── widgets/       # 재사용 위젯
```

### 핵심 라이브러리

| 카테고리 | 라이브러리 | 버전 | 용도 |
|----------|------------|------|------|
| **상태관리** | `flutter_riverpod` | ^2.6.1 | 앱 전역 상태 관리 |
| **라우팅** | `go_router` | ^14.6.2 | 선언적 라우팅 |
| **네트워킹** | `dio` | ^5.7.0 | HTTP 클라이언트 |
| **UI/반응형** | `flutter_screenutil` | ^5.9.3 | 반응형 UI 대응 |
| **백엔드 서비스** | `firebase_core` | ^3.8.1 | Firebase 통합 |
| **인증** | `firebase_auth` | ^5.3.4 | 사용자 인증 |
| **푸시 알림** | `firebase_messaging` | ^15.1.6 | 실시간 알림 |
| **보안 저장소** | `flutter_secure_storage` | ^9.2.4 | 민감 데이터 저장 |
| **웹뷰** | `flutter_inappwebview` | ^6.0.0 | 소셜 로그인 웹뷰 |
| **로깅** | `pretty_dio_logger` | ^1.4.0 | API 요청/응답 로깅 |

---

## 핵심 기능 구조

### 인증 시스템
**멀티 소셜 로그인 지원**
- **카카오 로그인**: KakaoTalk 계정 연동
- **네이버 로그인**: 네이버 아이디 연동  
- **구글 로그인**: Google 계정 연동

**구현 특징**:
- WebView 기반 OAuth 2.0 구현
- JWT 토큰 기반 세션 관리
- Secure Storage를 통한 토큰 암호화 저장
- Token Interceptor를 통한 자동 토큰 갱신

### 설문조사 시스템
**4단계 개인화 설문**
```
설문 플로우:
Survey Intro → Survey 1 → Survey 2 → Survey 3 → Survey 4 → Complete
```

**기술적 구현**:
- 단계별 라우팅 관리
- 설문 데이터 상태 관리 (Riverpod)
- 진행률 시각화
- 결과 기반 개인화 알고리즘

### 홈 기능 모듈
**5개 핵심 탭 구조**

1. **홈 (home1_screen)**: 메인 대시보드
   - 개인화된 운동/산책 추천
   - 단계별 진행 시스템 (레벨 1-2)
   - 위치 기반 추천 (지하철역, 공원 등)

2. **대화 (home2_screen)**: AI 챗봇
   - 멘탈 헬스 상담 챗봇
   - 감정 상태 모니터링

3. **호흡하기 (wind_screen)**: 명상/이완
   - 가이드 호흡 애니메이션
   - 스트레스 완화 프로그램

4. **일기 (home3_screen)**: 감정 기록
   - 일일 감정 일기 작성
   - 감정 변화 트래킹

5. **내 정보 (home4_screen)**: 사용자 프로필
   - 개인 정보 관리
   - 진행 현황 통계

### 알림 시스템
**Firebase Cloud Messaging (FCM)**
- 백그라운드 메시지 처리
- 로컬 알림 통합
- 플랫폼별 알림 권한 관리
- 알림 카테고리별 분류

---

## UI/UX 디자인 시스템

### 디자인 철학
- **미니멀리즘**: 불필요한 요소 제거로 집중도 향상
- **따뜻한 색감**: 심리적 안정감을 주는 컬러 팔레트
- **직관적 네비게이션**: FloatingActionButton + BottomNavigation

### 커스텀 디자인 시스템
**폰트**: Pretendard (한글 최적화)
- Regular (400), Medium (500), SemiBold (600), Bold (700)

**색상 체계**:
- Primary: `#EB423D` (토마토 레드)
- Secondary: `#989898` (그레이)
- Background: `#FFFFF5` (아이보리)
- Surface: `#FFFFFF` (화이트)

**반응형 대응**: ScreenUtil (402×874 기준)

### 컴포넌트 구조
**재사용 위젯들**:
- `CommonAppBar`: 공통 앱바 컴포넌트
- `NavigationScreen`: 하단 네비게이션 바
- Custom Animation Controllers (토마토 캐릭터 애니메이션)

---

## 상태 관리 아키텍처

### Riverpod 기반 상태 관리
**Provider 구조**:
```dart
// 라우팅 관리
final routerProvider = Provider<GoRouter>

// API 통신
final apiProvider = AsyncNotifierProvider(ApiNotifier.new)

// Firebase 서비스
final firebaseServiceProvider = Provider

// 보안 저장소
final secureStorageProvider = Provider
```

**특징**:
- 의존성 주입 패턴
- 자동 상태 변화 감지
- 메모리 효율적 상태 관리
- 테스트 용이성

---

## 네트워킹 아키텍처

### API 통신 구조
**Dio HTTP Client 설정**:
- Base URL 환경별 분리 (dev/prod)
- Request/Response 로깅
- 타임아웃 설정 (5초)
- 에러 핸들링 표준화

**보안 구현**:
- JWT Token Interceptor
- HTTPS 통신 강제
- Certificate Pinning (향후 구현 예정)

**API 응답 처리**:
```dart
// 표준화된 에러 핸들링
if (e.type == DioExceptionType.connectionTimeout) {
  handler.resolve(Response(
    statusCode: 400,
    data: {'message': '요청 시간이 초과되었습니다.'}
  ));
}
```

---

## 프로젝트 구조 상세

### 디렉토리 구조
```
tomate/
├── 플랫폼별 설정
│   ├── android/          # Android 네이티브 설정
│   ├── ios/             # iOS 네이티브 설정
│   ├── web/             # 웹 플랫폼 설정
│   ├── macos/           # macOS 데스크탑 지원
│   └── windows/         # Windows 데스크탑 지원
│
├── 에셋 리소스
│   ├── assets/icons/    # 아이콘 이미지들
│   ├── assets/images/   # 일반 이미지들
│   ├── assets/fonts/    # Pretendard 폰트 패밀리
│   └── assets/animations/ # 애니메이션 파일들
│
├── 핵심 비즈니스 로직
│   ├── lib/core/        # 코어 인프라
│   ├── lib/features/    # 기능별 모듈
│   ├── lib/navigation/  # 화면 네비게이션
│   └── lib/common/      # 공통 컴포넌트
│
└── 설정 파일들
    ├── pubspec.yaml     # 의존성 관리
    ├── firebase.json    # Firebase 설정
    └── analysis_options.yaml # 코드 품질 설정
```

### 개발 환경 설정
**환경 변수 관리**:
- `env.dev`: 개발 환경 설정
- `env.prod`: 프로덕션 환경 설정
- Flutter DotEnv를 통한 환경별 분리

**Firebase 설정**:
- `google-services.json` (Android)
- `GoogleService-Info.plist` (iOS)
- Analytics, Auth, Messaging 통합

---

## 배포 및 운영

### 플랫폼별 배포 준비
**Android**:
- Gradle 빌드 시스템
- ProGuard 코드 난독화
- Google Play Console 배포 준비

**iOS**:
- Xcode 프로젝트 설정
- App Store Connect 연동
- CocoaPods 의존성 관리

**Web**:
- PWA (Progressive Web App) 지원
- 매니페스트 파일 설정
- 반응형 웹 디자인

### 모니터링 및 분석
**Firebase Analytics**:
- 사용자 행동 분석
- 화면별 체류 시간 측정
- 사용자 여정 추적

**크래시 리포팅**:
- Firebase Crashlytics (향후 추가 예정)
- 실시간 에러 모니터링

---

## 성능 최적화

### 렌더링 최적화
- Widget Tree 플래터링으로 빌드 시간 단축
- Const Constructor 활용으로 불필요한 리빌드 방지
- 재사용 가능한 컴포넌트 설계

### 메모리 관리
- AnimationController 적절한 dispose
- 이미지 캐싱 최적화
- 메모리 리크 방지 패턴 적용

### 네트워크 최적화
- API 응답 캐싱
- 이미지 압축 및 최적화
- 배치 요청 처리

---

## 향후 개발 계획

### Phase 2 - 기능 확장
- [ ] 실시간 채팅 기능
- [ ] 커뮤니티 기능
- [ ] 전문가 상담 예약
- [ ] 웨어러블 기기 연동

### Phase 3 - 고도화
- [ ] AI 기반 개인화 추천
- [ ] 생체 신호 분석
- [ ] 다국어 지원
- [ ] 접근성 향상

---

## 프로젝트의 기술적 우수성

### 아키텍처 우수성
- **확장 가능한 구조**: Clean Architecture로 유지보수성 확보
- **모듈화된 설계**: 기능별 독립적 개발 가능
- **테스트 용이성**: 의존성 주입으로 단위 테스트 지원

### 사용자 경험 우수성
- **직관적 UI/UX**: 사용자 중심 디자인
- **부드러운 애니메이션**: 고품질 인터랙션
- **접근성 고려**: 다양한 사용자 환경 지원

### 기술적 혁신성
- **크로스 플랫폼**: 하나의 코드베이스로 다중 플랫폼 지원
- **실시간 기능**: Firebase를 활용한 실시간 서비스
- **확장성**: 마이크로서비스 아키텍처 준비

---

## 시작하기

### 필수 요구사항
- Flutter SDK 3.24.1+
- Dart 3.8.1+
- Android Studio / VS Code
- Firebase CLI

### 설치 및 실행
```bash
# 저장소 클론
git clone [repository-url]
cd tomate

# 의존성 설치
flutter pub get

# 개발 서버 실행
flutter run
```

### 환경 설정
```bash
# 개발 환경
flutter run --dart-define-from-file=env.dev

# 프로덕션 환경
flutter run --dart-define-from-file=env.prod --release
```

---

## 프로젝트 정보
- **팀**: 해커톤 12팀
- **역할**: 프론트엔드 개발
- **개발 기간**: 7월 26일 ~ 7월 27일 (1일)
- **플랫폼**: Flutter (iOS/Android/Web)
- **상태**: 프로토타입 완성

---

## 스크린샷

<!-- 앱 스크린샷이 들어갈 자리 -->
![앱 스크린샷 1](assets/images/screenshot1.png)
![앱 스크린샷 2](assets/images/screenshot2.png)

---

## 기여하기

프로젝트에 기여를 원하시는 분들은 다음 가이드라인을 따라주세요:

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 라이선스

이 프로젝트는 MIT 라이선스 하에 있습니다. 자세한 내용은 `LICENSE` 파일을 참조하세요.

---

## 연락처

프로젝트에 대한 문의사항이 있으시면 언제든 연락주세요.

**해커톤 12팀** - 프론트엔드 개발팀
