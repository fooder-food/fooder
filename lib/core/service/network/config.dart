import 'package:flutter_dotenv/flutter_dotenv.dart';

class HttpConfig {
  static String baseURL = '${dotenv.env['SERVER_URL']}';
  static const int timeout = 10000;
}