import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as error_codes;
import 'dart:developer' as dev;

class AuthService {
  static Future<bool> authenticateUser() async {
    final LocalAuthentication localAuthentication = LocalAuthentication();

    bool isAuthenticated = false;
    bool isBiometricSupported = await localAuthentication.isDeviceSupported();
    bool canCheckBiometric = await localAuthentication.canCheckBiometrics;
    var availableBiometrics =
        await localAuthentication.getAvailableBiometrics();

    dev.log('isBiometricSupported = $isBiometricSupported');
    dev.log('canCheckBiometric = $canCheckBiometric');
    dev.log('availableBiometrics = $availableBiometrics');

    if (isBiometricSupported && canCheckBiometric) {
      try {
        isAuthenticated = await localAuthentication.authenticate(
            localizedReason: 'Scan your fingerprint to authenticate',
            options: const AuthenticationOptions(
              sensitiveTransaction: false,
              biometricOnly: true,
              stickyAuth: true,
              useErrorDialogs: true,
            ));
      } on PlatformException catch (e) {
        if(e.code == error_codes.biometricOnlyNotSupported){
          dev.log('Biometric authentication is not available on this device.');
        }else if(e.code == error_codes.notAvailable || e.code == error_codes.notEnrolled){
          dev.log('Biometrics not available/enrolled');
        }else{
          dev.log(
              'Error occurred in Authentication Service. Error: ${e.toString()}');
        }

      }
    }
    return isAuthenticated;
  }
}
