# Memories Archive: Flutter app (semester 1)

The Flutter client for Memories Archive. It talks to the Express backend
(`Memory-Archive/memoryArchive-backend`, folder `backend-express-ts`). Its API
contract matches the backend documentation (Semester 1, PR #4,
21 November 2026).

## What's built

| Screen | Status |
| --- | --- |
| Splash | Done. Checks the saved login and opens Home if you're still logged in |
| Onboarding (3 pages) | Done. Shown on first launch only |
| Log in | Done. `POST /auth/login`, fields checked as you type |
| Create account | Done. `POST /auth/signup`, then logs in automatically |
| Forgot password | Done. `POST /auth/forgot-password`; the backend returns 501 this semester, so the screen says "Not available yet" |
| Home | Done. Greeting, On this day (once the backend has the route), recent memories (`GET /memories`) |
| Profile | Partly: shows the logged-in user; stats and memory grid later |
| Settings | Partly: **Log out works** (`POST /auth/logout`); other rows are placeholders |
| Timeline, Places, Place details, Add/edit place, Then & Now, New memory, Memory details, Edit memory, Edit profile, Favourites, Drafts, App lock | Placeholder screens. The routes and links work; each screen says what it will do |

## First-time setup

This repository has the Dart code, tests and config. Generate the platform
folders on your machine once:

```bash
# 1. Platform folders (keeps lib/, test/, pubspec.yaml as they are)
flutter create . --project-name memories_archive --platforms=android,ios,web

# 2. Packages
flutter pub get

# 3. Run without a backend (fake data)
flutter run --dart-define=USE_MOCK=true
```

Needs Flutter 3.32 or newer (Dart 3.8). There's **no code generation step**:
models and states are plain Dart, so `build_runner` isn't needed.

### Photos

Put your photos in `assets/images/` with the names listed in
`assets/images/README.md`. Until you do, the app shows grey placeholder boxes
with the file name, so it still runs.

## Running against the real backend

1. Start the backend (see its documentation): MySQL with `memory_archive`
   imported, `npm run dev` in `backend-express-ts`.
   `http://localhost:3000/health` must return `{ "status": "ok" }`.
2. Run the app:

| Where the app runs | Command | API address it uses |
| --- | --- | --- |
| Android emulator | `flutter run` | `http://10.0.2.2:3000` (the computer running the emulator) |
| iOS simulator | `flutter run` | `http://localhost:3000` |
| Chrome (web) | `flutter run -d chrome --web-port 5000` | `http://localhost:3000` |
| Real phone on the same Wi-Fi | `flutter run --dart-define=API_BASE_URL=http://192.168.1.20:3000` | Your computer's IP address |

The app never connects to MySQL itself. It only calls the backend's API; the
backend reads and writes the database.

### One-time platform settings for `http://` on your computer

The local backend uses plain `http://`, which phones block by default.

**Android:** in `android/app/src/main/AndroidManifest.xml`, add this attribute
to the `<application>` tag (debug and development only; remove it once the
backend uses HTTPS):

```xml
<application
    android:usesCleartextTraffic="true"
    ...>
```

Real Android phones and emulators also need
`<uses-permission android:name="android.permission.INTERNET"/>` in the same
file (above `<application>`). `flutter create` adds it to the debug manifest only.

**iOS:** in `ios/Runner/Info.plist`, inside the main `<dict>`:

```xml
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsLocalNetworking</key>
  <true/>
</dict>
```

**Web:** the backend only accepts browser requests from `CORS_ORIGIN`. Set it
in the backend's `.env` to the address the app runs on, then restart the
backend:

```env
CORS_ORIGIN=http://localhost:5000
```

## Staying logged in

When you log in, the access token, refresh token and user are saved in secure
storage (Keychain on iOS, encrypted storage on Android). On the next launch,
the splash screen:

1. reads the saved refresh token and calls `POST /auth/refresh`;
2. on success, saves the new pair of tokens and opens **Home** directly;
3. if the server can't be reached, it still opens Home with the saved user and
   refreshes later;
4. if the token is expired, revoked or reused, it clears everything and shows
   **Log in**.

While you use the app, an expired access token (15 minutes) gets a 401. The
`AuthInterceptor` then refreshes once and repeats the request. It's a queued
interceptor, so several requests failing together cause only one refresh. This
matters because the backend logs you out everywhere if an old refresh token is
used twice.

## Backend contract

These match the backend documentation for PR #4.

| Topic | What the app does |
| --- | --- |
| Base URL | `http://<host>:3000`, with **no `/api` prefix**. Paths start at `/`, for example `/auth/login` |
| Success body | `{ "message": "...", "data": ... }`. The app reads `data` |
| Error body | `{ "message": "...", "details": [{ "location", "path", "message" }] }`. Each `path` becomes a field error shown under that form field |
| Sign up | `POST /auth/signup` with `username`, `email`, `password`. Returns 201 with the user and **no tokens**, so the app calls `POST /auth/login` right after |
| Log in | `POST /auth/login` with `email`, `password`, `deviceName`. Returns the user, `accessToken` and `refreshToken` |
| Refresh | `POST /auth/refresh` with `refreshToken`. Returns a new pair; the old refresh token stops working (rotation) |
| Log out | `POST /auth/logout` with `refreshToken`. Always 200 |
| Auth header | `Authorization: Bearer <accessToken>` on every request except `/auth/...` |
| Password | 8 to 128 characters (checked on Create account only; Log in only checks it isn't empty) |
| Username | 3 to 30 characters: letters, numbers, `_` and `.` |
| Email | Trimmed and lowercased before sending, as the backend stores it |
| 401 on log in | "Email or password is incorrect." (the backend uses one message for both, on purpose) |
| 403 on log in | "This account has been disabled." |
| 409 on sign up | Shown under the email or username field |
| 501 | Treated as "not available yet", never as a crash (forgot password, memories, `/users/me`) |

Endpoint paths are all in `lib/core/constants/api_endpoints.dart`.

### Checked against the backend code

The auth wiring was checked against `Memory-Archive/memoryArchive-backend` at
the merge of PR #4 (`d3a4cde`):

- `POST /auth/signup` returns 201 `{ message: "Account created", data: { user } }`.
- `POST /auth/login` returns `data: { user, tokenType, accessToken,
  accessTokenExpiresIn, refreshToken, refreshTokenExpiresAt }`.
- `POST /auth/refresh` returns the same token fields (no user).
- The user object has `id`, `username`, `email`, `displayName`, `bio`,
  `status` and the timestamps; `passwordHash` is never sent.
- Validation errors are 400 with `details[].path` as the field name. The 409 on
  signup says "Email is already registered" or "Username is already taken";
  the app shows it under that field.
- CORS allows exactly one origin (`CORS_ORIGIN`), and the server listens on
  every network interface, so a real phone on the same Wi-Fi can reach it.

### Still open with the backend

- **`GET /users/me` returns 501.** The app uses the user returned at log in
  and caches it. Switch to `/users/me` once it's built.
- **`GET /memories` returns 501.** Home shows "Memories are coming soon"
  until it works. The app sends `GET /memories?limit=3`, which the backend's
  query rules accept (`page`, `limit` 1–100).
- **There's no `GET /memories/on-this-day` route** (it's on the backend to-do
  list). The app doesn't call it yet; see `getOnThisDay()` in
  `memories_remote_data_source.dart` to switch it on.
- **Rate limiting on log in** isn't on yet (backend). The app already shows a
  429 as "Too many attempts".

## Mock mode

`flutter run --dart-define=USE_MOCK=true` uses fake data sources that behave
like the backend, including its error bodies:

- any email and password log in, except `wrong@example.com` (shows "Email or
  password is incorrect.");
- signing up with `taken@example.com` shows "This email is already registered"
  under the email field;
- forgot password shows "Not available yet" (501, like the real backend);
- Home shows sample memories (photos from `assets/images/sample_memory_*.jpg`).

## Checks

```bash
flutter analyze
flutter test
```

## Folder structure

```
lib/
  main.dart, app.dart
  core/
    constants/   env (dart-define), API endpoints, storage keys, strings, asset paths
    di/          get_it registrations: the composition root
    helpers/     date formatting, form status
    networking/  Dio factory, auth interceptor, ApiResult<T>, ApiError, safeApiCall, JSON helpers
    routing/     route paths and the go_router config with the login redirect
    session/     AppUser and SessionManager (who is logged in)
    storage/     TokenStorage (secure storage)
    themes/      colours, text styles, spacing, ThemeData
    validation/  Validators with the backend's input rules
    widgets/     buttons, text field, images and placeholders, bottom nav, state views
  features/
    auth/        log in, create account, forgot password (data, domain, presentation)
    splash/      splash screen and session check
    onboarding/  the three intro pages
    home/        Home screen
    memories/    memory entity, repository and data sources; placeholder screens
    places/      placeholder screens
    timeline/    placeholder screen
    profile/     profile; placeholder edit profile, favourites, drafts
    settings/    settings with log out; placeholder app lock
```

Each feature has up to three layers:

```
features/<feature>/
  presentation/  screens/, widgets/, cubit/
  domain/        entities/, repositories/ (abstract)
  data/          models/ (DTOs), data_sources/ (remote + mock), repositories/ (impl)
```

## Rules

1. **presentation → domain.** Screens and cubits use entities and repository
   interfaces, never DTOs, data sources or Dio.
2. **data → domain.** The data layer implements the repository interfaces and
   converts DTOs to entities.
3. **domain → nothing.** No Flutter, Dio or JSON. The only `core` imports
   allowed are `ApiResult`, `ApiError` and `AppUser` (all pure Dart).
4. **One Dio** for the whole app, from get_it. No feature creates its own.
5. **Feature to feature:** only through the other feature's domain layer
   (Home reads `MemoriesRepository`).
6. **`core/di` and `core/routing`** are the only `core` files that import from
   `features/`.
7. **Repositories never throw.** Every call goes through `safeApiCall` and
   returns `ApiResult<T>`. Data sources throw; repositories catch.
8. **Screens never navigate after log in or log out.** The repository updates
   `SessionManager`, and the router's redirect moves the user.
9. **No hardcoded styles.** Use `AppColors`, `AppTextStyles`, `AppGap`,
   `AppRadii` and `AppSizes`.
10. **Navigate with `AppRoutes`** constants, never string literals.
11. **Every list has loading, empty and error states** (`AppLoader`,
    `EmptyState`, `ErrorState`).
12. **Security:** tokens only in secure storage; request headers and bodies
    are never logged; `/auth/` requests aren't logged at all; logging is off
    in release builds.

## Adding a feature (example: Timeline)

1. **Domain:** reuse `Memory` or add an entity; add methods to the repository
   interface returning `Future<ApiResult<...>>`.
2. **Data:** a DTO with `fromJson` and `toEntity()`, the Dio data source, a
   mock data source, and the repository implementation using `safeApiCall`.
3. **Presentation:** a cubit with a sealed state (loading / loaded / failure),
   then replace the placeholder screen's body.
4. **Endpoint:** add the path to `ApiEndpoints`.
5. **DI:** register the data source (mock or real with `Env.useMock`), the
   repository (lazy singleton) and the cubit (factory) in `core/di/injection.dart`.
6. **Route:** wrap the screen in a `BlocProvider` in `app_router.dart`.
7. Run `flutter analyze` and `flutter test`.
