import 'package:tomate/core/routes/route_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeAnimationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // fade-in 애니메이션 설정
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800), // 0.8초간 부드럽게
      vsync: this,
    );

    _fadeAnimation =
        Tween<double>(
          begin: 0.0, // 완전 투명
          end: 1.0, // 완전 불투명
        ).animate(
          CurvedAnimation(
            parent: _fadeAnimationController,
            curve: Curves.easeInOut, // 부드러운 곡선
          ),
        );

    // 1초 후에 애니메이션 시작
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        _fadeAnimationController.forward();
      }
    });

    _navigateToLogin();
  }

  @override
  void dispose() {
    _fadeAnimationController.dispose();
    super.dispose();
  }

  void _navigateToLogin() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        GoRouter.of(context).pushReplacementNamed(AppRoutes.loginScreen.name);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFF5),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 로고 이미지 with fade-in 애니메이션
            FadeTransition(
              opacity: _fadeAnimation,
              child: Image.asset(
                'assets/icons/logo.png',
                width: 263,
                height: 109,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
