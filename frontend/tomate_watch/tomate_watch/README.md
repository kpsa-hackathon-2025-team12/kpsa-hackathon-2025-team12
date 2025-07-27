# Tomate Watch

Apple Watch용 실시간 헬스 모니터링 애플리케이션

## 개요

Tomate Watch는 Apple Watch 전용으로 설계된 헬스 모니터링 앱으로, 실시간 심박수 추적과 시각적 애니메이션을 통해 사용자의 건강 상태를 직관적으로 표시합니다.

## 주요 기능

### 실시간 심박수 모니터링
- 90-120 BPM 범위의 실시간 심박수 시뮬레이션
- 2초 간격으로 업데이트되는 실시간 데이터
- 시각적 심장 박동 애니메이션

### 애니메이션 시스템
- 20개 프레임으로 구성된 부드러운 이미지 시퀀스 애니메이션
- 5초 간격으로 순환하는 자동 애니메이션
- 최적화된 메모리 관리

### 사용자 인터페이스
- Apple Watch에 최적화된 컴팩트한 UI 디자인
- 고대비 색상 체계로 가독성 향상
- 반응형 레이아웃 지원

## 기술 스택

- **플랫폼**: watchOS
- **언어**: Swift 5.0+
- **프레임워크**: SwiftUI
- **아키텍처**: MVVM 패턴
- **상태 관리**: ObservableObject, @StateObject

## 프로젝트 구조

```
tomate_watch/
├── tomate_watch Watch App/
│   ├── ContentView.swift          # 메인 UI 컨테이너
│   ├── tomate_watchApp.swift      # 앱 진입점
│   ├── Animation/                 # 애니메이션 리소스
│   │   ├── anim0.png ~ anim19.png # 20프레임 애니메이션 시퀀스
│   └── Assets.xcassets/           # 앱 아이콘 및 리소스
├── tomate_watch Watch AppTests/   # 단위 테스트
└── tomate_watch Watch AppUITests/ # UI 테스트
```

## 시스템 요구사항

- **최소 지원 버전**: watchOS 9.0+
- **개발 환경**: Xcode 14.0+
- **디바이스**: Apple Watch Series 4 이상

## 설치 및 실행

### 개발 환경 설정

1. **저장소 클론**
   ```bash
   git clone <repository-url>
   cd tomate_watch
   ```

2. **Xcode에서 프로젝트 열기**
   ```bash
   open tomate_watch.xcodeproj
   ```

3. **빌드 및 실행**
   - Xcode에서 Apple Watch 시뮬레이터 또는 실제 디바이스 선택
   - `Cmd + R`로 빌드 및 실행

### 배포

1. **아카이브 생성**
   - Xcode에서 `Product` → `Archive` 선택

2. **App Store Connect 업로드**
   - Organizer에서 생성된 아카이브 선택
   - `Distribute App` 클릭하여 업로드

## 아키텍처

### 컴포넌트 구조

#### ContentView
메인 UI 컨테이너로서 다음 요소들을 조합합니다:
- `ImageSequenceAnimationView`: 애니메이션 표시
- `SimpleHeartRateView`: 심박수 데이터 표시

#### SimpleHeartRateManager
심박수 데이터 관리를 담당하는 ObservableObject:
- 실시간 심박수 시뮬레이션
- 심장 박동 애니메이션 제어
- 타이머 기반 데이터 업데이트

#### ImageSequenceAnimationView
애니메이션 렌더링 및 제어:
- 프레임 순차 로딩
- 타이머 기반 프레임 전환
- 메모리 효율적인 이미지 관리

## 성능 최적화

### 메모리 관리
- 지연 로딩을 통한 이미지 리소스 최적화
- 타이머 생명주기 관리로 메모리 누수 방지
- SwiftUI 생명주기 메서드 활용

### 배터리 효율성
- 적절한 업데이트 간격 설정 (2-5초)
- 백그라운드 시 리소스 해제
- 최소한의 애니메이션 처리

## 테스트

### 단위 테스트
```bash
# Xcode에서 실행
Cmd + U
```

### UI 테스트
```bash
# 시뮬레이터에서 UI 테스트 실행
xcodebuild test -scheme "tomate_watch Watch App" -destination "platform=watchOS Simulator,name=Apple Watch Series 9 (45mm)"
```

## 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다.

## 기여

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 연락처

프로젝트 관련 문의사항이 있으시면 이슈를 등록해 주세요.

---

**개발 환경**: Xcode 15.0+ | **타겟 OS**: watchOS 9.0+ | **언어**: Swift 5.0+ 