## Hyotalk 프로젝트 흐름 가이드 (입문자용)

이 문서는 Flutter 초보자도 이해할 수 있도록, 이 프로젝트가 어떻게 실행되고 화면이 전환되는지, 상태 관리는 어떻게 하는지(=Riverpod), 라우팅은 어떻게 되는지(=GoRouter)를 하나씩 설명합니다.

---

### 무엇을 쓰나요? 한 줄로 이해하기
- Riverpod: 전역/화면 상태를 관리하는 도구. “데이터를 어디서든 쉽게 읽고 변경”하게 해줍니다.
- GoRouter: 화면 이동(네비게이션)을 관리하는 도구. “URL 같은 경로로 페이지를 바꾸는” 역할을 합니다.

---

## 앱이 켜질 때 무엇이 일어나나요?

1) `main.dart`
- Flutter 앱의 시작점입니다.
- `ProviderScope`로 앱 전체를 감싸 Riverpod 상태를 사용할 준비를 합니다.

2) `HyotalkApp`
- 앱의 루트 위젯입니다.
- 여기서 `routerProvider`를 통해 GoRouter(라우터)를 받아 `MaterialApp.router`에 연결합니다.

3) `router.dart`
- 앱의 모든 경로(화면)와 이동 규칙을 정의합니다.
- 스플래시를 처음에 보여줄지, 바로 로그인/홈으로 갈지 결정합니다.

4) 첫 화면 결정 로직
- 스플래시를 이미 본 적이 없으면: `'/splash'`로 시작
- 이미 봤다면: `'/'`로 시작하고, 인증 상태에 따라 로그인/홈으로 보냄

관련 파일:
- `lib/main.dart`
- `lib/hyotalk_app.dart`
- `lib/router.dart`

---

## 스플래시 화면은 언제/어떻게 보이나요?

1) 스플래시 첫 표시 여부: `splashShownProvider`
- Notifier(Boolean)로 “스플래시를 이미 봤는가?”를 메모리에 기록합니다.
- 앱 최초 실행 때는 `false`이므로 스플래시를 보여줍니다.
- 2초 기다린 뒤 `markAsShown()`으로 `true`로 바꾸고, 인증 상태를 보고 로그인/홈으로 `replace` 이동합니다.
  - replace를 쓰는 이유: 뒤로가기 시 스플래시로 돌아가지 않게 하려고.

2) 왜 로그인/로그아웃 때는 스플래시가 안 뜨나요?
- 라우터의 redirect가 “스플래시 경로에서는 아무 리다이렉트도 하지 않도록” 되어 있고,
- 스플래시를 이미 본 상태에서는 `'/splash'`로 다시 가게 하지 않기 때문입니다.

관련 파일:
- `lib/features/splash/providers/splash_provider.dart`
- `lib/features/splash/splash_view.dart`
- `lib/router.dart`

참고: 시스템이 앱을 완전히 종료시킨 뒤 재시작되면 메모리가 초기화되어 스플래시는 다시 한 번 표시됩니다(정상 동작). 이를 피하려면 SharedPreferences 등 영구 저장소에 “봤다” 플래그를 저장해야 합니다.

---

## 인증(로그인/로그아웃)은 어떻게 동작하나요?

1) 상태 모델: `AuthState`
- `user`: 로그인한 사용자 정보(없으면 null)
- `isLoading`: 작업 중 로딩 표시용
- `error`: 사용자에게 보여줄 에러 메시지(있을 수도, 없을 수도)

2) 상태 관리자: `AuthNotifier`
- `login(email, password)`: Repository를 호출해 로그인 시도 → 성공 시 `user` 채움, 실패 시 `error`에 사유 저장
- `logout()`: Repository의 로그아웃 실행 → `user`를 null로
- `signup(...)`: 회원가입 흐름
- `clearError()`: 에러 닫기용

3) 데이터 계층: `AuthRepository`
- 실제 서버 대신 `MockAuthRepository`가 기본 구현입니다.
- `test@example.com` / `password123`로 로그인 성공하도록 되어 있습니다.
- 이후 실제 API 연동 시 여기만 교체하면 위쪽 화면/상태 코드는 그대로 사용 가능합니다.

관련 파일:
- `lib/features/auth/models/auth_state.dart`
- `lib/features/auth/repositories/auth_repository.dart` (Mock 포함)
- `lib/features/auth/providers/auth_provider.dart` (Provider 정의)
- `lib/features/auth/views/login_view.dart` (로그인 화면)
- `lib/features/home/home_view.dart` (홈 화면)

---

## 라우팅(화면 이동)은 어떻게 동작하나요? — GoRouter

1) 경로 정의
- `'/'` → 홈 화면(`HomeView`)
- `'/login'` → 로그인 화면(`LoginView`)
- `'/splash'` → 스플래시 화면(`SplashView`)

2) redirect 규칙(중요)
- `'/splash'`에 있을 때는 redirect를 하지 않습니다. 스플래시가 자체적으로 다음 화면으로 이동합니다.
- 아직 스플래시를 본 적이 없으면(`splashShown=false`), 어디서든 `'/splash'`로 보냅니다.
- 스플래시를 이미 봤으면:
  - 로그인이 안 되어 있고 로그인 화면이 아니라면 → `'/login'`
  - 로그인되어 있는데 로그인 화면이면 → `'/'`
  - 그 외는 그대로 유지

결론: 스플래시는 “앱 최초 1회만”, 로그인/로그아웃 시에는 스플래시 없이 바로 이동합니다.

관련 파일:
- `lib/router.dart`

---

## 화면(UI)은 어떻게 상태를 읽고 변경하나요? — Riverpod

- 읽기: `ref.watch(authProvider)` 처럼 사용해서 UI가 상태를 구독하고, 값이 바뀌면 자동 리빌드됩니다.
- 쓰기: `ref.read(authProvider.notifier).login(...)` 처럼 호출해 상태 변경(로그인/로그아웃/회원가입 등)을 실행합니다.
- 에러 리스닝: `ref.listen<AuthState>(authProvider, ...)`로 에러를 감지해 스낵바 표시.

관련 파일(예시):
- `lib/features/auth/views/login_view.dart`:
  - 입력 폼 검증 → 로그인 버튼 클릭 시 `login()` 호출
  - `isLoading`일 때 버튼 비활성/인디케이터 표시
  - 에러 발생 시 스낵바로 메시지 노출
- `lib/features/home/home_view.dart`:
  - `user` 정보 표시, 우상단 로그아웃 버튼으로 `logout()` 호출

---

## 데이터/모델

- `User` 모델: 날짜 필드는 `DateTime`으로, `fromJson()/toJson()`/`copyWith()` 제공
- 앱 공통 상수: `AppConstants` (앱 이름, 버전, API 타임아웃 등)
  - `AppConstants._()`는 인스턴스 생성을 막기 위한 private 생성자입니다. 정적 상수만 쓰겠다는 의도.

관련 파일:
- `lib/features/auth/models/user.dart`
- `lib/core/constants/app_constants.dart`
-(옵션) `lib/core/utils/validators.dart`, `lib/core/utils/date_formatter.dart`

---

## 자주 쓰는 패턴 빠르게 보기

- 상태 읽기
final authState = ref.watch(authProvider);
// authState.user, authState.isLoading, authState.error- 상태 변경(로그인)
await ref.read(authProvider.notifier).login(email, password);- 화면 이동(GoRouter)
context.go('/login');     // 새 경로로 이동 (스택 유지)
context.replace('/');     // 현재 경로 대체 (뒤로가기 시 이전 경로로 안 돌아감)---

## 개발 팁

- 새 화면(페이지) 추가하기
  1) `lib/features/<feature>/views/your_view.dart` 생성
  2) `router.dart`에 `GoRoute(path: '/your', builder: ...)` 추가
  3) 원하는 곳에서 `context.go('/your')` 호출

- 상태(Provider) 만들기
  1) `class YourNotifier extends Notifier<YourState> { ... }`
  2) `final yourProvider = NotifierProvider<YourNotifier, YourState>(() => YourNotifier());`
  3) UI에서 `ref.watch(yourProvider)`로 읽고, `ref.read(yourProvider.notifier)`로 변경

- 의존성(패키지) 관리
  - `pubspec.yaml`에 버전 리터럴로 작성: `version: 1.0.0+1`
  - 앱 내 표시용 버전은 `package_info_plus`로 런타임에 읽기

---

## 자주 묻는 질문(FAQ)

- Q: 왜 로그인/로그아웃 때 스플래시가 안 나와요?
  - A: 스플래시는 “앱 최초 1회”만 보여주고, 이후에는 바로 목적지로 이동하도록 설계했습니다.

- Q: 앱을 백그라운드로 두었다가 시스템이 종료시켜 재시작하면 스플래시가 다시 나오나요?
  - A: 네. 메모리가 초기화되기 때문에 다시 1회 표시됩니다(정상 동작). 영구 저장으로 막고 싶다면 SharedPreferences로 플래그를 저장하세요.

- Q: `AppConstants._();`는 뭐죠?
  - A: 정적 상수 전용 클래스로 쓰기 위해 인스턴스 생성을 막는 private 생성자입니다.

---

## 파일 맵

- 라우팅: `lib/router.dart`
- 앱 루트: `lib/hyotalk_app.dart`, `lib/main.dart`
- 인증 흐름
  - 상태/Provider: `lib/features/auth/models/auth_state.dart`, `lib/features/auth/providers/auth_provider.dart`
  - 저장소: `lib/features/auth/repositories/auth_repository.dart` (Mock 포함)
  - 화면: `lib/features/auth/views/login_view.dart`, `lib/features/home/home_view.dart`
- 스플래시: `lib/features/splash/splash_view.dart`, `lib/features/splash/providers/splash_provider.dart`
- 공통: `lib/core/constants/app_constants.dart`, `lib/core/utils/...`

---

필요하면 이 문서를 계속 업데이트해 나가며, 화면 추가/상태 추가 시 흐름에 맞춰 섹션을 덧붙이면 팀 온보딩에도 큰 도움이 됩니다.
