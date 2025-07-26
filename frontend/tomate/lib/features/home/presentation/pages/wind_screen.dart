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
      backgroundColor: const Color(0xFFFFFFF5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFF5),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          '호흡하기',
          style: TextStyle(
            fontSize: 18,
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
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  // 호흡 애니메이션 GIF
                  Image.asset(
                    'assets/animations/breathe.gif',
                    key: UniqueKey(), // 다른 탭으로 갔다가 돌아올 때마다 gif가 처음부터 재생
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
