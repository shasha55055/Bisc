import 'screens/auth_screen.dart';
import 'screens/history_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/transcript_list_screen.dart';
import 'widgets/scaffold_with_nested_navigation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'firebase_options.dart';

Future main() async {
  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  MobileAds.instance.initialize();
  runApp(const BiscuittApp());
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorAuthKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellAuth');
final _shellNavigatorPracticeKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellPractice');
final _shellNavigatorHistoryKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellHistory');
final _shellNavigatorSettingsKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellSettings');

final _router = GoRouter(
    initialLocation: '/auth',
    navigatorKey: _rootNavigatorKey,
    routes: [
      StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return ScaffoldWithNestedNavigation(
                navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              navigatorKey: _shellNavigatorPracticeKey,
              routes: [
                GoRoute(
                  path: '/',
                  pageBuilder: (context, state) => const NoTransitionPage(
                    child: TranscriptListScreen(),
                  ),
                  routes: [
                    GoRoute(
                        path: 'quiz',
                        pageBuilder: (context, state) => const NoTransitionPage(
                              child: QuizScreen(),
                            )),
                  ],
                )
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _shellNavigatorHistoryKey,
              routes: [
                GoRoute(
                  path: '/history',
                  pageBuilder: (context, state) =>
                      const NoTransitionPage(child: HistoryScreen()),
                  routes: const [],
                )
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _shellNavigatorSettingsKey,
              routes: [
                GoRoute(
                  path: '/settings',
                  pageBuilder: (context, state) =>
                      const NoTransitionPage(child: SettingsScreen()),
                  routes: const [],
                )
              ],
            )
          ]),
      StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return Scaffold(body: navigationShell);
          },
          branches: [
            StatefulShellBranch(navigatorKey: _shellNavigatorAuthKey, routes: [
              GoRoute(
                  path: '/auth',
                  pageBuilder: (context, state) => const NoTransitionPage(
                        child: AuthScreen(),
                      )),
              GoRoute(
                  path: '/signup',
                  pageBuilder: (context, state) => const NoTransitionPage(
                        child: SignupScreen(),
                      )),
            ])
          ]),
    ]);

class BiscuittApp extends StatelessWidget {
  const BiscuittApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Biscuitt',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
