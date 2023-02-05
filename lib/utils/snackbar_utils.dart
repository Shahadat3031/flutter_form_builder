import 'package:flutter/material.dart';

class SnackBarUtils {
  // Singleton instance of the class by using factory constructor
  static final SnackBarUtils _instance = SnackBarUtils._internal();
  factory SnackBarUtils() => _instance;
  SnackBarUtils._internal();

  static SnackBarUtils get instance => _instance;

// Method to get the singleton instance
  void showSnackBar(BuildContext context, String message, {int? duration}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: duration ?? 3),
      ),
    );
  }
}