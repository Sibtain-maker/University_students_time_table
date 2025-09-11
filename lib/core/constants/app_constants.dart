class AppConstants {
  // Development mode settings
  static const bool isDevelopmentMode = true; // Set to false for production
  static const String developmentOtpCode = "123456"; // Fixed OTP for testing
  
  // Email delivery settings
  static const int emailDeliveryTimeoutSeconds = 30;
  static const int maxOtpResendAttempts = 3;
  
  // App information
  static const String appName = "University Timetable";
  static const String appVersion = "1.0.0";
}