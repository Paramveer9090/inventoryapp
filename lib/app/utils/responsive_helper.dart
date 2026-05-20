import 'package:flutter/material.dart';

/// Helper class to determine responsive layout parameters
class ResponsiveHelper {
  /// Get device scale factor based on screen width
  static double getScaleFactor(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) {
      return 1.3; // Large tablets - 30% bigger
    } else if (width > 900) {
      return 1.2; // Medium tablets - 20% bigger
    } else if (width > 600) {
      return 1.1; // Small tablets - 10% bigger
    } else {
      return 1.0; // Phones - standard size
    }
  }

  /// Get scaled font size
  static double getScaledFontSize(BuildContext context, double baseSize) {
    return baseSize * getScaleFactor(context);
  }

  /// Get scaled padding/spacing
  static double getScaledSize(BuildContext context, double baseSize) {
    return baseSize * getScaleFactor(context);
  }

  /// Get scaled height percentage (works with Sizer)
  static double getScaledHeight(BuildContext context, double heightPercent) {
    return heightPercent * getScaleFactor(context);
  }

  /// Get number of grid columns based on screen width
  static int getGridColumns(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return getGridColumnsFromWidth(width);
  }

  /// Get number of grid columns based on width value
  static int getGridColumnsFromWidth(double width) {
    if (width > 1200) {
      return 6; // Large tablets (iPad Pro 12.9", etc)
    } else if (width > 900) {
      return 5; // Medium tablets (iPad Pro 11", iPad Air)
    } else if (width > 600) {
      return 4; // Small tablets / landscape phones
    } else {
      return 2; // Phones (portrait)
    }
  }

  /// Get adaptive aspect ratio for grid items based on width
  static double getGridAspectRatio(double width) {
    if (width > 900) {
      return 0.7; // Slightly taller cards for tablets
    } else {
      return 0.65; // Standard aspect ratio for phones
    }
  }

  /// Check if device is a tablet (width > 600)
  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width > 600;
  }

  /// Check if device is a large tablet (width > 900)
  static bool isLargeTablet(BuildContext context) {
    return MediaQuery.of(context).size.width > 900;
  }

  /// Get adaptive padding based on screen width
  static double getAdaptivePadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 900) {
      return 24.0; // Larger padding for tablets
    } else if (width > 600) {
      return 16.0; // Medium padding for small tablets
    } else {
      return 12.0; // Smaller padding for phones
    }
  }

  /// Get adaptive font size multiplier
  static double getFontSizeMultiplier(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 900) {
      return 1.15; // Slightly larger text on big tablets
    } else if (width > 600) {
      return 1.05; // Slightly larger text on small tablets
    } else {
      return 1.0; // Standard text size on phones
    }
  }

  /// Get device orientation
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  /// Get adaptive cross axis count considering both width and orientation
  static int getAdaptiveColumns(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    // Adjust columns based on orientation
    int baseColumns = getGridColumnsFromWidth(width);

    // Add extra column in landscape if on phone/small tablet
    if (isLandscape && width < 900) {
      baseColumns = (baseColumns + 1).clamp(2, 6);
    }

    return baseColumns;
  }

  /// Get font size optimized for tablets (smaller) or default for phones
  /// - tabletSize: Font size to use on tablets (width > 600px)
  /// - phoneSize: Font size to use on phones (width <= 600px)
  static double getResponsiveFontSize(
      BuildContext context, double tabletSize, double phoneSize) {
    return isTablet(context) ? tabletSize : phoneSize;
  }

  /// Get padding optimized for tablets (smaller) or default for phones
  /// - tabletPadding: Padding to use on tablets (width > 600px)
  /// - phonePadding: Padding to use on phones (width <= 600px)
  static double getResponsivePadding(
      BuildContext context, double tabletPadding, double phonePadding) {
    return isTablet(context) ? tabletPadding : phonePadding;
  }

  /// Get icon size optimized for tablets or phones
  /// - tabletSize: Icon size to use on tablets (width > 600px)
  /// - phoneSize: Icon size to use on phones (width <= 600px)
  static double getResponsiveIconSize(
      BuildContext context, double tabletSize, double phoneSize) {
    return isTablet(context) ? tabletSize : phoneSize;
  }

  /// Get adaptive dialog width for responsive dialogs
  /// Returns wider dialogs on tablets for better UX
  static double getDialogWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 900) {
      return 400; // Large tablets - wider dialogs
    } else if (width > 600) {
      return 320; // Small tablets - medium dialogs
    } else {
      return 280; // Phones - compact dialogs
    }
  }
}
