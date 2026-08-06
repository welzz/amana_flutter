import 'dart:convert';
import 'package:amana_flutter/core/config/app_config.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class ParentBusSocketService {
  late StompClient client;

  void connect({
    required int busId,
    required Function(double lat, double lng) onLocation,
  }) {
    client = StompClient(
      config: StompConfig.sockJS(
        url: AppConfig.socketUrl,

        onConnect: (_) {
          print("✅ SOCKET CONNECTED");

          // ================= BUS LOCATION =================

          client.subscribe(
            destination: '/topic/bus/$busId',
            callback: (frame) {
              if (frame.body == null) return;

              final data = jsonDecode(frame.body!);

              onLocation(
                (data['latitude'] as num).toDouble(),
                (data['longitude'] as num).toDouble(),
              );
            },
          );
        },
      ),
    );

    client.activate();
  }

  // ================= NEW =================

  void subscribePickupStatus({
    required int parentId,
    required Function(Map<String, dynamic>) onPickup,
  }) {
    client.subscribe(
      destination: '/topic/pickup/$parentId',
      callback: (frame) {
        if (frame.body == null) return;

        print("📩 PICKUP => ${frame.body}");

        onPickup(jsonDecode(frame.body!));
      },
    );
  }

  void dispose() {
    client.deactivate();
  }
}