import 'dart:async';
import 'package:geolocator/geolocator.dart';

class LocationService {
  double? latitude;
  double? longitude;
  double? accuracy;

  StreamSubscription<Position>? _positionStream;

  /// Start tracking location (like watchPosition in Angular)
  Future<void> startTracking() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location service is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled');
      return;
    }

    // Check permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permission denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permission permanently denied');
      return;
    }

    const settings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 0,
    );

    _positionStream =
        Geolocator.getPositionStream(locationSettings: settings).listen(
      (Position position) {
        latitude = position.latitude;
        longitude = position.longitude;
        accuracy = position.accuracy;

        print('Lat: $latitude, Lng: $longitude, Acc: $accuracy');
      },
      onError: (error) {
        print('Geolocation error: $error');
      },
    );
  }

  /// Stop tracking (like clearWatch)
  void stopTracking() {
    _positionStream?.cancel();
    _positionStream = null;
  }
}