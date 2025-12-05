import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/app_colors.dart';
import '../theme/app_typography.dart';

/// Common utility for image picker dialog
/// Can be used in both signup and profile screens
class ImagePickerUtils {
  static final ImagePicker _imagePicker = ImagePicker();

  /// Show image source selection dialog (Camera or Gallery)
  static Future<void> showImageSourceDialog({
    required BuildContext context,
    required Function(File imageFile) onImageSelected,
    Function(String error)? onError,
  }) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.darkBlue,
          title: Text(
            'Select Image Source',
            style: AppTypography.inter16Medium.copyWith(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt, color: AppColors.pinkColor),
                title: Text(
                  'Pick from Camera',
                  style: AppTypography.inter14Medium.copyWith(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(context, ImageSource.camera, onImageSelected, onError);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library, color: AppColors.pinkColor),
                title: Text(
                  'Pick from Gallery',
                  style: AppTypography.inter14Medium.copyWith(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(context, ImageSource.gallery, onImageSelected, onError);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Pick image from camera or gallery
  static Future<void> _pickImage(
    BuildContext context,
    ImageSource source,
    Function(File imageFile) onImageSelected,
    Function(String error)? onError,
  ) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(source: source);
      if (pickedFile != null) {
        final imageFile = File(pickedFile.path);
        onImageSelected(imageFile);
      }
    } catch (e) {
      if (onError != null) {
        onError('Error picking image: ${e.toString()}');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

