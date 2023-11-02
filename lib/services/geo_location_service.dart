import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as dev;

class GeoLocationService {
  static Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we can not request permissions');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
  }

  static Future<void> recordLocation({Position? pos}) async {
    final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Position position = pos ?? await determinePosition();

      dev.log('position = $position');
      dev.log('lt, lg = ${position.latitude}, ${position.longitude}');
      String user = "User"; // Replace with the user's name or ID.
      String location = "${position.latitude}, ${position.longitude}";
      String timestamp = DateTime.now().toString();

      // Save location data to shared preferences
      // await prefs.setString('user', user);
      // await prefs.setString('location', location);
      // await prefs.setString('timestamp', timestamp);
    } catch (e) {
      // Handle location retrieval errors
      dev.log("Error getting location: $e");
    }
  }


}
