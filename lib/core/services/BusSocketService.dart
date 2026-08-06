import 'dart:convert';
import 'package:amana_flutter/core/config/app_config.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class BusSocketService {
  late StompClient client;
bool isConnected = false;
  void connect() {
    client = StompClient(
      config: StompConfig.sockJS(
        url: AppConfig.socketUrl,

        onConnect: (_) {
          print('BUS SOCKET CONNECTED');
           isConnected = true;
        },

        onWebSocketError: (error) {
          print('BUS SOCKET ERROR: $error');
        },

        onDisconnect: (_) {
          print('BUS SOCKET DISCONNECTED');
        },
      ),
    );

    client.activate();
  }

Future<void> waitUntilConnected() async {
  while (!isConnected || !client.connected) {
    await Future.delayed(const Duration(milliseconds: 200));
  }
}

void sendLocation(int busId, double lat, double lng) {
  if (!isConnected || !client.connected) {
    print('❌ Socket not ready yet');
    return;
  }

  print('📡 SENDING LOCATION: $busId , $lat , $lng');

  client.send(
    destination: '/app/bus/location',
    body: jsonEncode({
      "id": busId,
      "latitude": lat,
      "longitude": lng,
    }),
  );
}

void subscribeToPickupStatus(
  int parentId,
  Function(Map<String, dynamic>) onMessage,
) {
  client.subscribe(
    destination: '/topic/pickup/$parentId',
    callback: (frame) {
      if (frame.body == null) return;

      print("📩 PICKUP UPDATE: ${frame.body}");

      final json = jsonDecode(frame.body!);

      onMessage(json);
    },
  );
}
  void disconnect() {
      isConnected = false;
    client.deactivate();
  }
}