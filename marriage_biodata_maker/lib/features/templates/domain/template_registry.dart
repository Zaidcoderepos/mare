import '../layouts/emerald_royal_template.dart';
import '../layouts/floral_rose_gold_template.dart';
import '../layouts/kesar_saffron_template.dart';
import '../layouts/modern_minimal_template.dart';
import '../layouts/royal_crimson_template.dart';
import '../layouts/royal_navy_sidebar_template.dart';
import '../layouts/traditional_gold_template.dart';
import 'pdf_template_strategy.dart';

final List<PdfTemplateStrategy> availableTemplates = [
  TraditionalGoldTemplate(),
  RoyalCrimsonMandalaTemplate(),
  KesarSaffronTempleTemplate(),
  EmeraldNikaahArchTemplate(),
  FloralRoseGoldTemplate(),
  RoyalNavySidebarTemplate(),
  ModernMinimalTemplate(),
];
