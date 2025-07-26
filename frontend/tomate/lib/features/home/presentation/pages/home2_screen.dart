import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Home2Screen extends ConsumerStatefulWidget {
  const Home2Screen({super.key});

  @override
  ConsumerState<Home2Screen> createState() => _Home2ScreenState();
}

class _Home2ScreenState extends ConsumerState<Home2Screen> {
  bool _isFirstButtonPressed = false;
  bool _isSecondButtonPressed = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFCF5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFCF5),
        elevation: 0,
        title: Text(
          '마토와 대화하기',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30),
                    // 토마토 아이콘
                    Image.asset(
                      'assets/icons/mini_tomate.png',
                      width: 30,
                      height: 30,
                      fit: BoxFit.contain,
                    ),
                    Container(
                      width: 215,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFFFEEE1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(18),
                            bottomLeft: Radius.circular(18),
                            bottomRight: Radius.circular(18),
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Text(
                              '지금 마음에 가장 가까운 느낌을\n골라볼까요? 마토가 함께할게요!',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 20),
                            GestureDetector(
                              onTap: () {
                                // 여기 누른것처럼
                              },
                              onTapDown: (_) {
                                setState(() {
                                  _isFirstButtonPressed = true;
                                });
                              },
                              onTapUp: (_) {
                                setState(() {
                                  _isFirstButtonPressed = false;
                                });
                              },
                              onTapCancel: () {
                                setState(() {
                                  _isFirstButtonPressed = false;
                                });
                              },
                              child: AnimatedScale(
                                scale: _isFirstButtonPressed ? 0.95 : 1.0,
                                duration: Duration(milliseconds: 100),
                                child: Container(
                                  height: 61,
                                  decoration: ShapeDecoration(
                                    color: _isFirstButtonPressed
                                        ? const Color(0xFFF5F5F5)
                                        : Colors.white,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        width: 1,
                                        color: _isFirstButtonPressed
                                            ? const Color(0xFFEB423D)
                                            : const Color(0xFF4D4D4D),
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: '이야기가 하고 싶어요. \n',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          TextSpan(
                                            text: '대화하면서 안정을 찾아보아요.',
                                            style: TextStyle(
                                              color: const Color(0xFF828282),
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          TextSpan(
                                            text: ' ',
                                            style: TextStyle(
                                              color: const Color(0xFF828282),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            GestureDetector(
                              onTap: () {
                                // 여기 누른것처럼
                              },
                              onTapDown: (_) {
                                setState(() {
                                  _isSecondButtonPressed = true;
                                });
                              },
                              onTapUp: (_) {
                                setState(() {
                                  _isSecondButtonPressed = false;
                                });
                              },
                              onTapCancel: () {
                                setState(() {
                                  _isSecondButtonPressed = false;
                                });
                              },
                              child: AnimatedScale(
                                scale: _isSecondButtonPressed ? 0.95 : 1.0,
                                duration: Duration(milliseconds: 100),
                                child: Container(
                                  height: 61,
                                  decoration: ShapeDecoration(
                                    color: _isSecondButtonPressed
                                        ? const Color(0xFFF5F5F5)
                                        : Colors.white,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        width: 1,
                                        color: _isSecondButtonPressed
                                            ? const Color(0xFFEB423D)
                                            : const Color(0xFF4D4D4D),
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: '생각 전환을 하고 싶어요. \n',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontFamily: 'Pretendard',
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          TextSpan(
                                            text: '마토와 집중해서 퀴즈를 풀어봐요!',
                                            style: TextStyle(
                                              color: const Color(0xFF828282),
                                              fontSize: 11,
                                              fontFamily: 'Pretendard',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
