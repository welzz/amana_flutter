import 'package:amana_flutter/core/config/app_config.dart';
import 'package:dio/dio.dart';
 
class DioClient {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.baseUrl,
      headers: {'Content-Type': 'application/json'},
    ),
  );
}
