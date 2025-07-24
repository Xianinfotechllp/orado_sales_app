// lib/config/router.dart
import 'package:demo/presentation/profile_review_screen/profile_review_screen.dart';
import 'package:demo/presentation/screens/auth/provider/login_reg_provider.dart';
import 'package:demo/presentation/screens/auth/view/login.dart';
import 'package:demo/presentation/screens/auth/view/reg.dart';
import 'package:demo/presentation/screens/chat_screen.dart';
import 'package:demo/presentation/screens/home/earnings/earnings.dart';
import 'package:demo/presentation/screens/home/home.dart';
import 'package:demo/presentation/screens/home/orders/view/orders.dart';
import 'package:demo/presentation/screens/main_screen.dart';
import 'package:demo/presentation/screens/prepare_order.dart';
import 'package:demo/presentation/splash_Screen/splash_screen.dart';
import 'package:demo/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// Ensure these static routes are defined uniquely
// In your SplashScreen.dart:
// static const String route = '/';
// In your MainScreen.dart:
// static const String route = '/main'; // <-- Ensure this is set in MainScreen.dart
// In your ProfileReviewScreen.dart:
// static const String route = '/profile_review'; // <-- Ensure this is set in ProfileReviewScreen.dart

final GoRouter router = GoRouter(
  navigatorKey: NavigationService.navigatorKey,
  initialLocation: SplashScreen.route, // This will be '/'
  routes: [
    GoRoute(
      path: SplashScreen.route, // This is '/'
      name: SplashScreen.route, // This is '/'
      pageBuilder: (BuildContext context, GoRouterState state) {
        return getCustomTransition(state, const SplashScreen());
      },
    ),
    GoRoute(
      path: MainScreen.route, // Make sure this is now '/main' or something else
      name: MainScreen.route, // Make sure this is now 'main' or something else
      pageBuilder: (BuildContext context, GoRouterState state) {
        return getCustomTransition(state, const MainScreen());
      },
      routes: [
        // Your nested routes (login, home, earnings, etc.) remain relative to MainScreen.route
        GoRoute(
          path: LoginScreen.route.replaceAll(
            MainScreen.route,
            '',
          ), // Path should be relative, e.g., 'login'
          name:
              LoginScreen
                  .route, // Use full name for navigation: LoginScreen.route
          pageBuilder: (BuildContext context, GoRouterState state) {
            return getCustomTransition(state, const LoginScreen());
          },
        ),
        GoRoute(
          path: HomeScreen.route.replaceAll(
            MainScreen.route,
            '',
          ), // Path should be relative, e.g., 'home'
          name:
              HomeScreen
                  .route, // Use full name for navigation: HomeScreen.route
          pageBuilder: (BuildContext context, GoRouterState state) {
            return getCustomTransition(state, const HomeScreen());
          },
        ),
        GoRoute(
          path: Earnings.route.replaceAll(MainScreen.route, ''),
          name: Earnings.route,
          pageBuilder: (BuildContext context, GoRouterState state) {
            return getCustomTransition(state, const Earnings());
          },
        ),
        GoRoute(
          path: OrdersListScreen.route.replaceAll(MainScreen.route, ''),
          name: OrdersListScreen.route,
          pageBuilder: (BuildContext context, GoRouterState state) {
            return getCustomTransition(state, const OrdersListScreen());
          },
        ),
        GoRoute(
          path: PrepareYourOrder.route.replaceAll(MainScreen.route, ''),
          name: PrepareYourOrder.route,
          pageBuilder: (BuildContext context, GoRouterState state) {
            return getCustomTransition(state, const PrepareYourOrder());
          },
        ),
        GoRoute(
          path: ChatScreen.route.replaceAll(MainScreen.route, ''),
          name: ChatScreen.route,
          pageBuilder: (BuildContext context, GoRouterState state) {
            return getCustomTransition(state, ChatScreen(id: 0));
          },
        ),
        GoRoute(
          path: RegistrationScreen.route.replaceAll(MainScreen.route, ''),
          name: RegistrationScreen.route,
          builder: (context, state) => const RegistrationScreen(),
        ),
      ],
    ),
    // --- ProfileReviewScreen as a top-level route ---
    GoRoute(
      path: ProfileReviewScreen.route, // Use the static route name directly
      name: ProfileReviewScreen.route, // Use the static route name directly
      pageBuilder: (BuildContext context, GoRouterState state) {
        return getCustomTransition(state, const ProfileReviewScreen());
      },
    ),
  ],
);

CustomTransitionPage<dynamic> getCustomTransition(
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage<dynamic>(
    transitionDuration: const Duration(
      milliseconds: 300,
    ), // Changed to 300ms for smoother transitions
    key: state.pageKey,
    child: child,
    transitionsBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) {
      return FadeTransition(
        opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
        child: child,
      );
    },
  );
}
