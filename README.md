# Flutter Hyotalk App

Flutter로 개발된 Hyotalk 애플리케이션입니다.

## 주요 기능

- **인증 시스템**: 서버에서 토큰을 가져와 로그인, 자동 로그인 지원
- **하단 탭 네비게이션**: 홈, 업무일지, 쇼핑몰, 마이페이지
- **환경별 빌드**: dev, stage, prod 환경 지원
- **상태 관리**: flutter_bloc 사용
- **라우팅**: go_router와 shell route를 사용한 네비게이션

## 기술 스택

- **Flutter**: ^3.9.2
- **상태 관리**: flutter_bloc
- **네비게이션**: go_router
- **네트워크**: dio
- **보안 저장소**: flutter_secure_storage
- **환경 설정**: flutter_dotenv

## 프로젝트 구조

```
lib/
├── core/
│   ├── config/          # 환경 설정
│   ├── network/         # 네트워크 설정 (Dio)
│   ├── router/          # 라우터 설정
│   └── storage/         # Secure Storage
├── features/
│   ├── auth/           # 인증 기능
│   ├── home/           # 홈 화면
│   ├── main/           # 메인 화면 (하단 탭)
│   ├── work_diary/     # 업무일지
│   ├── shopping/       # 쇼핑몰
│   └── mypage/         # 마이페이지
└── main.dart
```

## 환경 설정

프로젝트 루트에 다음 환경 파일을 생성하세요:

### .env.dev
```
BASE_URL=https://dev-api.example.com
API_KEY=dev_api_key_here
ENV=dev
```

### .env.stage
```
BASE_URL=https://stage-api.example.com
API_KEY=stage_api_key_here
ENV=stage
```

### .env.prod
```
BASE_URL=https://api.example.com
API_KEY=prod_api_key_here
ENV=prod
```

## 빌드 및 실행

### 패키지 설치
```bash
flutter pub get
```

### 개발 환경 실행
```bash
# Android
flutter run --flavor dev -t lib/main.dart

# iOS
flutter run --flavor dev -t lib/main.dart
```

### 스테이징 환경 빌드
```bash
# Android
flutter build apk --flavor stage -t lib/main.dart

# iOS
flutter build ios --flavor stage -t lib/main.dart
```

### 프로덕션 환경 빌드
```bash
# Android
flutter build apk --flavor prod -t lib/main.dart

# iOS
flutter build ios --flavor prod -t lib/main.dart
```

## 화면 구조

1. **Splash 화면**: 앱 초기화 및 자동 로그인 확인
2. **Login 화면**: 서버에서 토큰을 가져와 로그인, 자동 로그인 옵션
3. **Main 화면**: 하단 탭 네비게이션
   - **홈**: 스크롤뷰, 이미지 배너(가로 슬라이드), 그리드뷰 카테고리(6개)
   - **업무일지**: 비슷한 구조
   - **쇼핑몰**: 비슷한 구조
   - **마이페이지**: 비슷한 구조 + 로그아웃 버튼
4. **카테고리 상세 페이지**: 카테고리 선택 시 이동

## 주요 기능 설명

### 인증 플로우
1. 앱 시작 시 Splash 화면에서 자동 로그인 확인
2. 자동 로그인이 활성화되어 있으면 저장된 토큰으로 로그인
3. 자동 로그인이 없으면 Login 화면으로 이동
4. Login 화면에서 서버에서 토큰을 가져와 로그인
5. 자동 로그인 체크박스를 선택하면 다음 앱 실행 시 자동 로그인

### 네비게이션
- go_router를 사용한 선언적 라우팅
- ShellRoute를 사용한 하단 탭 네비게이션
- 인증 상태에 따른 자동 리다이렉트

### 네트워크
- Dio를 사용한 HTTP 통신
- 인터셉터를 통한 자동 토큰 주입
- 401 에러 시 자동 로그아웃 처리

## 개발 가이드

### 새로운 기능 추가
1. `lib/features/` 하위에 새로운 feature 폴더 생성
2. data, domain, presentation 레이어 구조 유지
3. 필요시 BLoC 패턴 사용

### API 엔드포인트 추가
`lib/core/network/api_endpoints.dart`에 새로운 엔드포인트 추가

### 환경 변수 추가
`.env.*` 파일에 변수 추가 후 `lib/core/config/env_config.dart`에서 접근

## 라이선스

이 프로젝트는 비공개 프로젝트입니다.
