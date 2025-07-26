import 'dart:io';
import 'package:tomate/core/api/api_provider.dart';
import 'package:tomate/core/routes/route_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:tomate/navigation/kakao_webview_screen.dart';
import 'package:tomate/navigation/naver_webview_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    );

    // 토마토를 오른쪽 끝에 붙여서 약간만 왔다갔다
    _slideAnimation = Tween<double>(begin: 0.0, end: -30.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticInOut),
    );

    // 반복 애니메이션 시작
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFF5),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 131),

            // 제목
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '저희와 함께 숨을 고르며\n',
                      style: TextStyle(
                        color: const Color(0xFF0B0B0B),
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: '한 걸음씩',
                      style: TextStyle(
                        color: const Color(0xFF0B0B0B),
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text: ' 나아가봐요.',
                      style: TextStyle(
                        color: const Color(0xFF0B0B0B),
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 150.0),

            Expanded(
              child: Stack(
                clipBehavior: Clip.none, // 잘리지 않도록 설정
                children: [
                  // 토마토 애니메이션 - 완전히 오른쪽 끝에 붙여서 일부가 잘리도록
                  Positioned(
                    right: -60, // 토마토 일부가 화면 밖으로 나가도록
                    top: 70,
                    child: AnimatedBuilder(
                      animation: _slideAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(_slideAnimation.value, 0),
                          child: Image.asset(
                            'assets/icons/tomatoes.png',
                            width: 136.0,
                            height: 134.0,
                            fit: BoxFit.contain,
                          ),
                        );
                      },
                    ),
                  ),
                  // 말풍선
                  Positioned(
                    right: 20,
                    top: 10,
                    child: AnimatedBuilder(
                      animation: _slideAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(
                            _slideAnimation.value,
                            0,
                          ), // 토마토와 같은 속도로
                          child: CustomPaint(
                            painter: SpeechBubblePainter(),
                            child: Container(
                              width: 220,
                              height: 54,
                              padding: EdgeInsets.fromLTRB(
                                12.0,
                                8.0,
                                12.0,
                                16.0,
                              ),
                              child: Center(
                                child: Text(
                                  '로그인 시 기록이 안전하게 저장되어요!',
                                  style: TextStyle(
                                    fontSize: 11.0,
                                    color: Color(0xFF343434),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // 로그인 버튼들
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                children: [
                  // 카카오 로그인
                  _socialLoginButton(
                    buttonText: '카카오로 시작하기',
                    onButtonPressed: () {
                      _showLoginSuccessAndNavigate('카카오');
                    },
                    backgroundColor: Color(0xFFFFEC45),
                    textColor: Color(0xFF3C1E1E),
                    iconPath: 'assets/icons/kakaoIcon.png', // 카카오 아이콘
                  ),

                  SizedBox(height: 12.0),

                  // 네이버 로그인
                  _socialLoginButton(
                    buttonText: '네이버로 시작하기',
                    onButtonPressed: () {
                      _showLoginSuccessAndNavigate('네이버');
                    },
                    backgroundColor: Color(0xFF00BF18),
                    textColor: Colors.white,
                    iconPath: 'assets/icons/naverIcon.png', // 네이버 아이콘
                  ),

                  SizedBox(height: 12.0),

                  // 구글 로그인
                  _socialLoginButton(
                    buttonText: 'Google 시작하기',
                    onButtonPressed: () {
                      _showLoginSuccessAndNavigate('구글');
                    },
                    backgroundColor: Colors.white,
                    textColor: Color(0xFF4E4E4E),
                    borderColor: Color(0xFFCACACA),
                    iconPath: 'assets/icons/googleIcon.png', // 구글 아이콘
                    iconSize: 20.0,
                  ),
                ],
              ),
            ),

            SizedBox(height: 40.0),
          ],
        ),
      ),
    );
  }

  Future<void> _showLoginSuccessAndNavigate(String platform) async {
    try {
      // 백엔드에서 카카오 OAuth URL 받아오기
      if (platform == "카카오") {
        final response = await ref
            .read(apiProvider.notifier)
            .getAsync('/oauth2/login/kakao');

        final String? kakaoAuthUrl = response.data["data"];

        if (kakaoAuthUrl == null) {
          _showErrorSnackbar('로그인 URL을 받아오지 못했습니다.');
          return;
        }

        print('카카오 로그인 URL: $kakaoAuthUrl');

        // 웹뷰 스크린으로 카카오 로그인 처리
        final bool success =
            await Navigator.of(context).push<bool>(
              MaterialPageRoute(
                builder: (context) => KakaoWebViewScreen(authUrl: kakaoAuthUrl),
              ),
            ) ??
            false;

        if (success) {
          print('카카오 로그인 성공!');
          await _handleLoginSuccess();
        } else {
          print('카카오 로그인 취소 또는 실패');
          _showErrorSnackbar('카카오 로그인이 취소되었습니다.');
        }
      } else if (platform == "네이버") {
        final response = await ref
            .read(apiProvider.notifier)
            .getAsync('/oauth2/login/naver');

        final String? naverAuthUrl = response.data["data"];

        if (naverAuthUrl == null) {
          _showErrorSnackbar('로그인 URL을 받아오지 못했습니다.');
          return;
        }

        print('네이버 로그인 URL: $naverAuthUrl');

        // 웹뷰 스크린으로 네이버 로그인 처리
        final bool success =
            await Navigator.of(context).push<bool>(
              MaterialPageRoute(
                builder: (context) => NaverWebViewScreen(authUrl: naverAuthUrl),
              ),
            ) ??
                false;

        if (success) {
          print('네이버 로그인 성공!');
          await _handleLoginSuccess();
        } else {
          print('네이버 로그인 취소 또는 실패');
          _showErrorSnackbar('네이버 로그인이 취소되었습니다.');
        }
      }else{
        GoRouter.of(context).goNamed(AppRoutes.home1Screen.name);
      }
    } catch (error) {
      print('소셜 로그인 오류: $error');
      _showErrorSnackbar('로그인 중 오류가 발생했습니다.');
    }
  }

  Future<void> _handleLoginSuccess() async {
    // 로그인 성공 스낵바 표시
    if (mounted) {
      // 2초 후 다음 화면으로 이동
      if (mounted) {
        // TODO: 신규 사용자인지 기존 사용자인지에 따라 분기 처리
        // 현재는 신규 사용자로 가정
        // 잠시 주석
        GoRouter.of(context).goNamed(AppRoutes.userInfoScreen.name);
        // GoRouter.of(context).goNamed(AppRoutes.home1Screen.name);
      }
    }
  }

  void _showErrorSnackbar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Widget _socialLoginButton({
    required String buttonText,
    required VoidCallback onButtonPressed,
    required Color backgroundColor,
    required Color textColor,
    Color? borderColor,
    String? iconPath,
    double iconSize = 16.0, // 아이콘 크기 추가 (기본값 16.0)
  }) {
    return SizedBox(
      width: double.infinity,
      height: 46.0,
      child: ElevatedButton(
        onPressed: onButtonPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: borderColor != null
                ? BorderSide(color: borderColor, width: 1)
                : BorderSide.none,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (iconPath != null) ...[
              Image.asset(iconPath, width: iconSize, height: iconSize),
              SizedBox(width: 10.0),
            ],
            Text(
              buttonText,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// CustomPainter로 말풍선을 직접 그리기
class SpeechBubblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Color(0xFF424242)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    const borderRadius = 12.0;
    const tailWidth = 12.0;
    const tailHeight = 8.0;
    final tailX = size.width - 20;

    final path = Path();

    // 왼쪽 위 모서리부터 시계방향으로 그리기
    path.moveTo(0, borderRadius);

    // 왼쪽 위 둥근 모서리
    path.quadraticBezierTo(0, 0, borderRadius, 0);

    // 위쪽 직선
    path.lineTo(size.width - borderRadius, 0);

    // 오른쪽 위 둥근 모서리
    path.quadraticBezierTo(size.width, 0, size.width, borderRadius);

    // 오른쪽 직선
    path.lineTo(size.width, size.height - tailHeight - borderRadius);

    // 오른쪽 아래 둥근 모서리 (꼬리 전까지)
    path.quadraticBezierTo(
      size.width,
      size.height - tailHeight,
      size.width - borderRadius,
      size.height - tailHeight,
    );

    // 꼬리 오른쪽까지 직선
    path.lineTo(tailX + tailWidth / 2, size.height - tailHeight);

    // 꼬리 그리기 - 적당히 라운드 처리
    // 꼬리 오른쪽 연결부분 곡선
    path.quadraticBezierTo(
      tailX + tailWidth / 4,
      size.height - tailHeight / 2,
      tailX + 1.5,
      size.height - 1.5, // 적당히 둥글게
    );

    // 꼬리 끝부분 작은 곡선
    path.quadraticBezierTo(
      tailX,
      size.height - 1,
      tailX - 1.5,
      size.height - 1.5,
    );

    // 꼬리 왼쪽 연결부분 곡선
    path.quadraticBezierTo(
      tailX - tailWidth / 4,
      size.height - tailHeight / 2,
      tailX - tailWidth / 2,
      size.height - tailHeight,
    );

    // 꼬리 왼쪽부터 왼쪽 아래 모서리까지
    path.lineTo(borderRadius, size.height - tailHeight);

    // 왼쪽 아래 둥근 모서리
    path.quadraticBezierTo(
      0,
      size.height - tailHeight,
      0,
      size.height - tailHeight - borderRadius,
    );

    // 다시 시작점으로
    path.close();

    // 먼저 흰색으로 채우고
    canvas.drawPath(path, paint);
    // 그 다음 검은 테두리 그리기
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
