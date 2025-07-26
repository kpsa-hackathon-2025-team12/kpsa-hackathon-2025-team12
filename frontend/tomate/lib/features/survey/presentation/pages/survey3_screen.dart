import 'package:tomate/core/routes/route_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class Survey3Screen extends ConsumerStatefulWidget {
  const Survey3Screen({super.key});

  @override
  ConsumerState<Survey3Screen> createState() => _Survey3ScreenState();
}

class _Survey3ScreenState extends ConsumerState<Survey3Screen> {
  int? selectedOption;

  final List<String> options = [
    '매우\n그렇지 않다',
    '그렇지 않다',
    '보통이다',
    '그렇다',
    '아주\n그렇다',
  ];

  void _onOptionSelected(int index) {
    setState(() {
      selectedOption = index;
    });
  }

  void _onNextPressed() {
    if (selectedOption != null) {
      GoRouter.of(context).pushNamed(AppRoutes.survey4Screen.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFF5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFF5),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          '설문조사',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        leading: GestureDetector(
          onTap: () => GoRouter.of(context).pop(),
          child: const Icon(
            Icons.arrow_back_ios_outlined,
            size: 20,
            color: Color(0xFF757575),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 6),
          // 진행바
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            height: 6,
            child: LinearProgressIndicator(
              value: 0.75, // 3/4 (75%)
              backgroundColor: const Color(0xFFDDDDDD),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFFEB423D),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          Expanded(
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 80),

                  // 질문 영역
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: '별일이 없어도 ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const TextSpan(
                                  text: '불안하거나\n긴장한 상태',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const TextSpan(
                                  text: '가 자주 지속되나요?',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 10),

                          const Text(
                            '숨을 고르며, 선택해보아요',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF6E6E6E),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(height: 67),

                          // 원형 선택지들
                          Expanded(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // 원형 버튼들
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: List.generate(5, (index) {
                                      final isSelected =
                                          selectedOption == index;

                                      // 원 크기 설정 (양 끝이 크고 중앙이 작음)
                                      double circleSize;
                                      if (index == 0 || index == 4) {
                                        circleSize = 50; // 가장 큰 원 (양 끝)
                                      } else if (index == 1 || index == 3) {
                                        circleSize = 38; // 중간 크기 원
                                      } else {
                                        circleSize = 28; // 가장 작은 원 (중앙)
                                      }

                                      return GestureDetector(
                                        onTap: () => _onOptionSelected(index),
                                        child: Container(
                                          width: circleSize,
                                          height: circleSize,
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? const Color(0xFFFFE3D0) // 주황색
                                                : Colors.white,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: const Color(0xFF4E4E4E),
                                              width: 1,
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),

                                  const SizedBox(height: 20),

                                  // 라벨들
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: List.generate(5, (index) {
                                      // 라벨 너비도 원 크기에 맞춰 조정
                                      double labelWidth;
                                      if (index == 0 || index == 4) {
                                        labelWidth = 50; // 가장 큰 원에 맞춤
                                      } else if (index == 1 || index == 3) {
                                        labelWidth = 38; // 중간 크기 원에 맞춤
                                      } else {
                                        labelWidth = 28; // 가장 작은 원에 맞춤
                                      }

                                      return SizedBox(
                                        width: labelWidth,
                                        child: Text(
                                          options[index],
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 다음 버튼
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 24,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: selectedOption != null
                            ? _onNextPressed
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedOption != null
                              ? const Color(0xFFEB423D)
                              : const Color(0xFFE0E0E0),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: const Text(
                          '다음',
                          style: TextStyle(
                            fontSize: 16,
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
          ),
        ],
      ),
    );
  }
}
