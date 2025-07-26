import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class Survey1Screen extends ConsumerStatefulWidget {
  const Survey1Screen({super.key});

  @override
  ConsumerState<Survey1Screen> createState() => _Survey1ScreenState();
}

class _Survey1ScreenState extends ConsumerState<Survey1Screen> {
  int? selectedOption;

  final List<String> options = ['없음', '1~2회', '3~5회', '6회 이상'];

  void _onOptionSelected(int index) {
    setState(() {
      selectedOption = index;
    });
  }

  void _onNextPressed() {
    if (selectedOption != null) {
      context.push('/survey2-screen');
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
      ),
      body: Column(
        children: [
          SizedBox(height: 6,),
          // 진행바
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            height:  6,
            child: LinearProgressIndicator(
              value: 0.25, // 1/4 (25%)
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
                                  text: '최근 한 달 동안\n',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const TextSpan(
                                  text: '공황 증상',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const TextSpan(
                                  text: '을 느끼신 적 있나요?',
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
                            '천천히 떠올려도 괜찮아요',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF6E6E6E),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(height: 50),

                          // 선택지 그리드 (2x2) - 센터 정렬
                          Expanded(
                            child: Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 340,
                                ),
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisExtent: 92,
                                        crossAxisSpacing: 12,
                                        mainAxisSpacing: 12,
                                      ),
                                  itemCount: options.length,
                                  itemBuilder: (context, index) {
                                    final isSelected = selectedOption == index;
                                    return GestureDetector(
                                      onTap: () => _onOptionSelected(index),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? const Color(0xFFFFE3D0) // 주황색
                                              : Colors.white,
                                          border: Border.all(
                                            color: isSelected
                                                ? const Color(0xFFFFE3D0)
                                                : const Color(0xFFE0E0E0),
                                            width: 1.5,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            options[index],
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF0B0B0B),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
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
