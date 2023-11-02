import 'dart:async';

import 'package:assignment/services/geo_location_service.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:developer' as dev;

class LocationMonitoringService {
  GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
  Position? previousPosition;
  int minDistanceThreshold = 10;
  // StreamSubscription<Position>? locationStream;

  Future<void> startLocationMonitoring() async {
    await geolocator.checkPermission();

    StreamSubscription<Position> locationStream = geolocator
        .getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: minDistanceThreshold,
      ),
    )
        .listen((Position position) {
      if (previousPosition != null) {
        double distance = geolocator.distanceBetween(
          previousPosition!.latitude,
          previousPosition!.longitude,
          position.latitude,
          position.longitude,
        );

        if (distance >= minDistanceThreshold) {
          dev.log('position distance = $distance');
          GeoLocationService.recordLocation(pos: position);
        }
      }
      previousPosition = position;
    });
  }

  void stopLocationMonitoring(){
    // if(locationStream!=null){
    //   locationStream!.cancel();
    //   locationStream=null;
    // }
  }
}
