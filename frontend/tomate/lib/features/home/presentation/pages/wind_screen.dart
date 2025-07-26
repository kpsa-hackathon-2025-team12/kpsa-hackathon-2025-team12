import 'dart:io';

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
      backgroundColor: const Color(0xFFFBFCF4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBFCF4),
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
              child: Column(
                children: [
                  // 호흡 애니메이션 GIF
                  SizedBox(
                    width: Platform.isAndroid ? double.infinity : double.infinity,
                    height: Platform.isAndroid ? 400 : 380,
                    child: Image.asset(
                      'assets/animations/breathe.gif',
                      key: UniqueKey(), // 다른 탭으로 갔다가 돌아올 때마다 gif가 처음부터 재생
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 40,),

                  // 안내 메시지
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 26),
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 40),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            color: const Color(0xFF4D4D4D),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: '승현님 이전에 ',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '5번',
                                    style: TextStyle(
                                      color: const Color(0xFFEA423C),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '이나 잘 이겨냈어요.',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              '지금 두근거림은 단지 불안의 일시적인 반응일 뿐이고\n단비님의 심장은 건강해요. 수없이 이런 순간을 지나\n왔으니까 분명 단비님은 이번에도 잘 해낼 거예요!',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                height: 1.60,
                              ),
                            )
                          ],
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
