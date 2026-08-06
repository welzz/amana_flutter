import 'package:flutter/foundation.dart';

class AppConfig {

  // 🔥 true = live server
  // 🔥 false = localhost
  static const bool useLiveServer = false;

  static final String baseUrl = useLiveServer
      ? 'https://amanspringboot.onrender.com/api'
      : (kIsWeb
          ? 'http://localhost:8080/api'
          : 'http://10.0.2.2:8080/api');


          static final String socketUrl = useLiveServer
      ? 'https://amanspringboot.onrender.com/ws'
      : (kIsWeb
            ? 'http://localhost:8080/ws'
            : 'http://10.0.2.2:8080/ws');
}