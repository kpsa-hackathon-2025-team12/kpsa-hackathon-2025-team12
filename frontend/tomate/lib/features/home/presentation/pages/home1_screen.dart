import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/widgets/common_app_bar.dart';

class Home1Screen extends ConsumerStatefulWidget {
  const Home1Screen({super.key});

  @override
  ConsumerState<Home1Screen> createState() => _Home1ScreenState();
}

class _Home1ScreenState extends ConsumerState<Home1Screen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late AnimationController _bounceAnimationController;
  late Animation<double> _bounceAnimation;
  late AnimationController _walkAnimationController;
  late Animation<double> _walkHorizontalAnimation;
  late Animation<double> _walkVerticalAnimation;
  int _currentPage = 0;

  // 각 카드별 진행 상태 관리 (0: 지하철역, 1: 산책, 2: 공원벤치)
  List<bool> _cardInProgress = [false, false, false];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.80);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    // 토마토 통통 뛰는 애니메이션 컨트롤러 (첫 번째 카드용)
    _bounceAnimationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _bounceAnimation = Tween<double>(begin: 0.0, end: -20.0).animate(
      CurvedAnimation(
        parent: _bounceAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    // 걷기 애니메이션 컨트롤러 (두 번째 카드용)
    _walkAnimationController = AnimationController(
      duration: const Duration(seconds: 4), // 4초 주기로 왕복
      vsync: this,
    );

    // 수평 이동 애니메이션 (0에서 200까지 갔다가 다시 0으로)
    _walkHorizontalAnimation =
        Tween<double>(
          begin: 0.0,
          end: 200.0, // 200픽셀 오른쪽으로 이동
        ).animate(
          CurvedAnimation(
            parent: _walkAnimationController,
            curve: Curves.easeInOut,
          ),
        );

    // 수직 바운스 애니메이션 (걷는 동안 통통통)
    _walkVerticalAnimation = Tween<double>(begin: 0.0, end: -15.0).animate(
      CurvedAnimation(
        parent: _walkAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // 애니메이션 반복 시작
    _bounceAnimationController.repeat(reverse: true);
    _walkAnimationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    _bounceAnimationController.dispose();
    _walkAnimationController.dispose();
    super.dispose();
  }

  void _navigateToPage(int page) {
    if (page >= 0 && page < 3) {
      _pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _buildRichText(String text, String boldText, bool isActive) {
    final parts = text.split(boldText);
    final List<TextSpan> spans = [];

    for (int i = 0; i < parts.length; i++) {
      if (parts[i].isNotEmpty) {
        spans.add(
          TextSpan(
            text: parts[i],
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        );
      }

      if (i < parts.length - 1) {
        spans.add(
          TextSpan(
            text: boldText,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        );
      }
    }

    return Text.rich(TextSpan(children: spans));
  }

  /// 1번째 카드: 지하철역 입구 애니메이션 위젯
  Widget _buildStairAnimation(bool isActive) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          // 지하철역 입구 이미지 (정적)
          Positioned(
            left: 0,
            bottom: 0,
            child: Image.asset(
              'assets/icons/subway.png', // subway PNG 이미지
              width: 104,
              height: 96,
            ),
          ),
          // 토마토 캐릭터 (애니메이션)
          AnimatedBuilder(
            animation: _bounceAnimation,
            builder: (context, child) {
              return Positioned(
                right: Platform.isAndroid ? 0 : 30,
                bottom: 24 + _bounceAnimation.value,
                child: Image.asset(
                  'assets/icons/last_tomato.png',
                  width: 57,
                  height: 69,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// 2번째 카드: 산책 애니메이션 위젯
  Widget _buildWalkAnimation(bool isActive) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          // 역/정거장 이미지 (정적)
          Positioned(
            left: 0,
            bottom: 0,
            child: Image.asset(
              'assets/icons/station.png', // station PNG 이미지
              width: 104,
              height: 94,
            ),
          ),
          // 토마토 캐릭터 (걷기 애니메이션)
          AnimatedBuilder(
            animation: _walkAnimationController,
            builder: (context, child) {
              return Positioned(
                left: Platform.isAndroid ? _walkHorizontalAnimation.value : _walkHorizontalAnimation.value + 30,
                bottom:
                    10 +
                    (_walkVerticalAnimation.value *
                        (1 -
                            (_walkHorizontalAnimation.value / 200)
                                .abs())), // 멈춰있을 때는 바운스 없음
                child: Image.asset(
                  'assets/icons/right_tomate.png',
                  width: 57,
                  height: 69,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// 3번째 카드: 공원 벤치 애니메이션 위젯
  Widget _buildParkAnimation(bool isActive) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          // 서점 이미지 (정적)
          Positioned(
            left: 30,
            bottom: 0,
            child: Image.asset(
              'assets/icons/bookstore.png', // bookstore PNG 이미지
              width: 114,
              height: 54,
            ),
          ),
          // 토마토 캐릭터 (애니메이션)
          AnimatedBuilder(
            animation: _bounceAnimation,
            builder: (context, child) {
              return Positioned(
                right: Platform.isAndroid ? 32 : 87,
                bottom: 50 + _bounceAnimation.value,
                child: Image.asset(
                  'assets/icons/left_tomato.png',
                  width: 57,
                  height: 69,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// 카드 index에 따라 적절한 애니메이션 위젯을 반환하는 헬퍼 메소드
  Widget _getAnimationWidget(int index, bool isActive) {
    switch (index) {
      case 0:
        return _buildStairAnimation(isActive); // 지하철역 계단
      case 1:
        return _buildWalkAnimation(isActive); // 산책
      case 2:
        return _buildParkAnimation(isActive); // 공원 벤치
      default:
        return _buildStairAnimation(isActive); // 기본값
    }
  }

  /// 시작하기 단일 버튼 빌드
  Widget _buildStartButton(int index, bool isActive) {
    return GestureDetector(
      onTap: isActive ? () => _startChallenge(index) : null,
      child: Container(
        width: double.infinity,
        height: 38,
        decoration: BoxDecoration(
          color: const Color(0xFFEB423D),
          borderRadius: BorderRadius.circular(23),
        ),
        child: const Center(
          child: Text(
            '시작하기',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  /// 진행중 상태의 두 버튼 (다음에 하기, 성공) 빌드
  Widget _buildProgressButtons(int index, bool isActive) {
    return Row(
      children: [
        // 다음에 하기 버튼
        Expanded(
          flex: 3,
          child: GestureDetector(
            onTap: isActive ? () => _postponeChallenge(index) : null,
            child: Container(
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFF9E9E9E),
                borderRadius: BorderRadius.circular(23),
              ),
              child: const Center(
                child: Text(
                  '다음에 하기',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        // 성공 버튼
        Expanded(
          flex: 2,
          child: GestureDetector(
            onTap: isActive ? () => _completeChallenge(index) : null,
            child: Container(
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFEA423C),
                borderRadius: BorderRadius.circular(23),
              ),
              child: const Center(
                child: Text(
                  '성공',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 시작하기 버튼 클릭 시 호출
  void _startChallenge(int index) {
    setState(() {
      _cardInProgress[index] = true;
    });
  }

  /// 다음에 하기 버튼 클릭 시 호출
  void _postponeChallenge(int index) {
    setState(() {
      _cardInProgress[index] = false;
    });
  }

  /// 성공 버튼 클릭 시 호출
  void _completeChallenge(int index) {
    setState(() {
      _cardInProgress[index] = false;
    });
    // TODO: 성공 처리 로직 추가 (예: 포인트 증가, 성공 애니메이션 등)
  }

  Widget _buildCourageCard(
    String subtitle,
    String boldText,
    String date,
    bool isActive,
    int index,
  ) {
    double rotationAngle = 0.0;
    if (!isActive) {
      if (index < _currentPage) {
        rotationAngle = 0.06;
      } else if (index > _currentPage) {
        rotationAngle = -0.06;
      }
    }

    return Transform.rotate(
      angle: rotationAngle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        margin: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: isActive ? 0 : 16,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF4E4E4E), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isActive ? 0.08 : 0.03),
              blurRadius: isActive ? 12 : 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 날짜 및 진행중 라벨
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isActive ? Colors.black : Color(0xFF999999),
                    ),
                  ),
                  if (_cardInProgress[index]) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            strokeAlign: BorderSide.strokeAlignOutside,
                            color: const Color(0xFFEA423C),
                          ),
                          borderRadius: BorderRadius.circular(23),
                        ),
                      ),
                      child: const Text(
                        '진행중',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFEA423C),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 26),

              _buildRichText(subtitle, boldText, isActive),
              const SizedBox(height: 20),

              // 일러스트 영역
              Expanded(child: _getAnimationWidget(index, isActive)),
              const SizedBox(height: 20),

              // 버튼 영역 (조건에 따라 다른 버튼 표시)
              AnimatedOpacity(
                duration: const Duration(milliseconds: 400),
                opacity: isActive ? 1.0 : 0.6,
                child: _cardInProgress[index]
                    ? _buildProgressButtons(index, isActive)
                    : _buildStartButton(index, isActive),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        bool isActive = index == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: isActive ? 8 : 6,
          height: isActive ? 8 : 6,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFEB423D) : const Color(0xFFD9D9D9),
            borderRadius: BorderRadius.circular(8),
          ),
        );
      }),
    );
  }

  Widget _buildNavigationArrow(
    IconData icon,
    VoidCallback onTap,
    bool isEnabled,
  ) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Icon(
        icon,
        size: 22,
        color: isEnabled ? const Color(0xFF757575) : const Color(0xFFCCCCCC),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFF5),
      appBar: const CommonAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: '지금까지 마토와 함께\n',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const TextSpan(
                    text: '5번의 용기를 냈어요!',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 46),

            // 용기 카드들
            SizedBox(
              height: 380,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                  _animationController.forward(from: 0);
                },
                itemCount: 3,
                itemBuilder: (context, index) {
                  bool isActive = index == _currentPage;

                  final cards = [
                    {
                      'subtitle': '오늘은 집에서 가까운\n지하철역 입구까지 가볼까요?',
                      'boldText': '지하철역 입구',
                      'date': '7월 26일 오늘의 용기',
                    },
                    {
                      'subtitle': '한 정거장 거리만 걷고\n돌아오는 산책 어떨까요?',
                      'boldText': '산책',
                      'date': '7월 27일 오늘의 용기',
                    },
                    {
                      'subtitle': '오늘은 책을 들고 공원 밴치에\n앉아 10분만 머물러볼까요?',
                      'boldText': '10분만 머물러',
                      'date': '7월 28일 오늘의 용기',
                    },
                  ];

                  final card = cards[index];
                  return _buildCourageCard(
                    card['subtitle'] as String,
                    card['boldText'] as String,
                    card['date'] as String,
                    isActive,
                    index,
                  );
                },
              ),
            ),

            SizedBox(height: 30),
            // 하단 네비게이션 (인디케이터 + 화살표)
            Center(
              child: Row(
                spacing: 22,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 왼쪽 화살표
                  _buildNavigationArrow(
                    Icons.arrow_back_outlined,
                    () => _navigateToPage(_currentPage - 1),
                    _currentPage > 0,
                  ),

                  // 중앙 인디케이터
                  _buildPageIndicator(),

                  // 오른쪽 화살표
                  _buildNavigationArrow(
                    Icons.arrow_forward_outlined,
                    () => _navigateToPage(_currentPage + 1),
                    _currentPage < 2,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
