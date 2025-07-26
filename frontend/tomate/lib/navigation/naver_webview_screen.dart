import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class NaverWebViewScreen extends StatefulWidget {
  final String authUrl;

  const NaverWebViewScreen({Key? key, required this.authUrl}) : super(key: key);

  @override
  State<NaverWebViewScreen> createState() => _NaverWebViewScreenState();
}

class _NaverWebViewScreenState extends State<NaverWebViewScreen> {
  InAppWebViewController? webViewController;
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '네이버 로그인',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(widget.authUrl)),
            initialSettings: InAppWebViewSettings(
              javaScriptEnabled: true,
              domStorageEnabled: true,
              allowsInlineMediaPlayback: true,
              mediaPlaybackRequiresUserGesture: false,
            ),
            onWebViewCreated: (controller) {
              webViewController = controller;
            },
            onLoadStart: (controller, url) {
              print('🔄 페이지 로딩 시작: $url');
              setState(() {
                isLoading = true;
              });
            },
            onLoadStop: (controller, url) {
              setState(() {
                isLoading = false;
              });

              // 네이버 로그인 페이지가 로드되면 사용자에게 알림
              if (url.toString().contains('nid.naver.com')) {}
            },
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              final url = navigationAction.request.url.toString();
              print('URL 변경 감지: $url');

              // 네이버 로그인 성공 콜백 URL 감지 (더 구체적인 조건)
              if ((url.contains('code=') && url.contains('oauth')) ||
                  url.contains('access_token=') ||
                  (url.contains('callback') && url.contains('code=')) ||
                  url.contains('login/success') ||
                  (url.startsWith('http://localhost') &&
                      url.contains('code=')) ||
                  (url.startsWith('https://localhost') &&
                      url.contains('code='))) {
                print('네이버 로그인 성공 감지: $url');

                // 1초 후 성공 결과와 함께 화면 닫기
                Future.delayed(Duration(milliseconds: 1000), () {
                  if (mounted) {
                    Navigator.of(context).pop(true);
                  }
                });

                return NavigationActionPolicy.CANCEL;
              }

              // 오류 URL 감지
              if (url.contains('error=') ||
                  url.contains('login/failure') ||
                  url.contains('error_code=')) {
                print('네이버 로그인 실패: $url');

                Future.delayed(Duration(milliseconds: 1000), () {
                  if (mounted) {
                    Navigator.of(context).pop(false);
                  }
                });

                return NavigationActionPolicy.CANCEL;
              }

              return NavigationActionPolicy.ALLOW;
            },
            onReceivedError: (controller, request, error) {
              print('웹뷰 오류: $error');
            },
          ),
          if (isLoading)
            Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF03C75A),
                      ), // 네이버 초록색
                    ),
                    SizedBox(height: 16),
                    Text(
                      '네이버 로그인 페이지를 불러오는 중...',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
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
