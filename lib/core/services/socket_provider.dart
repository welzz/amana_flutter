import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/BusSocketService.dart';

final busSocketServiceProvider = Provider<BusSocketService>((ref) {
  final socket = BusSocketService();

  socket.connect();

  ref.onDispose(() {
    socket.disconnect();
  });

  return socket;
});