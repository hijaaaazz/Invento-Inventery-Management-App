// Create this as a utility file: lib/helpers/image_helper.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ImageHelper {
  /// Universal safe image builder that works everywhere
  static Widget buildSafeImage(String imageString, {BoxFit fit = BoxFit.cover}) {
    if (imageString.isEmpty) {
      return Image.asset('assets/images/box.jpg', fit: fit);
    }

    try {
      if (kIsWeb) {
        // Web: base64 decoding
        final bytes = base64Decode(imageString);
        return Image.memory(
          bytes,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset('assets/images/box.jpg', fit: fit);
          },
        );
      } else {
        // Mobile: File image with fallback
        return Image.file(
          File(imageString),
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset('assets/images/box.jpg', fit: fit);
          },
        );
      }
    } catch (e) {
      // Any error, show box placeholder
      return Image.asset('assets/images/box.jpg', fit: fit);
    }
  }
}
