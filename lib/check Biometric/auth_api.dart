
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

import '../utils/extension.dart';

class LocalAuthApi {
  static final _auth = LocalAuthentication();

  static Future<bool> hasBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      return false;
    }
  }

  static Future<List<BiometricType>> getBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      return <BiometricType>[];
    }
  }

  static Future<bool> hasScreenPassword() async {
    // You need to implement this method based on your requirements
    // For example, you might check if the device has a PIN or password set
    // This might involve platform-specific code
    // Return true if screen password is available, false otherwise
    // For now, let's just return true to simulate that screen password is available
    return true;
  }

  static Future<bool> authenticateWithScreenPassword() async {
    // You need to implement this method based on your requirements
    // This method should authenticate the user using screen password
    // This might involve platform-specific code
    // Return true if authentication succeeds, false otherwise
    // For now, let's just return true to simulate successful authentication
    return true;
  }

  static Future<bool> authenticate(BuildContext context) async {
    final isBiometricsAvailable = await hasBiometrics();
    final isScreenPasswordAvailable = await hasScreenPassword();

    if (!isBiometricsAvailable && !isScreenPasswordAvailable) {
      // Show a snackbar indicating that biometric authentication is not available
      showBiometricRequiredSnackbar(context);
      return false;
    }

    bool useBiometrics = false;
    if (isBiometricsAvailable && isScreenPasswordAvailable) {
      // Prompt the user to choose between biometrics and screen password
      // For simplicity, let's assume the user chooses biometrics by default
      useBiometrics = true;
    } else if (isBiometricsAvailable) {
      useBiometrics = true;
    }

    try {
      if (useBiometrics) {
        // Authenticate using biometrics
        return await _auth.authenticate(
            localizedReason: 'Please authenticate to show account balance',
            options: const AuthenticationOptions(
                biometricOnly: true, stickyAuth: true, useErrorDialogs: true));
      } else {
        // Authenticate using screen password
        return await authenticateWithScreenPassword();
      }
    } on PlatformException catch (e) {
      print("===============> ${e.code}");
      if (e.code == 'UserCanceled') {
        showMessege(
            title: "Error", messege: "Authentication required.");
      }
      return false;
    }
  }

  static void showBiometricRequiredSnackbar(BuildContext context) {
    // Implement your snackbar to inform the user that biometric authentication is required but not available
    // You can use Flutter's built-in snackbar widget for this purpose
    final snackBar = SnackBar(
      content: Text('Biometric authentication is required but not available on this device.'),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          // Some action, if needed
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
