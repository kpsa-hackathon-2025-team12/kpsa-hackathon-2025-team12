import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DiaryEntry {
  final DateTime date;
  final String title;
  final String content;
  final int mood; // 1-5 (1: 매우 나쁨, 5: 매우 좋음)

  DiaryEntry({
    required this.date,
    required this.title,
    required this.content,
    required this.mood,
  });
}

class Home3Screen extends ConsumerStatefulWidget {
  const Home3Screen({super.key});

  @override
  ConsumerState<Home3Screen> createState() => _Home3ScreenState();
}

class _Home3ScreenState extends ConsumerState<Home3Screen>
    with SingleTickerProviderStateMixin {
  DateTime selectedDate = DateTime.now();
  DateTime currentMonth = DateTime.now();
  late TabController _tabController;

  // 더미 데이터
  final List<DiaryEntry> diaryEntries = [
    DiaryEntry(
      date: DateTime.now().subtract(const Duration(days: 1)),
      title: "오늘의 일기",
      content: "좋은 하루였어요!",
      mood: 4,
    ),
    DiaryEntry(
      date: DateTime.now().subtract(const Duration(days: 3)),
      title: "힘든 하루",
      content: "팀원들이 너무 말을 안들어 .. 힘들어",
      mood: 2,
    ),
    DiaryEntry(
      date: DateTime.now().subtract(const Duration(days: 5)),
      title: "평범한 하루",
      content: "그냥 평범했던 하루",
      mood: 3,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFF5),
      body: SafeArea(
        child: Column(
          children: [
            // 상태바 공간
            // SizedBox(height: MediaQuery.of(context).padding.top),
            // 탭바
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 28),
              child: Container(
                decoration: BoxDecoration(color: Color(0xFFFFFFF5)),
                child: TabBar(
                  controller: _tabController,
                  labelColor: const Color(0xFFFF6B6B),
                  unselectedLabelColor: Color(0xFF4F4E4E),
                  labelStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  indicatorColor: const Color(0xFFFF6B6B),
                  indicatorWeight: 2,
                  indicatorSize: TabBarIndicatorSize.tab,
                  isScrollable: false,
                  dividerColor: Color(0xFFD9D9D9),
                  tabs: [
                    Tab(
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Text('일기'),
                      ),
                    ),
                    Tab(
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Text('추이'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 탭뷰 내용
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [_buildDiaryTab(), _buildTrendTab()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiaryTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            // 달력
            _buildCalendar(),
            SizedBox(height: 20),
            // 선택된 날짜의 일기
            _buildSelectedDateDiary(),
            SizedBox(height: 100), // FAB 공간
          ],
        ),
      ),
    );
  }

  Widget _buildTrendTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 27),
            // 감정 변화그래프
            Text(
              '이 달의 변화곡선',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 18),
            _buildTrendChart(),
            SizedBox(height: 20),
            // 이번 달 통계
            _buildMonthlyStats(),
            SizedBox(height: 20),
            // 이 달의 많이 기록된 불안
            _buildMonthlyDiary(),
            SizedBox(height: 10),
            _buildTransport(),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildTransport(){
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24,vertical: 20),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: const Color(0xFF4D4D4D),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '대중교통',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextSpan(
              text: '을 회피 하고 싶은 날이 가장 많았어요.',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Column(
      children: [
        // 달력 헤더
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  currentMonth = DateTime(
                    currentMonth.year,
                    currentMonth.month - 1,
                  );
                });
              },
              icon: Icon(
                Icons.chevron_left,
                size: 24,
                color: Color(0xFF757575),
              ),
            ),
            Text(
              '${currentMonth.year}년 ${currentMonth.month}월',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0A1811),
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  currentMonth = DateTime(
                    currentMonth.year,
                    currentMonth.month + 1,
                  );
                });
              },
              icon: Icon(
                Icons.chevron_right,
                size: 24,
                color: Color(0xFF757575),
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),
        // 요일 헤더
        Row(
          children: ['일', '월', '화', '수', '목', '금', '토']
              .map(
                (day) => Expanded(
                  child: Center(
                    child: Text(
                      day,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF7B827E),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        SizedBox(height: 10),
        // 달력 날짜들
        ..._buildCalendarDays(),
      ],
    );
  }

  List<Widget> _buildCalendarDays() {
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final lastDayOfMonth = DateTime(
      currentMonth.year,
      currentMonth.month + 1,
      0,
    );
    final startDay = firstDayOfMonth.weekday % 7;

    List<Widget> weeks = [];
    List<Widget> days = [];

    // 이전 달 날짜들
    for (int i = 0; i < startDay; i++) {
      days.add(Expanded(child: Container()));
    }

    // 현재 달 날짜들
    for (int day = 1; day <= lastDayOfMonth.day; day++) {
      final date = DateTime(currentMonth.year, currentMonth.month, day);
      final hasDiary = diaryEntries.any(
        (entry) =>
            entry.date.year == date.year &&
            entry.date.month == date.month &&
            entry.date.day == date.day,
      );

      final isSelected =
          selectedDate.year == date.year &&
          selectedDate.month == date.month &&
          selectedDate.day == date.day;

      // 감정 이모지 가져오기
      String? moodEmoji;
      if (hasDiary) {
        final entry = diaryEntries.firstWhere(
          (entry) =>
              entry.date.year == date.year &&
              entry.date.month == date.month &&
              entry.date.day == date.day,
        );
        moodEmoji = _getMoodEmoji(entry.mood);
      }

      days.add(
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedDate = date;
              });
            },
            child: Container(
              height: 45,
              margin: EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFFF6B6B)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$day',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                  if (hasDiary && moodEmoji != null)
                    Text(moodEmoji, style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ),
        ),
      );

      if (days.length == 7) {
        weeks.add(Row(children: List.from(days)));
        days.clear();
      }
    }

    // 남은 날짜들
    while (days.length < 7 && days.isNotEmpty) {
      days.add(Expanded(child: Container()));
    }
    if (days.isNotEmpty) {
      weeks.add(Row(children: List.from(days)));
    }

    return weeks;
  }

  String _getMoodEmoji(int mood) {
    switch (mood) {
      case 1:
        return '😞';
      case 2:
        return '😔';
      case 3:
        return '😐';
      case 4:
        return '😊';
      case 5:
        return '😄';
      default:
        return '😐';
    }
  }

  Widget _buildSelectedDateDiary() {
    final todayEntries = diaryEntries
        .where(
          (entry) =>
              entry.date.year == selectedDate.year &&
              entry.date.month == selectedDate.month &&
              entry.date.day == selectedDate.day,
        )
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${selectedDate.month}월 ${selectedDate.day}일',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 15),
        if (todayEntries.isEmpty)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                Text('📝', style: TextStyle(fontSize: 32)),
                SizedBox(height: 10),
                Text(
                  '이 날의 일기가 없어요',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
              ],
            ),
          )
        else
          ...todayEntries.map((entry) => _buildDiaryItem(entry)),
      ],
    );
  }

  Widget _buildDiaryItem(DiaryEntry entry) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(_getMoodEmoji(entry.mood), style: TextStyle(fontSize: 20)),
              SizedBox(width: 8),
              Text(
                '볼안 점수: 2회',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const Spacer(),
              Text(
                '${entry.date.hour.toString().padLeft(2, '0')}:${entry.date.minute.toString().padLeft(2, '0')}',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            entry.content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontFamily: 'Pretendard',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendChart() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: const Color(0xFF4D4D4D)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          // 그래프 영역 (y축 라벨과 함께)
          SizedBox(
            height: 210,
            child: Row(
              children: [
                // Y축 라벨
                SizedBox(
                  width: 24,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '5점',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF828282),
                        ),
                      ),
                      Text(
                        '4점',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF828282),
                        ),
                      ),
                      Text(
                        '3점',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF828282),
                        ),
                      ),
                      Text(
                        '2점',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF828282),
                        ),
                      ),
                      Text(
                        '1점',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF828282),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                // 그래프 영역
                Expanded(
                  child: CustomPaint(
                    painter: TrendChartPainter(),
                    size: Size(double.infinity, 210),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          // X축 라벨
          Padding(
            padding: EdgeInsets.only(left: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: ['7/27', '1주차', '2주차', '3주차', '4주차']
                  .map(
                    (date) => Text(
                      date,
                      style: TextStyle(fontSize: 10, color: Color(0xFF828282)),
                    ),
                  )
                  .toList(),
            ),
          ),
          SizedBox(height: 2),
          // 범례 ( 일단 주석 )
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Container(width: 12, height: 3, color: const Color(0xFFFF6B6B)),
          //     SizedBox(width: 8),
          //     Text(
          //       '감정 점수',
          //       style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget _buildMonthlyStats() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: const Color(0xFF4D4D4D),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
      Text.rich(
      TextSpan(
      children: [
        TextSpan(
        text: '이번 달, 승현님은 ',
        style: TextStyle(
          color: Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      TextSpan(
        text: '많이 편해졌어요',
        style: TextStyle(
          color: Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
      ],
    ),),
          SizedBox(height: 4),
          Text(
            '평균 불안 점수: 3.5 → 1.5점  /  미션: 87%  /  대처 횟수: 8회',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF828282),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMonthlyDiary() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24,vertical: 20),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: const Color(0xFF4D4D4D),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '빈도 높은 증상',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: ': 가슴 두근거림, 식은땀',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '빈도 높은 회피 상황',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: ': 대중교통, 혼잡한 장소',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class TrendChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 그라데이션 설정 (위에서 아래로 점점 연해짐)
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        const Color(0xFFFF6B6B).withValues(alpha: 0.4), // 상단: 더 진함
        const Color(0xFFFF6B6B).withValues(alpha: 0.08), // 하단: 거의 투명
      ],
    );

    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      )
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = const Color(0xFFEB423D)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // 차트 영역 계산 (여백 최소화)
    final chartWidth = size.width;
    final chartHeight = size.height;

    // 이미지와 유사한 데이터 패턴 (3점에서 시작해서 점점 감소)
    final dataPoints = [3.0, 3.0, 2.0, 1.0, 1.0]; // 감정 점수 데이터
    final points = <Offset>[];

    for (int i = 0; i < dataPoints.length; i++) {
      final x = i * chartWidth / (dataPoints.length - 1);
      final y =
          chartHeight -
          ((dataPoints[i] - 1) / 4 * chartHeight); // 1-5점을 0-1로 정규화
      points.add(Offset(x, y));
    }

    // 면적 채우기
    final areaPath = Path();
    areaPath.moveTo(0, chartHeight);
    for (int i = 0; i < points.length; i++) {
      areaPath.lineTo(points[i].dx, points[i].dy);
    }
    areaPath.lineTo(chartWidth, chartHeight);
    areaPath.close();
    canvas.drawPath(areaPath, paint);

    // 라인 그리기
    final linePath = Path();
    linePath.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      linePath.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(linePath, linePaint);

    // 시작점에만 동그라미 그리기
    if (points.isNotEmpty) {
      final pointPaint = Paint()
        ..color = const Color(0xFFEB423D)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(points[0], 6, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
