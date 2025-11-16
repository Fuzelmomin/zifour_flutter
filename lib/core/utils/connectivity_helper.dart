import 'package:flutter/material.dart';
import 'package:zifour_sourcecode/core/presentation/pages/no_internet_screen.dart';
import 'package:zifour_sourcecode/core/utils/connectivity_service.dart';

/// Helper class for checking internet connectivity before API calls
class ConnectivityHelper {
  static final ConnectivityService _connectivityService = ConnectivityService();

  /// Check connectivity and show no internet screen if not connected
  /// Returns true if connected, false otherwise
  static Future<bool> checkAndShowNoInternetScreen(BuildContext context) async {
    // Initialize connectivity service if not already initialized
    await _connectivityService.initialize();
    
    final isConnected = await _connectivityService.checkConnectivity();
    
    if (!isConnected) {
      // Show no internet screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const NoInternetScreen(),
        ),
      );
      return false;
    }
    
    return true;
  }

  /// Check connectivity without showing screen
  /// Returns true if connected, false otherwise
  static Future<bool> checkConnectivity() async {
    await _connectivityService.initialize();
    return await _connectivityService.checkConnectivity();
  }
}

