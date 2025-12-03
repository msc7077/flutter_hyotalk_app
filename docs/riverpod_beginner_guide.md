## Riverpod 3 입문 가이드 (Flutter 초보자용)

이 문서는 Flutter에서 Riverpod(3.x)을 처음 쓰는 분들을 위해 “왜 쓰는지, 어떻게 쓰는지”를 쉬운 예제와 함께 설명합니다. 이 가이드만 따라 해도 실전 앱에서 상태 관리와 의존성 주입을 무리 없이 적용할 수 있습니다.

---

### Riverpod 한 줄 요약
- 안전하고 테스트하기 쉬운 “상태 관리 + 의존성 주입” 도구
- 전역 싱글톤 없이 어디서나 상태를 읽고, 변경하고, 주입할 수 있게 해줍니다.

---

## 1) 설치와 기본 구성

### 의존성 추가
`pubspec.yaml`:
dependencies:
  flutter_riverpod: ^3.0.3### 앱 시작 파일
앱 전체를 `ProviderScope`로 감싸야 Provider를 사용할 수 있습니다.

// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}---

## 2) 위젯에서 Riverpod 쓰는 방법

위젯에서 `ref`를 쓰려면 아래 중 하나를 선택합니다.

- ConsumerWidget: Stateless한 느낌으로 간단할 때
- ConsumerStatefulWidget: 상태/라이프사이클 필요할 때
- Consumer: 기존 위젯 트리 안에서 일부만 감쌀 때

// ConsumerWidget
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider); // watch: 변경되면 재빌드
    return Text('Count: $count');
  }
}
// ConsumerStatefulWidget
class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});
  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    // ...
    return Container();
  }
}---

## 3) ref.read / ref.watch / ref.listen 차이

- ref.watch(provider): 상태 변경을 구독하며, 값이 바뀌면 위젯을 재빌드
- ref.read(provider): 현재 값만 한 번 읽음(재빌드 없음). 버튼 클릭 등 “한 번 실행”에 사용
- ref.listen(provider, (prev, next) { ... }): 사이드이펙트(스낵바, 네비게이션 등)에 사용. UI 리빌드 X

// watch: UI 표시용 데이터 구독
final auth = ref.watch(authProvider);

// read: 이벤트 핸들러에서 1회 호출
onPressed: () => ref.read(authProvider.notifier).logout();

// listen: 에러/성공 알림 등 사이드이펙트 처리
ref.listen<AuthState>(authProvider, (prev, next) {
  if (next.error != null) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.error!.message)));
  }
});---

## 4) Provider의 종류 (자주 쓰는 것만)

- Provider<T>: 순수 계산/의존성 제공용. 상태 변화 없음.
- StateProvider<T>: 간단한 가변 상태(카운터 등).
- Notifier/NotifierProvider: 구조화된 상태(클래스/모델)를 관리. 비동기/비즈니스 로직 포함에 적합.
- FutureProvider<T>: 비동기 “한 번”의 값을 UI에서 구독.
- StreamProvider<T>: 스트림을 구독.

프로젝트 규모가 커질수록 `Notifier/NotifierProvider`를 주로 사용하길 권장합니다(모델 상태 + 로직 + 에러/로딩).

---

## 5) Notifier/NotifierProvider로 상태 관리(권장)

### 상태 모델 정의
// auth_state.dart
class AuthState {
  final User? user;
  final bool isLoading;
  final AppException? error;

  const AuthState({this.user, this.isLoading = false, this.error});

  bool get isAuthenticated => user != null;

  AuthState copyWith({
    User? user,
    bool? isLoading,
    AppException? error,
    bool clearError = false,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}### Notifier 구현
// auth_notifier.dart
class AuthNotifier extends Notifier<AuthState> {
  late final AuthRepository _repo;

  @override
  AuthState build() {
    _repo = ref.read(authRepositoryProvider);
    return const AuthState(); // 초기 상태
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _repo.login(email, password);
      state = state.copyWith(user: user, isLoading: false);
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: UnknownException('알 수 없는 오류: $e', e));
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repo.logout();
      state = const AuthState();
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}### Provider 정의
// auth_provider.dart
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return MockAuthRepository(); // 나중에 실제 구현체로 교체
});

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});---

## 6) 비동기 상태 다루기: AsyncValue 패턴

`FutureProvider`/`StreamProvider`/`AsyncNotifier`를 쓰면 `AsyncValue<T>`를 받습니다. 3가지 상태를 한 번에 처리합니다.

- loading: 로딩 중
- data: 데이터 도착
- error: 오류 발생

final userFutureProvider = FutureProvider<User>((ref) async {
  return ref.read(api).fetchUser();
});

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncUser = ref.watch(userFutureProvider);
    return asyncUser.when(
      loading: () => const CircularProgressIndicator(),
      error: (e, st) => Text('에러: $e'),
      data: (user) => Text('안녕하세요, ${user.name}'),
    );
  }
}Tip: Notifier 안에서 직접 로딩/에러 플래그를 관리해도 됩니다(현재 프로젝트 방식). `AsyncValue`는 데이터를 가져오고 끝나는 단발성 비동기 작업에서 특히 편리합니다.

---

## 7) Provider 옵션: family / autoDispose

- family: 파라미터로 다른 인스턴스를 생성
final userProvider = FutureProvider.family<User, String>((ref, userId) async {
  return ref.read(api).fetchUser(userId);
});

ref.watch(userProvider('123'));- autoDispose: 사용하지 않으면 자동 폐기(메모리 절약, 단 재구독 시 다시 실행)
final tmpProvider = FutureProvider.autoDispose((ref) async {
  //...
});---

## 8) 의존성 주입(Repository, Service)와 DI 교체

final apiProvider = Provider<ApiService>((ref) => ApiService(baseUrl: '...'));

final repoProvider = Provider<UserRepository>((ref) {
  return UserRepository(api: ref.read(apiProvider));
});테스트나 다른 환경에서 override 가능:
ProviderScope(
  overrides: [
    apiProvider.overrideWithValue(MockApiService()),
  ],
  child: const MyApp(),
);---

## 9) 사이드 이펙트(스낵바, 라우팅) 처리: ref.listen

`watch`는 UI 리빌드용, `listen`은 “부수효과”용입니다.

ref.listen<AuthState>(authProvider, (prev, next) {
  if (next.error != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(next.error!.message)),
    );
    ref.read(authProvider.notifier).clearError();
  }
});---

## 10) 라우팅(GoRouter)과 함께 쓰기

- 라우터는 보통 Provider로 감싸서 상태 변화에 따라 재생성
- 인증 상태에 맞춰 `redirect`에서 진입 제한/이동

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authProvider);
  return GoRouter(
    routes: [
      GoRoute(path: '/', builder: (c, s) => const HomeView()),
      GoRoute(path: '/login', builder: (c, s) => const LoginView()),
    ],
    redirect: (context, state) {
      final isAuthed = auth.isAuthenticated;
      final loggingIn = state.matchedLocation == '/login';
      if (!isAuthed && !loggingIn) return '/login';
      if (isAuthed && loggingIn) return '/';
      return null;
    },
  );
});---

## 11) 성능과 구조 팁

- “필요한 곳에서만 watch”하세요. 상위 위젯에서 너무 많은 Provider를 watch하면 불필요한 재빌드가 커집니다.
- `select`로 필요한 부분만 구독:
final userName = ref.watch(authProvider.select((s) => s.user?.name));- 큰 모델은 `copyWith`로 변경(불변성 유지).
- Repository/Service는 Provider로 주입 → 테스트, 교체 용이.
- 사이드 이펙트는 `listen`에서 처리 → UI 빌드와 분리.

---

## 12) 자주 만나는 오류와 해결

- “No ProviderScope found”: `runApp(const ProviderScope(child: MyApp()))` 잊지 않았는지 확인
- “Tried to read a provider … that threw”: 의존성 그래프 순환 여부 확인, `override` 순서 확인
- “StateProvider/NotifierProvider is not defined”: import 경로 확인 `import 'package:flutter_riverpod/flutter_riverpod.dart';`
- 리빌드 안 됨: `read`로 값을 가져오면 재빌드가 안 됩니다. UI는 `watch`로 구독해야 함.

---

## 13) 간단 실습 예제 (카운터)

// 1) 상태
class CounterState {
  final int value;
  const CounterState(this.value);
  CounterState copyWith(int value) => CounterState(value);
}

// 2) 로직
class CounterNotifier extends Notifier<CounterState> {
  @override
  CounterState build() => const CounterState(0);

  void increment() => state = state.copyWith(state.value + 1);
}

// 3) Provider
final counterProvider = NotifierProvider<CounterNotifier, CounterState>(() {
  return CounterNotifier();
});

// 4) UI
class CounterView extends ConsumerWidget {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterProvider);
    return Column(
      children: [
        Text('Count: ${counter.value}'),
        ElevatedButton(
          onPressed: () => ref.read(counterProvider.notifier).increment(),
          child: const Text('+1'),
        ),
      ],
    );
  }
}---

## 14) 체크리스트

- 앱 최상단에 `ProviderScope` 있는가?
- UI는 `ref.watch`, 이벤트는 `ref.read`, 사이드이펙트는 `ref.listen`로 분리했는가?
- 비즈니스 로직은 `Notifier`(또는 `AsyncNotifier`)로 모았는가?
- Repository/Service는 Provider로 주입했는가?
- 라우팅은 상태(ref.watch) 기반으로 `redirect` 구성했는가?
- 에러/로딩 처리(AsyncValue/플래그)를 빼먹지 않았는가?

---

필요 시 이 문서를 프로젝트의 `docs/riverpod_beginner_guide.md`로 저장해 팀 온보딩 자료로 활용하세요. 처음에는 Provider/Notifier만 익혀도 충분합니다. 익숙해지면 `family`, `autoDispose`, `AsyncValue`, `overrides` 등 고급 기능을 단계적으로 적용해 보세요.
