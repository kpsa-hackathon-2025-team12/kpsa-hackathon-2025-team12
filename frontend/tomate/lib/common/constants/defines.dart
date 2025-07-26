import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// 환경 변수에서 값 가져오기
String get SERVER_URL => dotenv.get(
  'SERVER_URL',
  fallback: kDebugMode
      ? 'http://13.237.149.61:8999/'
      : 'http://13.237.149.61:8999/',
);

String get SERVER_FAQ_URL => dotenv.get(
  'SERVER_FAQ_URL',
  fallback: kDebugMode
      ? 'https://your-dev-api.com/faq'
      : 'https://your-production-api.com/faq',
);

String get SERVER_LINK_URL => dotenv.get(
  'SERVER_LINK_URL',
  fallback: kDebugMode
      ? 'https://your-dev-api.com/'
      : 'https://your-production-api.com/',
);

int get API_TIMEOUT =>
    int.tryParse(dotenv.get('API_TIMEOUT', fallback: '5000')) ?? 5000;
