import 'dart:io';
class AdMobService {
  static String? get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-5626955934501067~7751434299';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-5626955934501067~5286042730';
    }
    return null;
  }
}

// ios ca-app-pub-5626955934501067~5286042730
// android ca-app-pub-5626955934501067~7751434299
