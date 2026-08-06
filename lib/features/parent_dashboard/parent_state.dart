import 'package:amana_flutter/models/PickupRequest.dart';

class ParentState {
  final bool loading;
  final List<dynamic> children;
  final List<PickupRequest> pickupRequests;
  final String? error;

  final double? busLat;
  final double? busLng;

  ParentState({
    this.loading = false,
    this.children = const [],
    this.error,
    this.pickupRequests = const [],
    this.busLat,
    this.busLng,
  });

  ParentState copyWith({
    bool? loading,
    List<dynamic>? children,
    String? error,
    List<PickupRequest>? pickupRequests,
    double? busLat,
    double? busLng,
  }) {
    return ParentState(
      loading: loading ?? this.loading,
      children: children ?? this.children,
      error: error ?? this.error,
      pickupRequests: pickupRequests ?? this.pickupRequests,
      busLat: busLat ?? this.busLat,
      busLng: busLng ?? this.busLng,
    );
  }
}