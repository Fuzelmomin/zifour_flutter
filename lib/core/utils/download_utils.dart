import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadUtils {
  static final Dio _dio = Dio();

  static Future<void> downloadFile({
    required BuildContext context,
    required String url,
    required String fileName,
  }) async {
    try {
      // 1. Check/Request Permissions
      if (Platform.isAndroid) {
        final status = await Permission.storage.request();
        if (!status.isGranted) {
          // For Android 13+ (SDK 33+), storage permission might always be denied.
          // We can often still save to app-specific directories or Downloads.
          // Let's check manageExternalStorage for broader access if needed, 
          // but usually Downloads directory is accessible via path_provider.
        }
      }

      // 2. Get Storage Directory
      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory == null) {
        throw Exception("Could not find storage directory");
      }

      final String savePath = "${directory.path}/$fileName";
      
      // Notify user download started
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Downloading $fileName..."),
          duration: const Duration(seconds: 2),
        ),
      );

      // 3. Download File
      await _dio.download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            // Can implement progress indicator if needed
          }
        },
      );

      // 4. Notify Success
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Successfully downloaded to $savePath"),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: "OK",
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Download failed: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
