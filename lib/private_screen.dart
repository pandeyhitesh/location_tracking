import 'package:assignment/services/location_monitoring_service.dart';
import 'package:flutter/material.dart';

class PrivateScreen extends StatelessWidget {
  const PrivateScreen({super.key, required this.locationMonitor});

  final LocationMonitoringService locationMonitor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Private Screen'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Login successful.\nYou can access the private contents',
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(),
              child: ElevatedButton(
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text('Logout'),
                ),
                onPressed: () {
                  locationMonitor.stopLocationMonitoring();
                  Navigator.of(context).pop();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
