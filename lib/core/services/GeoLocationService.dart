import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GeoLocationsService extends StateNotifier<Map<String, double>?> {
  GeoLocationsService() : super(null);

  bool? hasPermission;
  StreamSubscription<Position>? _watcher;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    _initialized = true;

    if (!await Geolocator.isLocationServiceEnabled()) {
      hasPermission = false;
      return;
    }

    await _checkPermission();
  }

  Future<void> _checkPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      hasPermission = false;
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      hasPermission = false;
      await Geolocator.openAppSettings();
      return;
    }

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      hasPermission = true;
      _startWatching();
    }
  }

  void _startWatching() {
    if (_watcher != null) return;

    const settings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5,
    );

    _watcher =
        Geolocator.getPositionStream(locationSettings: settings).listen(
      (Position position) {
        state = {
          'lat': position.latitude,
          'lon': position.longitude,
        };
      },
    );
  }

  void _stopWatching() {
    _watcher?.cancel();
    _watcher = null;
  }

  @override
  void dispose() {
    _stopWatching();
    super.dispose();
  }

bool isPointInPolygon(
  Map<String, double> point,
  List<Map<String, double>> polygon,
) {
  if (polygon.length < 3) return false;

  final x = point['lon']!;
  final y = point['lat']!;

  bool inside = false;

  for (int i = 0, j = polygon.length - 1; i < polygon.length; j = i++) {
    final xi = polygon[i]['lon']!;
    final yi = polygon[i]['lat']!;
    final xj = polygon[j]['lon']!;
    final yj = polygon[j]['lat']!;

    final intersect = ((yi > y) != (yj > y)) &&
        (x < (xj - xi) * (y - yi) / (yj - yi) + xi);

    if (intersect) {
      inside = !inside;
    }
  }

  return inside;
}}