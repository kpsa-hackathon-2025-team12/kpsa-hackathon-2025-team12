import 'package:tomate/features/survey/presentation/pages/survey4_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../navigation/navigation_screen.dart';
import '../../navigation/splash_screen.dart';
import '../../navigation/login_screen.dart';
import '../../navigation/user_info_screen.dart';
import '../../navigation/survey_intro_screen.dart';
import '../../features/survey/presentation/pages/survey1_screen.dart';
import '../../features/survey/presentation/pages/survey2_screen.dart';
import '../../features/survey/presentation/pages/survey3_screen.dart';
import '../../features/survey/presentation/pages/survey_complete_screen.dart';
import '../../features/home/presentation/pages/home1_screen.dart';
import '../../features/home/presentation/pages/home2_screen.dart';
import '../../features/home/presentation/pages/home3_screen.dart';
import '../../features/home/presentation/pages/home4_screen.dart';
import '../../features/home/presentation/pages/wind_screen.dart';

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>();

enum AppRoutes {
  userInfoScreen,
  surveyIntroScreen,
  survey1Screen,
  survey2Screen,
  survey3Screen,
  survey4Screen,
  surveyCompleteScreen,
  splashScreen,
  loginScreen,
  homeScreen,
  home1Screen,
  home2Screen,
  home3Screen,
  home4Screen,
  windScreen,
}

extension AppRoutesName on AppRoutes {
  String get routeName => name;

  /// lower-snake-case 경로 생성
  String get path {
    var exp = RegExp(r'(?<=[a-z])[A-Z]');
    var result = name
        .replaceAllMapped(exp, (m) => '-${m.group(0)}')
        .toLowerCase();
    return result;
  }

  /// `/` 포함된 경로 반환
  String get fullPath {
    var exp = RegExp(r'(?<=[a-z])[A-Z]');
    var result = name
        .replaceAllMapped(exp, (m) => '-${m.group(0)}')
        .toLowerCase();
    return '/$result';
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: appNavigatorKey,
    initialLocation: '/', // 스플래시 화면으로 시작
    debugLogDiagnostics: true,
    routes: [
      // 스플래시 화면 (네비게이션 바 없음)
      GoRoute(
        path: '/',
        name: 'splashScreen',
        parentNavigatorKey: appNavigatorKey,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: const SplashScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return child;
                },
          );
        },
      ),

      // 로그인 화면 (네비게이션 바 없음)
      GoRoute(
        path: '/login',
        name: 'loginScreen',
        parentNavigatorKey: appNavigatorKey,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: const LoginScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return child;
                },
          );
        },
      ),

      // 사용자 정보 입력 화면 (네비게이션 바 없음)
      GoRoute(
        path: '/user-info',
        name: 'userInfoScreen',
        parentNavigatorKey: appNavigatorKey,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: const UserInfoScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return child;
                },
          );
        },
      ),

      // 설문 소개 화면 (네비게이션 바 없음)
      GoRoute(
        path: '/survey-intro',
        name: 'surveyIntroScreen',
        parentNavigatorKey: appNavigatorKey,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: const SurveyIntroScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return child;
                },
          );
        },
      ),

      // 설문 1번 화면 (네비게이션 바 없음)
      GoRoute(
        path: '/survey1-screen',
        name: 'survey1Screen',
        parentNavigatorKey: appNavigatorKey,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: const Survey1Screen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return child;
                },
          );
        },
      ),

      // 설문 2번 화면 (네비게이션 바 없음)
      GoRoute(
        path: '/survey2-screen',
        name: 'survey2Screen',
        parentNavigatorKey: appNavigatorKey,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: const Survey2Screen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return child;
                },
          );
        },
      ),

      // 설문 3번 화면 (네비게이션 바 없음)
      GoRoute(
        path: '/survey3-screen',
        name: 'survey3Screen',
        parentNavigatorKey: appNavigatorKey,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: const Survey3Screen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return child;
                },
          );
        },
      ),

      // 설문 4번 화면 (네비게이션 바 없음)
      GoRoute(
        path: '/survey4-screen',
        name: 'survey4Screen',
        parentNavigatorKey: appNavigatorKey,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: const Survey4Screen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return child;
                },
          );
        },
      ),

      // 설문 완료 화면 (네비게이션 바 없음)
      GoRoute(
        path: '/survey-complete-screen',
        name: 'surveyCompleteScreen',
        parentNavigatorKey: appNavigatorKey,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: const SurveyCompleteScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return child;
                },
          );
        },
      ),

      // 메인 앱 화면들 (네비게이션 바 포함)
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) {
          final currentTab = _getTabFromLocation(state.uri.toString());
          final isWindActive = currentTab == 'windScreen';

          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: child,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: SizedBox(
              width: 74,
              height: 74,
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                elevation: 0,
                onPressed: () {
                  GoRouter.of(context).goNamed(AppRoutes.windScreen.name);
                },
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: const Color(0xFFCBCBCB)),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: Image.asset(
                    isWindActive
                        ? 'assets/icons/wind.png'
                        : 'assets/icons/wind_g.png',
                    width: 32,
                    height: 32,
                  ),
                ),
              ),
            ),
            bottomNavigationBar: NavigationScreen(tab: currentTab),
          );
        },
        routes: [
          GoRoute(
            path: '/home-screen',
            name: 'homeScreen',
            parentNavigatorKey: shellNavigatorKey,
            pageBuilder: (context, state) {
              // level 파라미터 추출 (기본값: 1)
              final levelParam = state.uri.queryParameters['level'];
              final level = int.tryParse(levelParam ?? '2') ?? 2; // 레벨 수정

              return CustomTransitionPage(
                child: Home1Screen(level: level),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      return child;
                    },
              );
            },
          ),
          GoRoute(
            path: '/home1-screen',
            name: 'home1Screen',
            parentNavigatorKey: shellNavigatorKey,
            pageBuilder: (context, state) {
              // level 파라미터 추출 (기본값: 1)
              final levelParam = state.uri.queryParameters['level'];
              final level = int.tryParse(levelParam ?? '1') ?? 1;

              return CustomTransitionPage(
                child: Home1Screen(level: level),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      return child;
                    },
              );
            },
          ),
          GoRoute(
            path: '/home2-screen',
            name: 'home2Screen',
            parentNavigatorKey: shellNavigatorKey,
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                child: const Home2Screen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      return child;
                    },
              );
            },
          ),
          GoRoute(
            path: '/home3-screen',
            name: 'home3Screen',
            parentNavigatorKey: shellNavigatorKey,
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                child: const Home3Screen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      return child;
                    },
              );
            },
          ),
          GoRoute(
            path: '/home4-screen',
            name: 'home4Screen',
            parentNavigatorKey: shellNavigatorKey,
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                child: const Home4Screen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      return child;
                    },
              );
            },
          ),
          GoRoute(
            path: '/wind-screen',
            name: 'windScreen',
            parentNavigatorKey: shellNavigatorKey,
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                child: const WindScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      return child;
                    },
              );
            },
          ),
        ],
      ),
    ],
  );
});

String _getTabFromLocation(String location) {
  switch (location) {
    case '/home-screen':
    case '/home1-screen':
      return 'homeScreen';
    case '/home2-screen':
      return 'home2Screen';
    case '/home3-screen':
      return 'home3Screen';
    case '/home4-screen':
      return 'home4Screen';
    case '/wind-screen':
      return 'windScreen';
    default:
      return 'homeScreen';
  }
}
