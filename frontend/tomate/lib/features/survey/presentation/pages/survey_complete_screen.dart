import 'package:tomate/core/routes/route_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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

class SurveyCompleteScreen extends ConsumerStatefulWidget {
  const SurveyCompleteScreen({super.key});

  @override
  ConsumerState<SurveyCompleteScreen> createState() =>
      _SurveyCompleteScreenState();
}

class _SurveyCompleteScreenState extends ConsumerState<SurveyCompleteScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _characterAnimation;

  @override
  void initState() {
    super.initState();

    // 캐릭터 애니메이션 컨트롤러
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // 캐릭터 위아래 움직임 애니메이션
    _characterAnimation = Tween<double>(begin: -28.0, end: 14.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.bounceOut,
      ),
    );

    // 애니메이션 시작 (무한 반복)
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onStartPressed() {
    // 설문 완료 후 홈 화면으로 이동
    GoRouter.of(context).go('/home-screen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFF5),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 100.0),

                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '불안한 순간에도',
                            style: TextStyle(
                              color: const Color(0xFF0B0B0B),
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: ' 나를 지켜보는\n지금의 당신, 잘 해내고 있어요.',
                            style: TextStyle(
                              color: const Color(0xFF0B0B0B),
                              fontSize: 24,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12.0),

                    Text(
                      '때때로 느껴지는 긴장도 자연스러운 감정이에요.\n걱정하지 않아도 괜찮아요!',
                      style: TextStyle(
                        color: const Color(0xFF0B0B0B),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),


                    const SizedBox(height: 40.0),

                    // 말풍선과 캐릭터
                    Expanded(
                      child: Center(
                        child: AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, _characterAnimation.value),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // 말풍선
                                  CustomPaint(
                                    painter: SpeechBubblePainter(),
                                    child: Container(
                                      width: 240,
                                      height: 70,
                                      padding: const EdgeInsets.fromLTRB(
                                        12.0,
                                        8.0,
                                        12.0,
                                        16.0,
                                      ),
                                      child: const Center(
                                        child: Text(
                                          '지금부터는 불안과 친해지는 연습을\n해볼 거예요. 아주 작은 용기부터 시작해요!',
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

                                  const SizedBox(height: 30),

                                  // 캐릭터 (새싹)
                                  Image.asset(
                                    'assets/icons/last_tomato.png',
                                    width: 100,
                                    height: 120,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 시작하기 버튼 (하단 고정)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: SizedBox(
                width: double.infinity,
                height: 46.0,
                child: ElevatedButton(
                  onPressed: _onStartPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEB423D),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(23.0),
                    ),
                  ),
                  child: const Text(
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
