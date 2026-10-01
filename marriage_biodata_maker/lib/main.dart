import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/services/admob_service.dart';
import 'core/theme/app_theme.dart';
import 'features/templates/presentation/screens/template_gallery_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const ProviderScope(
      child: MarriageBiodataMakerApp(),
    ),
  );
}

class MarriageBiodataMakerApp extends ConsumerWidget {
  const MarriageBiodataMakerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialize AdMob and preload Rewarded & Interstitial Ads at startup
    ref.watch(adMobServiceProvider);

    return MaterialApp(
      title: 'Marriage Biodata Maker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const TemplateGalleryScreen(),
    );
  }
}
