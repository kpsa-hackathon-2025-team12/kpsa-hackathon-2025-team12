import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WindScreen extends StatefulWidget {
  const WindScreen({super.key});

  @override
  State<WindScreen> createState() => _WindScreenState();
}

class _WindScreenState extends State<WindScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          '호흡하기',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Column(
                children: [
                  // 호흡 시간 표시
                  Container(
                    margin: EdgeInsets.only(bottom: 20.h),
                    child: Text(
                      '호흡 시간',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF666666),
                      ),
                    ),
                  ),

                  // 시간 표시
                  Container(
                    margin: EdgeInsets.only(bottom: 40.h),
                    child: Text(
                      '1 / 5',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF999999),
                      ),
                    ),
                  ),

                  // 호흡 원형 인디케이터
                  Container(
                    width: 250.w,
                    height: 250.w,
                    margin: EdgeInsets.only(bottom: 60.h),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFE0E0E0),
                        width: 2,
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // 진행 표시 점
                        Positioned(
                          top: 20.h,
                          child: Container(
                            width: 12.w,
                            height: 12.w,
                            decoration: const BoxDecoration(
                              color: Color(0xFF4CAF50),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        // 중앙 원
                        Container(
                          width: 150.w,
                          height: 150.w,
                          decoration: const BoxDecoration(
                            color: Color(0xFFEB423D),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 안내 메시지
                  Container(
                    padding: EdgeInsets.all(20.w),
                    margin: EdgeInsets.only(bottom: 40.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: const Color(0xFFE0E0E0),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '천천히 어깨에 힘빼시고 호흡해주세요.',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          '지금 투약으로부터 얻은 컨디션 정보를 통해 알아낸 결과입니다. 아래의 대화를 통해 지금의 컨디션에 대해 충분히 이해하고 좋은 컨디션 유지를 위해 계속 기여하세요.',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF666666),
                            height: 1.4,
                          ),
                        ),
                      ],
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
