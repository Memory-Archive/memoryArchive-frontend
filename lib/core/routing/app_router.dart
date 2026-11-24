import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/cubit/forgot_password_cubit.dart';
import '../../features/auth/presentation/cubit/login_cubit.dart';
import '../../features/auth/presentation/cubit/register_cubit.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/memories/presentation/screens/create_memory_screen.dart';
import '../../features/memories/presentation/screens/edit_memory_screen.dart';
import '../../features/memories/presentation/screens/memory_details_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/places/presentation/screens/place_details_screen.dart';
import '../../features/places/presentation/screens/place_form_screen.dart';
import '../../features/places/presentation/screens/places_screen.dart';
import '../../features/places/presentation/screens/then_now_screen.dart';
import '../../features/profile/presentation/screens/drafts_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/profile/presentation/screens/favourites_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/settings/presentation/cubit/settings_cubit.dart';
import '../../features/settings/presentation/screens/app_lock_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/splash/presentation/cubit/splash_cubit.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/timeline/presentation/screens/timeline_screen.dart';
import '../di/injection.dart';
import '../session/session_manager.dart';
import 'app_routes.dart';

/// All routes, plus the redirect that decides between logged-out and
/// logged-in screens.
///
/// The router listens to [SessionManager]. When the session changes (app
/// start check finished, logged in, logged out, refresh token rejected), the
/// redirect runs again and moves the user to the right place.
class AppRouter {
  AppRouter(this._session) {
    router = GoRouter(
      initialLocation: AppRoutes.splash,
      refreshListenable: _session,
      redirect: _redirect,
      routes: _routes,
    );
  }

  final SessionManager _session;
  late final GoRouter router;

  String? _redirect(BuildContext context, GoRouterState state) {
    final location = state.matchedLocation;
    final loggedOutRoute = AppRoutes.loggedOutRoutes.contains(location);

    switch (_session.status) {
      case SessionStatus.unknown:
        // Still checking the saved session: stay on the splash.
        return location == AppRoutes.splash ? null : AppRoutes.splash;
      case SessionStatus.unauthenticated:
        if (location == AppRoutes.splash) {
          return _session.onboardingSeen ? AppRoutes.login : AppRoutes.onboarding;
        }
        return loggedOutRoute ? null : AppRoutes.login;
      case SessionStatus.authenticated:
        if (location == AppRoutes.splash || loggedOutRoute) return AppRoutes.home;
        return null;
    }
  }

  static final List<RouteBase> _routes = [
    // Logged out.
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => BlocProvider(
        lazy: false,
        create: (_) => getIt<SplashCubit>()..start(),
        child: const SplashScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => BlocProvider(
        create: (_) => getIt<LoginCubit>(),
        child: const LoginScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) => BlocProvider(
        create: (_) => getIt<RegisterCubit>(),
        child: const RegisterScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      builder: (context, state) => BlocProvider(
        create: (_) => getIt<ForgotPasswordCubit>(),
        child: const ForgotPasswordScreen(),
      ),
    ),

    // Main tabs.
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => BlocProvider(
        create: (_) => getIt<HomeCubit>()..load(),
        child: const HomeScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.timeline,
      builder: (context, state) => const TimelineScreen(),
    ),
    GoRoute(
      path: AppRoutes.places,
      builder: (context, state) => const PlacesScreen(),
    ),
    GoRoute(
      path: AppRoutes.profile,
      builder: (context, state) => const ProfileScreen(),
    ),

    // Memories. `/memories/new` must come before `/memories/:memoryId`.
    GoRoute(
      path: AppRoutes.createMemory,
      builder: (context, state) => const CreateMemoryScreen(),
    ),
    GoRoute(
      path: AppRoutes.editMemory,
      builder: (context, state) =>
          EditMemoryScreen(memoryId: state.pathParameters['memoryId'] ?? ''),
    ),
    GoRoute(
      path: AppRoutes.memoryDetails,
      builder: (context, state) =>
          MemoryDetailsScreen(memoryId: state.pathParameters['memoryId'] ?? ''),
    ),

    // Places. `/places/new` must come before `/places/:placeId`.
    GoRoute(
      path: AppRoutes.addPlace,
      builder: (context, state) => const PlaceFormScreen(),
    ),
    GoRoute(
      path: AppRoutes.editPlace,
      builder: (context, state) => PlaceFormScreen(placeId: state.pathParameters['placeId']),
    ),
    GoRoute(
      path: AppRoutes.thenNow,
      builder: (context, state) =>
          ThenNowScreen(placeId: state.pathParameters['placeId'] ?? ''),
    ),
    GoRoute(
      path: AppRoutes.placeDetails,
      builder: (context, state) =>
          PlaceDetailsScreen(placeId: state.pathParameters['placeId'] ?? ''),
    ),

    // Profile and settings.
    GoRoute(
      path: AppRoutes.editProfile,
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: AppRoutes.favourites,
      builder: (context, state) => const FavouritesScreen(),
    ),
    GoRoute(
      path: AppRoutes.drafts,
      builder: (context, state) => const DraftsScreen(),
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (context, state) => BlocProvider(
        create: (_) => getIt<SettingsCubit>(),
        child: const SettingsScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.appLock,
      builder: (context, state) => const AppLockScreen(),
    ),
  ];
}
