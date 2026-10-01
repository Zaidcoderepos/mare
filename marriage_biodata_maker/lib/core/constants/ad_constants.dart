import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

class AdConstants {
  AdConstants._();

  static bool get isMobileAdSupported {
    if (kIsWeb) return false;
    return Platform.isAndroid || Platform.isIOS;
  }

  static String get bannerAdUnitId {
    if (!isMobileAdSupported) return '';
    if (kDebugMode) {
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/6300978111'
          : 'ca-app-pub-3940256099942544/2934735716';
    }
    return 'YOUR_PRODUCTION_BANNER_AD_UNIT_ID';
  }

  static String get rewardedAdUnitId {
    if (!isMobileAdSupported) return '';
    if (kDebugMode) {
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/5224354917'
          : 'ca-app-pub-3940256099942544/1712485313';
    }
    return 'YOUR_PRODUCTION_REWARDED_AD_UNIT_ID';
  }

  static String get interstitialAdUnitId {
    if (!isMobileAdSupported) return '';
    if (kDebugMode) {
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/1033173712'
          : 'ca-app-pub-3940256099942544/4411468910';
    }
    return 'YOUR_PRODUCTION_INTERSTITIAL_AD_UNIT_ID';
  }
}
