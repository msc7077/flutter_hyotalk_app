# Flutter Hyotalk App 프로젝트 가이드

## 📚 목차
1. [프로젝트 구조](#프로젝트-구조)
2. [Bloc 패턴 기초](#bloc-패턴-기초)
3. [상태관리 흐름 상세 가이드](#상태관리-흐름-상세-가이드)
4. [앱 실행 흐름](#앱-실행-흐름)
5. [주요 기능 설명](#주요-기능-설명)

---

## 프로젝트 구조

```
lib/
├── core/                          # 핵심 기능 (공통 사용)
│   ├── config/                    # 환경 설정
│   │   └── env_config.dart        # 환경 변수 관리 (dev, stage, prod)
│   ├── network/                   # 네트워크 관련
│   │   ├── dio_client.dart        # HTTP 클라이언트 (Dio)
│   │   └── api_endpoints.dart     # API 엔드포인트 정의
│   ├── router/                    # 라우팅
│   │   ├── app_router.dart        # GoRouter 설정
│   │   └── router_refresh_stream.dart
│   └── storage/                   # 데이터 저장
│       ├── secure_storage.dart    # 보안 저장소 (토큰 등)
│       └── preference_storage.dart # 일반 저장소 (autoLogin 등)
│
├── features/                      # 기능별 모듈
│   ├── auth/                      # 인증 기능
│   │   ├── data/                  # 데이터 레이어
│   │   │   ├── models/            # 데이터 모델
│   │   │   │   └── auth_model.dart
│   │   │   └── repositories/      # 데이터 저장소
│   │   │       └── auth_repository.dart
│   │   └── presentation/          # UI 레이어
│   │       ├── bloc/              # 상태 관리
│   │       │   ├── auth_bloc.dart
│   │       │   ├── auth_event.dart
│   │       │   └── auth_state.dart
│   │       └── pages/             # 화면
│   │           ├── splash_page.dart
│   │           └── login_page.dart
│   ├── home/                      # 홈 화면
│   ├── main/                      # 메인 화면 (하단 탭)
│   ├── work_diary/                # 업무일지
│   ├── shopping/                  # 쇼핑몰
│   └── mypage/                    # 마이페이지
│
└── main.dart                      # 앱 진입점
```

### 레이어 구조 설명

#### 1. **Core 레이어**
- 모든 기능에서 공통으로 사용하는 코드
- 네트워크, 라우팅, 저장소 등 인프라 코드

#### 2. **Features 레이어**
- 각 기능별로 독립적인 모듈
- `data`: 데이터 모델과 저장소 (서버 통신, 로컬 저장)
- `presentation`: UI와 상태 관리 (화면, Bloc)

---

## Bloc 패턴 기초

### Bloc이란?

**Bloc (Business Logic Component)**는 Flutter의 상태 관리 패턴입니다.

```
사용자 액션 (Event) 
    ↓
Bloc (비즈니스 로직 처리)
    ↓
상태 변경 (State)
    ↓
UI 업데이트
```

### Bloc의 3가지 핵심 요소

#### 1. **Event (이벤트)**
- 사용자가 발생시키는 액션
- 예: "로그인 버튼 클릭", "로그아웃 버튼 클릭"

#### 2. **Bloc (블록)**
- Event를 받아서 비즈니스 로직을 처리
- State를 변경하여 UI에 알림

#### 3. **State (상태)**
- 앱의 현재 상태
- 예: "로딩 중", "로그인 완료", "에러 발생"

### 간단한 예시

```dart
// Event: 로그인 요청
class LoginButtonPressed extends AuthEvent {
  final String email;
  final String password;
}

// Bloc: 로그인 처리
void _onLogin(LoginButtonPressed event, Emitter<AuthState> emit) {
  emit(AuthLoading());  // 1. 로딩 상태로 변경
  // 2. 로그인 API 호출
  // 3. 성공 시 AuthAuthenticated(), 실패 시 AuthError() emit
}

// State: 현재 상태
class AuthLoading extends AuthState {}  // 로딩 중
class AuthAuthenticated extends AuthState {}  // 로그인 완료
```

---

## 상태관리 흐름 상세 가이드

### 인증(Authorization) 상태관리 예시

이 프로젝트의 인증 기능을 통해 Bloc 패턴을 자세히 설명합니다.

#### 1. Event 정의 (`auth_event.dart`)

Event는 사용자의 액션을 나타냅니다.

```dart
// 추상 클래스: 모든 Event의 부모
abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

// 구체적인 Event들
class AuthInit extends AuthEvent {
  // 앱 시작 시 자동 로그인 확인
}

class AuthGetToken extends AuthEvent {
  // 서버에서 토큰 가져오기
}

class AuthLogin extends AuthEvent {
  final String token;
  final bool autoLogin;
  // 로그인 요청
}

class AuthLogout extends AuthEvent {
  // 로그아웃 요청
}
```

**Event를 만드는 이유:**
- 사용자의 모든 액션을 명확하게 정의
- Bloc이 어떤 작업을 해야 하는지 알 수 있음

#### 2. State 정의 (`auth_state.dart`)

State는 앱의 현재 상태를 나타냅니다.

```dart
// 추상 클래스: 모든 State의 부모
abstract class AuthState extends Equatable {
  const AuthState();
}

// 구체적인 State들
class AuthInitial extends AuthState {
  // 초기 상태 (아무것도 하지 않음)
}

class AuthLoading extends AuthState {
  // 로딩 중 (API 호출 중)
}

class AuthAuthenticated extends AuthState {
  final AuthModel authModel;
  // 로그인 완료 (인증된 상태)
}

class AuthUnauthenticated extends AuthState {
  // 로그인 안 된 상태
}

class AuthError extends AuthState {
  final String message;
  // 에러 발생
}
```

**State를 만드는 이유:**
- UI가 현재 상태에 따라 다르게 보여야 함
- 예: 로딩 중이면 로딩 스피너, 에러면 에러 메시지

#### 3. Bloc 구현 (`auth_bloc.dart`)

Bloc은 Event를 받아서 State를 변경합니다.

```dart
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  // 생성자: 초기 상태 설정 및 Event 핸들러 등록
  AuthBloc(this._authRepository) : super(const AuthInitial()) {
    // Event가 발생하면 어떤 함수를 실행할지 등록
    on<AuthInit>(_onAuthInit);
    on<AuthGetToken>(_onAuthGetToken);
    on<AuthLogin>(_onAuthLogin);
    on<AuthLogout>(_onAuthLogout);
  }

  // AuthInit Event 처리
  Future<void> _onAuthInit(AuthInit event, Emitter<AuthState> emit) async {
    // 1. 로딩 상태로 변경
    emit(const AuthLoading());
    
    // 2. 자동 로그인 확인
    final autoLoginEnabled = await _authRepository.checkAutoLogin();
    
    // 3. 결과에 따라 State 변경
    if (autoLoginEnabled) {
      add(const AuthAutoLogin());  // 자동 로그인 Event 발생
    } else {
      emit(const AuthUnauthenticated());  // 로그인 안 된 상태
    }
  }
}
```

**핵심 개념:**
- `on<EventType>(handler)`: Event 타입에 따라 실행할 함수 등록
- `emit(newState)`: 새로운 State를 발행하여 UI에 알림
- `add(newEvent)`: 다른 Event를 발생시켜 추가 작업 수행

#### 4. UI에서 사용 (`login_page.dart`)

UI는 Bloc의 State를 구독하고, Event를 발생시킵니다.

```dart
class LoginPage extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      // State가 변경될 때마다 실행
      listener: (context, state) {
        if (state is AuthLoading) {
          // 로딩 중: 로딩 표시
        } else if (state is AuthAuthenticated) {
          // 로그인 성공: 메인 화면으로 이동
          context.go('/home');
        } else if (state is AuthError) {
          // 에러: 에러 메시지 표시
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        body: ElevatedButton(
          onPressed: () {
            // Event 발생: 로그인 요청
            context.read<AuthBloc>().add(const AuthGetToken());
          },
          child: Text('로그인'),
        ),
      ),
    );
  }
}
```

**핵심 개념:**
- `BlocListener`: State 변경을 감지하여 작업 수행 (네비게이션, 스낵바 등)
- `BlocBuilder`: State에 따라 UI를 다르게 렌더링
- `context.read<AuthBloc>()`: Bloc 인스턴스 가져오기
- `.add(event)`: Event 발생시키기

---

## 앱 실행 흐름

### 1. 앱 시작 (`main.dart`)

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. 환경 설정 로드 (.env.dev, .env.stage, .env.prod)
  await EnvConfig.loadEnv('dev');
  
  // 2. 앱 실행
  runApp(const HyotalkApp());
}
```

### 2. 앱 초기화 (`HyotalkApp`)

```dart
class _HyotalkAppState extends State<HyotalkApp> {
  late final AuthBloc _authBloc;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    
    // 1. AuthBloc 생성 (상태 관리자)
    _authBloc = AuthBloc(AuthRepository(DioClient()));
    
    // 2. GoRouter 생성 (라우팅)
    _router = AppRouter.createRouter(_authBloc);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      // 3. Bloc을 앱 전체에 제공
      providers: [BlocProvider.value(value: _authBloc)],
      child: MaterialApp.router(
        routerConfig: _router,
      ),
    );
  }
}
```

**왜 StatefulWidget을 사용하나요?**
- Hot Reload 시마다 Bloc과 Router가 재생성되는 것을 방지
- `initState`에서 한 번만 생성하여 앱이 재시작되는 것처럼 보이는 현상 방지

### 3. 스플래시 화면 (`splash_page.dart`)

```dart
class SplashPage extends StatefulWidget {
  @override
  void initState() {
    super.initState();
    // AuthInit Event 발생 → 자동 로그인 확인
    context.read<AuthBloc>().add(const AuthInit());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          // 로그인 완료 → 홈으로
          context.go('/home');
        } else if (state is AuthUnauthenticated) {
          // 로그인 안 됨 → 로그인 화면으로
          context.go('/login');
        }
      },
      child: Scaffold(/* 스플래시 UI */),
    );
  }
}
```

**흐름:**
1. 앱 시작 → SplashPage 표시
2. `AuthInit` Event 발생
3. Bloc이 자동 로그인 확인
4. State 변경에 따라 화면 이동

### 4. 로그인 화면 (`login_page.dart`)

```dart
class LoginPage extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          // 로딩 중 표시
        } else if (state is AuthAuthenticated) {
          // 로그인 성공 → 홈으로
          context.go('/home');
        } else if (state is AuthError) {
          // 에러 메시지 표시
        }
      },
      child: Scaffold(
        body: ElevatedButton(
          onPressed: () {
            // 로그인 버튼 클릭
            context.read<AuthBloc>().setAutoLoginFlag(_autoLogin);
            context.read<AuthBloc>().add(const AuthGetToken());
          },
          child: Text('로그인'),
        ),
      ),
    );
  }
}
```

**흐름:**
1. 사용자가 "로그인" 버튼 클릭
2. `AuthGetToken` Event 발생
3. Bloc이 서버에서 토큰 가져오기
4. 토큰으로 로그인 처리
5. `AuthAuthenticated` State 발행
6. Listener가 감지하여 홈으로 이동

### 5. 메인 화면 (`main_page.dart`)

```dart
class MainPage extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        // 탭 페이지들 (홈, 업무일지, 쇼핑몰)
        controller: _pageController,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        // 하단 탭바
        selectedIndex: _currentIndex,
        onDestinationSelected: _onDestinationSelected,
      ),
    );
  }
}
```

---

## 상태관리 흐름 다이어그램

### 로그인 프로세스

```
[UI: LoginPage]
    |
    | 사용자가 "로그인" 버튼 클릭
    |
    v
[Event: AuthGetToken 발생]
    |
    | context.read<AuthBloc>().add(AuthGetToken())
    |
    v
[Bloc: AuthBloc]
    |
    | _onAuthGetToken() 실행
    | 1. emit(AuthLoading())  ← UI에 로딩 표시
    | 2. 서버에서 토큰 가져오기
    | 3. 토큰으로 로그인
    | 4. emit(AuthAuthenticated())  ← UI에 로그인 완료 알림
    |
    v
[State: AuthAuthenticated]
    |
    | BlocListener가 감지
    |
    v
[UI: LoginPage의 listener]
    |
    | context.go('/home')  ← 홈으로 이동
    |
    v
[UI: MainPage (홈 화면)]
```

### 자동 로그인 프로세스

```
[앱 시작]
    |
    v
[SplashPage]
    |
    | AuthInit Event 발생
    |
    v
[Bloc: AuthBloc]
    |
    | _onAuthInit() 실행
    | 1. emit(AuthLoading())
    | 2. checkAutoLogin() 확인
    |    - true: AuthAutoLogin Event 발생
    |    - false: emit(AuthUnauthenticated())
    |
    v
[State 변경]
    |
    | BlocListener가 감지
    |
    v
[화면 이동]
    - AuthAuthenticated → /home
    - AuthUnauthenticated → /login
```

---

## 주요 기능 설명

### 1. 인증 시스템

#### 토큰 기반 인증
1. 서버에서 토큰 가져오기 (`getTokenFromServer`)
2. 토큰으로 로그인 (`loginWithToken`)
3. 토큰을 Secure Storage에 저장
4. 이후 API 호출 시 자동으로 토큰 포함

#### 자동 로그인
1. 로그인 시 "자동 로그인" 체크박스 선택
2. `PreferenceStorage`에 `autoLogin = true` 저장
3. 다음 앱 실행 시 자동으로 로그인 처리

### 2. 네트워크 통신

#### DioClient
- 모든 HTTP 요청을 처리하는 클라이언트
- 인터셉터로 자동 토큰 주입
- 401 에러 시 자동 로그아웃

#### 테스트 모드
- `TEST_MODE=true` 또는 `BASE_URL`이 비어있으면 Mock 데이터 사용
- 실제 서버 없이도 앱 테스트 가능

### 3. 라우팅

#### GoRouter
- 선언적 라우팅 (경로 기반)
- 인증 상태에 따른 자동 리다이렉트
- ShellRoute로 하단 탭 네비게이션 구현

#### 페이지 전환 애니메이션
- 스플래시/로그인 → 메인: Fade in/out
- 탭 간 이동: PageView로 자연스러운 페이징

### 4. 데이터 저장

#### SecureStorage
- 토큰 등 민감한 정보 저장
- 암호화된 저장소 사용

#### PreferenceStorage
- autoLogin 등 일반 설정 저장
- SharedPreferences 사용

---

## Bloc 패턴 핵심 정리

### 1. Event → Bloc → State 흐름

```
사용자 액션
    ↓
Event 발생 (add)
    ↓
Bloc이 Event 처리
    ↓
State 변경 (emit)
    ↓
UI 업데이트
```

### 2. Bloc 사용 방법

#### Event 발생
```dart
context.read<AuthBloc>().add(AuthGetToken());
```

#### State 구독
```dart
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    // State 변경 시 실행
  },
  child: Widget(),
)

BlocBuilder<AuthBloc, AuthState>(
  builder: (context, state) {
    // State에 따라 UI 렌더링
    if (state is AuthLoading) {
      return CircularProgressIndicator();
    }
    return Text('완료');
  },
)
```

### 3. Bloc 생성과 제공

```dart
// 1. Bloc 생성
final authBloc = AuthBloc(AuthRepository(DioClient()));

// 2. 앱 전체에 제공
MultiBlocProvider(
  providers: [BlocProvider.value(value: authBloc)],
  child: MaterialApp(...),
)

// 3. 사용
context.read<AuthBloc>()  // Bloc 가져오기
```

---

## 실전 예제: 로그인 기능 구현

### 1단계: Event 정의

```dart
// auth_event.dart
class AuthGetToken extends AuthEvent {
  const AuthGetToken();
}
```

### 2단계: State 정의

```dart
// auth_state.dart
class AuthLoading extends AuthState {}
class AuthAuthenticated extends AuthState {
  final AuthModel authModel;
}
class AuthError extends AuthState {
  final String message;
}
```

### 3단계: Bloc 구현

```dart
// auth_bloc.dart
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthGetToken>(_onAuthGetToken);
  }

  Future<void> _onAuthGetToken(
    AuthGetToken event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());  // 로딩 시작
    
    try {
      // API 호출
      final token = await repository.getToken();
      final authModel = await repository.login(token);
      
      emit(AuthAuthenticated(authModel));  // 성공
    } catch (e) {
      emit(AuthError(e.toString()));  // 실패
    }
  }
}
```

### 4단계: UI에서 사용

```dart
// login_page.dart
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is AuthAuthenticated) {
      context.go('/home');  // 로그인 성공 시 이동
    } else if (state is AuthError) {
      showError(state.message);  // 에러 표시
    }
  },
  child: ElevatedButton(
    onPressed: () {
      context.read<AuthBloc>().add(AuthGetToken());  // Event 발생
    },
    child: Text('로그인'),
  ),
)
```

---

## 자주 묻는 질문 (FAQ)

### Q1: 왜 Event와 State를 분리하나요?

**A:** 명확한 책임 분리
- Event: "무엇을 할 것인가" (사용자 액션)
- State: "현재 상태는 무엇인가" (앱 상태)

### Q2: emit()과 add()의 차이는?

**A:**
- `emit(newState)`: State를 변경하여 UI에 알림
- `add(newEvent)`: 새로운 Event를 발생시켜 추가 작업 수행

### Q3: BlocListener와 BlocBuilder의 차이는?

**A:**
- `BlocListener`: State 변경 시 작업 수행 (네비게이션, 스낵바 등)
- `BlocBuilder`: State에 따라 UI를 다르게 렌더링

### Q4: 왜 Repository를 사용하나요?

**A:** 데이터 소스 추상화
- Bloc은 비즈니스 로직에만 집중
- Repository가 실제 데이터 가져오기 처리 (API, 로컬 저장소 등)
- 테스트 시 Repository를 Mock으로 교체 가능

---

## 참고 자료

- [Flutter Bloc 공식 문서](https://bloclibrary.dev/)
- [GoRouter 공식 문서](https://pub.dev/packages/go_router)
- [Dio 공식 문서](https://pub.dev/packages/dio)

---

## 프로젝트 실행 방법

### 개발 환경 실행
```bash
flutter run --flavor dev -t lib/main.dart --dart-define=FLAVOR=dev
```

### 패키지 설치
```bash
flutter pub get
```

### 환경 파일 설정
프로젝트 루트에 `.env.dev`, `.env.stage`, `.env.prod` 파일 생성 필요

---

**작성일**: 2024년
**버전**: 1.0.0

