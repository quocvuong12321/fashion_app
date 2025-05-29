import 'package:flutter/material.dart';

// Function to be set from MainScreen
Function(int)? _mainScreenTabSetter;

/// Helper class for common navigation patterns in the app
class NavigationUtils {
  /// Set the function that can change tabs in the main screen
  static void setMainTabSetter(Function(int) setter) {
    _mainScreenTabSetter = setter;
  }

  /// Navigate to a specific tab in the main screen
  /// Use this for deep linking to specific tabs like cart, favorites, etc.
  static void navigateToMainTab(BuildContext context, int tabIndex) {
    // Pop all routes and return to main screen
    Navigator.of(context).popUntil((route) => route.isFirst);

    // Use the tab setter function if available
    _mainScreenTabSetter?.call(tabIndex);
  }
}
