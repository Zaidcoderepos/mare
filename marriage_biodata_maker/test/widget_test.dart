import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marriage_biodata_maker/main.dart';

void main() {
  testWidgets('Marriage Biodata Maker smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MarriageBiodataMakerApp(),
      ),
    );
    expect(find.text('Marriage Biodata Maker'), findsOneWidget);
  });
}
