## Navigation / Deep Link 문서

이 폴더는 **외부에서 들어오는 링크(딥링크/앱링크/푸시 payload 등)** 를 앱 내부 라우트(`/...`)로 통일하고, **콜드/웜 스타트 상황에서 올바른 스택(go/push)으로 화면을 여는** 공통 로직을 모아둡니다.

### 구성요소

- **`deep_link_normalizer.dart`**
  - 외부 링크(`hyotalk://...`, `https://...`, 또는 `/album/1` 같은 내부 경로 문자열)를 **go_router location(`/...`)** 으로 정규화합니다.
  - 커스텀 스킴을 go_router가 직접 파싱하다가 깨질 수 있는 이슈를 피하기 위해, 앱 내부에서는 **항상 `/...` location** 을 사용하도록 강제합니다.

- **`deep_link_controller.dart`**
  - `app_links`로부터 들어오는 링크 이벤트를 수신합니다.
  - **cold start**: 링크를 바로 열지 않고 `pendingDeepLinkLocation`에 저장 → `/splash`로 이동(인증 플로우를 거치게).
  - **warm start**: 로그인 상태에 따라 즉시 push/go 하거나, 미로그인이라면 pending 저장 후 `/login`으로 보냅니다.
  - 앨범/업무일지/공지 상세 등은 “베이스 탭을 먼저 선택 → 상세 push” 형태로 스택을 보장합니다.

- **`nav_stack_helper.dart`**
  - `go_router`에서 **뒤로가기 스택을 보장**하기 위한 최소 helper입니다.
  - `goLoginThenPush`: login을 바닥에 깔고 push(초대 링크 요구사항: back → login).
  - `goBaseThenPush`: location에 맞는 베이스 탭(`/home`, `/album`, `/work-diary`)을 go로 깔고, 그 위에 상세 location을 push.

---

## 전체 흐름(요약)

### 1) App 시작(main)

- `main.dart`에서 `DeepLinkController`를 생성하고 `init()`으로 링크 수신을 시작합니다.

### 2) cold start 딥링크 (앱 완전 종료 상태에서 링크로 실행)

- `DeepLinkController.getInitialLink()` 수신
- `DeepLinkNormalizer.normalize(uri)` → 내부 location(`/...`) 생성
- `pendingDeepLinkLocation`에 저장
- 라우터를 `/splash`로 보냄
- `SplashPage`가 인증 상태 확정 후:
  - 로그인 상태: `NavStackHelper.goBaseThenPush(context, pending)` (예: `/album` go 후 `/album/1` push)
  - 미로그인 + 초대: `NavStackHelper.goLoginThenPush(context, inviteLocation)` (login go 후 invite push)
  - 미로그인 + 보호 컨텐츠: pending 유지 후 `/login` 이동 (로그인 성공 후 처리)

### 3) warm start 딥링크 (앱 실행 중/백그라운드에서 링크 유입)

- `DeepLinkController.uriLinkStream` 수신
- 로그인 상태:
  - 탭 루트면 `go(location)`
  - 상세면 “베이스 탭 go → 상세 push” (앨범/업무일지/공지 상세는 base를 강제)
- 미로그인 상태:
  - 초대 링크: `go('/login')` 후 invite `push`
  - 보호 컨텐츠: pending 저장 후 `go('/login')` (로그인 성공 후 처리)

---

## 내부 라우트 규칙(중요)

- 앱 내부 이동은 **항상 `/...` location** 기반으로 처리합니다.
- 초대 링크는 `AppRouterPath.inviteRegister`(예: `/invite-register`)로 정규화됩니다.
- 앨범/업무일지 상세는 `/album/:id`, `/work-diary/:id`
- 공지 상세는 `/notice/:id` 이며, 상세 진입 시 **home 탭을 베이스**로 깔도록 처리합니다.

---

## 테스트 방법

### A) Android (에뮬레이터/실기기)

#### 1) 커스텀 스킴 딥링크 실행

```bash
adb shell am start -a android.intent.action.VIEW -d "hyotalk://album/1"
```

기대 동작(로그인 상태 기준):
- **앨범 탭이 선택되고**(`/album`), **앨범 상세(1)** 이 push로 열린다.
- 뒤로가기(back) → **앨범 탭**으로 돌아온다.

업무일지:

```bash
adb shell am start -a android.intent.action.VIEW -d "hyotalk://work-diary/1"
```

공지:

```bash
adb shell am start -a android.intent.action.VIEW -d "hyotalk://notice/1"
```

기대:
- 베이스는 **home 탭**(`/home`)이 깔리고, 공지 상세가 push로 열린다.
- 뒤로가기 → home 탭

#### 2) 콜드 스타트 테스트 팁
- 앱을 “최근 앱”에서 제거(완전 종료)한 뒤 위 명령을 실행합니다.
- 스플래시 2초 이후, 인증 상태에 따라 login/home 흐름이 탄 뒤 목적 화면으로 이동해야 합니다.

---

### B) iOS (시뮬레이터/실기기)

```bash
xcrun simctl openurl booted "hyotalk://album/1"

실기기는 웹브라우저에서 "hyotalk://album/1" 실행 
```

콜드 스타트 테스트:
- 앱을 완전히 종료한 뒤 위 명령 실행

---

## 자주 보는 체크 포인트

- **뒤로가기 버튼이 없다/뒤로가면 앱이 종료된다**
  - 상세 진입이 `go()`로만 처리되어 스택이 없을 가능성이 큼
  - 상세는 “베이스 go + 상세 push” 패턴으로 열려야 함 (`NavStackHelper.goBaseThenPush` 계열)

- **같은 링크가 두 번 처리된다**
  - Android에서 `getInitialLink`와 `uriLinkStream`이 같은 링크를 중복으로 주는 케이스가 있어,
    `DeepLinkController`는 `_lastHandledLink`로 1차 중복 방지를 한다.


