import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../utils/secure_storage.dart';

final secureStorageProvider = Provider(
  (ref) => SecureStorage(storage: const FlutterSecureStorage()),
);
