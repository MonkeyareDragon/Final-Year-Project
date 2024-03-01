// common.UrlUtil
class UrlUtil {
  static String getImageUrl(String equipmentImage) {
    String baseUrl = 'http://10.0.2.2:8000/';
    // Modify the base URL if necessary based on environment or configuration
    // For example:
    // if (isProduction) {
    //   baseUrl = 'https://your-production-domain.com';
    // } else if (isStaging) {
    //   baseUrl = 'https://your-staging-domain.com';
    // }

    String workoutImagePath = equipmentImage;

    return '$baseUrl/$workoutImagePath';
  }
}