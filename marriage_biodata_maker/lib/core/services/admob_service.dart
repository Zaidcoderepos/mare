import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../constants/ad_constants.dart';

final adMobServiceProvider = Provider<AdMobService>((ref) {
  return AdMobService()..initialize();
});

class AdMobService {
  RewardedAd? _rewardedAd;
  InterstitialAd? _interstitialAd;
  bool _isRewardedLoading = false;

  Future<void> initialize() async {
    if (!AdConstants.isMobileAdSupported) return;
    await MobileAds.instance.initialize();
    preloadRewardedAd();
    preloadInterstitialAd();
  }

  void preloadRewardedAd() {
    if (!AdConstants.isMobileAdSupported) return;
    if (_isRewardedLoading || _rewardedAd != null) return;
    _isRewardedLoading = true;

    RewardedAd.load(
      adUnitId: AdConstants.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isRewardedLoading = false;
        },
        onAdFailedToLoad: (error) {
          debugPrint('RewardedAd failed to load: $error');
          _rewardedAd = null;
          _isRewardedLoading = false;
        },
      ),
    );
  }

  void preloadInterstitialAd() {
    if (!AdConstants.isMobileAdSupported) return;
    if (_interstitialAd != null) return;

    InterstitialAd.load(
      adUnitId: AdConstants.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitialAd = ad,
        onAdFailedToLoad: (error) {
          debugPrint('InterstitialAd failed to load: $error');
          _interstitialAd = null;
        },
      ),
    );
  }

  /// Shows a Rewarded Ad first. On Web/Desktop preview, shows a simulated
  /// AdMob Rewarded Ad dialog so you can test the full ad-gate UX.
  void showExportGateAd({
    required BuildContext context,
    required VoidCallback onAdCompleted,
    required VoidCallback onAdDismissedWithoutReward,
  }) {
    if (!AdConstants.isMobileAdSupported) {
      _showSimulatedRewardedAdDialog(
        context: context,
        onAdCompleted: onAdCompleted,
        onAdDismissedWithoutReward: onAdDismissedWithoutReward,
      );
      return;
    }

    if (_rewardedAd != null) {
      bool isRewardEarned = false;

      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _rewardedAd = null;
          preloadRewardedAd();

          if (isRewardEarned) {
            onAdCompleted();
          } else {
            onAdDismissedWithoutReward();
          }
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _rewardedAd = null;
          preloadRewardedAd();
          onAdCompleted();
        },
      );

      _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          isRewardEarned = true;
        },
      );
    } else if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _interstitialAd = null;
          preloadInterstitialAd();
          onAdCompleted();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _interstitialAd = null;
          preloadInterstitialAd();
          onAdCompleted();
        },
      );
      _interstitialAd!.show();
    } else {
      preloadRewardedAd();
      preloadInterstitialAd();
      onAdCompleted();
    }
  }

  void _showSimulatedRewardedAdDialog({
    required BuildContext context,
    required VoidCallback onAdCompleted,
    required VoidCallback onAdDismissedWithoutReward,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Row(
          children: [
            Icon(Icons.monetization_on, color: Colors.amber),
            SizedBox(width: 8),
            Text(
              'AdMob Rewarded Ad (Test Mode)',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Simulating Google AdMob Rewarded Video Ad on Desktop/Web.',
              style: TextStyle(color: Colors.white70),
            ),
            SizedBox(height: 12),
            LinearProgressIndicator(value: 1.0, color: Colors.amber),
            SizedBox(height: 8),
            Text(
              'Reward: High-Resolution A4 PDF Biodata Export',
              style: TextStyle(
                color: Colors.amberAccent,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onAdDismissedWithoutReward();
            },
            child: const Text(
              'Skip Ad (No Reward)',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.amber.shade700,
              foregroundColor: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              onAdCompleted();
            },
            icon: const Icon(Icons.check_circle),
            label: const Text('Complete Ad & Unlock PDF'),
          ),
        ],
      ),
    );
  }
}
