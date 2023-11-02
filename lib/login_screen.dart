import 'package:assignment/private_screen.dart';
import 'package:assignment/services/auth_service.dart';
import 'package:assignment/services/geo_location_service.dart';
import 'package:assignment/services/location_monitoring_service.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text('Login to Continue..'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(),
              child: ElevatedButton(
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text('Login'),
                ),
                onPressed: () async {
                  bool isAuthenticated = await AuthService.authenticateUser();
                  if (isAuthenticated) {
                    await GeoLocationService.recordLocation();
                    LocationMonitoringService locationMonitor =
                        LocationMonitoringService();
                    locationMonitor.startLocationMonitoring();

                    if (isAuthenticated && context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PrivateScreen(
                            locationMonitor: locationMonitor,
                          ),
                        ),
                      );
                    }
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
