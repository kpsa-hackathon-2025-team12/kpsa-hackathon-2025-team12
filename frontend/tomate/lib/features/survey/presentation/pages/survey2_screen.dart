import 'package:tomate/core/routes/route_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class Survey2Screen extends ConsumerStatefulWidget {
  const Survey2Screen({super.key});

  @override
  ConsumerState<Survey2Screen> createState() => _Survey2ScreenState();
}

class _Survey2ScreenState extends ConsumerState<Survey2Screen> {
  Set<int> selectedOptions = {};

  final List<Map<String, String>> options = [
    {'main': '밀폐된 공간', 'sub': '지하철, 엘레베이터, 비행기'},
    {'main': '혼잡한 공간', 'sub': '공연장, 퇴근길, 지하상가'},
    {'main': '혼자 있는 공간', 'sub': '집 안, 낯선 거리, 공터'},
    {'main': '개방된 공간', 'sub': '광장, 다리 위, 고층 전망대'},
    {'main': '이동 중 공간', 'sub': '운전 중, 고속도로, 터널'},
    {'main': '사회적 압박', 'sub': '교실, 회의실, 발표장'},
  ];

  void _onOptionSelected(int index) {
    setState(() {
      if (selectedOptions.contains(index)) {
        selectedOptions.remove(index);
      } else {
        if (selectedOptions.length < 6) {
          selectedOptions.add(index);
        }
      }
    });
  }

  void _onNextPressed() {
    if (selectedOptions.isNotEmpty) {
      GoRouter.of(context).pushNamed(AppRoutes.survey3Screen.name);
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
              value: 0.5, // 2/4 (50%)
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
                                  text: '불안하거나 불편해서 ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const TextSpan(
                                  text: '피하게\n되는 상황',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const TextSpan(
                                  text: '이 있다면 골라주세요',
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
                            '최대 6개 선택 가능해요',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF6E6E6E),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(height: 20),

                          // 선택지 그리드 (2x3) - 센터 정렬
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
                                    final isSelected = selectedOptions.contains(
                                      index,
                                    );
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
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                options[index]['main']!,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF0B0B0B),
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                options[index]['sub']!,
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xFF888888),
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
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
                        onPressed: selectedOptions.isNotEmpty
                            ? _onNextPressed
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedOptions.isNotEmpty
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
