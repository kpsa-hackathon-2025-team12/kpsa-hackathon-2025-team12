import 'package:tomate/core/routes/route_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

// login_screen.dart와 동일한 말풍선을 그리는 CustomPainter
class SpeechBubblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Color(0xFFE0E0E0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    const borderRadius = 12.0;
    const tailWidth = 12.0;
    const tailHeight = 8.0;
    final tailX = size.width / 2 - tailWidth / 2; // 가운데 정렬

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
    path.quadraticBezierTo(
      tailX + tailWidth / 4,
      size.height - tailHeight / 2,
      tailX + 1.5,
      size.height - 1.5,
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
    // 그 다음 테두리 그리기
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class SurveyIntroScreen extends ConsumerStatefulWidget {
  const SurveyIntroScreen({super.key});

  @override
  ConsumerState<SurveyIntroScreen> createState() => _SurveyIntroScreenState();
}

class _SurveyIntroScreenState extends ConsumerState<SurveyIntroScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainAnimationController;

  late Animation<double> _animation1and3; // 1,3번 함께
  late Animation<double> _animation2; // 2번 따로

  @override
  void initState() {
    super.initState();

    // 메인 애니메이션 컨트롤러 (전체 사이클)
    _mainAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // 1,3번 애니메이션 (sin 곡선으로 자연스럽게 위아래)
    _animation1and3 = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(
        parent: _mainAnimationController,
        curve: Curves.easeInOutSine,
      ),
    );

    // 2번 애니메이션 (1,3번과 반대 위상으로 움직임)
    _animation2 = Tween<double>(begin: 24.0, end: -4.0).animate(
      CurvedAnimation(
        parent: _mainAnimationController,
        curve: Curves.easeInOutSine,
      ),
    );

    // 애니메이션 시작 (무한 반복)
    _mainAnimationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _mainAnimationController.dispose();
    super.dispose();
  }

  void _onStartPressed() {
    GoRouter.of(context).goNamed(AppRoutes.survey1Screen.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFF5),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 130.0),

                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '간단한 ',
                            style: TextStyle(
                              color: const Color(0xFF0B0B0B),
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: '마음 설문',
                            style: TextStyle(
                              color: const Color(0xFF0B0B0B),
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: '을 준비했어요.',
                            style: TextStyle(
                              color: const Color(0xFF0B0B0B),
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16.0),

                    Text(
                      '어떤 순간에 마음이 가장 무거워지는지\n우리 함께 살펴볼까요?',
                      style: TextStyle(
                        color: const Color(0xFF0B0B0B),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    SizedBox(height: 60.0),

                    // 말풍선과 캐릭터들
                    Expanded(
                      child: Stack(
                        children: [
                          // 1번 이미지 (왼쪽 오렌지)
                          Positioned(
                            left: 0,
                            top: 200,
                            child: AnimatedBuilder(
                              animation: _mainAnimationController,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(0, _animation1and3.value),
                                  child: Image.asset(
                                    'assets/icons/1.png',
                                    width: 100.w,
                                    height: 120.h,
                                  ),
                                );
                              },
                            ),
                          ),

                          // 2번 이미지와 말풍선 (가운데) - 함께 움직임
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 150,
                            child: AnimatedBuilder(
                              animation: _mainAnimationController,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(0, _animation2.value),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // 말풍선
                                      CustomPaint(
                                        painter: SpeechBubblePainter(),
                                        child: Container(
                                          width: 210,
                                          height: 80,
                                          padding: EdgeInsets.fromLTRB(
                                            12.0,
                                            8.0,
                                            12.0,
                                            16.0,
                                          ),
                                          child: Center(
                                            child: Text(
                                              '마음 설문 수행 시 나만의 맞춤\n미션을 찾는데 더 도움이 돼요!',
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),

                                      SizedBox(height: 20),
                                      // 2번 이미지 (사과)
                                      Image.asset(
                                        'assets/icons/2.png',
                                        width: 100.w,
                                        height: 94.h,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),

                          // 3번 이미지 (오른쪽 배)
                          Positioned(
                            right: 0,
                            bottom: 110,
                            child: AnimatedBuilder(
                              animation: _mainAnimationController,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(0, _animation1and3.value),
                                  child: Image.asset(
                                    'assets/icons/3.png',
                                    width: 100.w,
                                    height: 110.h,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 시작하기 버튼 (하단 고정)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: SizedBox(
                width: double.infinity,
                height: 46.0,
                child: ElevatedButton(
                  onPressed: _onStartPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFEB423D),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(23.0),
                    ),
                  ),
                  child: Text(
                    '시작하기',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
